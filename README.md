# vim-lua-format

Support for vim for [LuaFormatter](https://github.com/Koihik/LuaFormatter).

## Install

* you have to add next lines in your `.vimrc` file:

  `function! LuaFormat()`
  `  pyf /usr/local/bin/lua-format.py`
  `endfunction`
  `autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>`
  `autocmd BufWrite *.lua call LuaFormat()`

## Features

Reformats your Lua source code.

## Extension Settings

* `.lua-format`: Specifies the style config file. [Style Options](https://github.com/Koihik/LuaFormatter/wiki/Style-Config)
