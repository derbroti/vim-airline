" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" This extension is inspired by vim-anzu <https://github.com/osyo-manga/vim-anzu>.
" Heavily modified 2022 by Mirko Palmer (derbroti)
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*searchcount')
  finish
endif

let s:airline_searchcount_timer = 0
let s:airline_searchcount_last_update = 0
let s:airline_searchcount_force_update = 0

function! airline#extensions#searchcount#updateTimer(id)
  " needs to be set before refresh is called
  let s:airline_searchcount_timer += 1

  " force only if we are no longer in command mode, i.e., changing the search term
  if mode() ==# 'c'
    return
  endif

  if s:airline_searchcount_force_update == 1
    call airline#extensions#searchcount#refresh()
    " is evaluated in refresh - reset only after call!
    let s:airline_searchcount_force_update = 0
  endif
endfunction

" from https://github.com/mox-mox/vim-localsearch
function! airline#extensions#searchcount#localsearchSet()
  let g:last_search = @/
  let @/ = get(t:, 'last_search', '')
endfunction
function! airline#extensions#searchcount#localsearchUnset()
  let w:last_search = @/
  let @/ = get(g:, 'last_search', '')
endfunction

function airline#extensions#searchcount#init(ext)
  call a:ext.add_statusline_func('airline#extensions#searchcount#apply')
  call timer_start(250, function('airline#extensions#searchcount#updateTimer'), {'repeat': -1})

  augroup localsearch
    autocmd!
    au WinEnter * :call airline#extensions#searchcount#localsearchSet()
    au WinLeave * :call airline#extensions#searchcount#localsearchUnset()
  augroup END
endfunction

function airline#extensions#searchcount#refresh_redraw_hard() abort
  redrawtabline
  let &tabline = &tabline
  let &ro = &ro
  "let g:refresh_hard_called += 1
  endfun

function airline#extensions#searchcount#refresh_redraw() abort
  redrawtabline
  let &ro = &ro
endfun

function airline#extensions#searchcount#refresh()
   "let g:refreshcalled += 1
  if !(get(w:, 'search_last_mode', '') ==# 'c') && mode() ==# 'c'
    call airline#extensions#searchcount#refresh_redraw_hard()
    let w:airline_last_idx = -1
    let w:airline_last_term = ''
  else
    if get(w:, 'airline_last_term', '') != getreg('/')
      call airline#extensions#searchcount#status()
      call airline#extensions#searchcount#refresh_redraw()
      let w:airline_last_idx = -1
      let w:airline_last_term = getreg('/')
    elseif v:hlsearch " 'search term did not changed' case
      call airline#extensions#searchcount#status()
      if get(w:, 'airline_idx_changed', 1)
        call airline#extensions#searchcount#refresh_redraw()
      endif
    endif
  endif

  let w:search_last_mode = mode()
  return ''

  "return "r:". g:refreshcalled. " sc: " . get(g:, 'statuscalled', 1) . "x:" . get(w:, 'airline_idx_changed', 1). " ".getreg('/')
endfun


function airline#extensions#searchcount#apply(...)
  call airline#extensions#append_to_section('z', '%{airline#extensions#searchcount#refresh()}')
endfunction


function! s:search_term()
  let search_term_limit = get(g:, 'airline#extensions#searchcount#search_term_limit', 8)

  " shorten for all width smaller than 300 (this is just a guess)
  " this uses a non-breaking space, because it looks like
  " a leading space is stripped :/
  " return "\ua0" .  '/' . airline#util#shorten(getreg('/'), 300, 8)
  return "\ua0" . getreg('/')
endfunction

function airline#extensions#searchcount#status()
  "let g:statuscalled += 1
  let w:airline_not_found = 0
  try
    let l:recomp = s:airline_searchcount_timer != s:airline_searchcount_last_update
    let s:airline_searchcount_force_update = !l:recomp
    let s:airline_searchcount_last_update = s:airline_searchcount_timer

    let result = searchcount(#{recompute: l:recomp, maxcount: -1})

    if empty(result) || result.total ==# 0
      let w:airline_last_idx = -1
      let w:airline_idx_changed = 0
      let w:airline_not_found = 1
      return ' <not found>'
    endif
    if result.incomplete ==# 1     " timed out
      let w:airline_result = printf('%s [?/??]', <SID>search_term())
    elseif result.incomplete ==# 2 " max count exceeded
      if result.total > result.maxcount &&
            \  result.current > result.maxcount
        let w:airline_result = printf('%s [>%d/>%d]', <SID>search_term(),
              \		    result.current, result.total)
      elseif result.total > result.maxcount
        let w:airline_result = printf('%s [%d/>%d]', <SID>search_term(),
              \		    result.current, result.total)
      endif
    endif
    let w:airline_result = printf('%s [%d/%d]', <SID>search_term(),
          \		result.current, result.total)

    if get(w:, 'airline_last_idx', -1) != result.current
      let w:airline_last_idx = result.current
      let w:airline_idx_changed = 1
      " for C-G/-T while incsearching
      if line(".") == 1
        setlocal norelativenumber
      endif
    else
      let w:airline_idx_changed = 0
    endif
    " for jumping around while incsearching
    if get(w:, 'coli_search_line', -1) == 1 && line(".") != 1 && ! get(w:, 'force_abs_line', 0)
      setlocal relativenumber
      let w:coli_search_line = line(".")
    elseif get(w:, 'coli_search_line', -1) > 1 && line(".") == 1
      setlocal norelativenumber
      let w:coli_search_line = line(".")
    endif

  catch
    let w:airline_last_idx = -1
    let w:airline_idx_changed = 0
    let w:airline_not_found = 1
    let w:airline_result = ' <error>'
  endtry
  return w:airline_result
endfunction
