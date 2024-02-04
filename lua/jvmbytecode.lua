local M = {}

local function createwin()
  vim.cmd("vsplit")
  vim.api.nvim_create_buf(false, true)
  M.buf = vim.api.nvim_get_current_buf()
  M.win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = M.buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = M.buf })
  vim.api.nvim_set_option_value('filetype', 'rapid', { buf = M.buf })
end

function M.show()
  local current_file = vim.fn.expand("%")
  local class_file = vim.fn.fnamemodify(current_file, ":r") .. ".class"

  vim.cmd("silent !javac " .. current_file)

  local javap_output = vim.fn.system("javap -v " .. class_file)
  local javap_output_lines = vim.split(javap_output, "\n")
  
  if not M.win or not vim.api.nvim_win_is_valid(M.win) then
     createwin()
  end

  print (vim.inspect(M))

  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, javap_output_lines)
  vim.api.nvim_win_set_buf(0, M.buf)
end

function M.setup()
  local autocmd = vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.java",
    callback = function()
      vim.api.nvim_set_keymap("n", "<leader>jbc", "<cmd>lua require('jvmbytecode').show()<CR>", { noremap = true, silent = true })
    end
  })
end

return M
