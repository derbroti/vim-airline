" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! s:check_defined(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction

let s:loaded = 0
function! airline#init#bootstrap()
  if s:loaded
    return
  endif
  let s:loaded = 1

  let g:airline#init#bootstrapping = 1

  let g:airline#init#vim_async = (v:version >= 800 && has('job'))
  let g:airline#init#is_windows = has('win32') || has('win64')

  call s:check_defined('g:airline_detect_modified', 1)
  call s:check_defined('g:airline_detect_paste', 1)
  call s:check_defined('g:airline_detect_crypt', 1)
  call s:check_defined('g:airline_detect_spell', 1)
  call s:check_defined('g:airline_detect_spelllang', 1)
  call s:check_defined('g:airline_detect_iminsert', 0)
  call s:check_defined('g:airline_inactive_collapse', 1)
  call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
  call s:check_defined('g:airline_exclude_filetypes', [])
  call s:check_defined('g:airline_exclude_preview', 0)

  " If g:airline_mode_map_codes is set to 1 in your .vimrc it will display
  " only the modes' codes in the status line. Refer :help mode() for codes.
  " That may be a preferred presentation because it is minimalistic.
  call s:check_defined('g:airline_mode_map_codes', 0)
  call s:check_defined('g:airline_mode_map', {})

  if g:airline_mode_map_codes != 1
    " If you prefer different mode names than those below they can be
    " customised by inclusion in your .vimrc - for example, including just:
    " let g:airline_mode_map = {
    "    \ 'Rv' : 'VIRTUAL REPLACE',
    "    \ 'niV' : 'VIRTUAL REPLACE (NORMAL)',
    "    \ }
    " ...would override 'Rv' and 'niV' below respectively.
    call extend(g:airline_mode_map, {
        \ '__' : '------',
        \ 'n' : 'NORMAL',
        \ 'no' : 'OP PENDING',
        \ 'nov' : 'OP PENDING CHAR',
        \ 'noV' : 'OP PENDING LINE',
        \ 'no' : 'OP PENDING BLOCK',
        \ 'niI' : 'INSERT (NORMAL)',
        \ 'niR' : 'REPLACE (NORMAL)',
        \ 'niV' : 'V REPLACE (NORMAL)',
        \ 'v' : 'VISUAL',
        \ 'V' : 'V-LINE',
        \ '' : 'V-BLOCK',
        \ 's' : 'SELECT',
        \ 'S' : 'S-LINE',
        \ '' : 'S-BLOCK',
        \ 'i' : 'INSERT',
        \ 'ic' : 'INSERT COMPL GENERIC',
        \ 'ix' : 'INSERT COMPL',
        \ 'R' : 'REPLACE',
        \ 'Rc' : 'REPLACE COMP GENERIC',
        \ 'Rv' : 'V REPLACE',
        \ 'Rx' : 'REPLACE COMP',
        \ 'c'  : 'COMMAND',
        \ 'cv'  : 'VIM EX',
        \ 'ce'  : 'EX',
        \ 'r'  : 'PROMPT',
        \ 'rm'  : 'MORE PROMPT',
        \ 'r?'  : 'CONFIRM',
        \ '!'  : 'SHELL',
        \ 't'  : 'TERMINAL',
        \ 'multi' : 'MULTI',
        \ }, 'keep')
        " NB: no*, cv, ce, r? and ! do not actually display
  else
    " Exception: The control character in ^S and ^V modes' codes
    " break the status line if allowed to render 'naturally' so
    " they are overridden with ^ (when g:airline_mode_map_codes = 1)
    call extend(g:airline_mode_map, {
        \ '' : '^V',
        \ '' : '^S',
        \ }, 'keep')
  endif

  call s:check_defined('g:airline_theme_map', {})
  call extend(g:airline_theme_map, {
        \ 'default': 'dark',
        \ '\CTomorrow': 'tomorrow',
        \ 'base16': 'base16',
        \ 'mo[l|n]okai': 'molokai',
        \ 'wombat': 'wombat',
        \ 'zenburn': 'zenburn',
        \ 'solarized': 'solarized',
        \ 'flattened': 'solarized',
        \ '\CNeoSolarized': 'solarized',
        \ }, 'keep')

  call s:check_defined('g:airline_symbols', {})
  " First define the symbols,
  " that are common in Powerline/Unicode/ASCII mode,
  " then add specific symbols for either mode
  call extend(g:airline_symbols, {
          \ 'paste': 'PASTE',
          \ 'spell': 'SPELL',
          \ 'modified': '+',
          \ 'space': ' ',
          \ 'keymap': 'Keymap:',
          \ 'ellipsis': '...'
          \  }, 'keep')

  if get(g:, 'airline_powerline_fonts', 0)
    " Symbols for Powerline terminals
    call s:check_defined('g:airline_left_sep', "\ue0b0")      " 
    call s:check_defined('g:airline_left_alt_sep', "\ue0b1")  " 
    call s:check_defined('g:airline_right_sep', "\ue0b2")     " 
    call s:check_defined('g:airline_right_alt_sep', "\ue0b3") " 
    " ro=, ws=☲, lnr=, mlnr=☰, colnr=, br=, nx=Ɇ, crypt=🔒, dirty=⚡
    "  Note: For powerline, we add an extra space after maxlinenr symbol,
    "  because it is usually setup as a ligature in most powerline patched
    "  fonts. It can be over-ridden by configuring a custom maxlinenr
    call extend(g:airline_symbols, {
          \ 'readonly': "\ue0a2",
          \ 'whitespace': "\u2632",
          \ 'maxlinenr': "\u2630 ",
          \ 'linenr': " \ue0a1:",
          \ 'colnr': " \ue0a3:",
          \ 'branch': "\ue0a0",
          \ 'notexists': "\u0246",
          \ 'dirty': "\u26a1",
          \ 'crypt': nr2char(0x1F512),
          \ }, 'keep')
  elseif &encoding==?'utf-8' && !get(g:, "airline_symbols_ascii", 0)
    " Symbols for Unicode terminals
    call s:check_defined('g:airline_left_sep', "")
    call s:check_defined('g:airline_left_alt_sep', "")
    call s:check_defined('g:airline_right_sep', "")
    call s:check_defined('g:airline_right_alt_sep', "")
    " ro=⊝, ws=☲, lnr=㏑, mlnr=☰, colnr=℅, br=ᚠ, nx=Ɇ, crypt=🔒
    call extend(g:airline_symbols, {
          \ 'readonly': "\u229D",
          \ 'whitespace': "\u2632",
          \ 'maxlinenr': "\u2630",
          \ 'linenr': " \u33d1:",
          \ 'colnr': " \u2105:",
          \ 'branch': "\u16A0",
          \ 'notexists': "\u0246",
          \ 'crypt': nr2char(0x1F512),
          \ 'dirty': '!',
          \ }, 'keep')
  else
    " Symbols for ASCII terminals
    call s:check_defined('g:airline_left_sep', "")
    call s:check_defined('g:airline_left_alt_sep', "")
    call s:check_defined('g:airline_right_sep', "")
    call s:check_defined('g:airline_right_alt_sep', "")
    call extend(g:airline_symbols, {
          \ 'readonly': 'RO',
          \ 'whitespace': '!',
          \ 'linenr': ' ln:',
          \ 'maxlinenr': '',
          \ 'colnr': ' cn:',
          \ 'branch': '',
          \ 'notexists': '?',
          \ 'crypt': 'cr',
          \ 'dirty': '!',
          \ }, 'keep')
  endif

  call airline#parts#define('mode', {
        \ 'function': 'airline#parts#mode',
        \ 'accent': 'bold',
        \ })
  call airline#parts#define_function('iminsert', 'airline#parts#iminsert')
  call airline#parts#define_function('paste', 'airline#parts#paste')
  call airline#parts#define_function('crypt', 'airline#parts#crypt')
  " split spell icon and language prints (keep icon in airline_a, move language to airline_y)
  call airline#parts#define_function('spell_icon', 'airline#parts#spell_icon')
  call airline#parts#define_function('spell_lang', 'airline#parts#spell_lang')
  " is defined in vimrc to extend functionality
  " call airline#parts#define_function('filetype', 'airline#parts#filetype')
  call airline#parts#define('readonly', {
        \ 'function': 'airline#parts#readonly',
        \ 'accent': 'red',
        \ })
  if get(g:, 'airline_section_c_only_filename',0)
    call airline#parts#define_raw('file', '%t')
  else
    call airline#parts#define('cwd',  {'function': 'airline#parts#cwd', 'accent': 'cwd'})
    call airline#parts#define('file', {'function': 'airline#parts#path', 'accent': 'path'})
  endif
  call airline#parts#define('linenr', {
        \ 'raw': '%{g:airline_symbols.linenr}%l',
        \ 'accent': 'bold'})
  call airline#parts#define('maxlinenr', {
        \ 'raw': '/%L%{g:airline_symbols.maxlinenr}',
        \ 'accent': 'bold'})
  call airline#parts#define('colnr', {
        \ 'raw': ':%{g:airline_symbols.colnr}%v',
        \ 'accent': 'bold'})
  call airline#parts#define_function('ffenc', 'airline#parts#ffenc')
  call airline#parts#define('hunks', {
        \ 'raw': '',
        \ 'minwidth': 100})
  call airline#parts#define('branch', {
        \ 'raw': '',
        \ 'minwidth': 80})
  call airline#parts#define('coc_status', {
        \ 'raw': '',
        \ 'accent': 'bold'
        \ })
  call airline#parts#define('coc_current_function', {
        \ 'raw': '',
        \ 'accent': 'bold'
        \ })
  call airline#parts#define('lsp_information_count', {
        \ 'raw': '',
        \ 'accent': 'lsp_information'
        \ })
  call airline#parts#define('lsp_hint_count', {
        \ 'raw': '',
        \ 'accent': 'lsp_hint'
        \ })
  call airline#parts#define('lsp_warning_count', {
        \ 'raw': '',
        \ 'accent': 'lsp_warning'
        \ })
  call airline#parts#define('lsp_error_count', {
        \ 'raw': '',
        \ 'accent': 'lsp_error'
        \ })
  call airline#parts#define('async_run_running', {'raw': '', 'accent': 'running'})
  call airline#parts#define('async_run_success', {'raw': '', 'accent': 'success'})
  call airline#parts#define('async_run_failure', {'raw': '', 'accent': 'error'})

  call airline#parts#define_empty(['obsession', 'tagbar', 'syntastic-warn',
        \ 'syntastic-err', 'eclim', 'whitespace','windowswap', 'taglist',
        \ 'ycm_error_count', 'ycm_warning_count', 'neomake_error_count',
        \ 'neomake_warning_count', 'ale_error_count', 'ale_warning_count',
        \ 'lsp_progress', 'lsp_error', 'lsp_status', 'filetype', 'scrollbar',
        \ 'nvimlsp_error_count', 'nvimlsp_warning_count',
        \ 'vim9lsp_warning_count', 'vim9lsp_error_count',
        \ 'languageclient_error_count', 'languageclient_warning_count',
        \ 'coc_warning_count', 'coc_error_count', 'vista', 'battery'])

  call airline#parts#define_text('bookmark', '')
  call airline#parts#define_text('capslock', '')
  call airline#parts#define_text('gutentags', '')
  call airline#parts#define_text('gen_tags', '')
  call airline#parts#define_text('grepper', '')
  call airline#parts#define_text('xkblayout', '')
  call airline#parts#define_text('keymap', '')
  call airline#parts#define_text('omnisharp', '')

  unlet g:airline#init#bootstrapping
endfunction

function! airline#init#sections()
  let spc = g:airline_symbols.space
  if !exists('g:airline_section_a')
    let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'keymap', 'spell_icon', 'capslock', 'xkblayout', 'iminsert'])
  endif
  if !exists('g:airline_section_b')
    let g:airline_section_b = airline#section#create(['hunks', 'branch', 'async_run_success', 'async_run_running', 'async_run_failure'])
  endif
  if !exists('g:airline_section_c')
    let g:airline_section_c = airline#section#create(['%<', 'cwd', 'file', spc, 'readonly'])
  endif
  if !exists('g:airline_section_gutter')
    let g:airline_section_gutter = airline#section#create(['%='])
  endif
  if !exists('g:airline_section_w')
    let g:airline_section_w = airline#section#create_right(['tagbar_tag', 'tagbar'])
  endif
  if !exists('g:airline_section_x')
    let g:airline_section_x = airline#section#create_right(['lsp_information_count', 'lsp_hint_count', 'lsp_warning_count', 'lsp_error_count', 'lsp_status', 'filetype'])
  endif
  if !exists('g:airline_section_y')
    let g:airline_section_y = airline#section#create_right(['ffenc', 'spell_lang'])
  endif
  if !exists('g:airline_section_z')
    if airline#util#winwidth() > 79
      let g:airline_section_z = airline#section#create(['windowswap', 'obsession', 'linenr', 'colnr', 'maxlinenr'])
    else
      let g:airline_section_z = airline#section#create(['linenr', 'colnr'])
    endif
  endif
  if !exists('g:airline_section_error')
    let g:airline_section_error = airline#section#create(['ycm_error_count', 'syntastic-err', 'eclim', 'neomake_error_count', 'ale_error_count', 'lsp_error', 'nvimlsp_error_count', 'languageclient_error_count', 'coc_error_count', 'vim9lsp_error_count'])
  endif
  if !exists('g:airline_section_warning')
    let g:airline_section_warning = airline#section#create(['ycm_warning_count',  'syntastic-warn', 'neomake_warning_count', 'ale_warning_count', 'nvimlsp_warning_count', 'languageclient_warning_count', 'whitespace', 'coc_warning_count', 'vim9lsp_warning_count'])
  endif
endfunction
