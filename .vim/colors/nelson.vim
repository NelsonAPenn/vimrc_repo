" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Nelson Penn

set background=dark
set term=screen-256color
set t_ui=
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "nelson"
"ctermbg on next line is entire terminal background
hi Normal ctermfg=White		ctermbg=Black guifg=cyan			guibg=DarkGrey
hi Comment	term=bold		ctermfg=Grey	guifg=#80a0ff
hi String ctermfg=Grey
hi Character ctermfg=Grey
hi Number ctermfg=Grey
hi Boolean ctermfg=Grey
hi Constant	term=underline	ctermfg=Red		guifg=Magenta
hi Special	term=bold	ctermfg=LightBlue	guifg=Red
"Identifier not defined for cpp :(
hi Identifier term=underline	cterm=bold			ctermfg=DarkCyan guifg=#40ffff
"break et al.
hi Statement term=bold		ctermfg=LightBlue gui=bold	guifg=#aa4444
"case, default
hi Label ctermfg=LightBlue
"class, namespace, etc.
hi Structure ctermfg=DarkMagenta
hi PreProc	term=underline	ctermfg=DarkRed	guifg=#ff80ff
hi Type	term=underline		ctermfg=DarkMagenta	guifg=#60ff60 gui=bold
"Function not defined for cpp :(
hi Function	term=bold		ctermfg=DarkYellow guifg=White
hi Repeat	term=underline	ctermfg=DarkYellow		guifg=white
hi Operator				ctermfg=DarkYellow			guifg=Red
hi Ignore				ctermfg=black		guifg=bg
hi Error	term=reverse ctermbg=Black ctermfg=Red guibg=Red guifg=White
hi Todo	term=standout ctermbg=DarkMagenta ctermfg=Yellow guifg=Blue guibg=Yellow
hi Namespace ctermfg=DarkYellow
hi namespace ctermfg=DarkYellow
hi cppSTLnamespace ctermfg=DarkYellow

hi cppAccessors ctermfg=DarkGreen


" Common groups that link to default highlighting.
" You can specify other highlighting easily.
"hi link String	Constant
"hi link Character	Constant
"hi link Number	Constant
"hi link Boolean	Constant
hi link Float		Number
hi link Conditional	Repeat
"hi link Label		Statement
hi link Keyword	Statement
hi link Exception	Statement
hi link Include	PreProc
hi link Define	PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
"hi link Structure	Type
hi link Typedef	Type
hi link Tag		Special
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment Special
hi link Debug		Special
