-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Yanks go to the system clipboard via OSC 52, so they reach the real
-- clipboard even over SSH (tmux forwards them with set-clipboard on).
-- LazyVim disables clipboard sync when SSH_TTY is set — override that here,
-- since this file loads after LazyVim's defaults.
-- Terminals refuse OSC 52 *reads*, so paste inside nvim falls back to the
-- unnamed register; pasting from the OS clipboard stays the terminal's own
-- paste (Ctrl+Shift+V / right-click).
local function paste_from_unnamed()
  return vim.split(vim.fn.getreg('"'), "\n")
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste_from_unnamed,
    ["*"] = paste_from_unnamed,
  },
}
vim.opt.clipboard = "unnamedplus"
