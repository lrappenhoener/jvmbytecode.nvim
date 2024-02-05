local M = {}

local preparewin = function(lines)
  if M.win == nil or not vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_command("vsplit")
    M.win = vim.api.nvim_get_current_win()
    M.buf = vim.api.nvim_create_buf(false, true)

    -- vim.api.nvim_set_option_value('buftype', 'nofile', { buf = M.buf })
    -- vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = M.buf })
    -- vim.api.nvim_set_option_value('filetype', 'jvmbytecode', { buf = M.buf })

    vim.api.nvim_win_set_buf(M.win, M.buf)
  end  

  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
end

local getclassinfo = function(classfile)
  local javap_output = vim.fn.system("javap -v " .. classfile)
  return vim.split(javap_output, "\n")
end

local compile = function(file)
  vim.cmd("silent !javac " .. file)
end

function M.show()
  local current_file = vim.fn.expand("%")
  local class_file = vim.fn.fnamemodify(current_file, ":r") .. ".class"

  compile(current_file)
  local classinfo = getclassinfo(class_file)
  preparewin(classinfo)
end

function M.setup()
  print ("setup jvmbytecode")
  local autocmd = vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
      print("setup jvmbytecode key mapping")
      vim.keymap.set({"n"}, "<leader>xb", "<cmd>lua require('jvmbytecode').show()<CR>", { noremap = true, silent = true, desc = "JVM Bytecode" })
    end
  })
end

return M
