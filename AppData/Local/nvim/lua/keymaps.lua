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
