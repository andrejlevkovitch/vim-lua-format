# vim-lua-format

Support for vim for [LuaFormatter](https://github.com/Koihik/LuaFormatter).

## Install

You have to add next lines in your `.vimrc` file:

```vim
  function! LuaFormat() 
  " here you have to set path to lua-format.py file from the repo. In this case it was be copy to /usr/local/bin directory
    pyf /usr/local/bin/lua-format.py
  endfunction
  autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
  autocmd BufWrite *.lua call LuaFormat()
```

After this when you press `<C-K>` or just save `*.lua` file, it will be automaticly formatted.


Other way you can add to your `.vimrc` next lines:
```vim
function! LuaFormat()
  let sourcefile=expand("%")
  let text=getline(1, "$")

  " in case of some error formatter print to stderr error message and exit
  " with 0 code, so we need redirect stderr to file, for read message in case
  " of some error. So let create a temporary file
  let errorfile=tempname()

  let flags=" -si "

  " we can use config file for formatting which we have to set manually
  let config=findfile(".lua-format", ".;")
  if len(config) " append config file to flags
    let flags=flags . " -c " . config
  end

  let result=system("lua-format " . flags . " 2>" . errorfile, text)

  if len(result) " all right
    " save cursor position
    let sourcepos=line(".")

    " change content
    call deletebufline(bufname("%"), 1, "$")
    call setline(1, split(result, "\n"))

    " and restore cursor position
    call cursor(sourcepos, 0)

    " also clear cbuffer
    cexpr ""
    cwindow
  else
    let errors=readfile(errorfile)
    call insert(errors, sourcefile)

    set efm=%+P%f,line\ %l:%c\ %m,%-Q
    cexpr errors
    cwindow 5
  end

  call delete(errorfile)
endfunction
autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
autocmd BufWrite *.lua call LuaFormat()
```

This way works as previous, but it not required python support by vim. The second variant is preferable.

## Features

Reformats your Lua source code.

## Extension Settings

* `.lua-format`: Specifies the style config file. [Style Options](https://github.com/Koihik/LuaFormatter/wiki/Style-Config)

`.lua-format` file have to be in one of parrent directories or in source dir. If no one file - use default settings
