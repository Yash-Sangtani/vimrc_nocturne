" ============================================================================
"  GOTHAM — a minimal, VS Code-style Vim setup
"  near-black panels · grey text · one accent colour (pick it below)
"  Claude Code lives in a toggleable panel on the right.
"
"  Requires: Vim 9+ with +terminal   (check: vim --version | grep terminal)
"  Optional: brew install fzf ripgrep  ·  a Nerd Font (then set g:bat_icons=1)
" ============================================================================

set nocompatible

" ----------------------------------------------------------------------------
"  Toggles
" ----------------------------------------------------------------------------
let g:bat_accent       = 'steel' " steel · crimson · moon · violet · teal
let g:bat_icons        = 0     " 1 = file icons (needs a Nerd Font in your terminal)
let g:bat_claude_width = 0.36  " Claude panel width, fraction of the screen
let g:bat_claude_cmd   = 'claude'

let mapleader = ' '

" ----------------------------------------------------------------------------
"  Plugins — vim-plug installs itself on first launch
" ----------------------------------------------------------------------------
let s:plug = expand('~/.vim/autoload/plug.vim')
if empty(glob(s:plug))
  silent execute '!curl -fLo ' . s:plug . ' --create-dirs '
        \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'                               " explorer sidebar
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " quick open
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'                           " git change bars
Plug 'tpope/vim-commentary'                             " Ctrl+/ comments
Plug 'jiangmiao/auto-pairs'                             " auto-close brackets
if g:bat_icons
  Plug 'ryanoasis/vim-devicons'                         " must load last
endif
" Plug 'neoclide/coc.nvim', {'branch': 'release'}       " IntelliSense (needs Node)
call plug#end()

filetype plugin indent on
syntax on

" ----------------------------------------------------------------------------
"  Your settings (kept)
" ----------------------------------------------------------------------------
set number
set cursorline cursorcolumn
set shiftwidth=4 tabstop=4 expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch ignorecase smartcase hlsearch showmatch
set showcmd
set history=1000
set wildmenu wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set laststatus=2

" ----------------------------------------------------------------------------
"  Editor feel
" ----------------------------------------------------------------------------
set noshowmode                    " mode is shown in the status bar instead
set signcolumn=yes                " stable gutter for git bars
set showtabline=2                 " always show the buffer tab bar
set splitright splitbelow
set hidden
set mouse=a ttymouse=sgr          " click, scroll, drag splits
set updatetime=200
set ttimeoutlen=10
set backspace=indent,eol,start
set clipboard=unnamed             " yank to the macOS clipboard
set noswapfile undofile undodir=~/.vim/undo
silent! call mkdir(expand('~/.vim/undo'), 'p')
let &fillchars = 'vert:│,fold: ,eob: '
set shortmess+=Ic                 " no intro screen
set belloff=all

" cursor: bar in insert, underline in replace, block otherwise
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

" truecolor when the terminal supports it (iTerm2, kitty, WezTerm, Alacritty…)
" Terminal.app falls back to the 256-colour version of the same palette.
if $COLORTERM =~# 'truecolor\|24bit'
  let &t_8f = "\e[38;2;%lu;%lu;%lum"
  let &t_8b = "\e[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" ----------------------------------------------------------------------------
"  Palette   name : [ truecolor , 256-colour fallback ]
" ----------------------------------------------------------------------------
let s:p = {
  \ 'void'  : ['#0B0C0E', 232],
  \ 'panel' : ['#111316', 233],
  \ 'raise' : ['#181B1F', 234],
  \ 'line'  : ['#22262B', 235],
  \ 'edge'  : ['#2E333A', 236],
  \ 'mute'  : ['#4A5059', 239],
  \ 'ash'   : ['#6E747D', 243],
  \ 'fog'   : ['#A3A8AF', 248],
  \ 'text'  : ['#C5C9CE', 251],
  \ 'white' : ['#EEF0F2', 255],
  \ 'signal': ['#F2C230', 220],
  \ 'amber' : ['#C9A86A', 179],
  \ 'steel' : ['#8FA3B8', 103],
  \ 'ice'   : ['#B4C3D3', 152],
  \ 'blood' : ['#B5484B', 131],
  \ 'moss'  : ['#7F9C6E', 108],
  \ 'none'  : ['NONE', 'NONE'],
  \ }

"  accent presets:  accent (keywords, cursor line no., active tab, mode)
"                   second (numbers, constants, search)   string (strings, insert mode)
let s:accents = {
  \ 'steel'  : { 'signal': ['#7FA7D9', 110], 'amber': ['#B3A6CC', 146], 'string': ['#8FAE9A', 108] },
  \ 'crimson': { 'signal': ['#D0505A', 167], 'amber': ['#C9A091', 180], 'string': ['#8FA3B8', 103] },
  \ 'moon'   : { 'signal': ['#E6E8EB', 254], 'amber': ['#9AA4B0', 247], 'string': ['#7F8A96', 244] },
  \ 'violet' : { 'signal': ['#9D84D6', 140], 'amber': ['#D0A3B4', 181], 'string': ['#8FA3B8', 103] },
  \ 'teal'   : { 'signal': ['#4FB3A5',  73], 'amber': ['#C9A6A0', 181], 'string': ['#8FA3B8', 103] },
  \ }

function! s:hi(group, fg, bg, ...) abort
  let l:at = a:0 ? a:1 : 'NONE'
  execute 'highlight' a:group
        \ 'guifg='   . s:p[a:fg][0] 'guibg='   . s:p[a:bg][0]
        \ 'ctermfg=' . s:p[a:fg][1] 'ctermbg=' . s:p[a:bg][1]
        \ 'gui=' . l:at 'cterm=' . l:at
endfunction

function! s:Gotham() abort
  call extend(s:p, get(s:accents, g:bat_accent, s:accents.steel))
  highlight clear
  set background=dark
  let g:colors_name = 'gotham'

  " -- editor surface
  call s:hi('Normal',        'text',   'void')
  call s:hi('LineNr',        'mute',   'none')
  call s:hi('CursorLineNr',  'signal', 'none', 'bold')
  call s:hi('CursorLine',    'none',   'raise')
  call s:hi('CursorColumn',  'none',   'raise')
  call s:hi('ColorColumn',   'none',   'raise')
  call s:hi('SignColumn',    'none',   'none')
  call s:hi('FoldColumn',    'mute',   'none')
  call s:hi('Folded',        'ash',    'panel')
  call s:hi('VertSplit',     'line',   'none')
  call s:hi('EndOfBuffer',   'void',   'none')
  call s:hi('NonText',       'edge',   'none')
  call s:hi('SpecialKey',    'edge',   'none')
  call s:hi('Visual',        'none',   'edge')
  call s:hi('Search',        'void',   'amber')
  call s:hi('IncSearch',     'void',   'signal', 'bold')
  call s:hi('CurSearch',     'void',   'signal', 'bold')
  call s:hi('MatchParen',    'signal', 'edge',   'bold')
  call s:hi('Conceal',       'ash',    'none')
  call s:hi('Cursor',        'void',   'signal')

  " -- chrome
  call s:hi('StatusLine',       'fog',   'panel')
  call s:hi('StatusLineNC',     'mute',  'panel')
  call s:hi('StatusLineTerm',   'fog',   'panel')
  call s:hi('StatusLineTermNC', 'mute',  'panel')
  call s:hi('TabLine',          'ash',   'panel')
  call s:hi('TabLineSel',       'white', 'void')
  call s:hi('TabLineFill',      'none',  'panel')
  call s:hi('Pmenu',            'text',  'raise')
  call s:hi('PmenuSel',         'void',  'signal', 'bold')
  call s:hi('PmenuSbar',        'none',  'raise')
  call s:hi('PmenuThumb',       'none',  'mute')
  call s:hi('WildMenu',         'void',  'signal', 'bold')
  call s:hi('QuickFixLine',     'none',  'line')
  call s:hi('Directory',        'steel', 'none')
  call s:hi('Title',            'white', 'none', 'bold')
  call s:hi('ErrorMsg',         'blood', 'none', 'bold')
  call s:hi('WarningMsg',       'amber', 'none')
  call s:hi('ModeMsg',          'ash',   'none')
  call s:hi('MoreMsg',          'steel', 'none')
  call s:hi('Question',         'steel', 'none')

  " -- diff / spell
  call s:hi('DiffAdd',     'moss',  'raise')
  call s:hi('DiffChange',  'steel', 'raise')
  call s:hi('DiffDelete',  'blood', 'raise')
  call s:hi('DiffText',    'void',  'steel')
  call s:hi('SpellBad',    'blood', 'none', 'underline')
  call s:hi('SpellCap',    'amber', 'none', 'underline')
  call s:hi('SpellRare',   'steel', 'none', 'underline')
  call s:hi('SpellLocal',  'steel', 'none', 'underline')

  " -- syntax: mostly greys, yellow only for control flow
  call s:hi('Comment',      'ash',    'none', 'italic')
  call s:hi('Constant',     'amber',  'none')
  call s:hi('String',       'string', 'none')
  call s:hi('Character',    'string', 'none')
  call s:hi('Number',       'amber',  'none')
  call s:hi('Float',        'amber',  'none')
  call s:hi('Boolean',      'amber',  'none')
  call s:hi('Identifier',   'text',   'none')
  call s:hi('Function',     'white',  'none')
  call s:hi('Statement',    'signal', 'none')
  call s:hi('Conditional',  'signal', 'none')
  call s:hi('Repeat',       'signal', 'none')
  call s:hi('Keyword',      'signal', 'none')
  call s:hi('Label',        'signal', 'none')
  call s:hi('Exception',    'blood',  'none')
  call s:hi('Operator',     'fog',    'none')
  call s:hi('PreProc',      'ice',    'none')
  call s:hi('Include',      'ice',    'none')
  call s:hi('Define',       'ice',    'none')
  call s:hi('Macro',        'ice',    'none')
  call s:hi('Type',         'ice',    'none', 'italic')
  call s:hi('StorageClass', 'signal', 'none')
  call s:hi('Structure',    'ice',    'none')
  call s:hi('Typedef',      'ice',    'none')
  call s:hi('Special',      'amber',  'none')
  call s:hi('Delimiter',    'fog',    'none')
  call s:hi('Underlined',   'steel',  'none', 'underline')
  call s:hi('Todo',         'signal', 'none', 'bold')
  call s:hi('Error',        'blood',  'none', 'bold')

  " -- panels (sidebar + Claude sit one shade above the editor)
  call s:hi('BatPanel',      'text',  'panel')
  call s:hi('BatModeN',      'void',  'signal', 'bold')
  call s:hi('BatModeI',      'void',  'string', 'bold')
  call s:hi('BatModeV',      'void',  'white',  'bold')
  call s:hi('BatModeR',      'void',  'blood',  'bold')
  call s:hi('BatModeC',      'void',  'amber',  'bold')
  call s:hi('BatModeT',      'void',  'ice',    'bold')
  call s:hi('BatStatus',     'fog',   'panel')
  call s:hi('BatStatusDim',  'ash',   'panel')
  call s:hi('BatStatusNC',   'mute',  'panel')
  call s:hi('BatStatusAdd',  'moss',  'panel')
  call s:hi('BatStatusMod',  'steel', 'panel')
  call s:hi('BatStatusDel',  'blood', 'panel')
  call s:hi('BatTab',        'ash',   'panel')
  call s:hi('BatTabSel',     'white', 'void')
  call s:hi('BatTabMark',    'signal','void')
  call s:hi('BatTabMod',     'signal','panel')
  call s:hi('BatTabSelMod',  'signal','void')
  call s:hi('BatTabFill',    'none',  'panel')
  call s:hi('BatBrand',      'signal','panel', 'bold')

  " -- plugins
  call s:hi('NERDTreeDir',       'fog',    'none')
  call s:hi('NERDTreeDirSlash',  'mute',   'none')
  call s:hi('NERDTreeOpenable',  'ash',    'none')
  call s:hi('NERDTreeClosable',  'signal', 'none')
  call s:hi('NERDTreeFile',      'text',   'none')
  call s:hi('NERDTreeExecFile',  'moss',   'none')
  call s:hi('NERDTreeCWD',       'signal', 'none', 'bold')
  call s:hi('NERDTreeUp',        'mute',   'none')
  call s:hi('NERDTreeHelp',      'ash',    'none')
  call s:hi('NERDTreeFlags',     'mute',   'none')
  call s:hi('NERDTreeLinkTarget','steel',  'none')
  call s:hi('GitGutterAdd',          'moss',  'none')
  call s:hi('GitGutterChange',       'steel', 'none')
  call s:hi('GitGutterDelete',       'blood', 'none')
  call s:hi('GitGutterChangeDelete', 'amber', 'none')

  " Claude's terminal ANSI colours, tuned to the palette
  let g:terminal_ansi_colors = [
    \ '#0B0C0E', '#B5484B', '#7F9C6E', '#C9A86A', '#8FA3B8', '#A08CB0', '#8FB3B0', '#C5C9CE',
    \ '#4A5059', '#D06A6C', '#9AB889', '#D9BE8C', '#B4C3D3', '#C0AED0', '#B0D0CD', '#EEF0F2']
endfunction
call s:Gotham()

" try accents live:  :Accent crimson
function! s:AccentNames(...) abort
  return join(sort(keys(s:accents)), "\n")
endfunction
command! -nargs=1 -complete=custom,s:AccentNames Accent
      \ let g:bat_accent = <q-args> | call s:Gotham() | redraw! | echo '  accent: ' . <q-args>

" ----------------------------------------------------------------------------
"  Status bar  ▌NORMAL ▌ main  +2 ~1   file.py ●            Ln 12, Col 4  Spaces: 4  python
" ----------------------------------------------------------------------------
let s:modes = {
  \ 'n': ['NORMAL', 'BatModeN'],  'i': ['INSERT', 'BatModeI'],
  \ 'v': ['VISUAL', 'BatModeV'],  'V': ['V-LINE', 'BatModeV'],  "\<C-v>": ['V-BLOCK', 'BatModeV'],
  \ 'R': ['REPLACE', 'BatModeR'], 'c': ['COMMAND', 'BatModeC'], 't': ['TERMINAL', 'BatModeT'],
  \ 's': ['SELECT', 'BatModeV'],  'S': ['S-LINE', 'BatModeV'],
  \ }

function! s:Branch() abort
  if !exists('b:bat_branch')
    let l:dir = expand('%:p:h')
    let b:bat_branch = isdirectory(l:dir)
          \ ? trim(system('git -C ' . shellescape(l:dir) . ' branch --show-current 2>/dev/null'))
          \ : ''
    if v:shell_error | let b:bat_branch = '' | endif
  endif
  return b:bat_branch
endfunction
augroup BatBranch
  autocmd!
  autocmd BufEnter,FocusGained,ShellCmdPost * unlet! b:bat_branch
augroup END

function! BatStatus() abort
  let l:win    = g:statusline_winid
  let l:active = l:win == win_getid()
  let l:buf    = winbufnr(l:win)
  let l:ft     = getbufvar(l:buf, '&filetype')

  if l:ft ==# 'nerdtree'
    return '%#BatStatusDim#  EXPLORER'
  endif
  if l:buf == s:claude_buf
    return (l:active ? '%#BatModeN#' : '%#BatStatusDim#') . '  CLAUDE  %#BatStatusDim#  '
          \ . (l:active ? 'Ctrl-\ hide · Ctrl-h editor' : '')
  endif
  if !l:active
    return '%#BatStatusNC#  %f %m'
  endif

  let [l:name, l:grp] = get(s:modes, mode(), ['NORMAL', 'BatModeN'])
  let l:s = '%#' . l:grp . '#  ' . l:name . '  '

  let l:branch = s:Branch()
  if !empty(l:branch)
    let l:s .= '%#BatStatusDim#  ' . (g:bat_icons ? ' ' : '⎇ ') . l:branch
  endif
  if exists('*GitGutterGetHunkSummary')
    let [l:a, l:m, l:r] = GitGutterGetHunkSummary()
    let l:s .= (l:a ? '%#BatStatusAdd# +' . l:a : '')
          \ .  (l:m ? '%#BatStatusMod# ~' . l:m : '')
          \ .  (l:r ? '%#BatStatusDel# -' . l:r : '')
  endif

  let l:s .= '%#BatStatus#   %<%f%#BatTabMod#%{&modified ? " ●" : ""}%#BatStatusDim#%{&readonly ? " ro" : ""}'
  let l:s .= '%=%#BatStatusDim#Ln %l, Col %v   '
  if winwidth(l:win) >= 110
    let l:s .= (&expandtab ? 'Spaces: ' . &shiftwidth : 'Tab: ' . &tabstop) . '   '
  endif
  let l:s .= '%#BatStatus#' . (empty(&filetype) ? 'plain' : &filetype) . '  '
  return l:s
endfunction
set statusline=%!BatStatus()

" ----------------------------------------------------------------------------
"  Tab bar — open buffers, VS Code style, active one marked in yellow
" ----------------------------------------------------------------------------
let g:bat_lastbuf = -1
augroup BatTabs
  autocmd!
  autocmd BufEnter * if &buftype ==# '' && buflisted(bufnr()) | let g:bat_lastbuf = bufnr() | endif
augroup END

function! BatTabline() abort
  let l:s = '%#BatBrand#  ◆  '
  for l:b in getbufinfo({'buflisted': 1})
    if getbufvar(l:b.bufnr, '&buftype') !=# '' | continue | endif
    let l:name = empty(l:b.name) ? 'untitled' : fnamemodify(l:b.name, ':t')
    let l:name = substitute(l:name, '%', '%%', 'g')
    if g:bat_icons && exists('*WebDevIconsGetFileTypeSymbol')
      let l:name = WebDevIconsGetFileTypeSymbol(l:b.name) . ' ' . l:name
    endif
    if l:b.bufnr == g:bat_lastbuf
      let l:s .= '%#BatTabMark#▎%#BatTabSel# ' . l:name . ' '
            \ . (l:b.changed ? '%#BatTabSelMod#● ' : '  ')
    else
      let l:s .= '%#BatTab#  ' . l:name . ' '
            \ . (l:b.changed ? '%#BatTabMod#● ' : '  ')
    endif
  endfor
  return l:s . '%#BatTabFill#%='
endfunction
set tabline=%!BatTabline()

" ----------------------------------------------------------------------------
"  Explorer sidebar (NERDTree)
" ----------------------------------------------------------------------------
let g:NERDTreeMinimalUI           = 1
let g:NERDTreeShowHidden          = 1
let g:NERDTreeWinSize             = 32
let g:NERDTreeDirArrowExpandable  = '›'
let g:NERDTreeDirArrowCollapsible = '⌄'
let g:NERDTreeIgnore              = ['\.git$', '\.DS_Store$', '__pycache__', '\.pyc$']
let g:NERDTreeStatusline          = -1
let g:NERDTreeHijackNetrw         = 0

augroup BatTree
  autocmd!
  autocmd FileType nerdtree setlocal wincolor=BatPanel nocursorcolumn signcolumn=no
  " `vim .` or `vim somedir` opens with the sidebar
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && exists(':NERDTree')
        \ | execute 'NERDTree' argv()[0] | wincmd p | enew | silent! bwipeout # | execute 'cd' argv()[0] | endif
  " close Vim if only the sidebar / Claude are left
  autocmd BufEnter * if s:OnlyPanelsLeft() | confirm quitall | endif
augroup END

function! s:OnlyPanelsLeft() abort
  for l:w in range(1, winnr('$'))
    let l:b = winbufnr(l:w)
    if getbufvar(l:b, '&filetype') !=# 'nerdtree' && l:b != s:claude_buf
      return 0
    endif
  endfor
  return 1
endfunction

" ----------------------------------------------------------------------------
"  Quick open (fzf) — floating, palette-matched
" ----------------------------------------------------------------------------
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.55, 'border': 'sharp' } }
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],      'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Statement'],   'fg+':     ['fg', 'Function'],
  \ 'bg+':     ['bg', 'CursorLine'],  'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'Comment'],     'border':  ['fg', 'VertSplit'],
  \ 'prompt':  ['fg', 'Statement'],   'pointer': ['fg', 'Statement'],
  \ 'marker':  ['fg', 'Statement'],   'spinner': ['fg', 'Statement'],
  \ 'header':  ['fg', 'Comment'] }

" ----------------------------------------------------------------------------
"  Git bars
" ----------------------------------------------------------------------------
let g:gitgutter_sign_added              = '▎'
let g:gitgutter_sign_modified           = '▎'
let g:gitgutter_sign_removed            = '▁'
let g:gitgutter_sign_modified_removed   = '▎'
let g:gitgutter_sign_removed_first_line = '▔'

" ----------------------------------------------------------------------------
"  Claude Code panel
" ----------------------------------------------------------------------------
let s:claude_buf = -1

function! s:ClaudeAlive() abort
  return s:claude_buf > 0 && bufexists(s:claude_buf)
        \ && term_getstatus(s:claude_buf) =~# 'running'
endfunction

function! s:ClaudeOpenWin() abort
  botright vertical new
  execute 'vertical resize' max([50, float2nr(&columns * g:bat_claude_width)])
  setlocal winfixwidth
endfunction

function! s:ClaudeStyle() abort
  setlocal nobuflisted nonumber norelativenumber nocursorline nocursorcolumn
  setlocal signcolumn=no wincolor=BatPanel
endfunction

function! s:ClaudeToggle() abort
  let l:win = bufwinnr(s:claude_buf)
  if s:claude_buf > 0 && l:win > 0
    if winnr() == l:win
      execute l:win . 'hide'
    else
      execute l:win . 'wincmd w'
      if term_getstatus(s:claude_buf) =~# 'normal' | call feedkeys('i', 'n') | endif
    endif
    return
  endif

  if s:ClaudeAlive()
    call s:ClaudeOpenWin()
    execute 'buffer' s:claude_buf
    call s:ClaudeStyle()
    if term_getstatus(s:claude_buf) =~# 'normal' | call feedkeys('i', 'n') | endif
    return
  endif

  let l:cmd = split(g:bat_claude_cmd)[0]
  if !executable(l:cmd)
    echohl ErrorMsg | echo '  ' . l:cmd . ' not found on PATH — install Claude Code first' | echohl None
    return
  endif
  call s:ClaudeOpenWin()
  let s:claude_buf = term_start(g:bat_claude_cmd, {
        \ 'curwin': 1, 'term_name': 'claude', 'term_finish': 'close',
        \ 'cwd': getcwd(), 'norestore': 1 })
  call s:ClaudeStyle()
endfunction

" type @current/file into Claude's prompt so it reads that file
function! s:ClaudeAddFile() abort
  if &buftype !=# '' || empty(expand('%')) | return | endif
  let l:path = expand('%:.')
  if !s:ClaudeAlive() | call s:ClaudeToggle() | sleep 1500m | endif
  if !s:ClaudeAlive() | return | endif
  call term_sendkeys(s:claude_buf, '@' . l:path . ' ')
  if bufwinnr(s:claude_buf) < 0 | call s:ClaudeToggle() | endif
  execute bufwinnr(s:claude_buf) . 'wincmd w'
endfunction

command! Claude        call s:ClaudeToggle()
command! ClaudeAddFile call s:ClaudeAddFile()

" ----------------------------------------------------------------------------
"  Keys  (macOS terminals don't pass ⌘ to Vim, so Ctrl / Space stand in)
" ----------------------------------------------------------------------------
"  Ctrl-b       explorer sidebar          Ctrl-\ or Space c   Claude panel (Ctrl-\ also hides it)
"  Ctrl-p       quick open file           Space a   send current file to Claude (@file)
"  Space f      search in project (rg)    Space e   reveal current file in sidebar
"  Ctrl-/       toggle comment            Space w   save
"  Shift-h / l  previous / next tab       Space x   close tab
"  Ctrl-h/j/k/l move between panes (works from inside Claude too)
"  Esc Esc      clear search highlight

nnoremap <silent> <C-b>     :NERDTreeToggle<CR>
nnoremap <silent> <leader>e :NERDTreeFind<CR>
nnoremap <silent> <C-p>     :Files<CR>
nnoremap <silent> <leader>f :Rg<CR>
nnoremap <silent> <leader>b :Buffers<CR>

nnoremap <silent> <leader>c :Claude<CR>
nnoremap <silent> <C-\> :Claude<CR>
tnoremap <silent> <C-\> <C-w>:Claude<CR>
nnoremap <silent> <leader>a :ClaudeAddFile<CR>

nmap <C-_> gcc
xmap <C-_> gc
nmap <C-/> gcc
xmap <C-/> gc

nnoremap <silent> <S-l>     :bnext<CR>
nnoremap <silent> <S-h>     :bprevious<CR>
nnoremap <silent> <leader>x :bprevious <Bar> bdelete #<CR>
nnoremap <silent> <leader>w :write<CR>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
" Esc is left alone inside Claude (it uses Esc to interrupt).
" To scroll Claude's output: Ctrl-w N, then i to go back.
