local setup, tailwindHighlightColors = pcall(require, "tailwindcss-colors")
if not setup then
  return
end

tailwindHighlightColors.setup()
