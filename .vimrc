
" Interface appearance
"show line numbers on the left
:set number
:set relativenumber
"highlight search strings
:set hlsearch
:setlocal foldmethod=syntax
" allows foldmethod to visually highlight and use zf to fold, and zo to open said fold
:set foldmethod=manual
"All necessary things for correct tabbing (2 spaces/tab) and auto indentation
"based on syntax
:set et
:set sw=2
"This turns off physicall wrapping. Set textwidth=80 and disable wrapmargin
" to reenable the wrapping behavior.
:set textwidth=0 wrapmargin=0
:set sts=2
:set smarttab
:set smartindent
:syntax on
:filetype indent on
:set autoindent
:set cursorline
:colorscheme torte
" set tab as 4 spaces"
:set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
":hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=DarkGray ctermfg=white guibg=darkred guifg=white
" this allows for balanced braces to be highlighted
:set showmatch
":set cursorcolumn
:nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
"Set dots infront of indentations that will automatically disappear
:set list listchars=tab:»-,trail:·,extends:»,precedes:«

"Maps space bar to spell checker (initially off)
:nnoremap <space> :set spell!<cr>
"Maps double s to inserting space in normal mode"
:nnoremap ss i<space><esc>
"highlights 3 columns after 80 characters, to let you know to end your line
:set colorcolumn=+1  " highlight three columns after 'textwidth'
:highlight ColorColumn ctermbg=darkgrey guibg=darkgrey
"enables mouse support and allows click drag to trigger visual mode
:set mouse=a
"this allows vim to show a long line as multiline visually but maintain oneline
:set wrap

" File explorer netre settings======================================================================

" Toggle Vexplore with Ctrl-E
map <silent> <C-E> :Lexplore<CR>
" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'']'"
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25


"===================================================================================================

"========================== auto closing things
" these keys require quickly inserting both"
inoremap (; (<CR>);<C-c>O
inoremap (, (<CR>),<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap [, [<CR>],<C-c>O

" These keys only require the first,"
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {<CR> {<CR>};<ESC>O
"=========================== end auto close things


"===================================================================================================================================================================================================================================================================
" statusline
" https://github.com/vim-airline/vim-airline
" https://github.com/powerline/powerline
" this one contains no plugins --https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
set laststatus=2
" Very Vanilla Powerline
function! GetMode() " {{{
    let mode = mode()
 
    if mode ==# 'v'
        let mode = "VISUAL"
    elseif mode ==# 'V'
        let mode = "V.LINE"
    elseif mode ==# ' '
        let mode = "V.BLOCK"
    elseif mode ==# 's'
        let mode = "SELECT"
    elseif mode ==# 'S'
        let mode = "S.LINE"
    elseif mode ==# ' '
        let mode = "S.BLOCK"
    elseif mode =~# '\vi'
        let mode = "INSERT"
    elseif mode =~# '\v(R|Rv)'
        let mode = "REPLACE"
    else
        " Fallback to normal mode
        let mode = "NORMAL"
    endif
 
    return mode
endfunction " }}}
function! GetFilepath() " {{{
    " Recalculate the filepath when cwd changes.
    let cwd = getcwd()
    if exists("b:Powerline_cwd") && cwd != b:Powerline_cwd
        unlet! b:Powerline_filepath
    endif
    let b:Powerline_cwd = cwd
 
    if exists('b:Powerline_filepath')
        return b:Powerline_filepath
    endif
 
    let dirsep = has('win32') && ! &shellslash ? '\' : '/'
    let filepath = expand('%:p')
 
    if empty(filepath)
        return ''
    endif
 
    let ret = ''
 
    " Display a relative path, similar to the %f statusline item
    let ret = fnamemodify(filepath, ':~:.:h') . dirsep
 
    if ret == ('.' . dirsep)
        let ret = ''
    endif
 
    let b:Powerline_filepath = ret
    return ret
endfunction " }}}
function! GetBranch(symbol) " {{{
    if exists('fugitive#statusline')
        let ret = fugitive#statusline()
    else
        let ret = ''
    endif
    let ret = substitute(ret, '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', a:symbol .' \1', 'g')
 
    return ret
endfunction " }}}
function! MyStatusline(current) " {{{
    let s = {}
    let s['n'] = '%(%(%#StatusLine1# %{&paste ? "PASTE" : ""} %)%#StatusLine2#%)%(%(%#StatusLine3# %{GetMode()} %)%#StatusLine4#%)%(%(%#StatusLine5# %{GetBranch("BR:")} %)%#StatusLine5#│%)%( %(%#StatusLine6#%{&readonly ? "RO" : ""} %)%(%#StatusLine7#%{GetFilepath()}%)%(%#StatusLine8#%t %)%(%#StatusLine6#%M %)%(%#StatusLine6#%H%W %)%#StatusLine9#%)%<%#StatusLine10#%=%(%#StatusLine11#%(%#StatusLine12# %{&fileformat} %)%)%(%#StatusLine12#│%(%#StatusLine12# %{(&fenc == "" ? &enc : &fenc)} %)%)%(%#StatusLine12#│%(%#StatusLine12# %{strlen(&ft) ? &ft : "no ft"} %)%)%(%#StatusLine9#%(%#StatusLine5# %3p%% %)%)%(%#StatusLine7#%(%#StatusLine13# LN %3l%)%(%#StatusLine14#:%-2v%) %)'
    let s['i'] = '%(%(%#StatusLine1# %{&paste ? "PASTE" : ""} %)%#StatusLine15#%)%(%(%#StatusLine16# %{GetMode()} %)%#StatusLine17#%)%(%(%#StatusLine18# %{GetBranch("BR:")} %)%#StatusLine18#│%)%( %(%#StatusLine19#%{&readonly ? "RO" : ""} %)%(%#StatusLine18#%{GetFilepath()}%)%(%#StatusLine20#%t %)%(%#StatusLine19#%M %)%(%#StatusLine19#%H%W %)%#StatusLine21#%)%<%#StatusLine22#%=%(%#StatusLine23#%(%#StatusLine24# %{&fileformat} %)%)%(%#StatusLine24#│%(%#StatusLine24# %{(&fenc == "" ? &enc : &fenc)} %)%)%(%#StatusLine24#│%(%#StatusLine24# %{strlen(&ft) ? &ft : "no ft"} %)%)%(%#StatusLine21#%(%#StatusLine18# %3p%% %)%)%(%#StatusLine18#%(%#StatusLine25# LN %3l%)%(%#StatusLine26#:%-2v%) %)'
    let s['N'] = '%(%(%#StatusLine27# %{GetBranch("BR:")} %)%#StatusLine28#%)%( %(%#StatusLine29#%{&readonly ? "RO" : ""} %)%(%#StatusLine30#%{GetFilepath()}%)%(%#StatusLine31#%t %)%(%#StatusLine29#%M %)%(%#StatusLine29#%H%W %)%#StatusLine32#%)%<%#StatusLine33#%=%(%#StatusLine28#%(%#StatusLine27# %3p%% %)%)%(%#StatusLine34#│%(%#StatusLine34# LN %3l%)%(%#StatusLine35#:%-2v%) %)'
    let s['v'] = '%(%(%#StatusLine1# %{&paste ? "PASTE" : ""} %)%#StatusLine36#%)%(%(%#StatusLine37# %{GetMode()} %)%#StatusLine38#%)%(%(%#StatusLine5# %{GetBranch("BR:")} %)%#StatusLine5#│%)%( %(%#StatusLine6#%{&readonly ? "RO" : ""} %)%(%#StatusLine7#%{GetFilepath()}%)%(%#StatusLine8#%t %)%(%#StatusLine6#%M %)%(%#StatusLine6#%H%W %)%#StatusLine9#%)%<%#StatusLine10#%=%(%#StatusLine11#%(%#StatusLine12# %{&fileformat} %)%)%(%#StatusLine12#│%(%#StatusLine12# %{(&fenc == "" ? &enc : &fenc)} %)%)%(%#StatusLine12#│%(%#StatusLine12# %{strlen(&ft) ? &ft : "no ft"} %)%)%(%#StatusLine9#%(%#StatusLine5# %3p%% %)%)%(%#StatusLine7#%(%#StatusLine13# LN %3l%)%(%#StatusLine14#:%-2v%) %)' 
    let s['s'] = '%(%(%#StatusLine1# %{&paste ? "PASTE" : ""} %)%#StatusLine39#%)%(%(%#StatusLine40# %{GetMode()} %)%#StatusLine41#%)%(%(%#StatusLine5# %{GetBranch("BR:")} %)%#StatusLine5#│%)%( %(%#StatusLine6#%{&readonly ? "RO" : ""} %)%(%#StatusLine7#%{GetFilepath()}%)%(%#StatusLine8#%t %)%(%#StatusLine6#%M %)%(%#StatusLine6#%H%W %)%#StatusLine9#%)%<%#StatusLine10#%=%(%#StatusLine11#%(%#StatusLine12# %{&fileformat} %)%)%(%#StatusLine12#│%(%#StatusLine12# %{(&fenc == "" ? &enc : &fenc)} %)%)%(%#StatusLine12#│%(%#StatusLine12# %{strlen(&ft) ? &ft : "no ft"} %)%)%(%#StatusLine9#%(%#StatusLine5# %3p%% %)%)%(%#StatusLine7#%(%#StatusLine13# LN %3l%)%(%#StatusLine14#:%-2v%) %)'
    let s['r'] = '%(%(%#StatusLine1# %{&paste ? "PASTE" : ""} %)%#StatusLine1#│%)%(%(%#StatusLine1# %{GetMode()} %)%#StatusLine42#%)%(%(%#StatusLine5# %{GetBranch("BR:")} %)%#StatusLine5#│%)%( %(%#StatusLine6#%{&readonly ? "RO" : ""} %)%(%#StatusLine7#%{GetFilepath()}%)%(%#StatusLine8#%t %)%(%#StatusLine6#%M %)%(%#StatusLine6#%H%W %)%#StatusLine9#%)%<%#StatusLine10#%=%(%#StatusLine11#%(%#StatusLine12# %{&fileformat} %)%)%(%#StatusLine12#│%(%#StatusLine12# %{(&fenc == "" ? &enc : &fenc)} %)%)%(%#StatusLine12#│%(%#StatusLine12# %{strlen(&ft) ? &ft : "no ft"} %)%)%(%#StatusLine9#%(%#StatusLine5# %3p%% %)%)%(%#StatusLine7#%(%#StatusLine13# LN %3l%)%(%#StatusLine14#:%-2v%) %)'
 
    let mode = mode()
    if ! a:current
        let mode = 'N' " Normal (non-current)
    elseif mode =~# '\v(v|V| )'
        let mode = 'v' " Visual mode
    elseif mode =~# '\v(s|S| )'
        let mode = 's' " Select mode
    elseif mode =~# '\vi'
        let mode = 'i' " Insert mode
    elseif mode =~# '\v(R|Rv)'
        let mode = 'r' " Replace mode
    else
        " Fallback to normal mode
        let mode = 'n' " Normal (current)
    endif
 
    return s[mode]
endfunction " }}}
function! ResetStatusLineColors() " {{{
    hi StatusLine1 cterm=bold ctermfg=231 ctermbg=160 gui=bold guifg=#ffffff guibg=#d70000
    hi StatusLine10 ctermfg=231 ctermbg=236 guifg=#ffffff guibg=#303030
    hi StatusLine11 ctermfg=236 ctermbg=236 guifg=#303030 guibg=#303030
    hi StatusLine12 ctermfg=247 ctermbg=236 guifg=#9e9e9e guibg=#303030
    hi StatusLine13 cterm=bold ctermfg=236 ctermbg=252 gui=bold guifg=#303030 guibg=#d0d0d0
    hi StatusLine14 ctermfg=244 ctermbg=252 guifg=#808080 guibg=#d0d0d0
    hi StatusLine15 ctermfg=160 ctermbg=231 guifg=#d70000 guibg=#ffffff
    hi StatusLine16 cterm=bold ctermfg=23 ctermbg=231 gui=bold guifg=#005f5f guibg=#ffffff
    hi StatusLine17 ctermfg=231 ctermbg=31 guifg=#ffffff guibg=#0087af
    hi StatusLine18 ctermfg=117 ctermbg=31 guifg=#87d7ff guibg=#0087af
    hi StatusLine19 cterm=bold ctermfg=196 ctermbg=31 gui=bold guifg=#ff0000 guibg=#0087af
    hi StatusLine2 ctermfg=160 ctermbg=148 guifg=#d70000 guibg=#afd700
    hi StatusLine20 cterm=bold ctermfg=231 ctermbg=31 gui=bold guifg=#ffffff guibg=#0087af
    hi StatusLine21 ctermfg=31 ctermbg=24 guifg=#0087af guibg=#005f87
    hi StatusLine22 ctermfg=231 ctermbg=24 guifg=#ffffff guibg=#005f87
    hi StatusLine23 ctermfg=24 ctermbg=24 guifg=#005f87 guibg=#005f87
    hi StatusLine24 ctermfg=117 ctermbg=24 guifg=#87d7ff guibg=#005f87
    hi StatusLine25 cterm=bold ctermfg=23 ctermbg=117 gui=bold guifg=#005f5f guibg=#87d7ff
    hi StatusLine26 ctermfg=23 ctermbg=117 guifg=#005f5f guibg=#87d7ff
    hi StatusLine27 ctermfg=240 ctermbg=235 guifg=#585858 guibg=#262626
    hi StatusLine28 ctermfg=235 ctermbg=233 guifg=#262626 guibg=#121212
    hi StatusLine29 ctermfg=88 ctermbg=233 guifg=#870000 guibg=#121212
    hi StatusLine3 cterm=bold ctermfg=22 ctermbg=148 gui=bold guifg=#005f00 guibg=#afd700
    hi StatusLine30 ctermfg=241 ctermbg=233 guifg=#626262 guibg=#121212
    hi StatusLine31 cterm=bold ctermfg=245 ctermbg=233 gui=bold guifg=#8a8a8a guibg=#121212
    hi StatusLine32 ctermfg=233 ctermbg=233 guifg=#121212 guibg=#121212
    hi StatusLine33 ctermfg=231 ctermbg=233 guifg=#ffffff guibg=#121212
    hi StatusLine34 cterm=bold ctermfg=245 ctermbg=235 gui=bold guifg=#8a8a8a guibg=#262626
    hi StatusLine35 ctermfg=241 ctermbg=235 guifg=#626262 guibg=#262626
    hi StatusLine36 ctermfg=160 ctermbg=208 guifg=#d70000 guibg=#ff8700
    hi StatusLine37 cterm=bold ctermfg=88 ctermbg=208 gui=bold guifg=#870000 guibg=#ff8700
    hi StatusLine38 ctermfg=208 ctermbg=240 guifg=#ff8700 guibg=#585858
    hi StatusLine39 ctermfg=160 ctermbg=241 guifg=#d70000 guibg=#626262
    hi StatusLine4 ctermfg=148 ctermbg=240 guifg=#afd700 guibg=#585858
    hi StatusLine40 cterm=bold ctermfg=231 ctermbg=241 gui=bold guifg=#ffffff guibg=#626262
    hi StatusLine41 ctermfg=241 ctermbg=240 guifg=#626262 guibg=#585858
    hi StatusLine42 ctermfg=160 ctermbg=240 guifg=#d70000 guibg=#585858
    hi StatusLine5 ctermfg=250 ctermbg=240 guifg=#bcbcbc guibg=#585858
    hi StatusLine6 cterm=bold ctermfg=196 ctermbg=240 gui=bold guifg=#ff0000 guibg=#585858
    hi StatusLine7 ctermfg=252 ctermbg=240 guifg=#d0d0d0 guibg=#585858
    hi StatusLine8 cterm=bold ctermfg=231 ctermbg=240 gui=bold guifg=#ffffff guibg=#585858
    hi StatusLine9 ctermfg=240 ctermbg=236 guifg=#585858 guibg=#303030
endfunction "}}}
" Autocommands {{{
    function! s:Startup()
        augroup StatuslineMain
            autocmd!
            autocmd ColorScheme * call ResetStatusLineColors()
            autocmd BufEnter,WinEnter,FileType,BufUnload,CmdWinEnter *
                        \ call setwinvar(winnr(), '&statusline',
                        \                '%!MyStatusline(1)')
            autocmd BufLeave,WinLeave,CmdWinLeave * 
                        \ call setwinvar(winnr(), '&statusline',
                        \ '%!MyStatusline(0)')
        augroup END
 
        let curwindow = winnr()
        for window in range(1, winnr('$'))
            call ResetStatusLineColors()
            call setwinvar(winnr(), '&statusline',
                        \  '%!MyStatusline('. (window == curwindow) .')')
        endfor
    endfunction
 
    augroup StatuslineStartup
        autocmd!
        autocmd VimEnter * call s:Startup()
    augroup END
" }}}
"===================================================================================================================================================================================================================================================================
"===================================================================================================================================================================================================================================================================
" load vim scripts here
:au Filetype html,xml,xsl,launch source ~/.vim/scripts/closetag.vim

"===================================================================================================================================================================================================================================================================
" ROS Specific"
autocmd BufRead,BufNewFile *.launch set filetype=xml
" ROS Specific/"


" toggle transparency
let g:transparent = "false" 
function! Toggle_transparent()
    if g:transparent == "false"
        let g:transparent = "true"
        hi Normal guibg=NONE ctermbg=NONE
    else
        let g:transparent = "false"
        hi Normal ctermbg=Black
    endif
endfunction
nnoremap tt : call Toggle_transparent()<CR>




"automatically reloads vimrc configuration without having to restart vim
augroup myvimrchooks
  au!
  autocmd bufwritepost .vimrc source ~/.vimrc
augroup END

"remaps tabbing to autocomplete menu
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
