



"""""""""""""""""""""""""""""""""""
"        helper functions         
"""""""""""""""""""""""""""""""""""

" return message if 'paste' mode currently enabled - display on statusbar.
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    else
        return ''
    endif
endfunction

" set a property equal to itself to reload tabline - autoupdate statusbar.
function! UpdateStatusbar(timer)    
    :execute 'let &ro=&ro'
endfunction 

"""""""""""""""""""""""""""""""""""
"         order-dependent          
"""""""""""""""""""""""""""""""""""

" prevent 'defaults.vim' from being sourced.
:let g:skip_defaults_vim=1

" Use 'set nocompatible', only if not already done so (prevents any unintended
" "side effects", which can crop up if 'nocp' has already been set). 
if &compatible
    :set nocompatible
endif

"""""""""""""""""""""""""""""""""""
"     complex/situational           
"""""""""""""""""""""""""""""""""""

" write the file changes after editing without sudo
:command W silent execute 'write !sudo /usr/bin/tee ' 
            \   . shellescape(@%, 1) . ' > /dev/null' <bar> edit!

" jump to last position of cursor, unless it is invalid, inside event handler
" (when dropping files in gvim), or editing commit file (probably different).
autocmd BufReadPost * 
  \   if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   :execute "normal! g`\"" 
  \ | endif

" format the statusbar.
:set statusline=bf:[%n]\ 
                    \%{HasPaste()}\'%F'\%m%r%h%w,\ 
                    \ft:%y,\ 
                    \cwd:\'%{getcwd()}',\ 
                    \mod:\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}
                    \%=\ 
                    \line:%l/%L,\ 
                    \col:%c\ 

" update statusbar every number of seconds specified - '4000': 4 seconds.
let timer=timer_start(4000,'UpdateStatusbar',{'repeat':-1})

" load indentation rules and plugins according to the detected filetype.
if has("autocmd")
    filetype plugin indent on
endif

"""""""""""""""""""""""""""""""""""
"             common                             
"""""""""""""""""""""""""""""""""""

" allow '<BS>' over indent/autoindent, line breaks, and 'insert' mode start.
:set backspace=indent,eol,start

" turn on syntax highlighting
:syntax on

" set compatibility for dark background and syntax highlighting.
:set background=dark

" use indent of previous line for newly created line. 
:set autoindent

" specify when to display statusline  '2': always.
:set laststatus=2

" display current cursor position (lower-right). 
:set ruler

" enable mouse usage for specified mode(s) - 'a': all modes.
:set mouse=a

" use spaces instead of tab
:set expandtab

" set one tab equal to number of spaces specified - '2'.
:set tabstop=2

"
:set softtabstop=2

"
:set shiftwidth=2

" display line numbers in the left margin
:set number

" specify width of additional margin to add left of line numbers - '2'.
:set foldcolumn=2

" wrap lines at the width of the window.
:set wrap

" do not split words when wrapping text (wraps full word).
:set linebreak

" wrap text using specified formatting option - 't': textwidth. 
:set formatoptions=t

" break/wrap each line at number of characters specified - '80'.
:set textwidth=79

" highlight current line in all windows and update as cursor moves.
":set cursorline

" highlight current column in all windows and update as cursor moves.
":set cursorcolumn

" set the height of the command window to number of lines specified - '2'.
:set cmdheight=2

" display (partial) commands in statusline (lower-right, left of ruler).
:set showcmd

" show matching brackets, parentheses, etc. 
:set showmatch

" display partial matches for search patterns.
:set incsearch

" highlight matches with the last used search pattern. 
:set hlsearch

" search using case insensitive matching. 
:set ignorecase

" search using 'smart' case matching.
:set smartcase

" record specified number of commands and search patterns - '200'.
:set history=200

" keep a backup of a file when overwriting it. 
:set backup

" automatically save before commands like ':next' and ':make'.
:set autowrite

" use '<Left>' or '<Right>' to navigate through completion lists. 
:set wildmenu

" specify minimum screen lines to keep above/below cursor - '10'.
:set scrolloff=10

" stop certain movements from always going to the first character of a line.
:set nostartofline

" toggle between 'paste' and 'nopaste' using the key specified - '<F11>'
:set pastetoggle=<F11>

"""""""""""""""""""""""""""""""""""
"          colorschemes                
"""""""""""""""""""""""""""""""""""

" all of the available default colorschemes, together with the command needed
" to set the default to that scheme:
" NOTE: slightly narrowed down list is beneath all the default choices. 
"   command    scheme
":colorscheme blue
":colorscheme darkblue
":colorscheme default
":colorscheme delek
:colorscheme desert
":colorscheme elflord
":colorscheme evening
":colorscheme industry
":colorscheme koehler
":colorscheme morning
":colorscheme murphy
":colorscheme pablo
":colorscheme peachpuff
":colorscheme ron
":colorscheme shine
":colorscheme slate
":colorscheme torte
":colorscheme zellner
"
" schemes that have at least one desired or unique attribute:
"           blue     bright blue background.
"         desert*    good contrast; cool colors.
"        elflord*    good contrast; cool colors.
"        evening     misty, fog-like haze over screen.
"        koehler     a lot of bold text; good readability.
"       industry*    cool colors.
"        morning     bright background; great contrast.
"          pablo     cool colors; dark writing, dark background, bad contrast.
"            ron*    good contrast; cool colors.
"          shine     very bright background; some good contrast.
"     NOTE: * best default dark-themed colorschemes.

" remove the current individual syntax highlighting for a group:
":highlight Normal ctermfg=None
":highlight Comment ctermfg=None

" configure individual instructions for syntax hightlighting:
":highlight Normal ctermfg=Blue
":highlight Comment ctermfg=Green

"""""""""""""""""""""""""""""""""""
"     source other files next         
"""""""""""""""""""""""""""""""""""

" Source a global configuration file at '/etc/vim/vimrc(.local)', if
"if filereadable("/etc/vim/vimrc.local")
"  source /etc/vim/vimrc.local
"endif



