" initial setup
"==================================================================================:q
  " use Vim settings, rather than Vi settings, required for Vundle
  set nocompatible
  filetype off

  " initialize Vundle and rebuild helptags
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()

  Plugin 'airblade/vim-gitgutter'           " git diff in gutter
  Plugin 'andrewRadev/sideways.vim'         " Swap arguments with :SidewaysLeft and :SidewaysRight
  Plugin 'andrewRadev/splitjoin.vim'        " Multiline to single and back  gS, gJ  TODO Change to new key binding
  Plugin 'andrewRadev/switch.vim'           " Swap true for false and MUCH more
  " Plugin 'andrewRadev/whitespaste.vim'      " Only paste the space that is needved
  Plugin 'benmills/vimux'                   " Vim + Tmux Goodness
  Plugin 'bling/vim-airline'                " nice looking footer bar
  Plugin 'chriskempson/base16-vim'          " base 16 colorscheme
  Plugin 'christoomey/vim-conflicted'       " Git conflict resolution
  Plugin 'christoomey/vim-sort-motion'      " Sort lines with gs
  Plugin 'christoomey/vim-tmux-navigator'   " easy navigation b/w vim & tmux
  Plugin 'ctrlpvim/ctrlp.vim'               " fuzzy file finder
  Plugin 'ervandew/supertab'
  Plugin 'garbas/vim-snipmate'              " expand code snippits with <tab>
  Plugin 'gmarik/Vundle.vim'                " let Vundle manage Vundle, required
  Plugin 'godlygeek/csapprox'               " better gvim color support
  Plugin 'godlygeek/tabular'                " for indentation
  Plugin 'groenewege/vim-less'              " Less syntax highlighting / indentation
  Plugin 'heartsentwined/vim-emblem'        " emblem syntax & indent
  Plugin 'honza/vim-snippets'               " Snippets to autocomplete from
  Plugin 'idbrii/vim-mark'                  " Allow for multiple marks
  Plugin 'jordwalke/flatlandia'
  Plugin 'kana/vim-textobj-user'            " Allows ruby 'ir' 'ar' commands for method selection
  Plugin 'marcWeber/vim-addon-mw-utils'     " support tab completion snipmate functionality
  Plugin 'mattn/emmet-vim'                  " emmet stuff for vim [http://emmet.io/]
  Plugin 'mileszs/ack.vim'                  " searching via :Ack
  Plugin 'nathanaelkane/vim-indent-guides'  " Indent guides to keep your code aligned
  Plugin 'nelstrom/vim-textobj-rubyblock'   " Expands upon 'ir' 'ar' to be used in repatition
  Plugin 'othree/html5.vim'                 " html5 syntax & indent
  Plugin 'pangloss/vim-javascript'          " javascript syntax & indent
  Plugin 'rking/ag.vim'                     " Project search
  Plugin 'scrooloose/nerdtree'              " file menu
  Plugin 'scrooloose/syntastic'             " syntax checker
  " Plugin 'sirVer/ultisnips'
  Plugin 'terryma/vim-multiple-cursors'     " multiple cursors
  Plugin 'tfnico/vim-gradle'                " gradle syntax highlighting
  Plugin 'thoughtbot/vim-rspec'             " Vim RSPEC runner
  Plugin 'tommcdo/vim-exchange'             " Exchange text with Visual and X
  Plugin 'tomtom/tlib_vim'
  Plugin 'tpope/vim-abolish'                " Search replace with a touch of magic
  Plugin 'tpope/vim-characterize'           " Advanced Character info with ga
  Plugin 'tpope/vim-commentary'             " easily use comments
  Plugin 'tpope/vim-endwise'                " auto end addition in ruby
  Plugin 'tpope/vim-fugitive'               " Git in vim
  Plugin 'tpope/vim-markdown'               " markdown syntax & indent
  Plugin 'tpope/vim-rails'                  " Rails in Vim
  Plugin 'tpope/vim-repeat'                 " Repeat plugin commands
  Plugin 'tpope/vim-speeddating'            " Use CTRL-A/CTRL-X to increment dates, times, and more
  Plugin 'tpope/vim-surround'               " Change Surrounding tags
  Plugin 'tpope/vim-unimpaired'             " Short normal mode aliases for commonly used ex commands
  Plugin 'tyru/open-browser-github.vim'     " Open current file location on github
  Plugin 'tyru/open-browser.vim'            " Open url from vim
  Plugin 'valloric/YouCompleteMe'           " auto complete, son
  Plugin 'vim-ruby/vim-ruby'                " ruby syntax & indent
  Plugin 'wellle/targets.vim'               " Additional usage for: Pair text objects, Quote text objects, Separator text objects, Argument text objects
                                            " https://github.com/wellle/targets.vim/blob/master/cheatsheet.md
  Plugin 'wesQ3/vim-windowswap'             " window swapping

  " end Vundle init (required )"
  call vundle#end()
  filetype plugin indent on

"= Interface ======================================================================================

  "- Appearance -----------------------------------------------------------------------------------

    syntax on                    " turn on syntax highilghting

    filetype plugin on           " enable loading plugins for filetypes
    filetype indent on           " enable loading 'indent files' for filetypes

    set synmaxcol=400            " no syntax highlighting for lines longer than 200 cols

    set laststatus=2             " show status bar

    set visualbell               " use visual bell
    set number                   " display line numbers
    set relativenumber           " display relative line numbers

    set background=dark          " Dark background
    set laststatus=2             " Fix for statusbar toggling
    set encoding=utf-8           " Fix special character encoding
    set t_Co=256                 " MOAR COLORS

    "set cursorline               " show cursor line
    set ruler                    " cursor position in the lower right corner

    match ErrorMsg '\s\+$'       " highlight trailing whitespace

    au VimResized * :wincmd =    " resize splits when window is resized

  "- Interaction ----------------------------------------------------------------------------------

    set ttyfast                  " improve screen refresh for terminal vim
    set lazyredraw               " don't redraw while executing macros. async window title update
    set ttyscroll=3              " something about scrolling buffer size

    set scrolloff=3              " start scrolling 3 lines from bottom
    set sidescrolloff=6          " start scrolling 6 lines from right
    let loaded_match_paren = 1   " highlight matching parens

    set mouse=a                  " allow mouse usage
    set clipboard=unnamed        " set default yank register to machine clipboard

    set updatetime=250           " How often Vim updates the screen

    "folding settings
    set foldmethod=indent   "fold based on indent
    set foldnestmax=10      "deepest fold is 10 levels
    set nofoldenable        "dont fold by default
    set foldlevel=1         "this is just what i use
    " set nofoldenable             " disable folding

    :au FocusLost *   :set norelativenumber<cr>:set number<cr>
    :au FocusGained * :set relativenumber

    set modeline
    set modelines=5
  "- Wrapping -------------------------------------------------------------------------------------

    set nowrap                   " don't softwrap text
    set linebreak
    set formatoptions-=t         " don't automatically hardwrap text (use 'gq' to reflow text)
    set wrapmargin=0             " don't wrap based on terminal size

  "- Indentation ----------------------------------------------------------------------------------

    set autoindent               " indent next line to same level as current line
    set smartindent              "   ↑ but do it smartly
    set smarttab                 " <Tab> in front of a line inserts 'shiftwidth' blanks
    set shiftwidth=2             "   ↑ use 2 blanks for above
    set tabstop=2                " display a <Tab> as 2 spaces
    set softtabstop=2            " use 2 spaces for a <Tab>
    set expandtab

    " for html

    if has("autocmd")
      filetype indent plugin on
      augroup bashalias
        autocmd BufRead,BufNewFile *_aliases set filetype=sh
      augroup END
    endif

    autocmd FileType html setlocal indentkeys-=*<Return>
    autocmd FileType html.handlebars setlocal indentkeys-=*<Return>
    autocmd FileType eruby setlocal indentkeys-=*<Return>

  "- Searching ------------------------------------------------------------------------------------

    set hlsearch                 " highlight searching
    set ignorecase               " case insensitive search
    set smartcase                " case insensitive search
    set incsearch                " incremental search

  "- Movement

  nnoremap 0 ^

  "- Lazy command mode
  " nnoremap ; :

  "- Theme ----------------------------------------------------------------------------------------

    set background=dark      " dark background
    syntax enable
    " colorscheme smyck      " smyck colorscheme
    " colorscheme solarized  " solarized colorscheme
    colorscheme flatlandia   " flatlandia colorscheme

"= Utilities ======================================================================================

  set noswapfile                     " don't create swap files
  set autowrite                      " write the old file out when switching between files
  autocmd BufWritePre * :%s/\s\+$//e " auto strip whitespace on save
  runtime macros/matchit.vim
  runtime macros/
  let g:auto_save                = 1  " enable AutoSave on Vim startup
  let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
  let g:auto_save_silent         = 1  " do not display the auto-save notification
"= Keys ===========================================================================================

  let mapleader = ','                       " set <Leader>
  set backspace=indent,eol,start            " make backspace behave as expected

  " easy splits and switches over (\v)
  nnoremap <leader>v <C-w>v<C-w><C-w>
  nnoremap <leader>h <C-w>s<C-w><C-w>

  " map escape key to jj -- much faster, comments above b/c of Vim's interpretation of them jumping my cursor
  imap jj <Esc>:w<cr>

  " finish rails block
  imap <leader>end <% end %>

  " stupid save
  " imap :w <Esc>xx:w<cr>

  " use black hole register
  noremap x "_x
  " noremap X "_X

  " Yank keeps spot on line
  " vnoremap y myy`y
  " vnoremap Y myY`y

  " map escape key to ,N -- much faster
  nmap <leader>N <Esc>:noh<cr>

  "- Lazy macro repeat
  nmap <leader>M @@

  " easier window navigation
  nmap <C-h> <C-w>h
  nmap <C-j> <C-w>j
  nmap <C-k> <C-w>k
  nmap <C-l> <C-w>l

  " kill the trailing whitespace
  nnoremap <leader>rtw :%s/\s\+$//e<CR>

  " toggle Paste mode
  nnoremap <leader>p :set paste!<cr>
  nnoremap <leader>np :set nopaste!<cr>

  " quick edit VIMRC
  nmap <silent> <leader>ev :e $MYVIMRC<CR>
  " quick reload VIMRC
  nmap <silent> <leader>sv :so $MYVIMRC<CR>

  " Open file in github
  nmap gtg <Plug>(openbrowser-smart-search)
  vmap gtg <Plug>(openbrowser-smart-search)

  " quick bundle
  nmap <silent> <leader>pi :PluginInstall<CR>

  " quick switch file
  nnoremap <leader><leader> <c-^>

  " ruby tags
  imap <C-b> binding.pry

  " Run Ag on current word
  noremap <leader>A :Ag! -Q <C-r>=expand('<cword>')<CR><CR>
  " nnoremap :a<CR> :Ag! -Q <C-r>=expand('<cword>')<CR><CR>

  " ,# Surround a word with #{ruby interpolation} NOT WORKING :(
  " map <leader># ysiw#
  " vmap <leader># c#{<C-R>"}<ESC>

"= Plugin Settings=================================================================================

  "- Syntastic ------------------------------------------------------------------------------------
  let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': [],
                     \ 'passive_filetypes': ['html'] } " disable checking for html

  let g:syntastic_javascript_checkers = ['eslint']

  "- Markdown ------------------------------------------------------------------------------------
  let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass']

  "- NerdTree -------------------------------------------------------------------------------------
  " toggle NerdTree (ControlK + ControlB)
  nnoremap <C-k><C-b> :NERDTreeToggle<CR>
  let NERDTreeShowHidden     =1 " show hidden files
  let NERDTreeQuitOnOpen     =0 " Hide NERDTree when opening a file
  let NERDTreeShowLineNumbers=1 " enable line numbers
  nmap <leader>O :NERDTreeFind<CR>

  " make sure relative line numbers are used
  autocmd FileType nerdtree setlocal relativenumber
  " open on vim start and newtab open
  " autocmd BufWinEnter * NERDTreeMirror
  " autocmd VimEnter * NERDTree
  " Go to previous (last accessed) window.
  autocmd VimEnter * wincmd p
  " close nerdtree if it is the only window left
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  "- YouCompleteMe-------------------------------------------------------------------------------------
  " make" YCM compatible with UltiSnips (using supertab)
  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  let g:SuperTabDefaultCompletionType = '<C-n>'

  " better key bindings for UltiSnipsExpandTrigger
  let g:UltiSnipsExpandTrigger = "<tab>"
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

  "- Control-P ------------------------------------------------------------------------------------
  " Don't use caching
  let g:ctrlp_use_caching = 0

  "- JSX ------------------------------------------------------------------------------------
  let g:jsx_ext_required = 0 " Allow JSX in normal JS files

  " ================ Completion =======================

  set wildmode=list:longest,full
  set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches

  set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
  set wildignore+=*vim/backups*
  set wildignore+=*sass-cache*
  set wildignore+=*DS_Store*
  set wildignore+=vendor/rails/**
  set wildignore+=vendor/cache/**
  set wildignore+=*.gem
  set wildignore+=log/**
  set wildignore+=tmp/**
  set wildignore+=*.png,*.jpg,*.gif
  set wildignore+=*/tmp/*,*/bin/*,*/bower_components/*,*.so,*.swp,*.zip     " MacOSX/Linux

  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git\|bin\|log\|public\|solr\|tmp\|vendor\|node_modules',
    \ 'file': '\.DS_Store\|\.exe$\|\.so$\|\.dll$\|\.pyc$\|\.min\.js$' }
  "
  "- Ack ------------------------------------------------------------------------------------------
  let g:ackprg = 'ag --nogroup --color --column'

  "- Rspec.vim  -----------------------------------------------------------------------------------
  " let g:rspec_command = '!bundle exec bin/rspec {spec}'  " use spring w/ rspec runner
  let g:rspec_command = '!bundle exec rspec {spec}'      " dont use spring w/ rspec runner
  let g:rspec_runner = 'os_x_iterm'
  map <Leader>t :call RunCurrentSpecFile()<CR>
  map <Leader>s :call RunNearestSpec()<CR>
  map <Leader>l :call RunLastSpec()<CR>
  map <Leader>a :call RunAllSpecs()<CR>

  "- XMPFilter  ------------------------------------------------------------------------------------
  " map <C-b> <Plug>(xmpfilter-mark)<Plug>(xmpfilter-run)

  "- Switch ---------------------------------------------------------------------------------
  let g:switch_mapping = "-"

  "- Sidways---------------------------------------------------------------------------------
  map <Leader>S :SidewaysLeft<cr>
  map <Leader>R :SidewaysRight<cr>

  "- Indent Guides ---------------------------------------------------------------------------------
  let g:indent_guides_color_change_percent = 3      " ultra-low-contrast guides
  let g:indent_guides_guide_size = 2                " between 0 and 'shiftwidth'
  let g:indent_guides_start_level = 1               " don't show guides until the third indent

  "= Airline ========================================================================================
  let g:airline_powerline_fonts = 1

  "= Goyo & Limelight ===============================================================================
  autocmd User GoyoEnter Limelight
  autocmd User GoyoLeave Limelight!
  let g:goyo_width = 120
  nnoremap <Leader>G :Goyo<CR>

"= Language Specific Settings======================================================================

  "- Golang ---------------------------------------------------------------------------------------
  let g:go_fmt_command = 'goimports'     " use gofmt on save w/ go commands (from go plugin)

  function! ExecuteGoCode()              " for running Golang on enter
    exec ":!clear && go run " . @%
  endfunction

  "- C ---------------------------------------------------------------------------------------
  function! ExecuteCCode()
    exec ':Shell gcc ' . @% . ' -o file && ./file'
  endfunction

  "- Rust-------------------------------------------------------------------------------------
  function! ExecuteRustCode()
    exec ':Shell rustc ' . @% . ' -o file && ./file'
  endfunction

  "- ES6---------------------------------------------------------------------------------------
  autocmd BufRead,BufNewFile *.es6 setfiletype javascript

  "- JavaScript
  autocmd FileType javascript inoremap {<CR> {<CR>}<Esc><S-o>
  autocmd FileType javascript inoremap (; ();<Esc>hi

  "- J Builder ------------------------------------------------------------------------------------
  au BufNewFile,BufRead *.json.jbuilder set ft=ruby       " set syntax to ruby for jBuilder files

  "- HBARS ------------------------------------------------------------------------------------
  au BufNewFile,BufRead *.hbars set ft=haml       " set syntax to haml, even tho it's not ruby, for hbars files

  "- SnipMate------------------------------------------------------------------------------------
  " imap <C-c> <Plug>snipMateNextOrTrigger
  " inoremap <expr> pumvisible() ? "\<C-N>" : "\<C-R>=snipMate#TriggerSnippet()\<CR>"
"= Enter Key ======================================================================================

  function! MapCR()
    if (&ft=='c')
      :call ExecuteCCode()
    endif
    if (&ft=='go')
      :call ExecuteGoCode()
    endif
    if (&ft=='ruby')
      :call RunLastSpec()
    endif
    if (&ft=='haml')
      :call RunLastSpec()
    endif
    if (&ft=='html')
      :call RunLastSpec()
    endif
    if (&ft=='rust')
      :call ExecuteRustCode()
    endif
  endfunction

  :nnoremap <cr> :call MapCR()<cr>

"= For running commands in a new window ========================================================
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
  wincmd k
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
