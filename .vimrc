



"""""""""""""""""""""""""""""""""""
"        helper functions         "
"""""""""""""""""""""""""""""""""""

" return message if 'paste' mode currently enabled - display on statusbar.
function! HasPaste()
    if &paste
        return 'paste mode '
    else
        return ''
    endif
endfunction

" set a property equal to itself to reload tabline - autoupdate statusbar.
function! UpdateStatusbar(timer)    
    :execute 'let &ro=&ro'
endfunction 

" create function to call when '<del>' key is pressed in 'normal' mode.
function! Delete_key(...)
  let line=getline('.')
  if line=~'^\s*$'
    execute "normal dd"
    return
  endif
  let column=col('.')
  let line_len=strlen(line)
  let first_or_end=0
  if column==1
    let first_or_end=1
  else
    if column==line_len
      first_or_end=1
    endif
  endif
  execute "normal i\<del>\<esc>"
  if first_or_end==0
    execute "normal l"
  endif
endfunction
       
" create function to call when '<bs>' key is pressed in 'normal' mode.
function! Backspace_key(...)
  let column=col('.')
  execute "normal i\<bs>\<esc>"
    if column==1
      let column2=col('.')
      if column2>1
        execute "normal l"
      endif
    else
      if column>2
        execute "normal l"
      endif
    endif
endfunction
     
" create function to call when '<tab>' key is pressed in 'normal' mode.
function! Tab_key(...)
  let start_pos=col('.')
  execute "normal i\<tab>"
  let end_pos=col('.')
  let diff=end_pos-start_pos
  let counter=0
  while 1==1
    execute "normal l"
    "let counter=counter+1
    let counter+=1
    if counter>=diff
      break
    endif
  endwhile
  execute "normal \<esc>"
endfunction
   
" create function to call when '<cr>' key is pressed in 'normal' mode
function! Return_key(...)
  let buftype=getbufvar(bufnr(''),'&buftype')
  if buftype!=''
    unmap <cr>
    execute "normal \<cr>"
    nnoremap <silent> <cr> :call Return_key()<cr>
  else
    execute "normal i\<cr>\<esc>"
  endif
endfunction

"""""""""""""""""""""""""""""""""""
"         order-dependent         " 
"""""""""""""""""""""""""""""""""""

" defaults are set for debian or debian-based distros (such as ubuntu).
"runtime! debian.vim

" prevent 'defaults.vim' from being sourced
:let g:skip_defaults_vim=1

" set the 'nocompatible' option; vi compatibility is not a concern.
:set nocompatible

"""""""""""""""""""""""""""""""""""
"       complex/situational       "  
"""""""""""""""""""""""""""""""""""

" write file changes after editing without sudo using 'W'
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

" if file '/etc/papersize' is available, set the papersize according to it.
if filereadable("/etc/papersize")
  let s:papersize=matchstr(readfile('/etc/papersize','',1),'\p*')
  if strlen(s:papersize)
    execute ":set printoptions+=paper:" . s:papersize
  endif
endif

"""""""""""""""""""""""""""""""""""
"       swap, backup, undo        "
"""""""""""""""""""""""""""""""""""

" set swap directory and use of swap files
:set directory=~/.vim/.swp
:set swapfile

" set backup directory and use of backup files
:set backupdir=~/.vim/.backup
:set backup

" set undo directory and use of undo files
:set undodir=~/.vim/.undo
:set undofile

"""""""""""""""""""""""""""""""""""
"          key mappings           " 
"""""""""""""""""""""""""""""""""""

" map '<del>' key to call function 'Delete_key()'
nnoremap <silent> <del> :call Delete_key()<cr>

" map '<bs>' key to call function 'Backspace_key()'
nnoremap <silent> <bs> :call Backspace_key()<cr>

" map '<tab>' key to call function 'Tab_key()'
nnoremap <silent> <tab> :call Tab_key()<cr>

" map '<cr>' to call function 'Return_key()'
nnoremap <silent> <cr> :call Return_key()<cr>

" map '<space>' key to to 'i\<space>\<esc>l' which will change to 'insert'
" mode, enter '<space>' key, enter '<esc>' key to change to 'normal' mode
nnoremap <silent> <space> i<space><esc>l
      
"""""""""""""""""""""""""""""""""""
"             common              "               
"""""""""""""""""""""""""""""""""""

" load indentation rules and plugins according to the detected filetype.
:filetype plugin indent on

" allow '<bs>' over indent/autoindent, line breaks, and 'insert' mode start.
:set backspace=indent,eol,start

" turn on syntax highlighting
:syntax on

" set compatibility for dark background and syntax highlighting.
:set background=dark

" use indent of previous line for newly created line. 
:set autoindent

" specify when to display statusline - '2': always.
:set laststatus=2

" display current cursor position (lower-right). 
:set ruler

" enable mouse usage for specified mode(s) - 'a': all modes.
:set mouse=a

" use spaces instead of <tab> character.
:set expandtab

" set one <tab> character equal to the number of spaces specified - '2'.
:set tabstop=2

" mix of <tab> and spaces; specify number of spaces <tab> counts for when 
" performing editing operations (i.e., inserting <tab> or using <bs>) - '2'.
:set softtabstop=2

" each step of indent/autoindent is equal to number of spaces specified - '2'.
:set shiftwidth=2

" if 'on', a <tab> at the start of a line is based on the 'shiftwidth' value;
" if 'off', a <tab> is always based on 'tabstop' or 'softtabstop' value, and
" 'shiftwidth' is then only used to shift text left/right.
:set smarttab

" display line numbers in the left margin.
:set number

" specify width of additional margin to add left of the line numbers - '2'.
:set foldcolumn=2

" if window width is less than textwidth (below) then wrap at window width.
:set wrap

" do not split words when wrapping text (wrap full words).
:set linebreak

" wrap text using specified formatting option - 't': textwidth.
:set formatoptions=t

" break/wrap each line at number of characters specified - '79'.
:set textwidth=79

" highlight column at which point text is set to wrap for a visual border.
:set colorcolumn=80

" highlight current line in all windows and update as cursor moves.
:set cursorline

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

" automatically save before commands like ':next' and ':make'.
:set autowrite

" use '<left>' key or '<right>' key to navigate through completion lists. 
:set wildmenu

" specify minimum screen lines to keep above/below cursor - '10'.
:set scrolloff=10

" stop certain movements from always going to the first character of a line.
:set nostartofline

" toggle between 'paste' and 'nopaste' using the key specified - '<f11>'; note
" that '<ctrl>+<f11>' is required to actualy to turn 'paste' mode on/off.
:set pastetoggle=<f11>

"""""""""""""""""""""""""""""""""""
"          colorschemes           "     
"""""""""""""""""""""""""""""""""""

" all of the available default colorschemes, together with the command needed
" to set the default to that scheme:
" note: slightly narrowed down list is beneath all the default choices. 
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
"     note: * best default dark-themed colorschemes.

" remove the current individual syntax highlighting for a group:
":highlight Normal ctermfg=None
":highlight Comment ctermfg=None

" configure individual instructions for syntax hightlighting:
":highlight Normal ctermfg=Blue
":highlight Comment ctermfg=Green

