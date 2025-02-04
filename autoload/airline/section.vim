" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

call airline#init#bootstrap()
" no extra space...
let s:spc = '' " g:airline_symbols.space

function! s:wrap_accent(part, value)
  if exists('a:part.accent')
    call airline#highlighter#add_accent(a:part.accent)
    return '%#__accent_'.(a:part.accent).'#'.a:value.'%#__restore__#'
  endif
  return a:value
endfunction

function! s:create(parts, append)
  let _ = ''
  for idx in range(len(a:parts))
    let part = airline#parts#get(a:parts[idx])
    let val = ''
    let add_sep = get(l:, 'add_sep', 0)

    if exists('part.function')
      let func = (part.function).'()'
    elseif exists('part.text')
      let func = '"'.(part.text).'"'
    else
      if a:append > 0 && idx != 0
        let val .= s:spc.g:airline_left_alt_sep.s:spc
      endif
      if a:append < 0 && idx != 0
        let t = ''
        if !add_sep
          let t = s:spc.g:airline_right_alt_sep.s:spc
        endif
        let val = t.val
      endif
      if exists('part.raw')
        let _ .= s:wrap_accent(part, val.(part.raw))
        continue
      else
        let _ .= s:wrap_accent(part, val.a:parts[idx])
        continue
      endif
    endif

    let minwidth = get(part, 'minwidth', 0)

    if a:append > 0 && idx != 0
      let partval = printf('%%{airline#util#append(%s,%s)}', func, minwidth)
      " will add an extra separator, if minwidth is zero
      let add_sep = (minwidth == 0)
    elseif a:append < 0 && idx != len(a:parts) - 1
      let partval = printf('%%{airline#util#prepend(%s,%s)}', func, minwidth)
      " will add an extra separator, if minwidth is zero
      let add_sep = (minwidth == 0)
    else
      let partval = printf('%%{airline#util#wrap(%s,%s)}', func, minwidth)
      let add_sep = 0
    endif

    if exists('part.condition')
      let partval = substitute(partval, '{', '\="{".(part.condition)." ? "', '')
      let partval = substitute(partval, '}', ' : ""}', '')
    endif

    let val .= s:wrap_accent(part, partval)
    let _ .= val
  endfor
  return _
endfunction

function! airline#section#create(parts)
  return s:create(a:parts, 0)
endfunction

function! airline#section#create_left(parts)
  return s:create(a:parts, 1)
endfunction

function! airline#section#create_right(parts)
  return s:create(a:parts, -1)
endfunction
