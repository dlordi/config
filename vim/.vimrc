set clipboard=unnamedplus " use system clipboard
set number " show line numbers
set relativenumber " show line number offsets

" highlight current line
set cursorline
hi CursorLine cterm=NONE ctermbg=8 ctermfg=NONE
hi CursorLineNr cterm=NONE ctermbg=8 ctermfg=NONE

lan en_US.UTF-8 " no translation, always use english

" show white spaces (WARNING: mouse selection will COPY those characters instead of white spaces!)
" set listchars=tab:>-
" set listchars+=space:␣ " da usare in alternativa al comando seguente
" set listchars+=space:·
" set listchars+=eol:¬
" set list

" use different cursor shape for insert and normal mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" use utf-8 encoding (examples: à ζ 漢 🎉)
set encoding=utf-8 " open files using utf-8 encoding
set fileencoding=utf-8 " handle new charaters using utf-8 encoding

imap jk <esc> " exit insert mode, enter normal mode

" ctrl-s save current file
:nmap <c-s> :w<CR> 
:imap <c-s> <Esc>:w<CR>a
