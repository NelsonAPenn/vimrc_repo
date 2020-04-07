set cindent
set shiftwidth=2
set tabstop=2
set expandtab
set number
colorscheme nelson

filetype plugin indent on
syntax on

let mapleader = ","
nmap <F7> :tabp<CR>
nmap <F8> :tabn<CR>
noremap . mxgg=G`xzz


function GetComment()
  let dict = { 
        \ 'vim': "\"",
        \ 'cpp': "//",
        \ 'java': "//",
        \ 'python': "#",
        \ 'js': "//",
        \ 'sh': '#',
        \ 'R': '#',
        \}
  let currentFiletype = &ft
  let comment = dict[currentFiletype] 
  return comment
endfunction

" This function is used as a movement that can be combined with d, c, y, etc. The onoremap calls the function if & is pressed after one of those operators.
" function HighlightBlock()
"   execute "normal! zz"
"   let findBrace = "normal! /\}\<cr>"
"   let currentLine = line('.')
"   execute findBrace
"   if line('.') == currentLine
"     execute findBrace
"   endif
"   execute "normal! %"
"   let openParenLine = line('.')
"   while openParenLine >= currentLine
"     execute "normal! %"
"     execute findBrace
"     execute "normal! %"
"     let openParenLine = line('.')
"   endwhile
"   execute "normal! jmqk%kV`q"
" endfunction

function HighlightBlock()
  " Very sad because I found this command after the fact of writing my own
  " beautiful HighlightBlock function :(
  execute "normal! vi{"
endfunction


function IsLineEmpty(line)
  return match(a:line, "^\\s*$") != -1
endfunction

function VToggleComment()
  let comment = GetComment()
  execute "normal! mq`>"
  let lastLine = line('.')
  execute "normal! `<_"
  let beginning = strpart(getline('.')[col('.') - 1:], 0, strlen(comment))

  let commentMode = 1

  let breakNext = 0
  while line('.') <= lastLine
    if !IsLineEmpty(getline('.'))
      let beginning = strpart(getline('.')[col('.') - 1:], 0, strlen(comment))
      if beginning != comment
        let commentMode = 0
        break
      endif
    endif
    if breakNext
      break
    endif
    execute "normal! :" + line('.') + 1 + "<cr>"
    if line('.') == lastLine
      let breakNext = 1
    endif
  endwhile

  let comment = GetComment()
  execute "normal! mq`>"
  let lastLine = line('.')
  execute "normal! `<_"
  let beginning = strpart(getline('.')[col('.') - 1:], 0, strlen(comment))

  let breakNext = 0
  while line('.') <= lastLine
    if !IsLineEmpty(getline('.'))
      let beginning = strpart(getline('.')[col('.') - 1:], 0, strlen(comment))
      if commentMode == 0
        execute ("normal! I" . comment . " ") 
      elseif commentMode == 1 && beginning == comment
        execute "normal! ^"
        let i = 0
        while i < strlen(comment)
          execute "normal! x"
          let i = i + 1
        endwhile
        execute "normal! =="
      endif
    endif
    if breakNext
      break
    endif
    execute "normal! :" + line('.') + 1 + "<cr>"
    if line('.') == lastLine
      let breakNext = 1
    endif
  endwhile
  execute "normal! `q"
endfunction

function NToggleComment()
  let comment = GetComment()
  if !IsLineEmpty(getline('.'))
    execute "normal! mq^"
    let beginning = strpart(getline('.')[col('.') - 1:], 0, strlen(comment))
    if beginning != comment
      execute ("normal! I" . comment . " ") 
    elseif beginning == comment
      execute "normal! ^"
      let i = 0
      while i < strlen(comment)
        execute "normal! x"
        let i = i + 1
      endwhile
      execute "normal! =="
    endif
    execute "normal! `q"
  endif
endfunction

" Prevent strange behavior of <cr>
autocmd CmdwinEnter * nnoremap <cr> <cr>
autocmd BufReadPost quickfix nnoremap <cr> <cr>

" d&, c&, y&: delete, change, yank within block
onoremap & :<c-u>call HighlightBlock()<cr>
" dp, cp, yp, etc: delete, change, yank within parentheses
onoremap p :<c-u>normal! vi(<cr>
" ds, cs, ys, etc: delete, change, yank within string
onoremap s :<c-u>normal! vi"<cr>
" press " in visual mode to put quotes around selection
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
" press Q in visual mode to create a block around the selected lines and
" insert before the opening '('  (in order to type 'if(expr)', 'for(expr)', or
" the like
vnoremap Q <esc>`>o}<esc>`<O{<esc>mxgg=G`x<esc>zzI
" press Q in normal mode to create a block below the current line
nnoremap Q o{<cr>}<esc>O
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


nnoremap ^^ "+yy
nnoremap ^$ "+y$
nnoremap ^^ "+y^
nnoremap ^0 "+y0
nnoremap ^w "+yw
nnoremap ^b "+yb
nnoremap ^e "+ye
nnoremap ^G "+yG
vnoremap ^ "+y


hi Normal ctermbg=none
