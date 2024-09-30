local setup, octo = pcall(require, "octo")
if not setup then
  return
end

octo.setup({
  suppress_missing_scope = {
    projects_v2 = true,
  }
})
