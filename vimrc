if v:progname =~? "GGevim"
  finish
endif
set nocompatible
set backspace=indent,eol,start
set autoindent
set autowrite
"set history=1000
set ruler
set showcmd
set wim=longest,list
set wrap
set encoding=utf-8
set shiftwidth=4 tabstop=4 softtabstop=4 expandtab cino=t0

if has("win32") 
	set guifont=Consolas:h10:cEASTEUROPE:qDRAFT
	set clipboard=unnamed
	set grepprg=c:\msys64\usr\bin\grep.exe
	let lb_tmp_directory=$TEMP
elseif has("win32unix")
	set guifont=Monospace\ 11
	set clipboard=unnamed
	runtime ftplugin/man.vim
	let lb_tmp_directory='/tmp/' . $USER
else
	set guifont=Monospace\ 11
	"set clipboard=unnamed
	runtime ftplugin/man.vim
	let lb_tmp_directory='/tmp/' . $USER
endif

if has("mac")
	set clipboard=unnamed
endif
set foldmethod=syntax
set foldlevel=30
"set undofile
set visualbell
set showmode 
set ttyfast
set laststatus=2
set shiftround

"vimplug
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'kien/ctrlp.vim'
Plug 'WolfgangMehner/c-support'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'vim-scripts/armasm'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-repeat'   "repeats latest .(dot)
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/calendar.vim'
Plug 'Shougo/vimproc.vim' , {'do' : 'make'}
Plug 'Shougo/vimshell.vim'
Plug '1995parham/vim-spice'
Plug 'morhetz/gruvbox'
Plug 'rhysd/vim-clang-format'

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status != 'unchanged' || a:info.force
	if has("win32") 
		!python3 ./install.py --clang-completer
	else
		"!python3 ./install.py --clang-completer --system-libclang
		!python3 ./install.py --clangd-completer
	endif
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
call plug#end()
"vimplug end

"Automatic relative number on focus
set number
"set relativenumber

"Error format
set errorformat+=%D%*\\a[%*\\d]\:\ Entering\ directory\ '%f',%X%*\\a[%*\\d]\:\ Leaving\ directory\ '%f',%D%*\\a\:\ Entering\ directory\ '%f',%X%*\\a\:\ Leaving\ directory\ '%f'

function! LBRelNumberOn()
	if( &relativenumber == 0 )
		setlocal relativenumber
	endif
endfunction

function! LBRelNumberOff()
	if( &relativenumber == 1 )
		setlocal norelativenumber
	endif
endfunction

autocmd WinLeave,FocusLost,InsertEnter * :call LBRelNumberOff()
autocmd VimEnter,WinEnter,BufWinEnter,FocusGained,InsertLeave * :call LBRelNumberOn()
"Extra features 
"set numberwidth=3
"set cpoptions+=n


"Smart search and regexp config
set ignorecase
set smartcase
set incsearch
set gdefault
set showmatch
set hlsearch


"Undo file configuration
if !isdirectory(lb_tmp_directory . "/_vim_")
     call mkdir(lb_tmp_directory ."/_vim_", "p", 0777)
endif
if !isdirectory(lb_tmp_directory . "/_vim_/undo-dir")
	call mkdir(lb_tmp_directory . "/_vim_/undo-dir", "", 0700)
endif
let &undodir=lb_tmp_directory . '/_vim_/undo-dir'
set undofile


"set number
filetype plugin indent on
if has("gui_running")
	colorscheme summerfruit256
	"set guioptions-=m
	set guioptions-=T
elseif ( &t_Co == 256 )
	if has("unix")
		let s:uname = system("uname -s")
			colorscheme gruvbox
			let g:gruvbox_italics=1
	else 
		colorscheme lettuce
	endif
else
	colorscheme darkblue
endif

let c_gnu=1
let c_space_errors=1
let python_highlight_all=1
let mapleader = ","

autocmd BufNewFile *.{h,hpp} execute ":normal \\pind"
let g:C_SourceCodeExtensions  = 'h hpp c cc cp cxx cpp CPP c++ C i ii'


au FileType text setlocal spell spelllang=en textwidth=78
au FileType tex setlocal spell spelllang=en textwidth=78
au Filetype lisp set sm lisp
au FileType makefile set noexpandtab
au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
au Filetype html set shiftwidth=2
au BufRead,BufNewFile *.asd set filetype=lisp
au BufRead,BufNewFile *.txt set filetype=text
au BufRead,BufNewFile *.nvm set filetype=nvm
au BufNewFile,BufRead CMakeLists.txt set filetype=cmake tw=0
au BufNewFile,BufRead *.cmake set filetype=cmake tw=0
au BufNewFile,BufRead *.rs set filetype=rust tw=0
au BufNewFile,BufRead *.S set filetype=armasm tw=0
au BufNewFile,BufRead *.cir set filetype=spice tw=0


"Enable syntax checking
syntax on

" MiniBuf explorer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 

"TagList
let g:Tlist_Use_Right_Window=1

"Configuration for YouCompleteMe
" Functions
function! LBAskForRefactor()
	call inputsave()
	let sword = input('New symbol name: ')
	call inputrestore()
       execute 'YcmCompleter RefactorRename ' . sword
endfunction
" Variables
let g:ycm_confirm_extra_conf = 0
let g:syntastic_always_populate_loc_list = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_error_symbol = '▸'
let g:ycm_warning_symbol = '▸'
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
"	allowing YouCompleteMe to work with UltiSnips
let g:UltiSnipsExpandTrigger = "<C-space>"
let g:UltiSnipsJumpForwardTrigger = "<C-f>"
let g:UltiSnipsJumpBackwardTrigger = "<C-b>"
"	ycm remapping functions
nnoremap <leader>ygd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>ygh :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>ygt :YcmCompleter GetType<CR>
nnoremap <leader>ygr :YcmCompleter GoToReferences<CR>
nnoremap <leader>gf :YcmCompleter GoToInclude<CR>
nmap <leader>yfw <Plug>(YCMFindSymbolInWorkspace)
nmap <leader>yfd <Plug>(YCMFindSymbolInDocument)
nnoremap <leader>yfi :YcmCompleter FixIt<CR>
nnoremap <leader>ycf :YcmCompleter Format<CR>
nnoremap <leader>ycr :call LBAskForRefactor()<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

"Csupport
let g:alternateNoDefaultAlternate = 1

"Determine number of procesors
let &makeprg = 'make $* -j' . (system('nproc'))


"Configure pymode
let g:pymode_lint_options_pep8 =
	\ { 'max_line_length' : 120,
    \   'ignore' : 'E203,E201,E202,E211' }

"Location list mappings
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>lc :lclose<CR>
nnoremap <leader>ll :ll<CR>
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lprevious<CR>
nnoremap <leader>lf :lfirst<CR>
nnoremap <leader>la :llast<CR>

"Keyboard mapping stuff
nnoremap <silent> <leader>1 :NERDTreeToggle<CR>
nnoremap <silent> <leader>2 :TagbarToggle<CR>
nnoremap <silent> <leader>mm :make!<CR>
nnoremap <silent> <leader>mp :make! program<CR>
nnoremap <silent> <leader>mc :make! clean<CR>
nnoremap <silent> <C-s> :w <CR>

"Switch folding
nnoremap <silent> <space> za
"New windows create and move and close
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>wc <C-W>n<C-W><C-W><C-W>c
nnoremap <leader>wr <C-W>r
nnoremap <leader>w= <C-W>=

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Optional map jj instead esc
inoremap jj <ESC>

"Buffer operation stuff
nnoremap <leader>m :ls<CR>
nnoremap <leader>h :bp<CR>
nnoremap <leader>l :bn<CR>

"Save editor state
nnoremap <leader>ss :TagbarClose<CR>:NERDTreeClose<CR>:mks! .session.vim<CR>
noremap <F2> :ccl<CR>


"Grep search
if !exists("lb_grep_path")
	let lb_grep_path='.'
endif
nnoremap <leader>fw :execute "grep! -srnw --binary-files=without-match --exclude=tags --exclude='*.html' --exclude='*.js' --exclude-dir='.git' " . lb_grep_path . " -e " . expand("<cword>") . " " <bar> cwindow<CR>

function! LBAskForGrep()
	call inputsave()
	let sword = input('Enter grep word: ')
	call inputrestore()
	execute "grep! -srnw --binary-files=without-match --exclude=tags --exclude='*.html' --exclude='*.js' --exclude-dir='.git' " . g:lb_grep_path . " -e " . sword . " " | copen
endfunction

nnoremap <leader>fww :call LBAskForGrep()<CR>


" Makefile no expand tabs
autocmd FileType make setlocal noexpandtab
"Make and windowlist
autocmd QuickFixCmdPost [^l]* nested botrigh cwindow
autocmd QuickFixCmdPost l* nested botright lwindow

"Enable mouse integration
set mouse=a

" Disable arrows for learning
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
noremap <PAGEUP> <nop>
nnoremap <PAGEDOWN> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <PAGEUP> <nop>
inoremap <PAGEDOWN> <nop>

"Special abrev for C and C++
au FileType c,cpp inorea #i #include
au FileType c,cpp inorea #d #define

"Ctag special command
command! -nargs=1 -complete=file	Ctags :!ctags -R --c++-kinds=+p --fields=+iaS "<args>"

"Horizontal help
autocmd FileType help wincmd L

"Single line compilation
let g:C_CplusCFlags= '-Wall -g -O0 -c --std=gnu++17'

"airline config
"
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
" unicode symbols
"let g:airline_theme='luna'
let g:airline#extensions#branch#displayed_head_limit = 12
let g:airline#extensions#branch#format = 1
let g:airline#extensions#whitespace#show_message = 0
let g:airline#extensions#tabline#enabled = 0
if !has("win32") 
	let g:airline_symbols.branch = '⎇'
else
	let g:airline_symbols.readonly = '▼'
endif
"let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#default#layout = [
      \ [ 'b', 'c' ],
      \ [ 'x', 'z', 'error', 'warning' ]
      \ ]

"Update makeprg to waf when it is present
if filereadable(expand("%:p:h")."/wscript")
if has("win32") 
	set makeprg=python\ waf
elseif has("mac")
	set makeprg=python3\ waf
else
	set makeprg=python3\ waf
endif
	set errorformat=
	set errorformat+=%f:%l:%c:%m
	set errorformat+=%DWaf:\ Entering\ directory\ `%f'
	set errorformat+=%XWaf:\ Leaving\ directory
endif

" CTRL-P configuration
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }
if !has("win32")
let g:ctrlp_user_command = {
	\ 'types': {
		\ 1: ['.git', 'cd %s && git ls-files'],
		\ 2: ['.hg', 'hg --cwd %s locate -I .'],
		\ },
	\ 'fallback': 'find %s -type f'
	\ }
endif

"Clang auto formating
"autocmd FileType {c,cpp} ClangFormatAutoEnable

"Parse extra custom config file
if filereadable(".vim.custom")
    so .vim.custom
endif
