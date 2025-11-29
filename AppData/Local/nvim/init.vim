source ~\AppData\Local\nvim\settings.vim


" Lazy bootstrap: Vimscript equivalent:
let s:lazypath = stdpath('data') .. '/lazy/lazy.nvim'
if !isdirectory(s:lazypath)
  call system('git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git ' .. s:lazypath)
endif
execute 'set rtp^=' .. s:lazypath

lua require('plugins')
