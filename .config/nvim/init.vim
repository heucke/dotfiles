" init {{{
if has('nvim')
  let s:editor_root=expand('~/.config/nvim')
else
  let s:editor_root=expand('~/.vim')
endif
let &runtimepath.=','.s:editor_root
" automatically installs vim-plug in s:editor_root for us
if empty(glob(s:editor_root . '/autoload/plug.vim'))
  silent exec '!curl -fLo '.s:editor_root.'/autoload/plug.vim --create-dirs '
  \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync
endif
" init }}}

call plug#begin(s:editor_root . '/plugged')
" basic plugins {{{
" Plugin settings are at the end of this file
" quality of life
Plug 'christoomey/vim-tmux-navigator'  "seamless tmux/vim navigation <C-hjkl>
Plug 'moll/vim-bbye'                   "don't close window on last buffer close
Plug 'tpope/vim-repeat'                "fix repeat (.) for plugin actions
Plug 'tpope/vim-surround'              "change text surrounding other text
" fuzzy find everything
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "installs fzf
Plug 'junegunn/fzf.vim'                "provides helpful commands like :Rg
" looks
Plug 'morhetz/gruvbox'                 "color scheme
Plug 'sheerun/vim-polyglot'            "syntax support
Plug 'vim-airline/vim-airline'         "status bar
" basic plugins }}}
" advanced plugins {{{
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" advanced plugins }}}
call plug#end()

" settings {{{
" sensible (neovim) defaults {{{
" https://github.com/neovim/neovim/blob/master/runtime/doc/vim_diff.txt
if !has('nvim')
  syntax on
  filetype plugin indent on
  set autoindent
  set autoread
  set background=dark
  set backspace=indent,eol,start
  silent call system('mkdir -p '.s:editor_root.'/backup')
  let &backupdir=s:editor_root.'/backup'
  set belloff=all
  set complete-=i
  set cscopeverbose
  silent call system('mkdir -p '.s:editor_root.'/swap')
  let &directory=s:editor_root.'/swap'
  "set display=lastline,msgsep
  " msgsep arg doesn't exist
  set display=lastline
  set encoding=UTF-8
  "set fillchars=vert:│,fold:·,sep:│
  " invalid argument
  set fillchars+=vert:│
  set formatoptions=tcqj
  set nofsync
  set history=1000
  set hlsearch
  set incsearch
  set langnoremap
  set nolangremap
  set laststatus=2
  "set listchars=tab:> ,trail:-,nbsp:+
  " invalid argument
  set listchars=tab:>-,trail:-,nbsp:+
  set nrformats=bin,hex
  set ruler
  set sessionoptions-=options
  set shortmess+=F
  set shortmess-=S
  set showcmd
  set sidescroll=1
  set smarttab
  set nostartofline
  set tabpagemax=50
  set tags=./tags;,tags
  set ttimeoutlen=50
  set ttyfast
  silent call system('mkdir -p '.s:editor_root.'/undo')
  let &undodir=s:editor_root.'/undo/'
  set viminfo-=!
  set wildmenu
  "set wildoptions=pum,tagfile
  " pum not a valid option
  set wildoptions=tagfile
endif
" }}}
" behavior {{{
" Don't autoselect any completion options, always show menu with 1+ matches
set completeopt=noinsert,menuone,noselect
" Cross-platform copy/paste in and out of vim
set clipboard^=unnamed,unnamedplus
let g:clipboard={
\    'name': 'pb',
\    'copy': { '+': 'pbcopy', '*': 'pbcopy' },
\    'paste': { '+': 'pbpaste', '*': 'pbpaste' },
\    'cache_enabled': 1,
\ }
" Use unix line endings
set fileformat=unix
" Fold on triple brackets
set foldmethod=marker
" Use faster tools if available
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --vimgrep
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" Switch between buffers without needing to save
set hidden
" Case sensitive search if any capital letters are present (+smartcase)
set ignorecase
" Show search results as you type
if exists('&inccommand')
  set inccommand=nosplit
endif
" Break lines on words, not characters
set linebreak
" Display non-printable characters
set list
" Enable mouse usage
set mouse=a
" Hide absolute line number for current line
set nonumber
" Hide relative line numbers too
set norelativenumber
" Complete <C-x><C-o> from syntax
set omnifunc=syntaxcomplete#Complete
" Always show eight lines below the cursor
set scrolloff=8
" Don't show 'match 1 of 2' in completion menus
set shortmess+=c
" Show the vim command as you type it
set showcmd
" Display a message when in INSERT mode (disabled for airline)
set noshowmode
" Case sensitive if any capital letters in term
set smartcase
" Two spaces on tab key, display three spaces for tab character
set softtabstop=2 shiftwidth=2 tabstop=3 shiftround expandtab
" Open new windows below and to the right
set splitbelow splitright
" Store persistent undo history
set undofile
" Command line ignore
set wildignore+=*/.git/*,*/tmp/*,*.swp,*/.venv/*
" Command line completion
set wildmode=list:longest
" }}}
" performance {{{
" Improve performace when using macros/registers
set lazyredraw
" Save files in one action
set nowritebackup
" Only highlight first 300 characters
set synmaxcol=400
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" }}}
" terminal {{{
augroup vimrc_term
  autocmd!
  " remove any highlighted text from a previous search
  autocmd WinEnter term://* nohlsearch
  " automatically enter insert mode when switching to a :term window
  autocmd WinEnter term://* startinsert

  if has('nvim')
    " allow <C-hjkl> to navigate windows even in insert mode in a :term window
    autocmd TermOpen * tnoremap <buffer> <C-h> <C-\><C-n><C-w>h
    autocmd TermOpen * tnoremap <buffer> <C-j> <C-\><C-n><C-w>j
    autocmd TermOpen * tnoremap <buffer> <C-k> <C-\><C-n><C-w>k
    autocmd TermOpen * tnoremap <buffer> <C-l> <C-\><C-n><C-w>l
    autocmd TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
    autocmd TermOpen * tnoremap <buffer> jk    <C-\><C-n>
  endif

  " fzf launches in it's own filetype :term window
  autocmd FileType fzf tunmap <buffer> <Esc>
  autocmd FileType fzf tunmap <buffer> <C-h>
  autocmd FileType fzf tunmap <buffer> <C-j>
  autocmd FileType fzf tunmap <buffer> <C-k>
  autocmd FileType fzf tunmap <buffer> <C-l>
augroup END

"history search for commands
cnoremap <c-n>  <down>
cnoremap <c-p>  <up>
" }}}
" autocommands {{{
augroup QOL
  autocmd!

  " Remove whitespace on save
  au BufWritePre * :%s/\s\+$//e

  " Return to same line on file reopen
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif

  " Disable comment continuation
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END
" }}}
" language settings {{{
let python_highlight_all=1
if isdirectory($PYTHON3_BIN)
  let g:python3_host_prog=expand($PYTHON3_BIN.'/python3')
endif
augroup Languages
  autocmd!
  au FileType make,automake setl noexpandtab
  au FileType go setl noexpandtab shiftwidth=4 softtabstop=4 tabstop=4 autowrite colorcolumn=100
  au FileType gohtmltmpl setl expandtab shiftwidth=2 softtabstop=2 tabstop=4
  au FileType python setl colorcolumn=88 shiftwidth=4 softtabstop=4
  au FileType rust setl colorcolumn=100
augroup END

" tsv
au BufRead,BufNewFile *.tsv setlocal tabstop=20 nowrap listchars=eol:\ ,tab:»-,trail:·,precedes:…,extends:…,nbsp:‗ list
" }}}
" settings }}}

" mappings {{{
" Easily paste complex stuff
set pastetoggle=<F2>
" Use space for custom mappings
let mapleader=' '
" For poor Escape buttons
imap <special> jk <Esc>
" Switch to last open file
nnoremap <Space><Space> <C-^>
" Go to next buffer
nnoremap <C-n> :bnext<CR>
" Save
nnoremap <Leader>w :w<CR>
" Delete current buffer
nnoremap <Leader>q :bp <BAR> bd #<CR>
" Split below
nnoremap <Leader>s <C-W>s
" Split right
nnoremap <Leader>v <C-W>v
" N always searches up the page
nnoremap <expr> N  'nN'[v:searchforward] . 'zz'
" n always searches down
nnoremap <expr> n  'Nn'[v:searchforward] . 'zz'
" Fix common typo
nnoremap q: :q
" Split navigation (handled by plugin)
" nnoremap <C-j> <C-w><C-j>
" Split navigation (handled by plugin)
" nnoremap <C-k> <C-w><C-k>
" Split navigation (handled by plugin)
" nnoremap <C-l> <C-w><C-l>
" Split navigation (handled by plugin)
" nnoremap <C-h> <C-w><C-h>
" Use . shortcut with visual
vnoremap . :normal .<CR>
" Fold easily
nnoremap <Leader>f za
nnoremap <Leader>e zr
nnoremap <Leader>r zm
" File Navigation
" cd to current file
nnoremap > :lcd %:p:h<CR>
" cd to parent
nnoremap < :lcd ..<CR>
" mappings }}}

" theme and colors {{{
if has('nvim')
  if filereadable($HOME.'/.termguicolors')
    " manually enable termguicolors by touching ~/.termguicolors
    set termguicolors
  elseif filereadable($HOME.'/.gruvbox_256palette.sh')
    " if term doesn't support true color, touch this file if :term looks bad
    let g:gruvbox_termcolors=16
  else
    set notermguicolors
  endif
else
  " termguicolors doesn't seem to work in tmux/vim combo
  set notermguicolors
  if !filereadable($HOME.'/setup/gruvbox_256palette.sh')
    set t_Co=16
    highlight ColorColumn ctermbg=16
  endif
  " italics support in vim
  let &t_8f='\<Esc>[38;2;%lu;%lu;%lum'
  let &t_8b='\<Esc>[48;2;%lu;%lu;%lum'
endif
let g:gruvbox_number_column='bg1'
let g:gruvbox_italic=1
let g:gruvbox_italicize_strings=1
let g:gruvbox_contrast_light='hard'
silent! colorscheme gruvbox
if $LIGHTS == 'on'
  set background=light
else
  set background=dark
endif

" Vertical column at 80 chars, no horizontal line at cursor
set colorcolumn=80
set nocursorline
set nocursorcolumn

" Better looking splits
hi VertSplit ctermbg=NONE guibg=NONE

" Show indicator for wrapped lines
let &showbreak='\ '

" Give more space for displaying messages.
set cmdheight=2

if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" theme and colors }}}

" basic plugin settings {{{
" quality of life {{{
" christoomey/vim-tmux-navigator
let g:tmux_navigator_disable_when_zoomed=1
" moll/vim-bbye
nnoremap <Leader>q :Bwipeout<CR>
" }}}
" fuzzy find everything {{{
" junegunn/fzf.vim
nnoremap <C-p> :Files<CR>
nnoremap <Leader>a :Rg<CR>
nnoremap ; :Buffers<CR>

" https://github.com/junegunn/dotfiles/commit/9545174d0e34075d16c1d6a01eed820bce9d6cc0
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu

" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Floating window
if has('nvim') && &termguicolors
  if exists('&winblend')
    set winblend=15
  endif
  hi NormalFloat guibg=None
  if exists('g:fzf_colors.bg')
    call remove(g:fzf_colors, 'bg')
  endif
  function! CreateCenteredFloatingWindow()
    let width=min([180, &columns - 4])
    let height=min([50, &lines - 4])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
  endfunction
  let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
endif
" }}}
" looks {{{
" vim-airline/vim-airline
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_min_count=2
let g:airline#extensions#hunks#non_zero_only=1
let g:airline_skip_empty_sections=1
let g:airline_left_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_sep=''
let g:airline_right_alt_sep=''
let g:airline_section_y=''
let g:airline_section_z='%l/%L : %c'
" }}}
" basic plugin settings }}}
" advanced plugin settings {{{
"neoclide/coc.nvim
let g:coc_global_extensions = [
  \ 'coc-diagnostic',
  \ 'coc-go',
  \ 'coc-json',
  \ 'coc-pyright',
  \ 'coc-rust-analyzer',
  \ ]

nmap <silent> <Leader>le <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>ld <Plug>(coc-definition)
nmap <silent> <Leader>ly <Plug>(coc-type-definition)
nmap <silent> <Leader>li <Plug>(coc-implementation)
nmap <silent> <Leader>lr <Plug>(coc-references)

nmap <leader>ln <Plug>(coc-rename)
xmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>lf <Plug>(coc-format)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" advanced plugin settings }}}
