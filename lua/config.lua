local status_ok, toggleterm = pcall(require, "toggleterm")
local cmp = require("cmp")
--local lspconfig = require('lspconfig')
local nvim_tree_api = require('nvim-tree.api')
local indent_line = require('ibl')

--lspconfig.ts_ls.setup{}
--lspconfig.tilt_ls.setup{}

require("mason").setup()
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      print(server_name)
      --[[
      if server_name == 'ts_ls' then
        return
      end
      ]]--

      require('lspconfig')[server_name].setup({})
    end,
  }
})
indent_line.setup()

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--[[
require('gruvbox').setup({
  italic = {
    strings = false,
    comments = true,
    folds = true,
    operators = false,
  },
  transparent_mode = false,
  contrast = "",
  dim_inactive = false,
  overrides = {
    Todo = { fg = '#d3869b' },
  },
})
]]

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  on_attach = function(buf)
    nvim_tree_api.config.mappings.default_on_attach(buf)
    vim.keymap.set('n', 's', nvim_tree_api.node.open.vertical, {desc = 'nvim-tree: Open: Vertical Split', buffer = buf, noremap = true, silent = true, nowait = true})
    vim.keymap.set('n', 'v', nvim_tree_api.node.open.horizontal, {desc = 'nvim-tree: Open: Horizontal Split', buffer = buf, noremap = true, silent = true, nowait = true})
  end
})

--[[
lspconfig.rust_analyzer.setup({
  on_attach=function(client)
  end,
  settings = {
    ['rust_analyzer'] = {
      import = {
        granularity = {group = 'module'},
        prefix = 'self',
      },
      cargo = {
        buildScripts = {enable = true},
      },
      procMacro = {enable = true},
    }
  }
})
]]
cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      --vim.fn["vsnip#anonymous"](args.body)
      --require('luasnip').lsp_expand(args.body)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },

  -- Installed sources
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "buffer" },
  },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.authzed = {
        install_info = {
                url = "https://github.com/mleonidas/tree-sitter-authzed", -- local path or git repo
                files = { "src/parser.c" },
                generate_requires_npm = false,
                requires_generate_from_grammar = false,
                -- optional entries:
                branch = "main", -- default branch in case of git repo if different from master
        },
        filetype = "authzed", -- if filetype does not match the parser name
}

if not status_ok then return end
toggleterm.setup({
  size = 100,
  open_mapping = [[<c-\>]],
  shading_factor = 2,
  direction = "vertical",
  close_on_exit = false,
  float_opts = {
    border = "curved",
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})
