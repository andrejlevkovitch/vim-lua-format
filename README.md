# vim-lua-format

Support for vim for [LuaFormatter](https://github.com/Koihik/LuaFormatter).

## Install

Use `vundle` for add this plugin. After install plugin you need to add next
lines in your `.vimrc` file:

```vim
  autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
  autocmd BufWrite *.lua call LuaFormat()
```

After this when you press `<C-K>` or just save `*.lua` file, it will be
automaticly formatted.


## Features

Reformats your Lua source code.

## Extension Settings

* `.lua-format`: Specifies the style config file. [Style Options](https://github.com/Koihik/LuaFormatter/wiki/Style-Config)

`.lua-format` file have to be in one of parrent directories or in source dir. If no one file - use default settings

## Known Issues

You can has error about unknow option `-i` or `-si`. This happens becuase some
versions of `lua-formatter` uses different flags. So if you has error about
uncorrect flag - change it to other in [flags variable in lua_format#format function](autoload/lua_format.vim)
