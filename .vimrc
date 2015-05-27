execute pathogen#infect()

colorscheme wombat-atisu 
set nu!
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set showcmd
set ruler
set laststatus=2
set number
set showmode
set foldmethod=manual
"set cursorline guifont=Monaco:h12
"set cursorline guifont=Monospace\ 10
set guifont=Inconsolata:h14
set spell

set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_map = '<c-P>'


syntax on

nmap , $p
map <DOWN> gj
map <UP> gk

" select first spelling suggestion
imap <c-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
   if &wrap
      return "g" . a:movement
   else
      return a:movement
   endif
endfunction
onoremap <silent> <expr> j ScreenMovement("j")
onoremap <silent> <expr> k ScreenMovement("k")
onoremap <silent> <expr> 0 ScreenMovement("0")
onoremap <silent> <expr> ^ ScreenMovement("^")
onoremap <silent> <expr> $ ScreenMovement("$")
nnoremap <silent> <expr> j ScreenMovement("j")
nnoremap <silent> <expr> k ScreenMovement("k")
nnoremap <silent> <expr> 0 ScreenMovement("0")
nnoremap <silent> <expr> ^ ScreenMovement("^")
nnoremap <silent> <expr> $ ScreenMovement("$")

" bind del to the black hole register (wil not yank)
map <DEL> "_d

"cursor down/up existing lines
imap <S-Down> _<Esc>mz:set ve=all<CR>i<Down>_<Esc>my`zi<Del><Esc>:set ve=<CR>`yi<Del>
imap <S-Up> _<Esc>mz:set ve=all<CR>i<Up>_<Esc>my`zi<Del><Esc>:set ve=<CR>`yi<Del>
"cursor down with a new line
imap <S-CR> _<Esc>mz:set ve=all<CR>o<C-o>`z<Down>_<Esc>my`zi<Del><Esc>:set ve=<CR>`yi<Del>

" capitalize words
if (&tildeop)
  nmap gcw guw~l
  nmap gcW guW~l
  nmap gciw guiw~l
  nmap gciW guiW~l
  nmap gcis guis~l
  nmap gc$ gu$~l
  nmap gcgc guu~l
  nmap gcc guu~l
  vmap gc gu~l
else
  nmap gcw guw~h
  nmap gcW guW~h
  nmap gciw guiw~h
  nmap gciW guiW~h
  nmap gcis guis~h
  nmap gc$ gu$~h
  nmap gcgc guu~h
  nmap gcc guu~h
  vmap gc gu~h
endif

" ctags
" Open the definition in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Open the definition in a vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" For restore_view.vim plugin
set viewoptions=cursor,folds,slash,unix

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" buffers
:nnoremap <F6> :buffers<CR>:buffer<Space>

" save window position when switching buffers
if v:version >= 700
  au BufLeave * let b:winview = winsaveview()
  au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif

" switch between tab and previous with Ctrl-TAB
nmap <C-Tab> :b#<cr>
" does not work on xterm, use this there instead
nmap <C-w>w :b#<CR>

" hide unchanged buffer upon change instead of closing the file: disable no
" write warning
set hidden

"
" custom tex macros
augroup MyIMAPs
    au!
    au VimEnter * call IMAP('EDN', "\\begin{definition}\<CR><++>\<CR>\\end{definition}<++>", 'tex')
augroup END

"
" display partial lines when wrapping is enabled
set display=lastline

" vim-airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'
let g:airline_theme = 'zenburn'

"if &term =~ '^xtermi|screen'
      " solid underscore (4)
      let &t_SI .= "\<Esc>[4 q"
      " solid block (2)
      let &t_EI .= "\<Esc>[2 q"
      " 1 or 0 -> blinking block
      " 3 -> blinking underscore
      " Recent versions of xterm (282 or above) also support
      " 5 -> blinking vertical bar
      " 6 -> solid vertical bar
"endif

" Tagbar
nmap <F8> :TagbarToggle<CR> 

" my stupidness
:command! W w
:command! Wa wa
:command! WA wa

" NERDTree, Use F3 for toggle NERDTree
nmap <silent> <F3> :NERDTreeTabsToggle<CR>
" Automatically open NERDTree if no files are specified at command line
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" share clipboards between vim instances
if $TMUX == ''
  set clipboard+=unnamed
endif

" Color test: Save this file, then enter ':so %'
" Then enter one of following commands:
"   :VimColorTest    "(for console/terminal Vim)
"   :GvimColorTest   "(for GUI gvim)
function! VimColorTest(outfile, fgend, bgend)
  let result = []
  for fg in range(a:fgend)
    for bg in range(a:bgend)
      let kw = printf('%-7s', printf('c_%d_%d', fg, bg))
      let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
      let s = printf('syn keyword %s %s', kw, kw)
      call add(result, printf('%-32s | %s', h, s))
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
" Increase numbers in next line to see more colors.
command! VimColorTest call VimColorTest('vim-color-test.tmp', 12, 16)

function! GvimColorTest(outfile)
  let result = []
  for red in range(0, 255, 16)
    for green in range(0, 255, 16)
      for blue in range(0, 255, 16)
        let kw = printf('%-13s', printf('c_%d_%d_%d', red, green, blue))
        let fg = printf('#%02x%02x%02x', red, green, blue)
        let bg = '#fafafa'
        let h = printf('hi %s guifg=%s guibg=%s', kw, fg, bg)
        let s = printf('syn keyword %s %s', kw, kw)
        call add(result, printf('%s | %s', h, s))
      endfor
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
command! GvimColorTest call GvimColorTest('gvim-color-test.tmp')

"
" Coding: show vertical line at column 80-84 for line breaking
"
set colorcolumn=+1,+2,+3,+4,+5
highlight ColorColumn ctermbg=LightGrey guibg=grey25
set wrap
set textwidth=79
" do not reformat text
:set formatoptions+=l

" PHPDoc
source ~/.vim/autoload/php-doc.vim
inoremap <C-K> <ESC>:call PhpDocSingle()<CR>i 
nnoremap <C-K> :call PhpDocSingle()<CR> 
vnoremap <C-K> :call PhpDocRange()<CR>

" fold all multi line comments in TEX mode with zM
let g:tex_flavor='latex'
autocmd BufNewFile,BufRead *.tex
      \ set foldmethod=expr |
      \ set foldexpr=getline(v:lnum)=~'^\\s*%' 

" Cycling registers: unnamed ->q ->w ->e ->r ->t ->y
" http://vim.wikia.com/wiki/Comfortable_handling_of_registers
nnoremap <Leader>s :let @y=@t \| let @t=@r \| let @r=@e \| let @e=@w \| let @w=@q \| let @q=@"<CR> 


command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
    echo a:cmdline
    let expanded_cmdline = a:cmdline
    for part in split(a:cmdline, ' ')
        if part[0] =~ '\v[%#<]'
            let expanded_part = fnameescape(expand(part))
            let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
        endif
    endfor
    botright vnew
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    call setline(1, 'You entered:    ' . a:cmdline)
    call setline(2, 'Expanded Form:  ' .expanded_cmdline)
    call setline(3,substitute(getline(2),'.','=','g'))
    execute '$read !'. expanded_cmdline
    setlocal nomodifiable
    1
endfunction

