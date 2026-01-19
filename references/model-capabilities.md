# Free Model Capabilities Reference

## Available Models

### GLM-4 (`glm/glm-4`)

**Provider:** Zhipu AI (GLM)
**Cost:** Free
**Context:** 128K tokens

**Strengths:**
- Strong Python code generation
- Good documentation writing
- Solid general-purpose coding
- Handles long context well

**Best for:**
- Python boilerplate
- README and docs
- General code generation
- Test fixture data

**Limitations:**
- TypeScript inference slightly weaker than Copilot
- May need more specific prompts for complex types

---

### GitHub Copilot GPT-4.1 (`github-copilot/gpt-4.1`)

**Provider:** GitHub (via OpenAI)
**Cost:** Free with GitHub account
**Context:** 32K tokens

**Strengths:**
- Excellent TypeScript/JavaScript
- Strong code completion patterns
- Good at inferring types from context
- Familiar with popular frameworks

**Best for:**
- TypeScript interfaces
- React components
- Node.js code
- JavaScript refactoring

**Limitations:**
- Shorter context than GLM
- Requires GitHub authentication

---

## Model Selection Guide

| Task | Best Model | Reason |
|------|-----------|--------|
| TypeScript interfaces | github-copilot/gpt-4.1 | Superior TS inference |
| Python functions | glm/glm-4 | Strong Python patterns |
| Zod/Yup schemas | github-copilot/gpt-4.1 | TS ecosystem familiarity |
| Documentation | glm/glm-4 | Natural language quality |
| Test fixtures | Either | Both handle well |
| React components | github-copilot/gpt-4.1 | JSX expertise |
| FastAPI endpoints | glm/glm-4 | Python web frameworks |
| SQL queries | Either | Both capable |

## Adding New Models

To add new free models, update your MCP config:

```json
{
  "env": {
    "OPENCODE_CONFIG_CONTENT": "{\"models\":[\"glm/glm-4\",\"github-copilot/gpt-4.1\",\"new-model/name\"]}"
  }
}
```

Check OpenCode documentation for newly available free models.

## Fallback Order

Recommended fallback chain:

1. **Primary:** Model best suited for task type
2. **Secondary:** Other free model
3. **Escalate:** Return to Claude if both fail

Example for TypeScript task:
1. Try `github-copilot/gpt-4.1`
2. Fall back to `glm/glm-4`
3. Escalate to Claude
