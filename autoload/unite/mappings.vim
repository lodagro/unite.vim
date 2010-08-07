"=============================================================================
" FILE: mappings.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 03 Aug 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

" Define default mappings.
function! unite#mappings#define_default_mappings()"{{{
  " Plugin keymappings"{{{
  inoremap <silent><buffer> <Plug>(unite_exit)  :<C-u>call <SID>exit()<CR>
  inoremap <expr><buffer> <Plug>(unite_delete_backward_char)  col('.') == 2 ? '' : "\<C-h>"
  inoremap <expr><buffer> <Plug>(unite_delete_backward_line)  repeat("\<C-h>", col('.')-2)
  inoremap <expr><buffer> <Plug>(unite_delete_backward_word)  col('.') == 2 ? '' : "\<C-w>"
  
  nnoremap <silent><buffer> <Plug>(unite_exit)  :<C-u>call <SID>exit()<CR>
  nnoremap <silent><buffer> <Plug>(unite_do_default_action)  :<C-u>call <SID>do_action('default')<CR>
  nnoremap <silent><buffer> <Plug>(unite_do_delete_action)  :<C-u>call <SID>do_action('d')<CR>
  nnoremap <silent><buffer> <Plug>(unite_choose_action)  :<C-u>call <SID>choose_action()<CR>
  nnoremap <silent><buffer> <Plug>(unite_insert_enter)  :<C-u>call <SID>insert_enter()<CR>
  nnoremap <silent><buffer> <Plug>(unite_insert_head)  :<C-u>call <SID>insert_head()<CR>
  nnoremap <silent><buffer> <Plug>(unite_append_enter)  :<C-u>call <SID>append_enter()<CR>
  nnoremap <silent><buffer> <Plug>(unite_append_end)  :<C-u>call <SID>append_end()<CR>
  nnoremap <silent><buffer> <Plug>(unite_toggle_mark_current_file)  :<C-u>call <SID>toggle_mark()<CR>
  "}}}
  
  if exists('g:unite_no_default_keymappings') && g:unite_no_default_keymappings
    return
  endif
  
  " Normal mode key-mappings.
  nmap <buffer> <ESC> <Plug>(unite_exit)
  nmap <buffer> i <Plug>(unite_insert_enter)
  nmap <buffer> I <Plug>(unite_insert_head)
  nmap <buffer> a <Plug>(unite_append_enter)
  nmap <buffer> A <Plug>(unite_append_end)
  nmap <buffer> q <Plug>(unite_exit)
  nmap <buffer> <CR> <Plug>(unite_do_default_action)
  nmap <buffer> d <Plug>(unite_do_delete_action)
  nmap <buffer> <Space> <Plug>(unite_toggle_mark_current_file)
  nmap <buffer> <Tab> <Plug>(unite_choose_action)

  " Insert mode key-mappings.
  inoremap <buffer> <ESC>     <ESC>j
  inoremap <buffer> <CR>      <ESC>j
  imap <buffer> <C-h>     <Plug>(unite_delete_backward_char)
  imap <buffer> <BS>     <Plug>(unite_delete_backward_char)
  imap <buffer> <C-u>     <Plug>(unite_delete_backward_line)
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_word)
endfunction"}}}

" key-mappings functions.
function! s:exit()"{{{
  call unite#quit_session()
endfunction"}}}
function! s:do_action(key)"{{{
  let l:candidates = unite#get_marked_candidates()
  if empty(l:candidates)
    if line('.') <= 2
      " Ignore.
      return
    endif

    let l:candidates = [unite#get_unite_candidates()[line('.') - 3]]
  endif
  for l:candidate in l:candidates
    let l:source = unite#available_sources(l:candidate.source)
    if has_key(l:source.key_table, a:key)
      call l:source.action_table[l:source.key_table[a:key]](l:candidate)
    endif
  endfor

  call unite#redraw()
endfunction"}}}
function! s:toggle_mark()"{{{
  if line('.') <= 2
    " Ignore.
    return
  endif
  
  let l:candidate = unite#get_unite_candidates()[line('.') - 3]
  let l:candidate.is_marked = !l:candidate.is_marked
  call unite#redraw_current_line()
  
  normal! j
endfunction"}}}
function! s:choose_action()"{{{
endfunction"}}}
function! s:insert_enter()"{{{
  startinsert
endfunction"}}}
function! s:insert_head()"{{{
  normal! 0
  normal! l
  startinsert
endfunction"}}}
function! s:append_enter()"{{{
  startinsert
  normal! l
endfunction"}}}
function! s:append_end()"{{{
  startinsert!
endfunction"}}}

" vim: foldmethod=marker
