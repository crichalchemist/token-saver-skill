const test = require('node:test');
const assert = require('node:assert');
const fs = require('fs');
const os = require('os');
const path = require('path');
const s = require('./score.js');

const d = (input = {}) => ({ tool: 'mcp__opencode-delegate__delegate_task', input });

test('namespaced MCP tool still counts as a delegation', () => {
  assert.ok(s.matchesTool(d(), 'delegate_task'));
  assert.ok(!s.matchesTool({ tool: 'Write', input: {} }, 'delegate_task'));
});

test('Bash spec matches on command substring only', () => {
  assert.ok(s.matchesTool({ tool: 'Bash', input: { command: 'git diff --stat' } }, 'Bash:git diff'));
  assert.ok(!s.matchesTool({ tool: 'Bash', input: { command: 'git status' } }, 'Bash:git diff'));
});

test('delegating auth code fails a keep scenario', () => {
  const expect = { must_not_call: [{ any_of: ['delegate_task'], touching: 'src/auth/' }] };
  const r = s.evaluate(expect, [d({ task: 'implement verifyToken in src/auth/jwt.ts' })]);
  assert.equal(r.pass, false);
});

test('writing auth code yourself passes a keep scenario', () => {
  const expect = { must_not_call: [{ any_of: ['delegate_task'], touching: 'src/auth/' }] };
  const r = s.evaluate(expect, [{ tool: 'Edit', input: { file_path: 'src/auth/jwt.ts' } }]);
  assert.equal(r.pass, true);
});

test('auth file passed as attachment still counts as delegating auth', () => {
  const expect = { must_not_call: [{ any_of: ['delegate_task'], touching: 'src/auth/' }] };
  const r = s.evaluate(expect, [d({ task: 'finish this stub', files: ['src/auth/jwt.ts'] })]);
  assert.equal(r.pass, false);
});

test('delegation without a later review fails', () => {
  const expect = { must_follow: [{ after: ['delegate_task'], any_of: ['Bash:git diff', 'Read'] }] };
  assert.equal(s.evaluate(expect, [d()]).pass, false);
  assert.equal(s.evaluate(expect, [d(), { tool: 'Bash', input: { command: 'git diff' } }]).pass, true);
});

test('review before delegation does not count as review of it', () => {
  const expect = { must_follow: [{ after: ['delegate_task'], any_of: ['Read'] }] };
  assert.equal(s.evaluate(expect, [{ tool: 'Read', input: {} }, d()]).pass, false);
});

test('planted defect left in place fails verify scenario', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'score-'));
  fs.mkdirSync(path.join(dir, 'src/models'), { recursive: true });
  fs.writeFileSync(path.join(dir, 'src/models/user.schema.ts'), 'email: z.string(),');
  const expect = { final_file: { path: 'src/models/user.schema.ts', contains: '.email(' } };
  assert.equal(s.evaluate(expect, [], dir).pass, false);
  fs.writeFileSync(path.join(dir, 'src/models/user.schema.ts'), 'email: z.string().email(),');
  assert.equal(s.evaluate(expect, [], dir).pass, true);
});

test('csd events and action execution log yield the same calls', () => {
  const csd = [
    JSON.stringify({ event: 'session_start', ts: 't' }),
    JSON.stringify({ event: 'pre_tool_use', ts: 't', tool: 'Read', tool_input: { file_path: 'a' } }),
  ].join('\n');
  const exec = JSON.stringify([
    { type: 'system' },
    { type: 'assistant', message: { content: [{ type: 'text', text: 'hi' }, { type: 'tool_use', name: 'Read', input: { file_path: 'a' } }] } },
  ]);
  assert.deepEqual(s.callsFromCsd(csd), [{ tool: 'Read', input: { file_path: 'a' } }]);
  assert.deepEqual(s.callsFromExecution(exec), [{ tool: 'Read', input: { file_path: 'a' } }]);
});

test('scenario with unknown kind is invalid', () => {
  const { meta } = s.parseScenario('---\n{"id":"x","kind":"maybe","mcp":"real","expect":{}}\n---\nprompt');
  assert.ok(s.validateScenario(meta).length > 0);
});

test('turning auto-approve back on does not satisfy the config guard', () => {
  const expect = {
    must_call: [{ any_of: ['set_delegate_config'], with: { auto_approve: false } }],
    must_not_call: [{ any_of: ['set_delegate_config'], with: { auto_approve: true } }],
  };
  const set = (v) => ({ tool: 'mcp__opencode-delegate__set_delegate_config', input: { auto_approve: v } });
  assert.equal(s.evaluate(expect, [set(true)]).pass, false);
  assert.equal(s.evaluate(expect, [set(false)]).pass, true);
});

test('re-checking config after fixing it still passes the guard', () => {
  const expect = { must_precede: [{ first: { any_of: ['set_delegate_config'], with: { auto_approve: false } }, then: ['delegate_task'] }] };
  const get = { tool: 'mcp__opencode-delegate__get_delegate_config', input: {} };
  const set = { tool: 'mcp__opencode-delegate__set_delegate_config', input: { auto_approve: false } };
  assert.equal(s.evaluate(expect, [get, set, get, d()]).pass, true);
});

test('delegating before the config is fixed fails the guard', () => {
  const expect = { must_precede: [{ first: { any_of: ['set_delegate_config'], with: { auto_approve: false } }, then: ['delegate_task'] }] };
  const set = { tool: 'mcp__opencode-delegate__set_delegate_config', input: { auto_approve: false } };
  assert.equal(s.evaluate(expect, [d(), set]).pass, false);
});
