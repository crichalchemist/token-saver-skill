#!/usr/bin/env node
// Score an eval run: tool calls (csd events or action execution log) vs a scenario's expectations.
const fs = require('fs');
const path = require('path');

const KINDS = ['delegate', 'keep', 'verify', 'fallback', 'guard'];
const MCPS = ['real', 'stub', 'stub-unsafe', 'stub-timeout', 'stub-false-success', 'none'];

function parseScenario(text) {
  const m = text.match(/^---\n([\s\S]*?)\n---\n?([\s\S]*)$/);
  if (!m) throw new Error('scenario missing --- frontmatter');
  return { meta: JSON.parse(m[1]), prompt: m[2].trim() };
}

function validateScenario(meta) {
  const errs = [];
  if (!meta.id) errs.push('missing id');
  if (!KINDS.includes(meta.kind)) errs.push(`kind must be one of ${KINDS.join('|')}`);
  if (!MCPS.includes(meta.mcp)) errs.push(`mcp must be one of ${MCPS.join('|')}`);
  if (typeof meta.expect !== 'object' || meta.expect === null) errs.push('missing expect');
  return errs;
}

function callsFromCsd(jsonl) {
  return jsonl.split('\n').filter(Boolean).map((l) => JSON.parse(l))
    .filter((e) => e.event === 'pre_tool_use')
    .map((e) => ({ tool: e.tool, input: e.tool_input || {} }));
}

function callsFromExecution(json) {
  const calls = [];
  for (const msg of JSON.parse(json)) {
    const content = (msg.message && msg.message.content) || [];
    if (!Array.isArray(content)) continue;
    for (const c of content) if (c.type === 'tool_use') calls.push({ tool: c.name, input: c.input || {} });
  }
  return calls;
}

function matchesTool(call, spec) {
  if (spec.startsWith('Bash:')) {
    return call.tool === 'Bash' && String(call.input.command || '').includes(spec.slice(5));
  }
  return call.tool === spec || call.tool.endsWith(`__${spec}`);
}

function touches(call, prefix) {
  const i = call.input;
  const fields = [i.directory, i.file_path, i.path, i.task, i.scope, i.command, ...(i.files || [])];
  return fields.some((v) => typeof v === 'string' && v.includes(prefix));
}

function hits(call, rule) {
  return rule.any_of.some((t) => matchesTool(call, t))
    && (!rule.touching || touches(call, rule.touching))
    && (!rule.with || Object.entries(rule.with).every(([k, v]) => call.input[k] === v));
}

function evaluate(expect, calls, runDir) {
  const reasons = [];
  for (const rule of expect.must_call || []) {
    if (!calls.some((c) => hits(c, rule))) reasons.push(`missing call: ${JSON.stringify(rule)}`);
  }
  for (const rule of expect.must_not_call || []) {
    const bad = calls.find((c) => hits(c, rule));
    if (bad) reasons.push(`forbidden call: ${bad.tool} ${JSON.stringify(bad.input).slice(0, 200)}`);
  }
  for (const rule of expect.must_follow || []) {
    calls.forEach((c, idx) => {
      if (!rule.after.some((t) => matchesTool(c, t))) return;
      const later = calls.slice(idx + 1).some((n) => rule.any_of.some((t) => matchesTool(n, t)));
      if (!later) reasons.push(`no ${rule.any_of.join('/')} after ${c.tool} #${idx}`);
    });
  }
  for (const rule of expect.must_precede || []) {
    calls.forEach((c, idx) => {
      if (!rule.then.some((t) => matchesTool(c, t))) return;
      if (!calls.slice(0, idx).some((p) => hits(p, rule.first))) reasons.push(`${c.tool} #${idx} not preceded by ${JSON.stringify(rule.first)}`);
    });
  }
  if (expect.final_file) {
    const p = path.join(runDir || '.', expect.final_file.path);
    const body = fs.existsSync(p) ? fs.readFileSync(p, 'utf8') : '';
    if (!body.includes(expect.final_file.contains)) reasons.push(`${expect.final_file.path} lacks ${expect.final_file.contains}`);
  }
  return { pass: reasons.length === 0, reasons };
}

function arg(name) {
  const i = process.argv.indexOf(name);
  return i === -1 ? undefined : process.argv[i + 1];
}

function main() {
  if (arg('--validate')) {
    const dir = arg('--validate');
    let bad = 0;
    for (const f of fs.readdirSync(dir).filter((n) => n.endsWith('.md'))) {
      try {
        const errs = validateScenario(parseScenario(fs.readFileSync(path.join(dir, f), 'utf8')).meta);
        errs.forEach((e) => console.log(`${f}: ${e}`)); bad += errs.length;
      } catch (e) { console.log(`${f}: ${e.message}`); bad++; }
    }
    process.exit(bad ? 1 : 0);
  }
  if (arg('--aggregate')) {
    const dir = arg('--aggregate'); const min = Number(arg('--min'));
    const tally = {};
    for (const sub of fs.readdirSync(dir)) {
      const vf = path.join(dir, sub, 'verdict.json');
      if (!fs.existsSync(vf)) continue;
      const v = JSON.parse(fs.readFileSync(vf, 'utf8'));
      tally[v.id] = tally[v.id] || { pass: 0, runs: 0 };
      tally[v.id].runs++; if (v.pass) tally[v.id].pass++;
    }
    let ok = true;
    for (const [id, t] of Object.entries(tally)) {
      const good = t.pass >= min; ok = ok && good;
      console.log(`${good ? 'PASS' : 'FAIL'} ${id} ${t.pass}/${t.runs}`);
    }
    const expect = arg('--expect');
    if (expect && Object.keys(tally).length < Number(expect)) {
      console.log(`FAIL expected ${expect} scenarios, got ${Object.keys(tally).length}`);
      process.exit(1);
    }
    process.exit(ok && Object.keys(tally).length ? 0 : 1);
  }
  const { meta } = parseScenario(fs.readFileSync(arg('--scenario'), 'utf8'));
  const calls = arg('--csd')
    ? callsFromCsd(fs.readFileSync(arg('--csd'), 'utf8'))
    : callsFromExecution(fs.readFileSync(arg('--execution'), 'utf8'));
  const r = evaluate(meta.expect, calls, arg('--run-dir'));
  console.log(JSON.stringify({ id: meta.id, pass: r.pass, reasons: r.reasons, calls: calls.map((c) => c.tool) }, null, 2));
  process.exit(r.pass ? 0 : 1);
}

module.exports = { parseScenario, validateScenario, callsFromCsd, callsFromExecution, matchesTool, touches, evaluate };
if (require.main === module) main();
