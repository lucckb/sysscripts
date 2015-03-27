if v:progname =~? "evim"
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
set guifont=Ubuntu\ Mono\ 12
set clipboard=unnamedplus
set foldmethod=syntax
set foldlevel=30
"set undofile
set visualbell
set showmode 
set ttyfast
set laststatus=2
set shiftround
runtime ftplugin/man.vim

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


"set number

filetype plugin indent on
if has("gui_running")
	"colorscheme midnight
	colorscheme eclipse
	set guioptions-=m
	set guioptions-=T
elseif ( &t_Co == 256 )
	colorscheme lettuce
else
	colorscheme darkblue
endif

let c_gnu=1
"let c_space_errors=1
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
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_global_ycm_extra_conf='~/worksrc/sysscripts/ycm_extra_conf.py'
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

"Csupport
let g:alternateNoDefaultAlternate = 1

"Determine number of procesors
let &makeprg = 'make $* -j' . (system('nproc'))

"Keyboard mapping stuff
nnoremap <silent> <leader>1 :NERDTreeToggle<CR>
nnoremap <silent> <leader>2 :TlistToggle<CR>
nnoremap <silent> <leader>mc :make!<CR>
nnoremap <silent> <leader>mp :make! program<CR>
nnoremap <silent> <leader>oc :!omake <CR>
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
nnoremap <leader>ss :TlistClose<CR>:NERDTreeClose<CR>:mks! .session.vim<CR>
noremap <F2> :ccl<CR>


"Grep search
if !exists("lb_grep_path")
	let lb_grep_path='.'
endif
nnoremap <leader>fw :execute " grep -srnw --binary-files=without-match --exclude='*.lss' --exclude=tags --exclude-dir='.svn' --exclude-dir='.hg' " . lb_grep_path . " -e " . expand("<cword>") . " " <bar> cwindow<CR>

function LBSetColors()
"Color setup
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
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"Special abrev for C and C++
au FileType c,cpp inorea //- /* ------------------------------------------------------------------ */
au FileType c,cpp inorea #i #include
au FileType c,cpp inorea #d #define

"Extra commands
command -nargs=1 -complete=file	Ctags :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "<args>"

"Parse extra custom config file
if filereadable(".vim.custom")
    so .vim.custom
endif
