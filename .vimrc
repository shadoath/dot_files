" OS setup

let s:is_win = has('win32')
let $v = $HOME.(s:is_win ? '\vimfiles' : '/.vim')

if s:is_win
  set shell=cmd.exe
  set shellcmdflag=/c
  set encoding=utf-8
endif

let s:bundle_dir = $v.'/bundle'
" initial setup
"==================================================================================
  " use Vim settings, rather than Vi settings, required for Vundle
  set nocompatible
  filetype off

  " initialize Vundle and rebuild helptags
  set rtp+=~/.vim/bundle/Vundle.vim
  " set rtp+=/usr/local/opt/fzf
  set rtp+=~/.fzf

  call vundle#begin()

  " Required
  Plugin 'gmarik/Vundle.vim'                " let Vundle manage Vundle, required

  " Level 11 Vim skillz
  " Plugin 'wikitopian/hardmode'              " No arrow keys, +, _, or hjkl
  " Level 9 Vim skills
  Plugin 'takac/vim-hardtime'               " Can't use a key twice in X time

  " Most important
  Plugin 'scrooloose/nerdtree'              " file menu
  Plugin 'Xuyuanp/nerdtree-git-plugin'      " Changes via git
  " Plugin 'ctrlpvim/ctrlp.vim'               " fuzzy file finder
  Plugin 'airblade/vim-gitgutter'           " git diff in gutter
  Plugin 'andrewRadev/switch.vim'           " Swap true for false and MUCH more
  Plugin 'bling/vim-airline'                " nice looking footer bar
  Plugin 'mileszs/ack.vim'                  " searching via :Ack
  Plugin 'rking/ag.vim'                     " Project search
  Plugin 'tpope/vim-speeddating'            " Use CTRL-A/CTRL-X to increment dates, times, and more
  Plugin 'junegunn/fzf.vim'                 " Fuzzy search https://github.com/junegunn/fzf#search-syntax
  " Plugin 'm-kat/aws-vim'                    " AWS Cloudformation
  " Plugin 'valloric/YouCompleteMe'           " auto complete, son

  " Real useful
  Plugin 'wesQ3/vim-windowswap'             " window swapping
  Plugin 'dahu/vim-fanfingtastic'           " Extend tT and fF to multiple lines
  Plugin 'garbas/vim-snipmate'              " expand code snippits with <tab>
  Plugin 'tomtom/tlib_vim'                  " Used by snipmate
  Plugin 'honza/vim-snippets'               " Snippets to autocomplete from
  Plugin 'idbrii/vim-mark'                  " Allow for multiple marks
  Plugin 'ervandew/supertab'                " The best autocompletion based on words in file
  Plugin 'kana/vim-textobj-user'            " Allows ruby 'ir' 'ar' commands for method selection
  Plugin 'marcWeber/vim-addon-mw-utils'     " support tab completion snipmate functionality
  Plugin 'statox/GOD.vim'                   " Get vim doc link in markdown => :GOD mark
  Plugin 'moll/vim-bbye'                    " Buffers are not so finicky when being closed
  " Plugin 'maxbrunsfeld/vim-yankstack'       " Turns p and y into [stacks], nav with meta-p and meta-shift-p

  " Syntax
  Plugin 'martinda/Jenkinsfile-vim-syntax'  " Jenkins
  Plugin 'nathanaelkane/vim-indent-guides'  " Indent guides to keep your code aligned
  Plugin 'tommcdo/vim-lion'                 " For more better indentation use gl and gL, gl to add space before, gL to add space after. glip= add space before = around paragraph
  Plugin 'scrooloose/syntastic'             " syntax checker
  Plugin 'tfnico/vim-gradle'                " gradle syntax highlighting
  " Plugin 'guns/vim-sexp'                    " precision editing to S-expressions

  " Nice to have
  Plugin 'christoomey/vim-sort-motion'      " Sort lines with gs, ie: gs20j => sort 20 lines, gsip => Sort the current paragraph, gsi( => Sort within parenthesis. (b, c, a) would become (a, b, c)
  Plugin 'jtratner/vim-flavored-markdown'   " Markdown display good
  Plugin 'tommcdo/vim-exchange'             " Exchange text with Visual and X
  Plugin 'tyru/open-browser-github.vim'     " Open current file location on github
  Plugin 'tyru/open-browser.vim'            " Open url from vim use: gx while on URL
  Plugin 'wellle/targets.vim'               " Additional usage for: Pair text objects, Quote text objects, Separator text objects, Argument text objects https://github.com/wellle/targets.vim/blob/master/cheatsheet.md
  " Plugin 'severin-lemaignan/vim-minimap'    " Minimap

  " Color
  Plugin 'jordwalke/flatlandia'
  Plugin 'ryanoasis/vim-devicons'
  " Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'  "Slows Vim WAY down
  Plugin 'KabbAmine/vCoolor.vim'                   " Color Picker, find with <leader>g

  " Language specific
  Plugin 'nelstrom/vim-textobj-rubyblock'   " Expands upon 'ir' 'ar' to be used in repatition
  Plugin 'vim-ruby/vim-ruby'                " ruby syntax & indent
  Plugin 'othree/html5.vim'                 " html5 syntax & indent
  Plugin 'pangloss/vim-javascript'          " javascript syntax & indent
  Plugin 'Rykka/riv.vim'                    " RST text formtting
  Plugin 'thoughtbot/vim-rspec'             " Vim RSPEC runner
  Plugin 'chriskempson/base16-vim'          " base 16 colorscheme
  Plugin 'vim-scripts/nginx.vim'            " Nginx files
  " Plugin 'elixir-lang/vim-elixir'
  " Plugin 'hdima/python-syntax'

  " Extras
  " Plugin 'andrewRadev/sideways.vim'         " Swap arguments with :SidewaysLeft and :SidewaysRight
  " Plugin 'andrewRadev/splitjoin.vim'        " Multiline to single and back  gS, gJ  TODO Change to new key binding
  " Plugin 'andrewRadev/whitespaste.vim'      " Only paste the space that is needved
  " Plugin 'benmills/vimux'                   " Vim + Tmux Goodness
  " Plugin 'christoomey/vim-conflicted'       " Git conflict resolution
  " Plugin 'christoomey/vim-tmux-navigator'   " easy navigation b/w vim & tmux
  " Plugin 'godlygeek/csapprox'               " better gvim color support
  " Plugin 'godlygeek/tabular'                " for indentation
  " Plugin 'groenewege/vim-less'              " Less syntax highlighting / indentation
  " Plugin 'heartsentwined/vim-emblem'        " emblem syntax & indent
  " Plugin 'johngrib/vim-game-code-break'     " Pong for Vim, just run :VimGameCodeBreak
  " https://github.com/jmoon018/PacVim        " brew install pacvim
  " Plugin 'justinmk/vim-sneak'               " Sneaky movement s{char}{char}
  " Plugin 'lifepillar/vim-cheat40'           " 40 column cheat sheet, open with <leader>?
  " Plugin 'mattn/emmet-vim'                  " emmet stuff for vim [http://emmet.io/]
  " Plugin 'Rykka/InstantRst'                 " RST instant preview
  " Plugin 'terryma/vim-multiple-cursors'     " multiple cursors

  " The great tpope
  Plugin 'tpope/vim-abolish'                " Search replace with a touch of magic
  Plugin 'tpope/vim-characterize'           " Advanced Character info with ga
  Plugin 'tpope/vim-commentary'             " easily use comments
  Plugin 'tpope/vim-endwise'                " auto end addition in ruby
  Plugin 'tpope/vim-fugitive'               " Git in vim
  Plugin 'tpope/vim-markdown'               " markdown syntax & indent
  Plugin 'tpope/vim-rails'                  " Rails in Vim
  Plugin 'tpope/vim-repeat'                 " Repeat plugin commands
  Plugin 'tpope/vim-surround'               " Change Surrounding tags
  Plugin 'tpope/vim-unimpaired'             " Short normal mode aliases for commonly used ex commands


  " end Vundle init (required )"
  call vundle#end()
  filetype plugin indent on

"= Interface ======================================================================================

  "- Appearance -----------------------------------------------------------------------------------

    syntax on                    " turn on syntax highilghting

    filetype plugin on           " enable loading plugins for filetypes
    filetype indent on           " enable loading 'indent files' for filetypes

    set synmaxcol=266            " no syntax highlighting for lines longer than 266 cols
    set titlestring   =VIM:\ %f


    " backup settings
    set backup
    set backupext =-vimbackup
    set backupdir =$v/files/backup
    set directory =$v/files/swap// " Adding two // tells vim to use % stucture: %code%4flag%config%deploy.rb

    " undo settings
    set undofile
    set history    =9999          " History is important.
    set undolevels =9999          " Oops saftey
    set undodir    =$v/files/undo
    set viewdir    =$v/files/view

    " Vim settings between close and open
    set viminfo ='100,<50,s10,h,n$v/files/info/viminfo
    " https://stackoverflow.com/a/23036077/1418337

    set laststatus=2             " show status bar

    set showcmd                  " Show (partial) command in status line.
    set noerrorbells             " No beeps
    set vb t_vb=                 " Disable all bells.  I hate ringing/flashing.
    set visualbell               " use visual bell
    set number                   " display line numbers
    set relativenumber           " display relative line numbers

    set background=dark          " Dark background
    set laststatus=2             " Fix for statusbar toggling
    set encoding=utf-8           " Fix special character encoding
    scriptencoding utf-8
    set t_Co=256                 " MOAR COLORS

    set cursorline cursorcolumn  " set the crosshairs
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

    set updatetime=750          " How often vim writes to swap and 'cursorhold' event is fired

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
    set shiftround               " Round indent to multiple of shiftwidth
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
    set smartcase                " case insensitive search Unless using Capital Letters
    set incsearch                " incremental search

  "- Movement
  nnoremap 0 ^
  vnoremap 0 ^
  " nnoremap <tab> :<C-U>call <SNR>20_Match_wrapper('',1,'n') <CR>
  " vnoremap <tab> :<C-U>call <SNR>20_Match_wrapper('',1,'v') <CR>m'gv``

  " Write to the write protected files
  " command W w !sudo tee % > /dev/null
  "- Lazy command mode
  " nnoremap ; :
  "
  " Unsudo my screen
  nnoremap U :syntax sync fromstart<cr>:redraw!<cr>


  "- Theme ----------------------------------------------------------------------------------------
  " More options: http://vimcolors.com/
  " More colors: https://vignette.wikia.nocookie.net/vim/images/1/16/Xterm-color-table.png/revision/latest?cb=20110121055231

    set background=dark      " dark background
    syntax enable
    colorscheme flatlandia   " flatlandia colorscheme
    hi Comment guifg=#005969 guibg=NONE guisp=NONE gui=NONE ctermfg=105 ctermbg=NONE cterm=NONE
    hi LineNr  guifg=#515253 guibg=NONE guisp=NONE gui=NONE ctermfg=107 ctermbg=237  cterm=NONE
    hi Todo    guifg=#798188 guibg=NONE guisp=NONE gui=bold ctermfg=15  ctermbg=2    cterm=bold

    " Color picker
    let g:vcoolor_map = '<leader>g'
    let g:vcoolor_lowercase = 1

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

  " un/comment line and next line (Gemfile, fury => local)
  nmap gC gcc<ESC>j<ESC>gcc

  imap <leader>end <% end %>
  imap <leader>con console.log(": ");
  " stupid save
  " imap :w <Esc>xx:w<cr>

  " use black hole register
  noremap x "_x
  " noremap X "_X

  " Add the date
  " imap <leader>xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

  " Adjust splitscreen size
  nmap <leader>b <C-w>11>
  nmap <leader>B <C-w>11<
  nmap <leader>d <C-w>11+
  nmap <leader>D <C-w>11-


  " Closes current buffer leaving splits as is
  nnoremap <Leader>q :Bdelete<CR>

  " Yank keeps spot on line
  " vnoremap y myy`y
  " vnoremap Y myY`y

  " map escape key to ,N -- much faster
  nmap <leader>N <Esc>:noh<cr>

  "- Lazy macro repeat
  nmap <leader>M @@
  nmap <leader>. @@
  " nnoremap <buffer> <leader>. :call MacroDo(input('Param: '))<CR>

  " easier window navigation
  nmap <C-h> <C-w>h
  nmap <C-j> <C-w>j
  nmap <C-k> <C-w>k
  nmap <C-l> <C-w>l

  " Crosshair mode
  nnoremap <Leader>ch :set cursorline! cursorcolumn!<CR>


  " kill the trailing whitespace
  nnoremap <leader>rtw :%s/\s\+$//e<CR>

  " toggle Paste mode
  nnoremap <leader>p :set paste!<cr>
  nnoremap <leader>np :set nopaste!<cr>

  " Select the last pasted text
  nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

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
  "
  " quick replace word under cursor
  noremap <leader>R :%s/<C-r>=expand('<cword>')<CR>/

  " ruby tags
  imap <C-b> binding.pry
  nnoremap <leader>bp O<% binding.pry %><esc>

  " Run Ag on current word
  noremap <leader>A :Ag! -Q <C-r>=expand('<cword>')<CR><CR>
  nnoremap <leader>H :help <C-r>=expand('<cword>')<CR><CR>
  nnoremap <leader>G vy :GOD <c-r>"<CR>
  " nnoremap :a<CR> :Ag! -Q <C-r>=expand('<cword>')<CR><CR>

  " ,# Surround a word with #{ruby interpolation} NOT WORKING :(
  " map <leader># ysiw#
  " vmap <leader># c#{<C-R>"}<ESC>

"= Plugin Settings=================================================================================

  " GOD
  let g:god_close_help_buffer = 1


  " HARD MODE
  " autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
  " nnoremap <leader>NH <Esc>:call ToggleHardMode()<CR>
  " Hardtime
  let g:hardtime_default_on = 1
  let g:hardtime_maxcount = 6
  let g:hardtime_showmsg = 1
  let g:hardtime_ignore_buffer_patterns = [ "NERD.*", "*.txt", "*.json"]  " Ignore NerdTree buffer, *.txt, and *.json files
  let g:hardtime_ignore_quickfix = 1
  let g:hardtime_timeout = 600
  let g:hardtime_allow_different_key = 1
  let g:list_of_normal_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
  let g:list_of_visual_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]


  " if exists(":Tabularize")
  "   nmap <Leader>a= :Tabularize /=<CR>
  "   vmap <Leader>a= :Tabularize /=<CR>
  "   nmap <Leader>a: :Tabularize /:\zsl1<CR>
  "   vmap <Leader>a: :Tabularize /:\zsl1<CR>
  "   nmap <Leader>a, :Tabularize /,\zsl1<CR>
  "   vmap <Leader>a, :Tabularize /,\zsl1<CR>

  " endif
  " Python Settings
  " let python_highlight_all = 1


  "- Syntastic ------------------------------------------------------------------------------------
  let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': [],
                     \ 'passive_filetypes': ['html'] } " disable checking for html

  let g:syntastic_javascript_checkers = ['eslint']

  "- Markdown ------------------------------------------------------------------------------------
  let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass']

  "- NerdTree ----------------------Use ? for info-------------------------------------------------
  " toggle NerdTree (ControlK + ControlB)
  nnoremap <C-k><C-b> :NERDTreeToggle<CR>
  let NERDTreeShowHidden     =1 " show hidden files
  let NERDTreeQuitOnOpen     =0 " Hide NERDTree when opening a file
  let NERDTreeShowLineNumbers=1 " enable line numbers
  let NERDTreeShowBookmarks  =1 " Show bookmarks at top of nerd tree
  let NERDTreeMarkBookmarks  =1 " Mark folders with bookmarks
  let NERDTreeWinSize        =42

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
  let g:UltiSnipsJumpForwardTrigger = "<c-b>"
  let g:UltiSnipsJumpBackwardTrigger = "<c-z>"
  let g:UltiSnipsEditSplit="vertical"


 "= FZF =========================================================================
  let g:fzf_buffers_jump = 1

  " Open FZF
  noremap <C-p> :Files<CR>

  " Default fzf layout
  " - down / up / left / right
  let g:fzf_layout = { 'down': '~25%' }

  let g:jsx_ext_required = 0 " Allow JSX in normal JS files

  " ================ Completion =======================

  set list
  set listchars=tab:▸\
  set wildmode=list:longest,full
  set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
  "
  " stuff to ignore when tab completing
  set wildignore=*.o,*.obj,*~
  set wildignore+=*vim/backups*    " History files
  set wildignore+=*sass-cache*     " Sass
  set wildignore+=*DS_Store*       " IOS Image stores
  set wildignore+=vendor/rails/**,vendor/cache/**
  set wildignore+=*.gem
  set wildignore+=tmp/cache/**
  set wildignore+=log/**,tmp/**
  set wildignore+=*.png,*.jpg,*.gif
  set wildignore+=*.min.css
  set wildignore+=*.min.js
  set wildignore+=*/tmp/*,*/bin/*,*/bower_components/*,*.so,*.swp,*.zip     " MacOSX/Linux

  "
  "- Ack ------------------------------------------------------------------------------------------
  let g:ackprg = 'ag --nogroup --color --column'

  "- Rspec.vim  -----------------------------------------------------------------------------------
  let g:rspec_command = '!bundle exec bin/rspec {spec}'  " use spring w/ rspec runner
  " let g:rspec_command = '!bundle exec rspec {spec}'      " dont use spring w/ rspec runner
  let g:rspec_runner  = 'os_x_iterm'
  map <Leader>t :call RunCurrentSpecFile()<CR>
  map <Leader>s :call RunNearestSpec()<CR>
  " map <Leader>l :call RunLastSpec()<CR>
  map <Leader>a :call RunAllSpecs()<CR>

  "- XMPFilter  ------------------------------------------------------------------------------------
  " map <C-b> <Plug>(xmpfilter-mark)<Plug>(xmpfilter-run)

  "- Switch ---------------------------------------------------------------------------------
  let g:switch_mapping = "-"

  "- Sidways---------------------------------------------------------------------------------
  " map <Leader>S :SidewaysLeft<cr>
  " map <Leader>R :SidewaysRight<cr>

  "- Indent Guides ---------------------------------------------------------------------------------
  let g:indent_guides_color_change_percent = 3      " ultra-low-contrast guides
  let g:indent_guides_guide_size = 2                " between 0 and 'shiftwidth'
  let g:indent_guides_start_level = 1               " don't show guides until the third indent

  " Lion, glip= will reduce space to single char
  let b:lion_squeeze_spaces = 1

  "= File Icons =====================================================================================
  " let g:WebDevIconsNerdTreeGitPluginForceVAlign on

  let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
  " let g:webdevicons_enable_nerdtree = 1

  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['rake'] = 'ƛ'
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['bash'] = ''
  " let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['DS_Store'] = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ico']  = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['eot']  = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['svg']  = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ttf']  = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['woff'] = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['otf']  = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ico']  = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['yml']  = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css']  = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['gitignore']  = ''
  " to enter Unicode: (in insert mode) <ctrl-v>u(uncode)
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md'] = 'M'
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['diff'] = ''

  let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
  let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

  let g:NERDTreeFileExtensionHighlightFullName = 1
  let g:NERDTreeExactMatchHighlightFullName = 1
  let g:NERDTreePatternMatchHighlightFullName = 1

  let s:orange = "D4843E"

  let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
  let g:NERDTreeExtensionHighlightColor['rake'] = s:orange " sets the color of css files to blue


  "= Airline ========================================================================================
  let g:airline_powerline_fonts = 1

"= Language Specific Settings======================================================================

  "- Golang ---------------------------------------------------------------------------------------
  let g:go_fmt_command = 'goimports'     " use gofmt on save w/ go commands (from go plugin)

  " com -nargs=1 H call WebHeader(<f-args>)
  " function! WebHeader(size)
  "   exe ':s/\(.*\)/<H' . a:size . '>\1<\/H' . a:size . '>/'
  " endfunction

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

  "- MD
  "Markdown-----------------------------------------------------------------------------------
  autocmd BufNewFile,BufReadPost *.md set filetype=ghmarkdown

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
  imap <tab> <Plug>snipMateNextOrTrigger
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
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif
