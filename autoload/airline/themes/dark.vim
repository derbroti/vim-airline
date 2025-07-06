" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Modified by Mirko Palmer (derbroti) 2022 - minor color changes
"                          (derbroti) 2024 - more  color changes
" vim: et ts=2 sts=2 sw=2 tw=80
"
scriptencoding utf-8

let g:airline#themes#dark#palette = {}

let s:airline_a_normal   = [ '' , '' ,  17 , 190, '' ]
let s:airline_b_normal   = [ '' , '' , 252 , 236, '' ]
let s:airline_c_normal   = [ '' , '' ,  28 , 234, '' ]
let s:airline_w_normal   = [ '' , '' , 255 , 234, '' ]
let s:airline_x_normal   = [ '' , '' ,  77 , 236, '' ]
let s:airline_y_normal   = [ '' , '' , 255 , 238, '' ]
let g:airline#themes#dark#palette.normal =
    \ airline#themes#generate_color_map(s:airline_a_normal, s:airline_b_normal, s:airline_c_normal, s:airline_w_normal,
    \                                   s:airline_x_normal, s:airline_y_normal, s:airline_a_normal)

let g:airline#themes#dark#palette.normal_modified = {
    \ 'airline_c': [ '', '', 92, 234, '' ], 'airline_c_path': [ '', '', 92, '234', '' ]}

let s:airline_a_insert = [ '' , '' , 17  , 45  ]
let s:airline_b_insert = [ '' , '' , 252 , 27  ]
let s:airline_c_insert = [ '' , '' , 15  , 17  ]
let g:airline#themes#dark#palette.insert = airline#themes#generate_color_map(s:airline_a_insert, s:airline_b_insert, s:airline_c_insert)

let s:airline_c_insert_modified = [ '', '', 255, 53, '' ]
let g:airline#themes#dark#palette.insert_modified = {'airline_c': s:airline_c_insert_modified, 'airline_w': s:airline_c_insert_modified}
let g:airline#themes#dark#palette.insert_paste = {'airline_a': [ s:airline_a_insert[0], '', s:airline_a_insert[2], 172, '']}

let g:airline#themes#dark#palette.terminal = airline#themes#generate_color_map(s:airline_a_insert, s:airline_b_insert, s:airline_c_insert)

let g:airline#themes#dark#palette.replace = copy(g:airline#themes#dark#palette.insert)
let g:airline#themes#dark#palette.replace.airline_a = [ s:airline_b_insert[0]   , '' , s:airline_b_insert[2] , 125     , ''     ]
let g:airline#themes#dark#palette.replace_modified = g:airline#themes#dark#palette.insert_modified

let s:airline_a_visual = [ '' , '' , 232 , 214 ]
let s:airline_b_visual = [ '' , '' , 232 , 202 ]
let s:airline_c_visual = [ '' , '' , 15  , 52  ]
let g:airline#themes#dark#palette.visual = airline#themes#generate_color_map(s:airline_a_visual, s:airline_b_visual, s:airline_c_visual)
let g:airline#themes#dark#palette.visual_modified = {'airline_c': [ '', '', 255, 53, '']}


let s:airline_a_inactive = [ '' , '' , 239 , 234 , '' ]
let s:airline_b_inactive = [ '' , '' , 239 , 235 , '' ]
let s:airline_c_inactive = [ '' , '' , 250 , 235 , '' ]
let s:airline_w_inactive = [ '' , '' , 239 , 235 , '' ]
let g:airline#themes#dark#palette.inactive = airline#themes#generate_color_map(s:airline_a_inactive, s:airline_b_inactive, s:airline_c_inactive)
let g:airline#themes#dark#palette.inactive.airline_w = s:airline_w_inactive

let s:airline_c_modified = [ '' , '' , 97 , '' , '' ]
let g:airline#themes#dark#palette.inactive_modified = {'airline_c': s:airline_c_modified, 'airline_w': s:airline_c_modified}

let s:airline_a_command = [ '' , '' ,  17  , 40 ]
let g:airline#themes#dark#palette.commandline = airline#themes#generate_color_map(s:airline_a_command, s:airline_b_normal, s:airline_c_normal)

let g:airline#themes#dark#palette.accents = {
      \ 'red':             [ '', '' , 160, '', ''],
      \ 'cwd':             [ '', '' ,  33, '', ''],
      \ 'path':            [ '', '' ,  40, '', ''],
      \ 'lsp_information': [ '', '' ,  51, '', ''],
      \ 'lsp_hint':        [ '', '' , 226, '', ''],
      \ 'lsp_warning':     [ '', '' , 208, '', ''],
      \ 'lsp_error':       [ '', '' , 160, '', ''],
      \ 'running':         [ '', '' , 222, '', ''],
      \ 'error':           [ '', '' , 160, '', 'bold'],
      \ 'success':         [ '', '' ,  40, '', 'bold'],
      \ 'tagbar':          [ '', '' , 245, '', ''],
      \ 'tagbar_tag':      [ '', '' , 252, '', 'bold'],
      \ }

for mode in keys(g:airline#themes#dark#palette)
  if mode == 'accents' | continue | endif
  let g:airline#themes#dark#palette[mode]['airline_warning'] = [ '', '', 208, 234, 'bold' ]
  let g:airline#themes#dark#palette[mode]['airline_error']   = [ '', '', 160, 234, '' ]
endfor
