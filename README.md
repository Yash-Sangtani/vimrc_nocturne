# nocturne

A minimal, dark Vim setup laid out like VS Code: explorer on the left, editor in the middle, **Claude Code** in a panel on the right. One file. No logos, no noise, just near-black panels, grey text and a single accent colour.

![Nocturne vim: explorer, editor, Claude Code panel](screenshots/preview.png)

---

## Features

| | |
|---|---|
| **One-file config** | Everything lives in `vimrc`. The plugin manager installs itself on first launch. |
| **Built-in colour scheme** | A hand-tuned palette with 5 switchable accents. Uses truecolor where the terminal supports it and falls back to 256 colours. |
| **VS Code layout** | Explorer sidebar, buffer tab bar, and a status bar showing mode, git branch and changes, `Ln/Col`, indent and filetype |
| **Claude Code panel** | `claude` runs in a right-side split that you toggle with one key. You can also send the current file to it as an `@file` mention. |
| **Quick open & search** | `Ctrl-p` to find files, `Space f` to search across the project (fzf + ripgrep) |
| **Git gutter** | Thin bars beside the line numbers for added, changed and deleted lines |
| **Editing helpers** | Comment toggling, auto-closing brackets, undo history that persists, system clipboard |

---

## Requirements

- **Vim 9+ with `+terminal`**. Check with `vim --version | grep terminal`. If it shows `-terminal`, run `brew install vim`.
- **git** and **curl** (used for the first-run plugin install)
- **[Claude Code](https://docs.claude.com/en/docs/claude-code)** with `claude` on your `PATH`, for the side panel
- Recommended: `brew install fzf ripgrep`
- Optional: a [Nerd Font](https://www.nerdfonts.com/), for file icons

**Terminal:** iTerm2, kitty, WezTerm, Alacritty and Ghostty show the exact truecolor palette. Terminal.app uses the 256-colour fallback automatically.

---

## Install

```bash
# 1. back up your current config
cp ~/.vimrc ~/.vimrc.bak 2>/dev/null

# 2. clone and link
git clone https://github.com/<your-username>/nocturne-vim.git ~/nocturne-vim
ln -sf ~/nocturne-vim/vimrc ~/.vimrc

# 3. tools for quick open / search
brew install fzf ripgrep

# 4. launch — plugins install automatically, then the config reloads
vim
```

Because `~/.vimrc` is a link to the repo, pulling new changes updates your setup: run `cd ~/nocturne-vim && git pull`.

---

## Keybindings

The leader key is **`Space`**, so `Space c` means press Space, then c.

> macOS terminals don't pass `⌘` through to Vim, so `Ctrl` and `Space` take the place of VS Code's `⌘` shortcuts.

### Panels

| Key | Action |
|---|---|
| `Ctrl-b` | Show or hide the explorer sidebar |
| `Space e` | Show the current file in the sidebar |
| `Ctrl-\` | Show or hide the Claude panel. Works from inside Claude too. |
| `Space c` | Open the Claude panel, or jump to it if it's already open |
| `Space a` | Send the current file to Claude (types `@path/to/file` into its prompt) |
| `Ctrl-h` `Ctrl-j` `Ctrl-k` `Ctrl-l` | Move to the pane on the left, below, above or right. Works inside Claude too. |

### Files & tabs

| Key | Action |
|---|---|
| `Ctrl-p` | Quick open: find a file by name |
| `Space f` | Search text across the project (ripgrep) |
| `Space b` | Pick from open buffers |
| `Shift-l` / `Shift-h` | Next / previous tab |
| `Space x` | Close the current tab without closing the window |
| `Space w` | Save |

### Editing

| Key | Action |
|---|---|
| `Ctrl-/` | Comment or uncomment the line, or the selection in visual mode |
| `Esc Esc` | Clear search highlighting |
| `(` `[` `{` `"` `'` | Closing pair added automatically |

### Explorer sidebar (NERDTree)

| Key | Action |
|---|---|
| `Enter` / `o` | Open a file, or expand/collapse a folder |
| `s` / `i` | Open in a side-by-side / stacked split |
| `t` | Open in a new tab page |
| `m` | File menu: add, move, delete, copy |
| `I` | Show or hide hidden files |
| `R` | Refresh the tree |
| `C` | Make the folder under the cursor the tree root |
| `u` | Move the tree root up one folder |
| `A` | Zoom the sidebar to full width (press again to restore) |
| `?` | Full help |

### Inside the Claude panel

| Key | Action |
|---|---|
| *type normally* | Talk to Claude Code |
| `Esc` | Passed to Claude, which uses it to interrupt. It does **not** leave the panel. |
| `Ctrl-h` | Back to the editor |
| `Ctrl-\` | Hide the panel. Claude keeps running and comes back where you left it. |
| `Ctrl-w N` | Scroll mode, for reading back through output. Press `i` to return to typing. |

Claude starts in Vim's current working directory. Exiting Claude (`/exit`) closes the panel, and the next toggle starts a new session.

---

## Commands

| Command | Action |
|---|---|
| `:Claude` | Toggle the Claude panel (same as `Ctrl-\`) |
| `:ClaudeAddFile` | Send the current file to Claude (same as `Space a`) |
| `:Accent <name>` | Switch the accent colour live. Tab completes the names. |
| `:Files` / `:Rg` / `:Buffers` | fzf pickers |
| `:PlugUpdate` | Update plugins |
| `:PlugClean` | Remove plugins you've deleted from the list |

---

## Accent colours

![Accent options](screenshots/accents.png)

| Accent | Feel |
|---|---|
| `steel` *(default)* | Cold blue night, sage-green strings |
| `crimson` | Muted red, clay-coloured numbers |
| `moon` | All greys, white highlights only |
| `violet` | Soft purple, rose-coloured numbers |
| `teal` | Green-blue, blush-coloured numbers |

Try one live with `:Accent crimson`. To keep it, edit the top of `vimrc`:

```vim
let g:noc_accent = 'moon'
```

The accent colours keywords, the current line number, the active tab, the NORMAL mode label and search matches. Everything else stays greyscale.

---

## Configuration

All options are at the top of `vimrc`:

```vim
let g:noc_accent       = 'steel'   " steel · crimson · moon · violet · teal
let g:noc_icons        = 0         " 1 = file icons (requires a Nerd Font)
let g:noc_claude_width = 0.36      " Claude panel width as a fraction of the screen
let g:noc_claude_cmd   = 'claude'  " command run in the panel, e.g. 'claude --continue'
```

### Optional: VS Code-style autocomplete

`coc.nvim` is included but commented out because it needs Node.js. To enable it:

```vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```

Remove the leading `"` from that line, restart Vim, run `:PlugInstall`, then add language servers, e.g. `:CocInstall coc-pyright coc-tsserver`.

---

## Plugins

| Plugin | Role |
|---|---|
| [vim-plug](https://github.com/junegunn/vim-plug) | Plugin manager (installs itself) |
| [nerdtree](https://github.com/preservim/nerdtree) | Explorer sidebar |
| [fzf](https://github.com/junegunn/fzf) + [fzf.vim](https://github.com/junegunn/fzf.vim) | Quick open, project search |
| [vim-gitgutter](https://github.com/airblade/vim-gitgutter) | Git change bars |
| [vim-commentary](https://github.com/tpope/vim-commentary) | Comment toggling |
| [auto-pairs](https://github.com/jiangmiao/auto-pairs) | Auto-close brackets and quotes |
| [vim-devicons](https://github.com/ryanoasis/vim-devicons) | File icons (only when `g:noc_icons = 1`) |

The colour scheme, status bar, tab bar and Claude panel are written directly in `vimrc` and don't depend on any plugin.

---

## Editor defaults

Line numbers, cursor line and column highlight, 4-space indentation, no line wrapping, `scrolloff=10`, case-smart incremental search, a 1000-line command history, persistent undo (`~/.vim/undo`), no swap files, mouse support, system clipboard, a bar cursor in insert mode, and splits that open right and below.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Claude panel won't open (`E117: term_start`) | Your Vim was built without terminal support (`-terminal`). Run `brew install vim`, then `hash -r`. |
| "claude not found on PATH" | Install Claude Code, check that `which claude` works in the same shell, then restart Vim |
| Colours look flat or wrong | Use a truecolor terminal (iTerm2, kitty, WezTerm…) or set `COLORTERM=truecolor` if yours supports it |
| Boxes or `?` instead of icons | Set `g:noc_icons = 0`, or install a Nerd Font and select it in your terminal |
| `Ctrl-p` / `Space f` do nothing | `brew install fzf ripgrep` |
| Yank doesn't reach the macOS clipboard | Needs a Vim built with `+clipboard`. Homebrew's Vim has it. |
| `Ctrl-/` doesn't comment | Some terminals don't send it. Use `gcc` (line) or `gc` (selection) instead. |
| Plugins missing after the first launch | Run `:PlugInstall` manually |

---

## Uninstall

```bash
rm ~/.vimrc && mv ~/.vimrc.bak ~/.vimrc
rm -rf ~/.vim/plugged ~/.vim/autoload/plug.vim
```
