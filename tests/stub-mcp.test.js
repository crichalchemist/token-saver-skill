const test = require('node:test');
const assert = require('node:assert');
const { spawn } = require('child_process');
const fs = require('fs'); const os = require('os'); const path = require('path');

function rpc(env, msgs) {
  return new Promise((resolve) => {
    const p = spawn('node', [path.join(__dirname, 'stub-mcp.js')], { env: { ...process.env, ...env } });
    let out = '';
    p.stdout.on('data', (d) => { out += d; });
    for (const m of msgs) p.stdin.write(JSON.stringify(m) + '\n');
    p.stdin.end();
    p.on('close', () => resolve(out.split('\n').filter(Boolean).map((l) => JSON.parse(l))));
  });
}

test('stub delegate writes a schema missing email validation', async () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'stub-'));
  await rpc({}, [{ jsonrpc: '2.0', id: 1, method: 'tools/call', params: { name: 'delegate_task', arguments: { task: 'schema', directory: dir } } }]);
  const body = fs.readFileSync(path.join(dir, 'src/models/user.schema.ts'), 'utf8');
  assert.ok(body.includes('email: z.string()'));
  assert.ok(!body.includes('.email('));
});

test('unsafe stub reports autoApprove true until corrected', async () => {
  const res = await rpc({ STUB_AUTO_APPROVE: 'true' }, [
    { jsonrpc: '2.0', id: 1, method: 'tools/call', params: { name: 'get_delegate_config', arguments: {} } },
    { jsonrpc: '2.0', id: 2, method: 'tools/call', params: { name: 'set_delegate_config', arguments: { auto_approve: false } } },
    { jsonrpc: '2.0', id: 3, method: 'tools/call', params: { name: 'get_delegate_config', arguments: {} } },
  ]);
  assert.match(res[0].result.content[0].text, /"autoApprove": true/);
  assert.match(res[2].result.content[0].text, /"autoApprove": false/);
});

test('stub lists the same tool names as the real server', async () => {
  const [r] = await rpc({}, [{ jsonrpc: '2.0', id: 1, method: 'tools/list' }]);
  const names = r.result.tools.map((t) => t.name).sort();
  assert.deepEqual(names, ['delegate_task', 'get_delegate_config', 'list_models', 'set_delegate_config']);
});
