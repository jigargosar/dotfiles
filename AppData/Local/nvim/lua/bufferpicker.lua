local M = {}

local state = {
  win = nil,
  buffers = {},
  selected = 1,
}

local function get_recent_buffers()
  local all_bufs = vim.fn.getbufinfo()
  local bufs = {}
  for _, buf in ipairs(all_bufs) do
    if buf.listed == 1 then
      table.insert(bufs, buf)
    end
  end
  table.sort(bufs, function(a, b)
    return a.lastused > b.lastused
  end)
  return bufs
end

local function render()
  local lines = {}
  for i, buf in ipairs(state.buffers) do
    local name = buf.name ~= "" and vim.fn.fnamemodify(buf.name, ":~:.") or "[No Name]"
    local prefix = i == state.selected and "> " or "  "
    lines[i] = prefix .. name
  end
  vim.bo[state.win.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.win.buf, 0, -1, false, lines)
  vim.bo[state.win.buf].modifiable = false
end

local function close()
  if state.win then
    state.win:close()
    state.win = nil
  end
end

local function select_buffer()
  local buf = state.buffers[state.selected]
  close()
  if buf then
    vim.api.nvim_set_current_buf(buf.bufnr)
  end
end

local function move(delta)
  state.selected = state.selected + delta
  if state.selected < 1 then state.selected = #state.buffers end
  if state.selected > #state.buffers then state.selected = 1 end
  render()
end

local function open()
  if state.win then return end

  state.buffers = get_recent_buffers()
  if #state.buffers == 0 then return end

  state.selected = 1
  local height = math.min(#state.buffers, 15)

  state.win = require("snacks").win({
    position = "float",
    width = 60,
    height = height,
    border = "rounded",
    minimal = true,
    enter = true,
    bo = { modifiable = false },
    keys = {
      ["<Space>"] = function() move(1) end,
      ["<S-Space>"] = function() move(-1) end,
      j = function() move(1) end,
      k = function() move(-1) end,
      ["<CR>"] = select_buffer,
      ["<Esc>"] = close,
      q = close,
    },
  })

  render()
  move(1)
end

-- Register keymap on load
vim.keymap.set("n", "<leader><leader>", open, { desc = "Buffer picker" })

return M
