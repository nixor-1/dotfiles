" - - - VISUALS - - -
set number " Turn on line numbers by default.
set cursorline " Enables the cursorline feature.
" The following command does the following:
" - cterm=NONE: Removes any special attributes (e.g., underline).
" - ctermbg=238: Sets the background color using a 256-color code (238 being a dark gray color).
" - ctermfg=NONE: Keeps the existing foreground text color.
:highlight CursorLine cterm=NONE ctermbg=238 ctermfg=NONE
:highlight CursorLineNr cterm=NONE " Disables the underline for the line numbers to the left.

" - - - INDENTATION RULES - - -
set autoindent " New lines inherit the indentation of previous lines.
set expandtab " Converts tabs to spaces.
set shiftround " When shifting lines, round the indentation to the nearest multiple of shiftwidth.
set shiftwidth=4 " When shifting, indent using four spaces.
set smarttab " Insert tabstop number of spaces when the tab key is pressed.
set tabstop=4 " Indent using four spaces.

" - - - ENCODING - - -
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
