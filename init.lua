local opt = vim.opt
local g = vim.g

opt.guicursor = ""
opt.nu = true
opt.relativenumber = true
opt.cursorline = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.hlsearch = false
opt.incsearch = true

opt.smartindent = true

opt.scrolloff = 8

opt.updatetime = 50

opt.termguicolors = true

-- fix orgmode links


g.mapleader = " "


local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('iamcco/markdown-preview.nvim', { ['do']=function() vim.fn['mkdp#util#install']() end, ['for']= {'markdown', 'vim-plug'}})
Plug('windwp/nvim-autopairs')

Plug('nvim-treesitter/nvim-treesitter', {['do'] ='TSUpdate'})

Plug('jghauser/follow-md-links.nvim')

Plug('ixru/nvim-markdown')

Plug('AlexvZyl/nordic.nvim')

Plug('williamboman/mason.nvim')

--LSP autocomplete
Plug('neovim/nvim-lspconfig') -- Collection of configurations for built-in LSP client
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')

-- for luasnip users
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')

-- neat autocomplete formatting
Plug('onsails/lspkind.nvim')
Plug('jose-elias-alvarez/null-ls.nvim')

Plug('nvim-lua/plenary.nvim')


-- END
vim.call('plug#end')

require('nvim-autopairs').setup()
vim.keymap.set('n', '<bs>', ':edit #<cr>', { silent = true })

-- open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move lines upwards/downwards
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in the center of the screen when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

require('nordic').setup({
        bold_keywords = true,
        reduced_blue = true,
        cursorline = {
            -- Bold font in cursorline.
            bold = true,
            -- Bold cursorline number.
            bold_number = true,
            -- Avialable styles: 'dark', 'light'.
            theme = 'dark',
            -- Blending the cursorline bg with the buffer bg.
            blend = 0.85,
            noice = {
                -- Available styles: `classic`, `flat`.
                style = 'flat',
            },
            telescope = {
                -- Available styles: `classic`, `flat`.
                style = 'flat',
            },
        },

    })

vim.cmd('colorscheme nordic');


-- LSP CONFIG
--
local cmp = require'cmp'
local cmp_select = {behavior = cmp.SelectBehavior.Select}

local lspkind = require('lspkind')

cmp.setup({
  snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
  },

  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),

  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        path = "[path]",
        vsnip = "[snip]"
      }
    })
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' },
  }

})

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
  })
})

  -- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
  vim.keymap.set ("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  vim.keymap.set ("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
  vim.keymap.set ("n", "gr", "<cmd>Telescope lsp_references<CR>")
  vim.keymap.set ("n", "<C-j>", "<cmd>Telescope lsp_document_symbols<CR>")
  vim.keymap.set ("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")

  vim.keymap.set ("n", "gi", "<cmd>Telescope lsp_implementations<CR>")
  vim.keymap.set ("n", "<leader>D", "<cmd>Telescope lsp_type_definitions<CR>")
  vim.keymap.set ("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  vim.keymap.set ("n", '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  vim.keymap.set ("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  vim.keymap.set ("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
end

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.marksman.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {"marksman","server"}
})


-- format on save for prettier
local null_ls = require 'null-ls'
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.deno_fmt,
    null_ls.builtins.formatting.prettier.with {
      filetypes = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'}
    }
  },
  on_attach = function(client, bufnr)
    if client.supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
        end,
      })
    end
  end,
}
