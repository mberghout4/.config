set nocompatible " Require ViMproved

" Bundles
" {
    if filereadable(expand("~/.config/nvim/.vimrc.bundle"))
      source ~/.config/nvim/.vimrc.bundle
    endif
" }

" General Setup
" {
    " View
    color peaksea                  " Pick a color scheme

    set background=dark            " Assume a dark background
    set cursorline                 " Underline the row with the cursor
    "set foldenable                 " Auto fold code
    set linespace=0                " No extra space between rows
    set list                       " Show non-printing Characters
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Add problematic white space characters to the list
    set number                     " Line numbers on
    set shortmess+=filmnrxoOtT     " Abbrev. of messages (avoids 'hit enter')
    set showmatch                  " Show matching brackets/parenthesis
    set showmode                   " Display the Current Mode (Insert|Visual|Normal)
    set spell                      " Spell checking on
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows Compatibility
    set wildmenu                   " Show list instead of just completing
    set wildmode=list:longest,full " Command <Tab> completion, list matches, then longest common part, then all

    highlight clear LineNr         " Remove highlight color from current line number
    highlight clear SignColumn     " SignColumn should match background

    " Editor Behaviour/Tools
    set autoindent                 " Indent at the same level as the previous line
    "set backspace=indet,eol,start  " Backspace for dummies
    set formatoptions=tcqrn1
    set hidden                     " Allow buffer switching without saving
    set matchpairs+=<:>            " Match, to be used with %
    set mouse=a                    " Enable mouse usage
    set mousehide                  " Hide the mouse cursor while typing
    set nojoinspaces               " Prevent inserting two spaces after punctuation on a join (J)
    set nowrap                     " Do not wrap long lines
    set pastetoggle=<F12>          " pastetoggle (sane indentation on pastes)
    set scrolljump=5               " Number of lines to scroll when cursor leaves the screen
    set scrolloff=3                " Minimum number of lines to keep above and below cursor
    set splitbelow                 " Puts new split windows to the bottom of the current
    set splitright                 " Put new vsplit windows to the right of the current
    "set ttyfast                   " Speed up scrolling
    set virtualedit=onemore        " Allow cursor to go beyond last character
    set whichwrap=b,s,h,l,<,>,[,]  " Backspace and cursor keys wrap too
    set winminheight=0             " Windows can be 0 lines high
    syntax enable                  " Turn on syntax highlighting

    " Tabs/Indent
    set expandtab                  " Expand tabs to be spaces
    set shiftwidth=4               " Use indents of 4 spaces
    set softtabstop=4              " Let backspace delete indent
    set tabpagemax=15              " Only show 15 tabs
    set tabstop=4                  " An indentation every four columns

    " Searching
    set hlsearch                   " Highlight search terms
    set ignorecase                 " Case insensitive search
    set incsearch                  " Find as you type search
    set smartcase                  " Case sensitive when upper case characters are present

    " Other Configurations
    set iskeyword-=.               " '.' is an end of word designator
    set iskeyword-=#               " '#' is an end of word designator
    set iskeyword-=-               " '-' is an end of word designator
    set encoding=utf-8
    scriptencoding utf-8

    " Ruler
    if has('cmdline_info')
        set ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%v\ %P%) " A ruler on steriods
        set showcmd
    endif

    " Status line
    if has('statusline')
        set laststatus=2

        set statusline=%<%f\                       " Filename
        set statusline+=%w%h%m%r                   " Options
        if isdirectory(expand('~/.config/nvim/bundle/vim-fugitive'))
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]              " Filetype
        set statusline+=\ [%{getcwd()}]            " Current directory
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%    " Right aligned file nav info
    endif


    " History/Undo/Info
    set backup
    set history=1000              " Store a ton of history (default is 20)
    set viminfo='100,<9999,s100    "Store info for 100 files at a time, 9999 lines of text, 100kb of data.
    if has('persistent_undo')
        set undofile
        set undolevels=1000     " Maximum number of changes that can be undone
        set undoreload=10000    " Maximum number of lines to save for undo on a buffer reload
    endif

    " Clipboard
    if has('clipboard')
        if has('unnamedplus')
            set clipboard=unnamed,unnamedplus
        else
            set clipboard=unnamed
        endif
    endif

    " Auto Commands
    autocmd BufEnter * if bufname("") !~ "~\[A-Aa-z0-9\]*://" | lcd %:p:h | endif " Switch to the directory of the current file
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.'[0,1,1,0]) " Put cursor at beginning of the file for gitcommits

    " Color a column if we go over 80 columns
    highlight ColorColumn ctermbg=green
    call matchadd('ColorColumn','\%81v', 100)
" }

" Key (re)Mappings
" {
    " The default leader is '\', but many people prefer ',' as it's in a
    " standard location
    let mapleader =  ','
    let maplocalleader = '_'

    " Easier moving in tabs and windows
    " Note: These lines conflict with the default digraph mapping of <C-K>
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " Toggle highlighting of the current search
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv
" }

" Functions
" {
    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has ('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        let common_dir = parent . '/.' . prefix

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Restore cursor to the file position in the previous editing session
    function! RestoreCursor()
        if line("'\'") <= line("S")
            silent! normal! g`"
            return 1
        endif
    endfunction
    augroup restoreCursor
        autocmd!
        autocmd BufWinEnter * call RestoreCursor()
    augroup END

    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction

    function! FixLineEndings()
        %s/\r\+//g
    endfunction
" }

" NerdTree {
if isdirectory(expand("~/.config/nvim/bundle/nerdtree"))
  map <C-e> <plug>NERDTreeTabsToggle<CR>
  map <leader>e :NERDTreeFind<CR>
  nmap <leader>nt :NERDTreeFind<CR>

  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
  let NERDTreeChDirMode=0
  let NERDTreeQuitOnOpen=0
  let NERDTreeMouseMode=2
  let NERDTreeShowHidden=1
  let NERDTreeKeepTreeInNewTab=1
  let g:nerdtree_tabs_open_on_gui_startup=0
endif
" }
