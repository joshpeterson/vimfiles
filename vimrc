set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" For Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-markdown'
" For C#
"Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-dispatch'
" For C++
Plugin 'rhysd/vim-clang-format'
Plugin 'vim-scripts/a.vim'
" General
Plugin 'tpope/vim-vinegar'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ap/vim-buftabline'
Plugin 'szw/vim-tags'
Plugin 'yssl/QFEnter'
Plugin 'junegunn/fzf.vim'
Plugin 'jremmen/vim-ripgrep'
"
" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" " To ignore plugin indent changes, instead use:
" "filetype plugin on
" "
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line

""" My settings
syn on
set number
set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set list
noremap <Leader>r :Rake test<CR>
au BufRead *.md setlocal spell
au BufRead *.md setlocal wrap
set path+=$PWD/**
autocmd BufNew,BufRead *.html.*.yml match none
au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell " spell check in commit messages
set wildignore+=*.o,*.swp,*.swo,*/build/*,*/artifacts/*
autocmd QuickFixCmdPost *grep* cwindow
nnoremap <buffer><Leader>k :<C-u>ClangFormat<CR>
vnoremap <buffer><Leader>k :ClangFormat<CR>

" From http://scottsievert.com/blog/2016/01/06/vim-jekyll-mathjax/
function! MathAndLiquid()
  "" Define certain regions
  " Block math. Look for "$$[anything]$$"
  syn region math start=/\$\$/ end=/\$\$/
  " inline math. Look for "$[not $][anything]$"
  syn match math_block '\$[^$].\{-}\$'
  " Liquid single line. Look for "{%[anything]%}"
  syn match liquid '{%.*%}'
  " Liquid multiline. Look for {%[anything]%}[anything]{%[anything]%}"
  syn region highlight_block start='{% highlight .*%}' end='{%.*%}'
  " Fenced code blocks, used in GitHub Flavored Markdown (GFM)
  syn region highlight_block start='```' end='```'

  "" Actually highlight those regions.
  hi link math Statement
  hi link liquid Statement
  hi link highlight_block Function
  hi link math_block Function
endfunction

" Call everytime we open a Markdown file
autocmd BufRead,BufNewFile,BufEnter *.md,*.markdown call MathAndLiquid()
autocmd BufRead,BufNewFile,BufEnter *.md,*.markdown set textwidth=83

" Shortcut to search tags with ctrlp
nnoremap <leader>. :CtrlPTag<cr>

" vim-ruby-refactoring
:nnoremap <leader>rap  :RAddParameter<cr>
:nnoremap <leader>rcpc :RConvertPostConditional<cr>
:nnoremap <leader>rel  :RExtractLet<cr>
:vnoremap <leader>rec  :RExtractConstant<cr>
:vnoremap <leader>relv :RExtractLocalVariable<cr>
:nnoremap <leader>rit  :RInlineTemp<cr>
:vnoremap <leader>rrlv :RRenameLocalVariable<cr>
:vnoremap <leader>rriv :RRenameInstanceVariable<cr>
:vnoremap <leader>rem  :RExtractMethod<cr>

" bind K to grep word under cursor
nnoremap K :Rg "\b<C-R><C-W>\b"<CR>:cw<CR>

let g:vim_tags_project_tags_command = "{CTAGS} -R {OPTIONS} {DIRECTORY} --exclude=artifacts --exclude=build --exclude=buildszip_stagingarea 2>/dev/null"
let g:vim_tags_use_vim_dispatch = 0

"FZF Stuff
let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.hg,build,artifacts}/*" 2> /dev/null'
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
nnoremap <c-t> :FZF<cr>

" macOS clipboard integration
set clipboard=unnamed

"Buffer switching
nnoremap <c-p> :bp<cr>
nnoremap <c-n> :bn<cr>
