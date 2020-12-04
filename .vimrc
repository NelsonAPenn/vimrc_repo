set noerrorbells
set vb t_vb=
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
        \ 'javascript': "//",
        \ 'json': "//",
        \ 'sh': '#',
        \ 'R': '#',
        \ 'rust': '//',
        \ 'dockerfile': '#',
        \}
  let currentFiletype = &ft
  let comment = dict[currentFiletype] 
  return comment
endfunction

function HighlightBlock()
  " Very sad because I found this command after the fact of writing my own
  " beautiful HighlightBlock function :(
  execute "normal! vi{"
endfunction


function IsLineEmpty(line)
  return match(a:line, "^\\s*$") != -1
endfunction

function CurrentCharacter()
  return getline('.')[col('.')-1] 
endfunction

function IsSpace(c)
  if a:c == " "
    return 1
  elseif a:c == "\t"
    return 1
  elseif a:c == "\n"
  endif
endfunction

function CurrentLineIsCommented()
  let comment = GetComment()
  if !IsLineEmpty(getline('.'))
    execute "normal! ^"
    let beginning = strpart(getline('.')[col('.') - 1:], 0, strlen(comment))
    return beginning == comment
  endif
  return 0
endfunction

function CapLineLength()
  execute "normal! 80|"

  if virtcol('.') != 80
    " line does not need to be capped
    return
  endif

  " find whether the current or surrounding characters are spaces
  let space_at = IsSpace(CurrentCharacter())
  execute "normal! h"
  let space_before = IsSpace(CurrentCharacter())
  execute "normal! l"
  execute "normal! l"
  if virtcol('.') == 80 " at end of line already
    return
  endif
  let space_after = IsSpace(CurrentCharacter())
  execute "normal! h"

  " build command
  let command = "normal! "

  if !space_at && !space_after " if there is a space at or after the current character, no need to move

    if !space_before " if in the middle of a word, move to the start of the word 
      let command = command."B"
    endif

    " at this point, the cursor should be at the start of the word. Move one
    " space left.
    let command = command."h"

  endif

  let command = command."a\<cr>"
  execute command
endfunction

function VToggleComment()
  execute "normal! mq`>"
  let last_line = line('.')
  execute "normal! `<_"

  let comment_mode = 1
  let break_next = 0

  " Determine comment mode:
  " if all lines are commented, a level of comments will be removed.
  " Otherwise, a level of comments will be added.
  while line('.') <= last_line
    if !IsLineEmpty(getline('.')) && !CurrentLineIsCommented()
      let comment_mode = 0
    endif

    if break_next
      break
    endif

    execute "normal! :" + line('.') + 1 + "<cr>"
    if line('.') == last_line
      let break_next = 1
    endif
  endwhile

  execute "normal! `< "

  let break_next = 0
  while line('.') <= last_line
    call ApplyComment(comment_mode)
    if break_next
      break
    endif
    execute "normal! :" + line('.') + 1 + "<cr>"
    if line('.') == last_line
      let break_next = 1
    endif
  endwhile
  execute "normal! `q"
endfunction

function ApplyComment(comment_mode)
  if IsLineEmpty(getline('.'))
    return
  endif

  let comment = GetComment()
  if a:comment_mode == 0
    " insert one level of comment
    execute ("normal! I" . comment . " ") 
  elseif a:comment_mode == 1 && CurrentLineIsCommented()
    " remove one level of comment
    execute "normal! ^"
    let i = 0
    while i < strlen(comment)
      execute "normal! x"
      let i = i + 1
    endwhile
    while IsSpace(CurrentCharacter())
      execute "normal! x"
    endwhile
  endif
endfunction

function Label(list)
  " Inserts items in list at locations found by using the recording in n
  if len(a:list) == 0
    return
  endif

  execute "normal! i".a:list[0]
  let i = 1
  while i < len(a:list) 
    execute "normal! @n"
    execute "normal! i".a:list[i]

    let i = i + 1
  endwhile


endfunction

function Number(n)
  " Inserts numbers at locations found by using the recording in n
  if a:n == 0
    return
  endif

  execute "normal! i0"
  let i = 1
  while i < a:n
    execute "normal! @n"
    execute "normal! i".i

    let i = i + 1
  endwhile

endfunction

function NToggleComment()
  execute "normal! mq"

  if CurrentLineIsCommented()
    call ApplyComment(1)
  else
    call ApplyComment(0)
  endif

  execute "normal! `q"
endfunction



" ~~~ REMAPPINGS ~~~

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

" 0 safely caps the current line at 80 characters
nnoremap 0 <esc>:<c-u>call CapLineLength()<cr>

" enter in normal mode inserts a carriage return
nnoremap <cr> i<cr><esc>

" arrow keys move current line up or down
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
