" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:parts = {}


" PUBLIC API {{{

function! airline#parts#define(key, config)
  let s:parts[a:key] = get(s:parts, a:key, {})
  if exists('g:airline#init#bootstrapping')
    call extend(s:parts[a:key], a:config, 'keep')
  else
    call extend(s:parts[a:key], a:config, 'force')
  endif
endfunction

function! airline#parts#define_function(key, name)
  call airline#parts#define(a:key, { 'function': a:name })
endfunction

function! airline#parts#define_text(key, text)
  call airline#parts#define(a:key, { 'text': a:text })
endfunction

function! airline#parts#define_raw(key, raw)
  call airline#parts#define(a:key, { 'raw': a:raw })
endfunction

function! airline#parts#define_minwidth(key, width)
  call airline#parts#define(a:key, { 'minwidth': a:width })
endfunction

function! airline#parts#define_condition(key, predicate)
  call airline#parts#define(a:key, { 'condition': a:predicate })
endfunction

function! airline#parts#define_accent(key, accent)
  call airline#parts#define(a:key, { 'accent': a:accent })
endfunction

function! airline#parts#define_empty(keys)
  for key in a:keys
    call airline#parts#define_raw(key, '')
  endfor
endfunction

function! airline#parts#get(key)
  return get(s:parts, a:key, {})
endfunction

" }}}

function! airline#parts#mode()
  return airline#util#shorten(get(w:, 'airline_current_mode', ''), 79, 1)
endfunction

function! airline#parts#crypt()
  return g:airline_detect_crypt && exists("+key") && !empty(&key) ? g:airline_symbols.crypt : ''
endfunction

function! airline#parts#paste()
  return g:airline_detect_paste && &paste ? g:airline_symbols.paste : ''
endfunction

" derbroti 2022: separate prints for spell icon and language
function! airline#parts#spell_icon()
  if g:airline_detect_spell && (&spell || (exists('g:airline_spell_check_command') && eval(g:airline_spell_check_command)))
    return g:airline_symbols.spell
  endif
  return ''
endfunction

" see comment above
function! airline#parts#spell_lang()
  let spelllang = g:airline_detect_spelllang ? printf("[%s] ", substitute(&spelllang, ',', '/', 'g')) : ''
  if g:airline_detect_spell && (&spell || (exists('g:airline_spell_check_command') && eval(g:airline_spell_check_command)))
    let winwidth = airline#util#winwidth()
    if winwidth >= 70
      return spelllang
    endif
  endif
  return ''
endfunction

function! airline#parts#iminsert()
  if g:airline_detect_iminsert && &iminsert && exists('b:keymap_name')
    return toupper(b:keymap_name)
  endif
  return ''
endfunction

function! airline#parts#readonly()
  " only consider regular buffers (e.g. ones that represent actual files,
  " but not special ones like e.g. NERDTree)
  if !empty(&buftype) || airline#util#ignore_buf(bufname('%'))
    return ''
  endif
  if &readonly && !filereadable(bufname('%'))
    return '[noperm]'
  else
    return &readonly ? g:airline_symbols.readonly : ''
  endif
endfunction

function! airline#parts#filetype()
  return (airline#util#winwidth() < 90 && strlen(&filetype) > 3)
        \ ? matchstr(&filetype, '...'). (&encoding is? 'utf-8' ? '…' : '>')
        \ : &filetype
endfunction

function! airline#parts#ffenc()
  let expected = get(g:, 'airline#parts#ffenc#skip_expected_string', '')
  let bomb     = &bomb ? '[BOM]' : ''
  let noeolf   = &eol ? '' : '[!EOL]'
  let ff       = strlen(&ff) ? '['.&ff.']' : ''
  if expected is# &fenc.bomb.noeolf.ff
    return ''
  else
    return &fenc.bomb.noeolf.ff
  endif
endfunction

function! airline#parts#executable()
  if exists("*getfperm") && getfperm(bufname('%')) =~ 'x'
    return g:airline_symbols.executable
  else
    return ''
  endif
endfunction

fun! airline#parts#adjusted_path(s1, s2)
  let l2 = len(a:s2)
  if !l2 | return '' | endif
  let l1 = len(a:s1)
  let m = min([l1, l2])

  let slash = 1 " first char after last shared slash
  for i in range(m)
    if a:s1[i] != a:s2[i] | break           | endif
    if a:s1[i] == '/'     | let slash = i+1 | endif
  endfor
  let ret = ""
  if slash < l1
    for i in range(slash, l1-1) | if a:s1[i] == '/' | let ret .= '../' | endif | endfor
  endif
  return ret . a:s2[slash : -1]
endfun

function! airline#parts#cwd()
  return fnamemodify(getcwd(), ':p:~')
endfunction

function! airline#parts#path()
  let cwd  = fnamemodify(getcwd(), ':p')
  let path = expand('%:p:h') . '/'
  return airline#parts#adjusted_path(cwd, path)
endfunction

