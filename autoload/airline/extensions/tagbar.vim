" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/majutsushi/tagbar
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':TagbarToggle')
  finish
endif

let s:spc = g:airline_symbols.space
let s:init=0

" Arguments: current, sort, fname
function! airline#extensions#tagbar#get_status(...)
  let builder = airline#builder#new({ 'active': a:1 })
  call builder.add_section('airline_a', '%#airline_a_bold#'.s:spc.'Tags'.s:spc)
  call builder.add_section('airline_b', s:spc.'Sort by '.a:2.s:spc)
  "call builder.add_section('airline_c', s:spc.a:3.s:spc)
  return builder.build()
endfunction

function! airline#extensions#tagbar#inactive_apply(...)
  if getwinvar(a:2.winnr, '&filetype') == 'tagbar'
    return -1
  endif
endfunction

let s:airline_tagbar_last_lookup_time = 0
let s:airline_tagbar_last_lookup_val = ''
function! airline#extensions#tagbar#currenttag()
  if get(w:, 'airline_active', 0)
    if !s:init
      try
        " try to load the plugin, if filetypes are disabled,
        " this will cause an error, so try only once
        let a = tagbar#currenttag('%s', '', '')
      catch
      endtry
      unlet! a
      let s:init=1
    endif
    let cursize = getfsize(fnamemodify(bufname('%'), ':p'))
    if cursize > 0 && cursize > get(g:, 'airline#extensions#tagbar#max_filesize', 1024 * 1024)
      return ''
    endif
    let flags = get(g:, 'airline#extensions#tagbar#flags', '')
    " function tagbar#currenttag does not exist, if filetype is not enabled
    if s:airline_tagbar_last_lookup_time != localtime() && exists("*tagbar#currenttag")
      let s:airline_tagbar_last_lookup_val = tagbar#currenttag('%s', '', flags,
            \ get(g:, 'airline#extensions#tagbar#searchmethod', 'nearest-stl'))
      let s:airline_tagbar_last_lookup_time = localtime()
      let split_lookup_val = split(s:airline_tagbar_last_lookup_val, '::')
      if len(split_lookup_val) > 1
        let s:airline_tagbar_last_lookup_val = (len(split_lookup_val) > 2 ? '::' : '') . join(split_lookup_val[-2:-1], '::')
      endif
      let s:airline_tagbar_last_lookup_val = substitute(s:airline_tagbar_last_lookup_val, "__anon[a-f0-9]*", "[anon]", '')
    endif
    return s:airline_tagbar_last_lookup_val
  endif
  return ''
endfunction

function! airline#extensions#tagbar#currenttagstack()
    let l:tag = gettagstack()
    let l:tag_len = l:tag['length']
    let l:tag_idx = l:tag['curidx'] - 1 " index is on the next free slot
    if l:tag_len > 0 && l:tag_idx > 0
      return l:tag_idx . "⋮ "
    endif
    return ''
endfunction

function! airline#extensions#tagbar#init(ext)
  call a:ext.add_inactive_statusline_func('airline#extensions#tagbar#inactive_apply')
  let g:tagbar_status_func = 'airline#extensions#tagbar#get_status'

  call airline#parts#define('tagbar', {'function': 'airline#extensions#tagbar#currenttag', 'accent': 'tagbar'})
  call airline#parts#define('tagbar_tag', {'function': 'airline#extensions#tagbar#currenttagstack', 'accent': 'tagbar_tag'})
endfunction
