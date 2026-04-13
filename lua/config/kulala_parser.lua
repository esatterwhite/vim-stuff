-- Kulala HTTP parser registration
-- This ensures the kulala_http parser is properly registered for http/rest files

local M = {}

-- Function to register the kulala_http parser for http filetypes
function M.register_parser()
  -- Register kulala_http parser for http and rest filetypes
  local ok = pcall(function()
    vim.treesitter.language.register("kulala_http", {"http", "rest"})
  end)

  if ok then
    -- Also ensure the parser path is in runtime path
    local parser_path = vim.fn.expand("~/.local/share/nvim/site")
    if not vim.tbl_contains(vim.opt.runtimepath:get(), parser_path) then
      vim.opt.runtimepath:prepend(parser_path)
    end

    -- Also add kulala's own parser path
    local kulala_parser_path = vim.fn.expand("~/.local/share/nvim/lazy/kulala.nvim/lua/tree-sitter")
    if vim.fn.isdirectory(kulala_parser_path) == 1 then
      vim.opt.runtimepath:append(kulala_parser_path)
    end
  end
end

-- Function to ensure highlighting is enabled for http files
function M.ensure_highlighting()
  local ft = vim.bo.filetype
  if ft == "http" or ft == "rest" then
    -- Make sure parser is registered
    M.register_parser()

    -- Try to enable highlighting if it's not active
    vim.defer_fn(function()
      local bufnr = vim.api.nvim_get_current_buf()
      local ts_active = vim.treesitter.highlighter.active[bufnr] ~= nil

      if not ts_active then
        -- Try to start the highlighter
        pcall(function()
          vim.cmd("TSBufEnable highlight")
        end)
      end
    end, 50)
  end
end

-- Set up autocmds
function M.setup()
  -- Register parser on startup
  M.register_parser()

  -- Create autocmd group
  local group = vim.api.nvim_create_augroup("KulalaParserSetup", { clear = true })

  -- Register parser when entering an http/rest file
  vim.api.nvim_create_autocmd({"BufEnter", "BufReadPost", "BufNewFile"}, {
    group = group,
    pattern = {"*.http", "*.rest"},
    callback = function()
      M.ensure_highlighting()
    end,
  })

  -- Also register when filetype is set
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {"http", "rest"},
    callback = function()
      M.ensure_highlighting()
    end,
  })
end

return M

