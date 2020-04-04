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
" help function for formatters
function! CopyDiffToBuffer(input, output, bufname)
  " prevent out of range in cickle
  let min_len=min([len(a:input), len(a:output)])

  " copy all lines, that was changed
  for i in range(0, min_len - 1)
    let output_line=a:output[i]
    let input_line=a:input[i]
    if input_line != output_line
      call setline(i + 1, output_line) " lines calculate from 1, items - from 0
    end
  endfor

  " in this case we have to handle all lines, that was in range
  if len(a:input) != len(a:output)
    if min_len == len(a:output) " remove all extra lines from input
      call deletebufline(a:bufname, min_len + 1, "$")
    else " append all extra lines from output
      call append("$", a:output[min_len:])
    end
  end
endfunction

function! LuaFormat()
  let input=getline(1, "$")

  " in case of some error formatter print to stderr error message and exit
  " with 0 code, so we need redirect stderr to file, for read message in case
  " of some error. So let create a temporary file
  let errorfile=tempname()

  let flags=" -i "

  " we can use config file for formatting which we have to set manually
  let config=findfile(".lua-format", ".;")
  if len(config) " append config file to flags
    let flags=flags . " -c " . config
  end

  let output_str=system("lua-format " . flags . " 2>" . errorfile, input)

  if len(output_str) " all right
    let output=split(output_str, "\n")
    call CopyDiffToBuffer(input, output, bufname("%"))

    " also clear lbuffer
    lexpr ""
    lwindow
  else " we got error
    let errors=readfile(errorfile)

    " insert filename of current buffer in front of list. Need for errorformat
    let sourcefile=expand("%")
    call insert(errors, sourcefile)

    set efm=%+P%f,line\ %l:%c\ %m,%-Q
    lexpr errors
    lwindow 5
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

## Known Issues

You can has error about unknow option `-i` or `-si`. This happens becuase some
versions of `lua-formatter` uses different flags. So if you has error about
uncorrect flag - change it to other
