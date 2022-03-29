-- package manager and plugins {{{
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
vim.cmd([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]])

-- install plugins
local use = require("packer").use
require("packer").startup(function()
	use("wbthomason/packer.nvim") -- Package manager

	-- basic plugins
	use("alexghergh/nvim-tmux-navigation") -- Seamless vim/tmux pane navigation with <C-h/j/k/l>
	use("earthly/earthly.vim") -- Earthfile support
	use("moll/vim-bbye") -- Prevent closing files from messing with splits
	use({ -- Colorscheme
		"ellisonleao/gruvbox.nvim",
		requires = { "rktjmp/lush.nvim" },
	})
	use("sheerun/vim-polyglot") -- Language support
	use("svermeulen/vimpeccable") -- Simpler remaps for lua configs
	use("tpope/vim-repeat") -- Allow '.' repeat action everywhere
	use("tpope/vim-surround") -- Add new actions for surroundings

	-- advanced plugins
	use("nvim-lualine/lualine.nvim") -- Status bar and tab (buffer) bar
	use({ -- Fuzzy finder
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	use({ -- Smarter parsing
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("neovim/nvim-lspconfig") -- LSP Support
	use({ -- Run linters and formatters via LSP
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
	})
	use("simrat39/rust-tools.nvim") -- Better LSP support for Rust
	use("hrsh7th/nvim-cmp") -- Autocompletion
	use("hrsh7th/cmp-nvim-lsp") -- Completion source: LSP
	use("hrsh7th/cmp-buffer") -- Completion source: buffers
	use("hrsh7th/cmp-path") -- Completion source: paths
end)
-- install package manager and plugins }}}

-- settings {{{
-- Cross-platform copy/paste in and out of vim
vim.opt.clipboard = "unnamed,unnamedplus"
vim.g.clipboard = {
	name = "pb",
	copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
	paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
	cache_enabled = 1,
}
-- Give more space for displaying messages
vim.opt.cmdheight = 2
-- Don't autoselect any completion options, always show menu with 1+ matches
vim.opt.completeopt = "noinsert,menuone,noselect"
-- Use unix line endings
vim.opt.fileformat = "unix"
-- Fold on triple brackets
vim.opt.foldmethod = "marker"
-- Use faster tools if available
if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --no-heading --vimgrep"
	vim.opt.grepformat = "%f:%l:%c:%m"
end
-- Switch between buffers without needing to save
vim.opt.hidden = true
-- Case sensitive search if any capital letters are present (+smartcase)
vim.opt.ignorecase = true
-- Show search results as you type
if vim.fn.exists("&inccommand") then
	vim.opt.inccommand = "nosplit"
end
-- Improve performace when using macros/registers
vim.opt.lazyredraw = true
-- Break lines on words, not characters
vim.opt.linebreak = true
-- Display non-printable characters
vim.opt.list = true
-- Enable mouse usage
vim.opt.mouse = "a"
-- Hide line numbers, show diagnostics
vim.opt.number = false
vim.opt.relativenumber = false
if vim.fn.has("patch-8.1.1564") then
	-- Recently vim can merge signcolumn and number column into one
	vim.opt.number = true
	vim.opt.signcolumn = "number"
else
	vim.opt.signcolumn = "yes"
end
-- Complete <C-x><C-o> from syntax
vim.opt.omnifunc = "syntaxcomplete#Complete"
-- Sometimes it's required for pasting large blocks
vim.opt.pastetoggle = "<F2>"
-- Always show eight lines below the cursor
vim.opt.scrolloff = 8
-- Don't show 'match 1 of 2' in completion menus
vim.opt.shortmess:append({ c = true })
-- Show the vim command as you type it
vim.opt.showcmd = true
-- Display a message when in INSERT mode (disabled for airline)
vim.opt.showmode = false
-- Case sensitive if any capital letters in term
vim.opt.smartcase = true
-- Two spaces on tab key, display three spaces for tab character
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 3
vim.opt.shiftround = true
vim.opt.expandtab = true
-- Open new windows below and to the right
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Only highlight first x characters
vim.opt.synmaxcol = 1000
-- Store persistent undo history
vim.opt.undofile = true
-- Having longer updatetime (default is 4000 ms / 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300
-- Command line ignore
vim.opt.wildignore:append("*/.git/*,*/tmp/*,*.swp,*/.venv/*")
-- Command line completion
vim.opt.wildmode = "list:longest"
-- Save files in one action
vim.opt.writebackup = false
vim.cmd([[
augroup QOL
  autocmd!

  " Remove whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Return to same line on file reopen
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif

  " Disable comment continuation
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END
]])
-- settings }}}

-- mappings {{{
vim.g.mapleader = " "
local vimp = require("vimp")
-- Quicker than reaching for Escape
vimp.inoremap("jk", "<Esc>")
-- Switch to previous file
vimp.nnoremap("<Space><Space>", "<C-^>")
-- Go to next buffer
vimp.nnoremap("<C-n>", ":bnext<CR>")
-- Save
vimp.nnoremap("<Leader>w", ":w<CR>")
-- Delete current buffer
-- vimp.nnoremap('<Leader>q', ':bp <BAR> bd #<CR>')
-- Split below
vimp.nnoremap("<Leader>s", "<C-W>s")
-- Split right
vimp.nnoremap("<Leader>v", "<C-W>v")
-- N always searches up the page
vimp.nnoremap({ "expr" }, "N", [['nN'[v:searchforward] . 'zz']])
-- n always searches down
vimp.nnoremap({ "expr" }, "n", [['Nn'[v:searchforward] . 'zz']])
-- Fix common typo
vimp.nnoremap("q:", ":q")
-- Use . shortcut with visual
vimp.vnoremap(".", ":normal .<CR>")
-- Fold easily
vimp.nnoremap("<Leader>f", "za")
vimp.nnoremap("<Leader>e", "zr")
vimp.nnoremap("<Leader>r", "zm")
-- cd to current file
vimp.nnoremap(">", ":lcd %:p:h<CR>")
-- cd to parent
vimp.nnoremap("<", ":lcd ..<CR>")
-- mappings }}}

-- looks {{{
vim.opt.termguicolors = true
vim.g.gruvbox_number_column = "bg1"
vim.g.gruvbox_italic = true
vim.g.gruvbox_italicize_strings = true
vim.g.gruvbox_contrast_light = "hard"
vim.cmd([[ colorscheme gruvbox ]])
if vim.env.LIGHTS == "on" then
	vim.opt.background = "light"
else
	vim.opt.background = "dark"
end
vim.opt.colorcolumn = "80"
vim.cursorline = false
vim.cursorcolumn = false
-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
-- Better looking splits
vim.cmd([[hi VertSplit ctermbg=NONE guibg=NONE]])
-- Show indicator for wrapped lines
vim.opt.showbreak = "\\ "
--- looks }}}

-- language settings {{{
vim.g.python_highlight_all = 1
if vim.fn.isdirectory(vim.env.PYTHON3_BIN) then
	vim.g.python3_host_prog = vim.env.PYTHON3_BIN .. "/python3"
end
vim.cmd([[
augroup Languages
  autocmd!
  au FileType make,automake setl noexpandtab
  au FileType go setl noexpandtab shiftwidth=4 softtabstop=4 tabstop=4 autowrite colorcolumn=100
  au FileType gohtmltmpl setl expandtab shiftwidth=2 softtabstop=2 tabstop=4
  au FileType python setl colorcolumn=88 shiftwidth=4 softtabstop=4
  au FileType rust setl colorcolumn=100
  au BufNewFile,BufRead *.env set syntax=txt filetype=txt
  au BufNewFile,BufRead *.fish set syntax=fish filetype=fish
  au BufRead,BufNewFile *.tsv setlocal tabstop=20 nowrap listchars=eol:\ ,tab:»-,trail:·,precedes:…,extends:…,nbsp:‗ list
augroup END
]])
-- language settings }}}

-- basic plugin settings {{{
-- alexghergh/nvim-tmux-navigation
require("nvim-tmux-navigation").setup({
	disable_when_zoomed = true,
	keybindings = {
		left = "<C-h>",
		down = "<C-j>",
		up = "<C-k>",
		right = "<C-l>",
		last_active = "<C-\\>",
		next = "<C-Space>",
	},
})
-- moll/vim-bbye
vimp.nnoremap("<Leader>q", ":Bwipeout<CR>")
-- basic plugin settings }}}

-- advanced plugin settings {{{
-- lualine {{{
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "gruvbox",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", {
			"diagnostics",
			sources = { "nvim_diagnostic" },
		} },
		lualine_c = { { "filename", file_statue = true, path = 1 } },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = {},
		lualine_z = { "%l/%L : %c" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", file_statue = true, path = 1 } },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { { "buffers", show_filename_only = false } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {},
})
-- lualine }}}

-- telescope {{{
vimp.nnoremap({ "silent" }, ";", [[<cmd>lua require("telescope.builtin").buffers()<CR>]])
vimp.nnoremap({ "silent" }, "<C-p>", [[<cmd>lua require("telescope.builtin").find_files()<CR>]])
-- vimp.nnoremap({ "silent" }, "<leader>sb", [[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>]])
-- vimp.nnoremap({ "silent" }, "<leader>sh", [[<cmd>lua require("telescope.builtin").help_tags()<CR>]])
-- vimp.nnoremap({ "silent" }, "<leader>st", [[<cmd>lua require("telescope.builtin").tags()<CR>]])
-- vimp.nnoremap({ "silent" }, "<leader>sd", [[<cmd>lua require("telescope.builtin").grep_string()<CR>]])
vimp.nnoremap({ "silent" }, "<leader>a", [[<cmd>lua require("telescope.builtin").live_grep()<CR>]])
-- vimp.nnoremap(
-- { "silent" },
-- "<leader>so",
-- [[<cmd>lua require("telescope.builtin").tags{ only_current_buffer = true }<CR>]]
-- )
-- vimp.nnoremap({ "silent" }, "<leader>?", [[<cmd>lua require("telescope.builtin").oldfiles()<CR>]])
-- telescope }}}

-- treesitter {{{
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = true,
	},
})
-- treesitter }}}

-- completion {{{
local cmp = require("cmp")
cmp.setup({
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		-- ["<C-Space>"] = cmp.mapping.complete(),
		-- ["<C-e>"] = cmp.mapping.close(),
		-- ["<CR>"] = cmp.mapping.confirm({
			-- behavior = cmp.ConfirmBehavior.Replace,
			-- select = true,
		-- }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})
-- completion }}}

-- lsp {{{
local nvim_lsp = require("lspconfig")
local on_attach = function(_, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vimp.add_buffer_maps(bufnr, function()
		vimp.nnoremap("<leader>lf", [[<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>]])
		vimp.nnoremap("<leader>lD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]])
		vimp.nnoremap("<leader>ld", [[<cmd>lua vim.lsp.buf.definition()<CR>]])
		vimp.nnoremap("K", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
		vimp.nnoremap("<leader>li", [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
		-- vimp.nnoremap("<C-k>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
		-- vimp.nnoremap("<leader>wa", [[<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>]])
		-- vimp.nnoremap("<leader>wr", [[<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>]])
		-- vimp.nnoremap("<leader>wl", [[<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>]])
		-- vimp.nnoremap("<leader>D", [[<cmd>lua vim.lsp.buf.type_definition()<CR>]])
		vimp.nnoremap("<leader>ln", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
		vimp.nnoremap("<leader>lr", [[<cmd>lua vim.lsp.buf.references()<CR>]])
		vimp.nnoremap("<leader>la", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
		-- vimp.nnoremap("<leader>e", [[<cmd>lua vim.diagnostic.open_float()<CR>]])
		-- vimp.nnoremap("[d", [[<cmd>lua vim.diagnostic.goto_prev()<CR>]])
		-- vimp.nnoremap("]d", [[<cmd>lua vim.diagnostic.goto_next()<CR>]])
		-- vimp.nnoremap("<leader>q", [[<cmd>lua vim.diagnostic.setloclist()<CR>]])
		-- vimp.nnoremap("<leader>so", [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>]])
		-- Goto previous/next diagnostic warning/error
		vimp.nnoremap({ "silent" }, "<leader>le", [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]])
		vimp.nnoremap({ "silent" }, "<leader>lE", [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]])

		-- vimp.nnoremap({ "silent" }, "g0", [[<cmd>lua vim.lsp.buf.document_symbol()<CR>]])
		-- vimp.nnoremap({ "silent" }, "gW", [[<cmd>lua vim.lsp.buf.workspace_symbol()<CR>]])
	end)
end
-- Show issues with code under cursor (if any)
-- vim.cmd([[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]])

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Enable the following language servers
-- (rust is handled separately below)
local servers = {
	"pyright",
	"tsserver",
}
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	})
end
local opts = {
	tools = { -- rust-tools options
		autoSetHints = true,
		hover_with_actions = true,
		inlay_hints = {
			show_parameter_hints = true,
		},
	},
	-- all the opts to send to nvim-lspconfig
	-- these override the defaults set by rust-tools.nvim
	-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
	server = {
		-- on_attach is a callback called when the language server attachs to the buffer
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			-- to enable rust-analyzer settings visit:
			-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
			["rust-analyzer"] = {
				-- enable clippy on save
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}
require("rust-tools").setup(opts)

local null_ls = require("null-ls")
null_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	sources = {
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.stylua,
	},
})
-- lsp }}}
-- advanced plugin settings }}}
