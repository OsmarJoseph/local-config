require('minuet').setup({
  provider = 'openai_compatible',

  -- SPEED OPTIMIZATIONS:
  request_timeout = 1.5, -- Reduced from 2.5s
  throttle = 100,        -- REDUCED from 1500ms - trigger after 100ms pause
  debounce = 50,         -- REDUCED from 600ms - minimal debounce
  context_window = 2000, -- ADDED: limit context to 2000 chars (faster processing)

  -- Disable virtual text (using cmp instead)
  virtualtext = {
    enable = false,
  },

  -- Enable cmp integration
  cmp = {
    enable_auto_complete = true,
  },

  provider_options = {
    openai_compatible = {
      api_key = 'OPENCODE_API_KEY',
      end_point = 'https://opencode.ai/zen/v1/chat/completions',
      model = 'claude-haiku-4-5',
      name = 'AI',
      optional = {
        max_tokens = 64,   -- Short completions (faster)
        temperature = 0.2, -- Lower = faster, more deterministic
      },
    },
  },
})
