" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Modified by derbroti
" Plugin: http://www.drchip.org/astronaut/vim/#NETRW
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':NetrwSettings')
  finish
endif

function! airline#extensions#netrw#apply(...)
  if &ft == 'netrw'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', '%#airline_a_bold#'.spc.'Files'.spc.'%*')
    if exists('*airline#extensions#branch#get_head')
      call a:1.add_section('airline_b', spc.'%{airline#extensions#branch#get_head()}'.spc)
    endif
    call a:1.add_section('airline_c', '')
    call a:1.split()
    call a:1.add_section('airline_y', spc.'%{airline#extensions#netrw#sortstring()}'.spc)
    return 1
  endif
endfunction

function! airline#extensions#netrw#inactive_apply(...)
  if getbufvar(a:2.bufnr, '&ft') == 'netrw'
    let spc = g:airline_symbols.space
    if exists('*airline#extensions#branch#get_head')
      call a:1.add_section('airline_b', spc.'%{airline#extensions#branch#get_head()}'.spc)
    endif
    call a:1.add_section('airline_c', '')
    call a:1.split()
    call a:1.add_section('airline_y', spc.'%{airline#extensions#netrw#sortstring()}'.spc)
    return 1
  endif
endfun

function! airline#extensions#netrw#init(ext)
  let g:netrw_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#netrw#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#netrw#inactive_apply')
endfunction


function! airline#extensions#netrw#sortstring()
  let order = (get(g:, 'netrw_sort_direction', 'n') =~ 'n') ? 'ᐃ' : 'ᐁ'
  return get(g:, 'netrw_sort_by', '') . ' ' . order
endfunction

