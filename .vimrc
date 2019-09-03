:set cindent
:set shiftwidth=2
:set tabstop=2
:set expandtab
:set number
:colorscheme nelson

filetype plugin indent on
syntax on

let mapleader = "-"
nmap <F7> :tabp<CR>
nmap <F8> :tabn<CR>
noremap . mxgg=G`xzz

" This function is used as a movement that can be combined with d, c, y, etc. The onoremap calls the function if & is pressed after one of those operators.
function HighlightBlock()
  execute "normal! zz"
  let findBrace = "normal! /\}\<cr>"
  let currentLine = line('.')
  execute findBrace
  if line('.') == currentLine
    execute findBrace
  endif
  execute "normal! %"
  let openParenLine = line('.')
  while openParenLine >= currentLine
    execute "normal! %"
    execute findBrace
    execute "normal! %"
    let openParenLine = line('.')
  endwhile
  execute "normal! jmqk%kV`q"
endfunction


function IsLineEmpty(line)
  return match(a:line, "^\\s*$") != -1
endfunction

function VToggleComment()
  execute "normal! mq`>"
  let lastLine = line('.')
  execute "normal! `<_"
  let beginning = strpart(getline('.')[col('.') - 1:], 0, 2)
  let commentMode = 0
  if beginning == "//"
    let commentMode = 1
  endif

  while line('.') <= lastLine
    if !IsLineEmpty(getline('.'))
      let beginning = strpart(getline('.')[col('.') - 1:], 0, 2)
      if commentMode == 0 && beginning != "//"
        execute "normal! I// " 
      elseif commentMode == 1 && beginning == "//"
        execute "normal! ^xx=="
      endif
    endif
    execute "normal! :" + line('.') + 1 + "<cr>"
  endwhile
  execute "normal! `q"
endfunction

function NToggleComment()
  if !IsLineEmpty(getline('.'))
    execute "normal! mq^"
    let beginning = strpart(getline('.')[col('.') - 1:], 0, 2)
    if beginning != "//"
      execute "normal! I// " 
    elseif beginning == "//"
      execute "normal! ^xx=="
    endif
    execute "normal! `q"
  endif
endfunction

" d&, c&, y&: delete, change, yank within block
onoremap & :<c-u>call HighlightBlock()<cr>
" dp, cp, yp, etc: delete, change, yank within parentheses
onoremap p :<c-u>normal! vi(<cr>
" ds, cs, ys, etc: delete, change, yank within string
onoremap s :<c-u>normal! vi"<cr>
" press " in visual mode to put quotes around selection
vnoremap " <esc>`>a"<esc>`<i"<esc>
" press Q in visual mode to create a block around the selected lines and
" insert before the opening '('  (in order to type 'if(expr)', 'for(expr)', or
" the like
vnoremap Q <esc>`>o}<esc>`<O{<esc>mxgg=G`xI
" + inserts w/correct spacing at current empty line
nnoremap + ddO
" for adding spaces in too compact code easily
nnoremap <space> i<space><esc>l
" Ctrl-/ toggles comment on line in normal mode
nnoremap <C-_> :<c-u>call NToggleComment()<cr>
" Ctrl-/ toggles comment on selection in visual mode
vnoremap <C-_> <esc>:<c-u>call VToggleComment()<cr>
" enter in normal mode inserts a carriage return
nnoremap <cr> i<cr><esc>
nnoremap <up> ddkP
nnoremap <down> ddp
" map <F10> to show the highlight group for the current text
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . "> trans<". synIDattr(synID(line("."),col("."),0),"name") . "> lo<". synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


" nnoremap __ "+yy
" nnoremap _$ "+y$
" nnoremap _^ "+y^
" nnoremap _0 "+y0
" nnoremap _w "+yw
" nnoremap _b "+yb
" nnoremap _e "+ye
" nnoremap _G "+yG
" vnoremap _ "+y


