source ~\AppData\Local\nvim\settings.vim


" Lazy bootstrap: Vimscript equivalent:
let s:lazypath = stdpath('data') .. '/lazy/lazy.nvim'
if !isdirectory(s:lazypath)
  call system('git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git ' .. s:lazypath)
endif
execute 'set rtp^=' .. s:lazypath

lua << EOF
require("lazy").setup({
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "elm" },
        auto_install = true,
        highlight = { enable = true },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      pickers = {
        colorscheme = { enable_preview = true },
      },
    },
  },
  {
    "levouh/tint.nvim",
    opts = {
      tint = -70,
      saturation = 0.1,
    },
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        silent_chdir = false,
        exclude_dirs = { vim.fn.expand("~") },
      })
      require("telescope").load_extension("projects")
    end,
  },
})
EOF
