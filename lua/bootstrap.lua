local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'ctrlpvim/ctrlp.vim'
, 'airblade/vim-gitgutter'
, 'ryanoasis/vim-devicons'
, 'tpope/vim-fugitive'
, 'terryma/vim-multiple-cursors'
, {
    'vim-airline/vim-airline'
  , lazy = false
  , config = function()
      vim.cmd([[AirlineTheme gruvbox_material]])
    end
  }
, {'retorillo/istanbul.vim', ft = 'javascript'}
, 'tpope/vim-surround'
, 'tpope/vim-obsession'
, 'eugen0329/vim-esearch'
, {'dense-analysis/ale', lazy = false}
, 'Yggdroot/indentLine'
, 'tpope/vim-dispatch'
, 'luochen1990/rainbow'
, 'liuchengxu/vista.vim'

  -- lsp-zero
, {
    {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v2.x',
      lazy = true,
      config = function()
        -- This is where you modify the settings for lsp-zero
        -- Note: autocompletion settings will not take effect

        require('lsp-zero.settings').preset({})
      end
    }

  }
  -- Autocompletion
, {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'}
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

      require('lsp-zero.cmp').extend()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()

      --[[
      cmp.setup({
        snippet = {
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body)
            require('luasnip').lsp_expand(args.body)
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
      ]]--
    end
  }

  -- LSP
, {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
    },
    config = function()
      -- This is where all the LSP shenanigans will live

      local lsp = require('lsp-zero')

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
      end)

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()
    end
  }

  -- Markdown
, {'euclio/vim-markdown-composer', ft = 'markdown', layz=true}
, {'dhruvasagar/vim-table-mode', ft = 'markdown'}
, {'plasticboy/vim-markdown', ft = 'markdown'}
, {'mzlogin/vim-markdown-toc', ft = 'markdown'}
, {'akinsho/toggleterm.nvim', version = '2.x', config=true}

, {'nvim-tree/nvim-tree.lua', lazy=false}
, {'nvim-tree/nvim-web-devicons', lazy=false}
, 'towolf/vim-helm'
  -- languages
, {'tbastos/vim-lua', ft = 'lua'}
, {'moll/vim-node', ft = 'javascript'}
, 'pangloss/vim-javascript'
, {'rust-lang/rust.vim', ft = 'rust'}
, {'simrat39/rust-tools.nvim', ft = 'rust'}
, {'cespare/vim-toml', ft = 'toml'}
, {'fatih/vim-go', ft= 'go'}
, {'cappyzawa/starlark.vim', ft = 'starlark'}
, 'edgedb/edgedb-vim'
, 'tweekmonster/django-plus.vim'
, 'mustache/vim-mustache-handlebars'
, {'vim-python/python-syntax', ft = 'python'}

-- themes
, {
    'sainnhe/gruvbox-material'
  , lazy = false
  , priority = 1000
  , config = function()
      vim.cmd([[colorscheme gruvbox-material]])
    end
  }
, {'Lokaltog/vim-distinguished'}
, {'kristijanhusak/vim-hybrid-material'}
})

