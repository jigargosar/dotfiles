local function cmd(...)
  return '<Cmd>' .. table.concat({...}) .. '<CR>'
end

local function setn(keys, command, opts)
  vim.keymap.set('n', keys, command, opts)
end

local cfg = vim.fn.stdpath("config")

-- Edit
setn('<leader>e', '', { desc = '+edit' })
setn('<leader>ec', cmd('edit ', cfg, '/init.vim'), { desc = 'Edit init.vim' })
setn('<leader>es', cmd('edit ', cfg, '/settings.vim'), { desc = 'Edit settings.vim' })
setn('<leader>ep', cmd('edit ', cfg, '/lua/plugins.lua'), { desc = 'Edit plugins.lua' })
setn('<leader>ek', cmd('edit ', cfg, '/lua/keymaps.lua'), { desc = 'Edit keymaps.lua' })

-- Source
setn('<leader>s', '', { desc = '+source' })
setn('<leader>ss', cmd('source ', cfg, '/settings.vim'), { desc = 'Source settings.vim' })
setn('<leader>sc', cmd('source %'), { desc = 'Source current file' })
setn('<leader>sl', cmd('.source'), { desc = 'Source current line' })

-- Telescope
setn('<leader>t', '', { desc = '+telescope' })
setn('<leader>tp', cmd('Telescope projects'), { desc = 'Projects' })
setn('<leader>tf', cmd('Telescope find_files'), { desc = 'Find files' })
setn('<leader>tr', cmd('Telescope oldfiles'), { desc = 'Recent files' })
setn('<leader>tg', cmd('Telescope git_files'), { desc = 'Git files' })
setn('<leader>ts', cmd('Telescope live_grep'), { desc = 'Search (grep)' })
setn('<leader>tb', cmd('Telescope buffers'), { desc = 'Buffers' })
setn('<leader>th', cmd('Telescope help_tags'), { desc = 'Help tags' })
setn('<leader>tc', cmd('Telescope colorscheme'), { desc = 'Colorschemes' })
setn('<leader>td', cmd('Telescope diagnostics'), { desc = 'Diagnostics' })
setn('<leader>tl', cmd('Telescope lsp_document_symbols'), { desc = 'LSP symbols' })
