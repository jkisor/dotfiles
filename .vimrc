" Start Vundle 
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'thoughtbot/vim-rspec'
Plugin 'scrooloose/nerdtree'
"Plugin 'myusuf3/numbers.vim'
Plugin 'tpope/vim-endwise'
Plugin 'airblade/vim-gitgutter'
Plugin 'lambdatoast/elm.vim'
Plugin 'elmcast/elm-vim'

call vundle#end()            " required
filetype plugin indent on    " required
" End Vundle

let mapleader=","

" Color
syntax on
colorscheme molokai 

" Tabbing
set tabstop=2 
set shiftwidth=2
set expandtab " tabs are spaces

" UI 
set number  " show line numbers
set relativenumber "show relative numbers to cursor
set showcmd " show command in bottom bar
set cursorline " highlight current line
set laststatus=2 " always show status line
set statusline+=%f " show current file name in status line

filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
" set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]

" Searching
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" Split Direction
set splitbelow
set splitright

" Split Navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Split on cursor ctag
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Folding
set foldmethod=syntax
set nofoldenable "don't fold when opening file

function! MyFoldText()
  let nl = v:foldend - v:foldstart + 1
  let linetext = substitute(getline(v:foldstart),"^ *","",1)
  let txt = '(' . nl . ')' . ' + ' . linetext
  return txt
endfunction
set foldtext=MyFoldText()

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" insert mode mappings
imap jk <Esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction

nnoremap <leader>. :call OpenTestAlternate()<cr>

" RSpec.vim mappings
let g:rspec_command = "!docker-compose exec test rspec {spec}"
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" this is for the number switching plugin (slow)
"nnoremap <C-n> :NumbersToggle<CR>
map <C-n> :NERDTreeToggle<CR>
