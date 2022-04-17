-- package manager and plugins {{{
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("Packer", { clear = true }),
	pattern = { "init.lua" },
	command = "source <afile> | PackerCompile",
})

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
vim.api.nvim_create_augroup("QOL", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = "QOL",
	pattern = "*",
	command = [[:%s/\s\+$//e]],
	desc = "Remove whitespace on save",
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	group = "QOL",
	command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
	desc = "Return to same line on file reopen",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "QOL",
	command = [[setlocal formatoptions-=c formatoptions-=r formatoptions-=o]],
	desc = "Disable comment continuation",
})
-- settings }}}

-- mappings {{{
vim.g.mapleader = " "
-- Quicker than reaching for Escape
vim.keymap.set("i", "jk", "<Esc>")
-- Switch to previous file
vim.keymap.set("n", "<Space><Space>", "<C-^>")
-- Go to next buffer
vim.keymap.set("n", "<C-n>", ":bnext<CR>")
-- Save
vim.keymap.set("n", "<Leader>w", ":w<CR>")
-- Delete current buffer
-- vim.keymap.set("n", '<Leader>q', ':bp <BAR> bd #<CR>')
-- Split below
vim.keymap.set("n", "<Leader>s", "<C-W>s")
-- Split right
vim.keymap.set("n", "<Leader>v", "<C-W>v")
-- N always searches up the page
vim.keymap.set("n", "N", [['nN'[v:searchforward] . 'zz']], { expr = true })
-- n always searches down
vim.keymap.set("n", "n", [['Nn'[v:searchforward] . 'zz']], { expr = true })
-- Fix common typo
vim.keymap.set("n", "q:", ":q")
-- Use . shortcut with visual
vim.keymap.set("v", ".", ":normal .<CR>")
-- Fold easily
vim.keymap.set("n", "<Leader>f", "za")
vim.keymap.set("n", "<Leader>e", "zr")
vim.keymap.set("n", "<Leader>r", "zm")
-- cd to current file
vim.keymap.set("n", ">", ":lcd %:p:h<CR>")
-- cd to parent
vim.keymap.set("n", "<", ":lcd ..<CR>")
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
vim.api.nvim_create_autocmd("TextYankPost", {
	once = true,
	callback = function()
		vim.highlight.on_yank()
	end,
})
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
vim.api.nvim_create_augroup("Languages", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "Languages",
	pattern = { "make", "automake" },
	callback = function()
		vim.opt_local.expandtab = false
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "Languages",
	pattern = { "go" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.autowrite = true
		vim.opt_local.colorcolumn = "100"
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "Languages",
	pattern = { "gohtmltmpl" },
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.tabstop = 4
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "Languages",
	pattern = { "python" },
	callback = function()
		vim.opt_local.colorcolumn = "88"
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "Languages",
	pattern = { "rust" },
	callback = function()
		vim.opt_local.colorcolumn = "100"
	end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = "Languages",
	pattern = { "*.env" },
	callback = function()
		vim.opt_local.syntax = "txt"
		vim.opt_local.filetype = "txt"
	end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = "Languages",
	pattern = { "*.fish" },
	callback = function()
		vim.opt_local.syntax = "fish"
		vim.opt_local.filetype = "fish"
	end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = "Languages",
	pattern = { "*.tsv" },
	callback = function()
		vim.opt_local.tabstop = 20
		vim.opt_local.wrap = false
		vim.opt_local.listchars = {
			eol = " ",
			tab = "»-",
			trail = "·",
			precedes = "…",
			extends = "…",
			nbsp = "‗",
		}
	end,
})
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
vim.keymap.set("n", "<Leader>q", ":Bwipeout<CR>")
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
vim.keymap.set("n", ";", [[<cmd>lua require("telescope.builtin").buffers()<CR>]], { silent = true })
vim.keymap.set("n", "<C-p>", [[<cmd>lua require("telescope.builtin").find_files()<CR>]], { silent = true })
-- vim.keymap.set("n", "<leader>sb", [[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>]], { silent = true })
-- vim.keymap.set("n", "<leader>sh", [[<cmd>lua require("telescope.builtin").help_tags()<CR>]], { silent = true })
-- vim.keymap.set("n", "<leader>st", [[<cmd>lua require("telescope.builtin").tags()<CR>]], { silent = true })
-- vim.keymap.set("n", "<leader>sd", [[<cmd>lua require("telescope.builtin").grep_string()<CR>]], { silent = true })
vim.keymap.set("n", "<leader>a", [[<cmd>lua require("telescope.builtin").live_grep()<CR>]], { silent = true })
-- vim.keymap.set(
-- "n",
-- "<leader>so",
-- [[<cmd>lua require("telescope.builtin").tags{ only_current_buffer = true }<CR>]],
-- { silent = true },
-- )
-- vim.keymap.set("n", "<leader>?", [[<cmd>lua require("telescope.builtin").oldfiles()<CR>]], { silent = true })
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
	vim.keymap.set("n", "<leader>lf", [[<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>]], { buffer = bufnr })
	vim.keymap.set("n", "<leader>lD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]], { buffer = bufnr })
	vim.keymap.set("n", "<leader>ld", [[<cmd>lua vim.lsp.buf.definition()<CR>]], { buffer = bufnr })
	vim.keymap.set("n", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]], { buffer = bufnr })
	vim.keymap.set("n", "<leader>li", [[<cmd>lua vim.lsp.buf.implementation()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "<C-k>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "<leader>wa", [[<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "<leader>wr", [[<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "<leader>wl", [[<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "<leader>D", [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], { buffer = bufnr })
	vim.keymap.set("n", "<leader>ln", [[<cmd>lua vim.lsp.buf.rename()<CR>]], { buffer = bufnr })
	vim.keymap.set("n", "<leader>lr", [[<cmd>lua vim.lsp.buf.references()<CR>]], { buffer = bufnr })
	vim.keymap.set("n", "<leader>la", [[<cmd>lua vim.lsp.buf.code_action()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "<leader>e", [[<cmd>lua vim.diagnostic.open_float()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "[d", [[<cmd>lua vim.diagnostic.goto_prev()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "]d", [[<cmd>lua vim.diagnostic.goto_next()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "<leader>q", [[<cmd>lua vim.diagnostic.setloclist()<CR>]], { buffer = bufnr })
	-- vim.keymap.set("n", "<leader>so", [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>]], { buffer = bufnr })
	-- Goto previous/next diagnostic warning/error
	vim.keymap.set(
		"n",
		"<leader>le",
		[[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]],
		{ silent = true, buffer = bufnr }
	)
	vim.keymap.set(
		"n",
		"<leader>lE",
		[[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]],
		{ silent = true, buffer = bufnr }
	)

	-- vim.keymap.set("n", "g0", [[<cmd>lua vim.lsp.buf.document_symbol()<CR>]], { silent = true, buffer = bufnr })
	-- vim.keymap.set("n", "gW", [[<cmd>lua vim.lsp.buf.workspace_symbol()<CR>]], { silent = true, buffer = bufnr })
end

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
				debug = {
					openDebugPane = true,
				},
				inlayHints = {
					closureReturnTypeHints = true,
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
