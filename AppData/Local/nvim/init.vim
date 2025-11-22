" lazy.nvim bootstrap and setup
" lua << LUA
" local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
" if not vim.loop.fs_stat(lazypath) then
"   vim.fn.system({
"     "git",
"     "clone",
"     "--filter=blob:none",
"     "https://github.com/folke/lazy.nvim.git",
"     "--branch=stable",
"     lazypath,
"   })
" end
" vim.opt.rtp:prepend(lazypath)
"
" require("lazy").setup({})
" LUA

" Vimscript equivalent:
let s:lazypath = stdpath('data') .. '/lazy/lazy.nvim'
if !isdirectory(s:lazypath)
  call system('git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git ' .. s:lazypath)
endif
execute 'set rtp^=' .. s:lazypath

lua require("lazy").setup({})
