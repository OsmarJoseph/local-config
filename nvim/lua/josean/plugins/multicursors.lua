local status, multi = pcall(require, "vim-visual-multi")
if not status then
  return
end

multi.setup()
