require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "elmls" },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable({ "lua_ls", "elmls" })
    end,
  },
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  { "folke/snacks.nvim", opts = {} },
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
    -- keys = {
    --   {
    --     "<C-e>",
    --     function()
    --       require('telescope.builtin').buffers({
    --         sort_mru = true,
    --         initial_mode = "normal",
    --         layout_config = { prompt_position = "top", height = 0.4 },
    --         previewer = false,
    --         prompt_title = false,
    --         results_title = false,
    --         attach_mappings = function(prompt_bufnr, map)
    --           local actions = require('telescope.actions')
    --           map('n', '<C-e>', 'move_selection_next')
    --           map('n', 'e', 'select_default')
    --           map('n', '<Esc>', 'close')
    --           -- disable insert mode entry
    --           map('n', 'i', function() end)
    --           map('n', 'a', function() end)
    --           map('n', 'I', function() end)
    --           map('n', 'A', function() end)
    --           return false
    --         end,
    --       })
    --     end,
    --     desc = "Recent buffers",
    --   },
    -- },
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
        detection_methods = { "pattern" },
        patterns = { ".git", ".projectroot", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
        silent_chdir = false,
        exclude_dirs = { vim.fn.expand("~") },
      })
      require("telescope").load_extension("projects")
    end,
  },
  {
    "coder/claudecode.nvim",
    -- dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      -- { "<leader>a", nil, desc = "AI/Claude Code" },
      -- { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      -- { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      -- { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      -- { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      -- { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      -- { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      -- { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      -- {
      --   "<leader>as",
      --   "<cmd>ClaudeCodeTreeAdd<cr>",
      --   desc = "Add file",
      --   ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      -- },
      -- -- Diff management
      -- { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      -- { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "echasnovski/mini.clue",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        window = {
          config = {
            width = 'auto',
          },
          scroll_down = '<C-d>',
          scroll_up = '<C-u>',
        },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    enabled = false,
    opts = {},
  },
  {
    "ghillb/cybu.nvim",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    opts = {
      display_time = 0,
      style = { path = "relative" },
    },
  },
  {
    "anuvyklack/hydra.nvim",
    enabled = false,
  },
})
