---@alias swm.Position { row: integer, col: integer }

local swm = {}

---Return screen cursor position.
---@return swm.Position
local function get_screen_pos()
  local p = vim.fn.screenpos(0, vim.fn.line('.'), vim.fn.col('.'))
  return {
    row = p.row - 1,
    col = p.col - 1,
  }
end

---Return windows by position.
---NOTE: this consider z-index of windows.
---@param pos swm.Position
---@return integer
local function get_window_by_pos(pos)
  local z_index = -2
  local window = nil --[[@as integer?]]
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_row, win_col = unpack(vim.api.nvim_win_get_position(win))
    local win_pos = {
      row = win_row,
      col = win_col,
    }
    local win_size = {
      width = vim.api.nvim_win_get_width(win),
      height = vim.api.nvim_win_get_height(win) + 1, -- this is statusline offset.
    }
    local win_config = vim.api.nvim_win_get_config(win)
    local win_z_index = win_config.relative == '0' and -1 or win_config.zindex or 0

    local contains = true
    contains = contains and win_pos.row <= pos.row and pos.row < win_pos.row + win_size.height
    contains = contains and win_pos.col <= pos.col and pos.col < win_pos.col + win_size.width
    if contains then
      if win_z_index > z_index then
        z_index = win_z_index
        window = win
      end
    end
  end
  return window or vim.api.nvim_get_current_win()
end

function swm.h()
  local current_win = vim.api.nvim_get_current_win()

  local pos = get_screen_pos()
  while pos.col > 0 do
    pos.col = pos.col - 1
    local win = get_window_by_pos(pos)
    if win ~= current_win then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

function swm.j()
  local current_win = vim.api.nvim_get_current_win()

  local pos = get_screen_pos()
  while pos.row < vim.o.lines do
    pos.row = pos.row + 1
    local win = get_window_by_pos(pos)
    if win ~= current_win then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

function swm.k()
  local current_win = vim.api.nvim_get_current_win()

  local pos = get_screen_pos()
  while pos.row > 0 do
    pos.row = pos.row - 1
    local win = get_window_by_pos(pos)
    if win ~= current_win then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

function swm.l()
  local current_win = vim.api.nvim_get_current_win()

  local pos = get_screen_pos()
  while pos.col < vim.o.columns do
    pos.col = pos.col + 1
    local win = get_window_by_pos(pos)
    if win ~= current_win then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

return swm
