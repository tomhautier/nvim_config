vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap de Lazy.nvim (installation auto)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Chargement des options et keymaps de base
require("thomas.set")
require("thomas.remap")

-- Chargement des plugins via Lazy
require("lazy").setup("thomas.plugins")
