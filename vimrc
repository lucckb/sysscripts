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
set shiftwidth=4 tabstop=4 noexpandtab cino=t0
if has("win32") 
	set guifont=Consolas:h11:cEASTEUROPE:qDRAFT
	set clipboard=unnamed
	let lb_tmp_directory=$TEMP
else
	set guifont=Monospace\ 11
	set clipboard=unnamedplus
	runtime ftplugin/man.vim
	let lb_tmp_directory='/tmp/' . $USER
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
Plug 'python-mode/python-mode'
Plug 'vim-scripts/armasm'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-repeat'   "repeats latest .(dot)
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/calendar.vim'
Plug 'Shougo/vimproc.vim' , {'do' : 'make'}
Plug 'Shougo/vimshell.vim'

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
	if has("win32") 
		!python3 ./install.py --clang-completer
	else
		!python3 ./install.py --clang-completer --system-libclang --system-boost
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
	colorscheme lettuce
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


"Enable syntax checking
syntax on

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 


let g:clang_auto_select=1
let g:clang_complete_auto=0
let g:clang_complete_copen=1
let g:clang_hl_errors=1
let g:clang_periodic_quickfix=0
let g:clang_snippets=1
let g:clang_snippets_engine="clang_complete"
let g:clang_conceal_snippets=1
let g:clang_exec="clang"
let g:clang_user_options=""
let g:clang_auto_user_options="path, .clang_complete"
let g:clang_use_library=1
let g:clang_close_preview=1
set completeopt-=preview
let g:clang_sort_algo="priority"
let g:clang_complete_macros=1
let g:clang_complete_patterns=0
let g:Tlist_Use_Right_Window=1

"Configuration for YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:syntastic_always_populate_loc_list = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_global_ycm_extra_conf='~/worksrc/sysscripts/ycm_extra_conf.py'
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>je :YcmCompleter GoToDeclaration<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

"Csupport
let g:alternateNoDefaultAlternate = 1

"Determine number of procesors
let &makeprg = 'make $* -j' . (system('nproc'))


"Configure pymode
let g:pymode_lint_options_pep8 =
	\ { 'max_line_length' : 120,
    \   'ignore' : 'E203,E201,E202,E211' }


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
nnoremap <leader>fw :execute "grep! -srnw --binary-files=without-match --exclude=tags --exclude-dir='.git' " . lb_grep_path . " -e " . expand("<cword>") . " " <bar> cwindow<CR>

function! LBAskForGrep()
	call inputsave()
	let sword = input('Enter grep word: ')
	call inputrestore()
	execute "grep! -srnw --binary-files=without-match --exclude=tags --exclude-dir='.git' " . g:lb_grep_path . " -e " . sword . " " | copen
endfunction

nnoremap <leader>fww :call LBAskForGrep()<CR>




"Color setup
function! LBSetColors()
if !has("gui_running") && (&t_Co <= 16)
	hi Pmenu      ctermfg=Cyan    ctermbg=Blue cterm=None guifg=Cyan guibg=DarkBlue
	hi PmenuSel   ctermfg=White   ctermbg=Blue cterm=Bold guifg=White guibg=DarkBlue gui=Bold
	hi PmenuSbar                  ctermbg=Cyan            guibg=Cyan
	hi PmenuThumb ctermfg=White                           guifg=White
	hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
endif
endfunction

exec LBSetColors()

" Makefile no expand tabs
autocmd FileType make setlocal noexpandtab
"Make and windowlist
autocmd QuickFixCmdPost [^l]* nested botrigh cwindow
autocmd QuickFixCmdPost l* nested botright lwindow
"Session restore autocommand recover vimrc
autocmd SessionLoadPost * :call LBSetColors()
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

"Extra commands
command! -nargs=1 -complete=file	Ctags :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "<args>"

"Horizontal help
autocmd FileType help wincmd L

"Single line compilation
let g:C_CplusCFlags= '-Wall -g -O0 -c --std=gnu++14'

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
else
	set makeprg=waf
endif
	set errorformat=
	set errorformat+=%f:%l:%c:%m
	set errorformat+=%DWaf:\ Entering\ directory\ `%f'
	set errorformat+=%XWaf:\ Leaving\ directory
endif

"Parse extra custom config file
if filereadable(".vim.custom")
    so .vim.custom
endif
