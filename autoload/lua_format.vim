" help function for formatters
function lua_format#CopyDiffToBuffer(input, output, bufname)
  " prevent out of range in cickle
  let min_len = min([len(a:input), len(a:output)])

  " copy all lines, that was changed
  for i in range(0, min_len - 1)
    let output_line = a:output[i]
    let input_line  = a:input[i]
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

  " XXX if formatting is a long operation and we call after format start some
  " other command, then window will display invalid data. For prevent this we
  " just redraw the windows
  redraw!
endfunction



function lua_format#format()
  let input = getline(1, "$")

  " in case of some error formatter print to stderr error message and exit
  " with 0 code, so we need redirect stderr to file, for read message in case
  " of some error. So let create a temporary file
  let error_file = tempname()

  let flags = " -i "

  " we can use config file for formatting which we have to set manually
  let config_file = findfile(".lua-format", ".;")
  if empty(config_file) == 0 " append config_file to flags
    let flags = flags .. " -c " .. config_file
  end

  let output_str=system("lua-format " .. flags .. " 2> " .. error_file, input)

  if empty(output_str) == 0 " all right
    let output = split(output_str, "\n")
    call lua_format#CopyDiffToBuffer(input, output, bufname("%"))

    " also clear lbuffer
    lexpr ""
    lwindow
  else " we got error
    let errors = readfile(error_file)

    " insert filename of current buffer in front of list. Need for errorformat
    let source_file = bufname("%")
    call insert(errors, source_file)

    set efm=%+P%f,line\ %l:%c\ %m,%-Q
    lexpr errors
    lwindow 5
  end

  call delete(error_file)
endfunction
