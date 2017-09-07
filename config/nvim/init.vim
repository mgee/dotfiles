" ------------------------------------------------------------------------------
" vimrc
"
" Inspired by
"   https://github.com/Soliah/dotfiles/blob/master/vimrc
"   https://github.com/wincent/wincent/tree/master/roles/dotfiles/files/.vim
"   https://github.com/junegunn/dotfiles/blob/master/vimrc
"   https://github.com/mhinz/dotfiles/blob/master/vim/vimrc
"   https://github.com/cHoco/dotFiles/blob/master/vimrc
"   https://github.com/pgdouyon/dotfiles/blob/master/config/nvim/init.vim
" ------------------------------------------------------------------------------

" Settings {{{
" General {{{
filetype plugin indent on
syntax enable

let mapleader                 = "\<SPACE>"

let g:netrw_dirhistmax        = 0 " Disable .netrwhist file creation
" Disable loading of plugins bundled with vim
let g:loaded_2html_plugin     = 1
let g:loaded_getscriptPlugin  = 1
let g:loaded_gzip             = 1
let g:loaded_logipat          = 1
let g:loaded_matchparen       = 1
let g:loaded_netrwPlugin      = 1
let g:loaded_rrhelper         = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin        = 1
let g:loaded_vimballPlugin    = 1
let g:loaded_zipPlugin        = 1

if has('vim_starting')
  set encoding=utf8        " Always use unicode
endif
set shell=$SHELL           " Use zsh as shell
set viminfo=/100,:100,'100 " Save command history and search patterns
set autoread               " Automatically load changes
set undolevels=1000        " Large undo levels
set history=200            " Size of command history
set nobackup               " Disable backups
set clipboard=unnamed      " Use the OS clipboard by default
set ttyfast                " Optimize for fast terminal connections
set lazyredraw             " Wait to redraw
set ttimeout               " Timeout on keycodes
set ttimeoutlen=10         " Small timeout to reduce lag when pressing ESC in terminal
" }}}

" Completion {{{
set completeopt-=preview       " Disable preview window
set wildmenu                   " Show list
set wildmode=longest:full,full " Show all matches
" }}}

" Searching {{{
set incsearch                  " Show partial matches as search is entered.
set hlsearch                   " Highlight search patterns.
set ignorecase                 " Enable case insensitive search.
set smartcase                  " Disable case insensitivity if mixed case.
set gdefault                   " Make search and replace global by default.
" }}}

" Whitespace {{{
set autoindent           " Keep indentation
set tabstop=4            " Set tab to equal 4 spaces
set softtabstop=4        " Set soft tabs equal to 4 spaces
set shiftwidth=4         " Set auto indent spacing
set shiftround           " Shift to the next round tab stop
set expandtab            " Expand tabs into spaces
set smarttab             " Insert spaces in front of lines
set list                 " Show whitespace
set listchars=tab:╶─     " Tab symbol
set listchars+=trail:·   " Trailing whitespace
set listchars+=extends:# " Character to show when wrap is off
set listchars+=nbsp:%    " Non breakable whitespace
" }}}

" Basic UX {{{
set backspace=indent,eol,start " Fix backspace
set confirm                    " Confirm instead of fail
set cursorline                 " Highlight current line
set foldlevelstart=0           " Close all folds by default
set foldmethod=marker          " Use markers for folds
set fillchars=vert:│           " Use longest bar for vertical split
set fillchars+=fold:─          " Use longest dash for folds
set hidden                     " Allow hidden buffers
set laststatus=2               " Always show status line
set linespace=1                " Use 1 pixel space between lines
set matchpairs+=<:>            " Pairs to match
set noerrorbells               " Disable error bells
set nomodeline                 " Hide modeline
set noshowmode                 " No need to show mode
set nostartofline              " Do not move cursor to start of line after line-wise command
set nowrap                     " Wrap text
set number                     " Enable line numbers
set scrolljump=8               " Scroll 8 lines at a time at top/bottom
set scrolloff=5                " Always show one line above and below cursor
set shortmess=aIoO             " Show short messages, no intro
set showcmd                    " Show last command
set showmatch                  " Show matching parenthesis
set showtabline=2              " Always show the tabline
set sidescrolloff=5            " Always show 5 columns before and after cursor
set signcolumn=yes             " Display sign column
set splitbelow                 " Open new splits below
set splitright                 " Open new splits on the right
set switchbuf=usetab           " Switch to the window of the buffer
set synmaxcol=240              " Limit syntax highlighting to 240 colums
set vb t_vb=                   " Disable visual bell
set virtualedit=onemore        " Allow for cursor beyond last character
set whichwrap+=<,>,h,l,[,]     " Move lines using arrows.

" Inspired by http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! CustomFoldText()
  let l:name = substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g')
  let l:lines = v:foldend - v:foldstart + 1
  let l:foldchar = matchstr(&fillchars, 'fold:\zs.')
  let l:end = l:lines . ' lines ' . printf('%4.1f', l:lines*100.0/line('$')) . '% ' . repeat(l:foldchar, 4)
  let l:width = winwidth(0) - strwidth(l:end) - &foldcolumn - &numberwidth - 2 " 2 for sign colum
  let l:start = strpart(repeat(l:foldchar, 5) . repeat('━' . l:foldchar . l:foldchar, v:foldlevel - 1) . ' ' . l:name . ' ', 0, l:width)
  return l:start . repeat(' ', l:width  - strwidth(l:start)) . l:end
endfunction
set foldtext=CustomFoldText()
" }}}

" Terminal UX {{{
set t_Co=256 " Terminal supports 256 colors
set t_md=    " Disable bold fonts in terminal

if has('termguicolors')
  set termguicolors " Enable 24bit colors in terminal
endif

if has('nvim')
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
endif
" }}}

" Colorscheme {{{
let s:theme = 'gruvbox'

if s:theme == 'gruvbox'
  let g:gruvbox_italic        = 1
  let g:gruvbox_bold          = 0
  let g:gruvbox_contrast_dark = 'hard'
  let g:gruvbox_sign_column   = 'bg0'
  let g:gruvbox_vert_split    = 'bg1'

  set background=dark
  colorscheme gruvbox

  highlight! link NonText GruvboxBg1
  highlight! link SpecialKey GruvboxBg1
  highlight! link LineNr GruvboxBg2
  let s:whitespace_fg = [synIDattr(synIDtrans(hlID("ErrorMsg")), "fg", "gui"), synIDattr(synIDtrans(hlID("ErrorMsg")), "fg", "cterm")]
  let s:whitespace_bg = [synIDattr(synIDtrans(hlID("ErrorMsg")), "bg", "gui"), synIDattr(synIDtrans(hlID("ErrorMsg")), "bg", "cterm")]
elseif s:theme == 'onedark'
  let g:onedark_terminal_italics = 1
  let g:lightline#onedark#disable_bold_style = 1

  set background=dark
  colorscheme onedark

  let s:whitespace_fg = [synIDattr(synIDtrans(hlID("Normal")), "bg", "gui"), synIDattr(synIDtrans(hlID("Normal")), "bg", "cterm")]
  let s:whitespace_bg = [synIDattr(synIDtrans(hlID("Error")), "fg", "gui"), synIDattr(synIDtrans(hlID("Error")), "fg", "cterm")]
elseif s:theme == 'papercolor'
  set background=light
  colorscheme PaperColor

  let s:whitespace_fg = [synIDattr(synIDtrans(hlID("Error")), "fg", "gui"), synIDattr(synIDtrans(hlID("Error")), "fg", "cterm")]
  let s:whitespace_bg = [synIDattr(synIDtrans(hlID("Error")), "bg", "gui"), synIDattr(synIDtrans(hlID("Error")), "bg", "cterm")]
endif
" }}}

" Symbols {{{
let s:powerline_font              = 1 " Enable for powerline glyphs
if s:powerline_font
  let s:symbol_separator_left     = "\uE0B0"
  let s:symbol_separator_right    = "\uE0B2"
  let s:symbol_subseparator_left  = "\uE0B1"
  let s:symbol_subseparator_right = "\uE0B3"
  let s:symbol_vcs_branch         = "\uE0A0"
else
  let s:symbol_separator_left     = "▏"
  let s:symbol_separator_right    = "▕"
  let s:symbol_subseparator_left  = "│"
  let s:symbol_subseparator_right = "│"
  let s:symbol_vcs_branch         = "\u16B4"
endif
" }}}

" GUI {{{
if has('gui_running')
  set fullscreen
  set guicursor=a:blinkon0 " Non blinking cursor
  set guioptions-=m        " Disable menu bar
  set guioptions-=T        " Disable the toolbar
  set guioptions-=a        " Do not auto copy selection to clipboard
  set guioptions-=e        " Do not use gui tab apperance
  set guioptions-=r        " Do not show scrollbars
  set guioptions-=R        " Do not show scrollbars
  set guioptions-=l        " Do not show scrollbars
  set guioptions-=L        " Do not show scrollbars
  set guifont=PragmataPro\ Mono:h14

  if has('gui_macvim')
    set macligatures " Enable ligatures

    if &background ==# 'dark'
      set macthinstrokes " Use thin strokes in dark colorscheme
    endif
  endif
endif
" }}}
" }}}

" Mappings {{{
" Misc Mappings {{{
inoremap jj <Esc>

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Visual shifting (without exiting visual mode)
vnoremap < <gv
vnoremap > >gv

" Move around lines visually (do not skip parts of wrapped lines)
nnoremap j gj
nnoremap k gk

" Toggle wrapping
map <F2> :set wrap!<CR>

" Invert result highlighting
nnoremap <silent> _ :set invhlsearch<CR>

" Find merge conflict markers
nnoremap <Leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

nnoremap <expr> <CR> foldlevel(line('.')) ? 'za' : '\<CR>'

nmap z/   yygccp
xmap z/ V<Esc>gvygvgc`>p
" }}}

" Window Mappings {{{
" Easier window switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Close quickfix and location list
nnoremap <silent> <Leader>c :cclose<Bar>lclose<CR>
" }}}

" Buffer Mappings {{{
nnoremap <silent> <C-t> :enew<CR>
nnoremap <silent> <C-x> :Sayonara!<CR>
nnoremap <silent> <C-z> :Sayonara<CR>
nnoremap <silent> <C-u> :bprev<CR>
nnoremap <silent> <C-i> :bnext<CR>
" }}}

" Cursor Mappings {{{
nnoremap <A-Left>  b
nnoremap <A-Right> w
vnoremap <A-Left>  b
vnoremap <A-Right> w
inoremap <A-Left>  <C-O>b
inoremap <A-Right> <C-O>w
snoremap <A-Left>  <C-O>b
snoremap <A-Right> <C-O>w
" }}}

" Tab Mappings {{{
nnoremap <silent> <Leader>t :tabnew<CR>
nnoremap <silent> <Leader>x :tabclose<CR>
nnoremap <silent> <Leader>u :tabprevious<CR>
nnoremap <silent> <Leader>i :tabnext<CR>
nnoremap <silent> <Leader>1 :tabn 1<CR>
nnoremap <silent> <Leader>2 :tabn 2<CR>
nnoremap <silent> <Leader>3 :tabn 3<CR>
nnoremap <silent> <Leader>4 :tabn 4<CR>
nnoremap <silent> <Leader>5 :tabn 5<CR>
nnoremap <silent> <Leader>6 :tabn 6<CR>
nnoremap <silent> <Leader>7 :tabn 7<CR>
nnoremap <silent> <Leader>8 :tabn 8<CR>
nnoremap <silent> <Leader>9 :tabn 9<CR>
" }}}

" Cut Mappings {{{
" Replace and delete to black hole register and cut text with m (move)
nnoremap m d
vnoremap m d
nnoremap M D
vnoremap M D
vnoremap p "_dP
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X
" }}}

" Terminal Mode Mappings {{{
if has('nvim')
  tnoremap <ESC>     <C-\><C-n>
  tnoremap <C-h>     <C-\><C-n><C-w>h
  tnoremap <C-j>     <C-\><C-n><C-w>j
  tnoremap <C-k>     <C-\><C-n><C-w>k
  tnoremap <C-l>     <C-\><C-n><C-w>l
  tnoremap <C-x>     <C-\><C-n>:Sayonara!<CR>
  tnoremap <C-y>     <C-\><C-n>:Sayonara<CR>
  nnoremap <Leader>z :below 20sp term://$SHELL<CR>i
endif
" }}}

" Bookmarks {{{
nnoremap <silent><Leader>ec :e $MYVIMRC<CR>
nnoremap <silent><Leader>el :e ~/.dotfiles<CR>
nnoremap <silent><Leader>ez :e ~/.dotfiles/config/zsh/.zshrc<CR>
" }}}
" }}}

" Autocommands {{{
" Cursor Position {{{
augroup CursorPosition
  autocmd!

  " Restore cursor position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
" }}}

" Color column {{{
if exists('+colorcolumn')
  augroup ColorColumn
    autocmd!
    autocmd FileType *           setlocal colorcolumn=
    autocmd FileType sh,zsh      setlocal colorcolumn=80
    autocmd FileType cpp         setlocal colorcolumn=100
    autocmd FileType python,ruby setlocal colorcolumn=120
    autocmd FileType gitcommit   setlocal colorcolumn=50,72
  augroup END
endif
" }}}

" ObjC {{{
augroup ObjC
  autocmd!
  autocmd BufRead,BufNewFile *.mm setlocal filetype=objcpp
augroup END
" }}}

" Python {{{
augroup Python
  autocmd!
  autocmd BufRead,BufNewFile *.gyp,*.gypi setlocal filetype=python sw=4 ts=4
augroup END
" }}}

" Help {{{
augroup Help
  autocmd!
  autocmd FileType help nnoremap <buffer><silent> <CR> <C-]>
  autocmd FileType help nnoremap <buffer><silent> <BS> <C-t>
augroup END
" }}}

  autocmd FileType cpp setlocal commentstring=//%s

  " Undefine <CR> in the quickfix window because it is used to jump to the item under the cursor
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

  " Disable tabs
  " autocmd BufWinEnter,BufNewFile * silent tabo
" }}}

" Custom Functionality {{{
" Profile {{{
function! s:profile()
    profile start /tmp/profile.log
    profile func *
    profile file *
endfunction

command! Profile call <SID>profile()
" }}}

" Buffer Information {{{
let s:special_buffers = {
      \ 'dirvish': 'Dirvish',
      \ 'fugitiveblame': 'Git Blame',
      \ 'git': 'Git',
      \ 'gitcommit': 'Git Commit',
      \ 'gitrebase': 'Git Rebase',
      \ 'GV': 'GV',
      \ 'help': 'Help',
      \ 'nerdtree': 'NERD',
      \ 'niffler': 'Niffler',
      \ 'qf': 'Quickfix',
      \ 'startify': 'Startify',
      \ 'vim-plug': 'Plug',
      \ }

function! s:buffer_update()
  let b:is_special = has_key(s:special_buffers, &ft)
  let b:special_name = get(s:special_buffers, &ft, '')
endfunction

function! s:buffer_init()
  if exists('b:buffer_init')
    return
  endif
  let b:buffer_init = 1
  call s:buffer_update()
endfunction

augroup BufferInfoEvents
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter,BufReadPre,BufNew * call <SID>buffer_init()
  autocmd FileType                                        * call <SID>buffer_update()
augroup END
" }}}

" Listchars {{{
augroup Listchars
  autocmd!
  autocmd InsertEnter * setlocal listchars-=trail:·
  autocmd InsertLeave * setlocal listchars+=trail:·
  autocmd FileType    *
        \ if b:is_special |
        \   setlocal nolist |
        \ endif
augroup END
" }}}

" Whitespace {{{
exe "hi ExtraWhitespace gui=none cterm=none guifg=" . s:whitespace_fg[0] . " guibg=" . s:whitespace_bg[0] .
  \ " ctermfg=" . s:whitespace_fg[1] . " ctermbg=" . s:whitespace_bg[1]

" Remove all trailing whitespace
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

function! s:match_whitespace(pattern)
  if !b:is_special && &buftype != 'nofile'
    exe 'match ExtraWhitespace ' . a:pattern
  endif
endfunction

augroup Whitespace
  autocmd!
  autocmd InsertLeave,BufReadPost * call <SID>match_whitespace('/\s\+$/')
  autocmd InsertEnter             * call <SID>match_whitespace('/\s\+\%#\@<!$/')
augroup END
" }}}

" Git Root {{{
function! s:cd_git_toplevel()
  execute 'lcd ' . expand("%:p:h")
  let l:toplevel = system('git rev-parse --show-toplevel')
  if !v:shell_error
    execute 'lcd ' . l:toplevel
  endif
endfunction

nnoremap <silent> <Leader>gt :call <SID>cd_git_toplevel()<CR>
" }}}

" Git Info {{{
function! s:get_git_hunk_status()
  if !exists('*GitGutterGetHunkSummary') || !get(g:, 'gitgutter_enabled', 0)
    return ''
  endif
  let hunks = GitGutterGetHunkSummary()
  let parts = [
      \ hunks[0] > 0 ? g:gitgutter_sign_added . hunks[0] : '',
      \ hunks[1] > 0 ? g:gitgutter_sign_modified . hunks[1] : '',
      \ hunks[2] > 0 ? g:gitgutter_sign_removed . hunks[2] : '',
      \ ]
  return join(filter(parts, 'len(v:val)'), ' ')
endfunction

function! s:get_git_branch()
  if !exists("*fugitive#head")
    return ''
  endif
  let branch = fugitive#head()
  return branch !=# '' ? s:symbol_vcs_branch . " " . branch : ''
endfunction

function! s:git_info()
  echo 'Git stats for file: ' . join(filter([s:get_git_hunk_status(), s:get_git_branch()], 'len(v:val)'), ' ')
endfunction

nnoremap <Leader>gi :call <SID>git_info()<CR>
" }}}
" }}}

" Plugin Settings {{{
" Sleuth {{{
let g:sleuth_width = 4
let g:sleuth_trigger_ratio = 16 " Allow some fuzz on heuristics
" }}}

" Gitgutter {{{
let g:gitgutter_sign_removed = '-'
" }}}

" Dirvish {{{
function! s:dirvish_init()
  call fugitive#detect(@%)

  nnoremap <silent> <buffer> t :call dirvish#open('tabedit', 0)<CR>
  nnoremap <silent> <buffer> s :call dirvish#open('split', 0)<CR>
  nnoremap <silent> <buffer> v :call dirvish#open('vsplit', 0)<CR>
  nnoremap <buffer> + :edit %
  nnoremap <buffer> b :!mkdir %
  nnoremap <silent> <buffer> p :lcd %:p:h<CR>
  nnoremap <silent> <buffer> <C-R> :<C-u>Dirvish %<CR>

  " Sort folders to top and alphabetically
  sort ir /^.*[^\/]$/
endfunction

nnoremap <silent> <Leader>r        :Dirvish %<CR>

autocmd FileType dirvish call <SID>dirvish_init()
" }}}

" Bufferline {{{
nmap <D-1> <Plug>lightline#bufferline#go(1)
nmap <D-2> <Plug>lightline#bufferline#go(2)
nmap <D-3> <Plug>lightline#bufferline#go(3)
nmap <D-4> <Plug>lightline#bufferline#go(4)
nmap <D-5> <Plug>lightline#bufferline#go(5)
nmap <D-6> <Plug>lightline#bufferline#go(6)
nmap <D-7> <Plug>lightline#bufferline#go(7)
nmap <D-8> <Plug>lightline#bufferline#go(8)
nmap <D-9> <Plug>lightline#bufferline#go(9)
nmap <D-0> <Plug>lightline#bufferline#go(10)
" }}}

" Lightline {{{
let g:lightline                  = {}
let g:lightline.colorscheme      = g:colors_name
let g:lightline.separator        = {'left': s:symbol_separator_left, 'right': s:symbol_separator_right}
let g:lightline.subseparator     = {'left': s:symbol_subseparator_left, 'right': s:symbol_subseparator_right}
let g:lightline.active           = {
      \ 'left': [['mode', 'paste'], ['readonly', 'cwd'], ['filename']],
      \ 'right': [['percent', 'lineinfo'], ['whitespace', 'fileformat', 'fileencoding'], ['filetype']],
      \ }
let g:lightline.inactive         = {'left': [['name']], 'right': [['percent', 'lineinfo']]}
let g:lightline.tab              = {'active': ['tabnum'], 'inactive': ['tabnum']}
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['tabs']]}
let g:lightline.mode_map         = {
      \ 'n': 'N', 'i': 'I', 'R': 'R', 'v': 'V', 'V': 'V', "\<C-v>": 'V',
      \ 'c': 'C', 's': 'S', 'S': 'S', "\<C-s>": 'S', 't': 'T',
      \ }
let g:lightline.component_expand = {
      \ 'buffers': 'lightline#bufferline#buffers',
      \ 'tabs': 'LightLineTabs',
      \ }
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.component        = {
      \ 'cwd': '%{fnamemodify(getcwd(), ":~")}',
      \ 'fileencoding': '%{b:is_special || &fenc == &enc || &fenc == "" ? "" : &fenc}',
      \ 'fileformat': '%{b:is_special || &ff == "unix" ? "" : &ff == "dos" ? "CRLF" : &ff == "mac" ? "CR" : "??"}',
      \ 'filename': '%{b:is_special || &bt == "nofile" ? "" : (@% == "" ? "*" : expand("%:.")) . (&mod ? "+" : &ma ? "" : "-")}',
      \ 'filetype': '%{b:is_special ? "" : &ft == "" ? "--" : &ft}',
      \ 'mode': '%{b:is_special ? b:special_name : lightline#mode()}',
      \ 'name': '%{b:is_special ? b:special_name : expand("%:.")}',
      \ 'whitespace': '%{b:is_special ? "" : &shiftwidth . (&expandtab ? "S" : "T")}',
      \ }

let g:lightline.component_visible_condition = {
      \ 'fileencoding': '!b:is_special&&&fenc!=&enc&&&fenc!=""',
      \ 'fileformat': '!b:is_special&&&fileformat!="unix"',
      \ 'filename': '!b:is_special&&&bt!="nofile"',
      \ 'filetype': '!b:is_special',
      \ 'whitespace': '!b:is_special',
      \ }

" Copy the left tabline style because the tabs shall look like buffers
autocmd VimEnter,ColorScheme *
      \ exe 'let g:lightline#colorscheme#' . g:lightline.colorscheme . '#palette.tabline.right = ' .
      \ 'copy(g:lightline#colorscheme#' . g:lightline.colorscheme . '#palette.tabline.left)'

function! LightLineTabs()
  let l:tabs = lightline#tabs()
  return [reverse(l:tabs[0]), l:tabs[1], reverse(l:tabs[2])]
endfunction
" }}}

" Sneak {{{
let g:sneak#streak = 1

hi link Sneak          IncSearch
hi link SneakLabel     IncSearch
hi link SneakLabelMask Comment
" }}}

" gtfo {{{
let g:gtfo#terminals = {'mac' : 'iterm'}
" }}}

" Fugitive {{{
nnoremap <Space>ga :Gcommit -v -q --amend<CR>
nnoremap <Space>gb :Gblame<CR>
nnoremap <Space>gc :Gcommit -v -q<CR>
nnoremap <Space>gd :Gdiff<CR>
nnoremap <Space>gg :Ggrep<Space>
nnoremap <Space>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <Space>gm :Gmove<Space>
nnoremap <Space>gp :Dispatch! git push<CR>
nnoremap <Space>gr :Dispatch! git pull --rebase<CR>
nnoremap <Space>gs :Gstatus<CR>
" }}}

" Niffler {{{
let g:niffler_marked_indicator = s:symbol_separator_left . ' '
let g:niffler_mru_max_history  = 1
let g:niffler_prompt           = '%s> '
let g:niffler_user_command     = 'rg --files --hidden --glob "!.git" --glob "!.svn" --glob "!Applications/" --glob "!Library/" %s'
let s:mru_blacklist            = ['COMMIT_EDITMSG', fnamemodify(resolve($VIMRUNTIME), ':p') . 'doc']

function! s:filter_file(fname)
  if !filereadable(a:fname) | return 0 | endif
  for l:pattern in s:mru_blacklist
    if a:fname =~# l:pattern | return 0 | endif
  endfor
  return 1
endfunction

function! MRUFiles()
  let l:files = map(v:oldfiles, 'fnamemodify(v:val, ":p")')
  let l:filtered = filter(l:files, 's:filter_file(v:val)')
  return map(l:filtered, 'fnamemodify(v:val, ":~")')
endfunction

function! OpenFile(sel) dict
  let l:sel = fnamemodify(a:sel, ':p')
  execute 'silent' (bufexists(l:sel) ? 'buffer' : 'edit') fnameescape(l:sel)
endfunction

command! -nargs=0 NifflerMRUCustom :call niffler#custom({'source': MRUFiles(), 'sink': function('OpenFile'), 'prompt': 'MRU'})

nnoremap <C-p>         :Niffler -vcs<CR>
nnoremap <silent><C-o> :NifflerBuffer<CR>
nnoremap <silent><C-y> :NifflerMRUCustom<CR>
" }}}

" Easy-Align {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(LiveEasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(LiveEasyAlign)
" }}}

" clang-format {{{
let g:clang_format#detect_style_file = 1

augroup ClangFormatSettings
  autocmd FileType c,cpp,objc,objcpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc,objcpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
augroup END
" }}}

" vim enhanced cpp highlight {{{
let c_no_curly_error                      = 1 " Do not show curly braces error in cpp files
let g:cpp_class_scope_highlight           = 1 " Highlight class scope
let g:cpp_experimental_template_highlight = 1 " Highlight template functions
" }}}
" }}}

" Local Config {{{
let s:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h').'/vimrc.local'
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif
" }}}

