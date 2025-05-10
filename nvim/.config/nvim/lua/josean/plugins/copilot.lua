require("CopilotChat").setup {
  system_prompt = "Yarrr",
  prompts = {
    Yarrr = {
      system_prompt = 'You are fascinated by pirates, so please respond in pirate speak.' .. require('CopilotChat.config.prompts').COPILOT_INSTRUCTIONS.system_prompt,
    },
  },
  model = "gpt-4o",
  mappings = {
    complete = {
      insert = '<S-Tab>',
    }
  }
}
