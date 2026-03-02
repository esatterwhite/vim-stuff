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
function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end
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
, 'tpope/vim-dispatch'
, {
    "hedyhli/outline.nvim",
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
        { desc = "Toggle Outline" })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
        providers = {
          priority = { 'lsp', 'treesitter', 'coc', 'markdown', 'norg' },
        },
      symbol_folding = {
        autofold_depth = 1,
        auto_unfold = {
          hovered = true,
        },
      },
      }
    end,
   event = 'VeryLazy',
   dependencies = {
    'epheien/outline-treesitter-provider.nvim'
   }
  }
, {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>tt", desc = "Send request" },
      { "<leader>ta", desc = "Send all requests" },
      { "<leader>tb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      -- your configuration comes here
      global_keymaps_prefix = "<leader>t",
      global_keymaps = {
        ["Send request <cr>"] = {
          "<CR>",
          function()
            require("kulala").run()
          end,
          mode = { "n", "v" },
          ft = { "http", "rest" },
        },
      },
    },
  }
, {
    'folke/snacks.nvim'
  , priority = 1000
  , lazy = false
  ---@type snacks.Config
  , opts = {
      indent = {enabled = true}
    , animate = {enabled = true}
    , input = {enabled = true}
    , picker = {enabled = false}
    , scope = {enabled = true}
    , layout = {enabled = true}
    , scroll = {enabled = true}
    , quickfile = {enabled = true}
    , statuscolumn = {enabled = true}
    , notifier = {
        enabled = true
      , timeout = 3000
      }
    }
  }
, {
    'yetone/avante.nvim'
  ,  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "make"
  , event = 'VeryLazy'
  , version = false
  , opts = {
      instructions_file = '.api/context.md'
    , provider = 'claude'
    , providers = {
        claude = {
          --model = 'claude-haiku-4-5',
          model = 'claude-sonnet-4-20250514',
          --[[ model = 'claude-opus-4-1',
          extra_request_body = {
            max_tokens = 32000,
          }
          --]]
        }
      }
    }
  , dependencies = {
      "nvim-lua/plenary.nvim"
    , "MunifTanjim/nui.nvim"
    , {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      }
    }
  }
, {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    options = {}
  }
, {
      "OXY2DEV/helpview.nvim",
      lazy = false, -- Recommended

      -- In case you still want to lazy load
      -- ft = "help",

      dependencies = {
          "nvim-treesitter/nvim-treesitter"
      }
  }
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
    end
  }

  -- LSP
, {
    'neovim/nvim-lspconfig',
    lazy = false,
    cmd = 'LspInfo',
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {
        'mason-org/mason.nvim',
        lazy = false,
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {
        'mason-org/mason-lspconfig.nvim', lazy = false,
        opts = {},
      },
    },
    config = function()
      -- This is where all the LSP shenanigans will live

      local lsp = require('lsp-zero')

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath('config')
            and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
          then
            return
          end
        end
        local opts = lsp.nvim_lua_ls()
        -- (Optional) Configure lua language server for neovim
        -- require('lspconfig').lua_ls.setup(opts)
        vim.lsp.config('lua_ls', opts)
      end)

      -- require('lspconfig').pylsp.setup({})
      vim.lsp.config('pylsp', {})

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
, {'mrcjkb/rustaceanvim', version = '^6', lazy = 'false', ft='rust'}
, {'simrat39/rust-tools.nvim', ft = 'rust'}
, {'cespare/vim-toml', ft = 'toml'}
, {'fatih/vim-go', ft= 'go'}
, {'cappyzawa/starlark.vim', ft = 'starlark'}
, 'edgedb/edgedb-vim'
, 'tweekmonster/django-plus.vim'
, 'mustache/vim-mustache-handlebars'
, 'mleonidas/tree-sitter-authzed'
, {'vim-python/python-syntax', ft = 'python'}
, {
    'puremourning/vimspector'
  , lazy = false
  , config = function()
      vim.cmd([[
        let g:vimspector_sidebar_width = 85
        let g:vimspector_bottombar_height = 15
        let g:vimspector_terminal_maxwidth = 100

        nmap <F9> <cmd>call vimspector#Launch()<cr>
        nmap <F5> <cmd>call vimspector#Continue()<cr>
        nmap <F8> <cmd>call vimspector#Reset()<cr>
        nmap <F11> <cmd>call vimspector#StepOver()<cr>")
        nmap <F12> <cmd>call vimspector#StepOut()<cr>")
        nmap <F10> <cmd>call vimspector#StepInto()<cr>")
        nmap <Leader>qq <cmd> call vimspector#ToggleBreakpoint()<cr>

        map('n', "Db", ":call vimspector#ToggleBreakpoint()<cr>")
        map('n', "Dw", ":call vimspector#AddWatch()<cr>")
        map('n', "De", ":call vimspector#Evaluate()<cr>")

      ]])
    end
  },
  {
  'stevearc/aerial.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
}
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

