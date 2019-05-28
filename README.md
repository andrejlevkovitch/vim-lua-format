# vim-lua-format

Support for vim for [LuaFormatter](https://github.com/Koihik/LuaFormatter).

## Install

You have to add next lines in your `.vimrc` file:

```
  function! LuaFormat() 
  " here you have to set path to lua-format.py file from the repo. In this case it was be copy to /usr/local/bin directory
    pyf /usr/local/bin/lua-format.py
  endfunction
  autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
  autocmd BufWrite *.lua call LuaFormat()
```

## Features

Reformats your Lua source code.

## Extension Settings

* `.lua-format`: Specifies the style config file. [Style Options](https://github.com/Koihik/LuaFormatter/wiki/Style-Config)

`.lua-format` file have to be in one of parrent directories or in source dir. If no one file - use default settings
