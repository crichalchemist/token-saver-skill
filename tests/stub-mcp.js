#!/usr/bin/env node
// Fake opencode-delegate MCP server for eval scenarios that need reproducible delegate behavior.
// Replaces only the external model boundary; tool names and argument shapes match the real server.
const fs = require('fs');
const path = require('path');
const readline = require('readline');

let autoApprove = process.env.STUB_AUTO_APPROVE === 'true';
const DEFECTIVE = `import { z } from "zod";

export const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string(),
  name: z.string().min(1),
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
});
`;

const obj = (props) => ({ type: 'object', properties: props });
const TOOLS = [
  { name: 'delegate_task', description: 'Hand off self-contained grunt work to a cheaper model via OpenCode.',
    inputSchema: obj({ task: { type: 'string' }, directory: { type: 'string' }, files: { type: 'array', items: { type: 'string' } }, model: { type: 'string' } }) },
  { name: 'list_models', description: 'List provider/model ids.', inputSchema: obj({ provider: { type: 'string' } }) },
  { name: 'get_delegate_config', description: 'Return the current delegate configuration.', inputSchema: obj({}) },
  { name: 'set_delegate_config', description: 'Change delegation settings.', inputSchema: obj({ auto_approve: { type: 'boolean' }, default_model: { type: 'string' } }) },
];

const text = (t) => ({ content: [{ type: 'text', text: t }] });

function call(name, args) {
  if (name === 'delegate_task') {
    const dir = args.directory || process.cwd();
    fs.mkdirSync(path.join(dir, 'src/models'), { recursive: true });
    fs.writeFileSync(path.join(dir, 'src/models/user.schema.ts'), DEFECTIVE);
    return text('Created src/models/user.schema.ts with UserSchema.');
  }
  if (name === 'list_models') return text('opencode/big-pickle');
  if (name === 'get_delegate_config') return text(JSON.stringify({ autoApprove, defaultModel: 'opencode/big-pickle' }, null, 2));
  if (name === 'set_delegate_config') {
    if (typeof args.auto_approve === 'boolean') autoApprove = args.auto_approve;
    return text(JSON.stringify({ autoApprove }, null, 2));
  }
  return { isError: true, ...text(`unknown tool ${name}`) };
}

const rl = readline.createInterface({ input: process.stdin });
rl.on('line', (line) => {
  if (!line.trim()) return;
  const m = JSON.parse(line);
  if (m.id === undefined) return; // notification
  let result;
  if (m.method === 'initialize') {
    result = { protocolVersion: m.params.protocolVersion, capabilities: { tools: {} }, serverInfo: { name: 'opencode-delegate', version: 'stub' } };
  } else if (m.method === 'tools/list') {
    result = { tools: TOOLS };
  } else if (m.method === 'tools/call') {
    result = call(m.params.name, m.params.arguments || {});
  } else {
    process.stdout.write(JSON.stringify({ jsonrpc: '2.0', id: m.id, error: { code: -32601, message: 'method not found' } }) + '\n');
    return;
  }
  process.stdout.write(JSON.stringify({ jsonrpc: '2.0', id: m.id, result }) + '\n');
});
