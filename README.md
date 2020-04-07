# My `.vimrc`

If you are a die-hard VIM user like me, feel free to download/clone my continuously expanding `.vimrc` to see what it is like to be in my shoes.

Some of my favorite commands I've added:

 - Normal mode:
   - `Ctrl + /` for comment/uncomment.
   - `.` reindents everything and maintains the current cursor position
   - `&` movement function - operates on the current function block. Use in `d&`, `y&`, `c&`, etc.
   - `p` movement function - operates within the surrounding parentheses. Use in `dp`, `yp`, `cp`, etc.
   - `s` movement function - operates within the current string (as long as it is surrounded by double quotes). Use in `ds`, `ys`, `cs`, etc.
   - `^^`, `^$`, `^w`, etc. used to yank into the `+` buffer.
   - `Q` creates a block below the current line and inserts into the middle
   - `+` inserts at the correctly indented position on an empty line
   - space inserts a space without having to go into insert mode
   - up and down move the current line up and down. Using the arrow keys for movement is for amateurs!
   
   
 - Visual mode:
   - `Ctrl + /` for comment/uncomment
   - `,"` puts the current selection within a string
   - `Q` puts the highlighted lines into a block and inserts before the opening parentheses
