local M = {}

M.buffer = nil

function M.show()
  local current_file = vim.fn.expand("%")
  local class_file = vim.fn.fnamemodify(current_file, ":r") .. ".class"

  vim.cmd("silent !javac " .. current_file)

  local javap_output = vim.fn.system("javap -v " .. class_file)
  local javap_output_lines = vim.split(javap_output, "\n")

  if M.buffer == nil or not vim.api.nvim_buf_is_valid(M.buffer) then
    vim.cmd("vsplit")
    M.buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(M.buffer, 0, -1, false, javap_output_lines)
    vim.api.nvim_win_set_buf(0, M.buffer)
    vim.cmd("setlocal buftype=nofile")
    vim.cmd("setlocal noswapfile")
    vim.cmd("setlocal bufhidden=wipe")
    --vim.cmd("setlocal nomodifiable")
  else
    vim.api.nvim_buf_set_lines(M.buffer, 0, -1, false, javap_output_lines)
    vim.api.nvim_win_set_buf(0, M.buffer)
  end
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
