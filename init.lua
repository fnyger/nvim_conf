--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)

--]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.clipboard = 'unnamedplus'

local function paste()
  return {
    vim.fn.split(vim.fn.getreg '', '\n'),
    vim.fn.getregtype '',
  }
end

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy '+',
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added via a link or github org/name. To run setup automatically, use `opts = {}`
  { 'NMAC427/guess-indent.nvim', opts = {} },
  {
    'olimorris/onedarkpro.nvim',
    priority = 1000, -- Ensure it loads first
  },

  -- somewhere in your config:

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>p', group = '[P]ersistance', mode = { 'n' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin
  -- lazy.nvim
  {
    'folke/snacks.nvim',
    lazy = false,
    keys = {
      { '<leader>t', function() Snacks.terminal.toggle() end, desc = 'Toggle Terminal' },
      { '<F4>', function() Snacks.terminal.toggle() end, desc = 'Toggle Terminal', mode = { 'n', 't' } },
      -- Top Pickers & Explorer
      { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
      { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
      { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
      { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
      -- find
      { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },
      { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
      { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
      { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
      -- git
      { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
      { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
      { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
      { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
      { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
      { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
      { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },
      -- gh
      { '<leader>gi', function() Snacks.picker.gh_issue() end, desc = 'GitHub Issues (open)' },
      { '<leader>gI', function() Snacks.picker.gh_issue { state = 'all' } end, desc = 'GitHub Issues (all)' },
      { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = 'GitHub Pull Requests (open)' },
      { '<leader>gP', function() Snacks.picker.gh_pr { state = 'all' } end, desc = 'GitHub Pull Requests (all)' },
      -- Grep
      { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
      { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
      { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
      { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
      { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
      { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
      { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands' },
      { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
      { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
      { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
      { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
      { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
      { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
      { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
      { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
      { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
      { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
      { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
      { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
      { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume' },
      { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
      { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
      -- LSP
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
      { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration' },
      { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
      { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
      { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
      { 'gai', function() Snacks.picker.lsp_incoming_calls() end, desc = 'C[a]lls Incoming' },
      { 'gao', function() Snacks.picker.lsp_outgoing_calls() end, desc = 'C[a]lls Outgoing' },
      { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
      { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
    },
    ---@type snacks.Config
    opts = {
      scroll = {
        enabled = true,
      },
      indent = { enabled = true },
      terminal = {
        win = {
          position = 'float',
          border = 'rounded',
          backdrop = false,
        },
        -- your terminal configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      picker = {
        prompt = ' ',
        sources = {},
        focus = 'input',
        show_delay = 5000,
        limit_live = 10000,
        layout = {
          cycle = true,
          --- Use the default layout or vertical if the window is too narrow
          preset = function() return vim.o.columns >= 120 and 'default' or 'vertical' end,
        },
        ---@class snacks.picker.matcher.Config
        matcher = {
          fuzzy = true, -- use fuzzy matching
          smartcase = true, -- use smartcase
          ignorecase = true, -- use ignorecase
          sort_empty = false, -- sort results when the search string is empty
          filename_bonus = true, -- give bonus for matching file names (last part of the path)
          file_pos = true, -- support patterns like `file:line:col` and `file:line`
          -- the bonusses below, possibly require string concatenation and path normalization,
          -- so this can have a performance impact for large lists and increase memory usage
          cwd_bonus = false, -- give bonus for matching files in the cwd
          frecency = false, -- frecency bonus
          history_bonus = false, -- give more weight to chronological order
        },
        sort = {
          -- default sort is by score, text length and index
          fields = { 'score:desc', '#text', 'idx' },
        },
        ui_select = true, -- replace `vim.ui.select` with the snacks picker
        ---@class snacks.picker.formatters.Config
        formatters = {
          text = {
            ft = nil, ---@type string? filetype for highlighting
          },
          file = {
            filename_first = false, -- display filename before the file path
            --- * left: truncate the beginning of the path
            --- * center: truncate the middle of the path
            --- * right: truncate the end of the path
            ---@type "left"|"center"|"right"
            truncate = 'center',
            min_width = 40, -- minimum length of the truncated path
            filename_only = false, -- only show the filename
            icon_width = 2, -- width of the icon (in characters)
            git_status_hl = true, -- use the git status highlight group for the filename
          },
          selected = {
            show_always = false, -- only show the selected column when there are multiple selections
            unselected = true, -- use the unselected icon for unselected items
          },
          severity = {
            icons = true, -- show severity icons
            level = false, -- show severity level
            ---@type "left"|"right"
            pos = 'left', -- position of the diagnostics
          },
        },
        ---@class snacks.picker.previewers.Config
        previewers = {
          diff = {
            -- fancy: Snacks fancy diff (borders, multi-column line numbers, syntax highlighting)
            -- syntax: Neovim's built-in diff syntax highlighting
            -- terminal: external command (git's pager for git commands, `cmd` for other diffs)
            style = 'fancy', ---@type "fancy"|"syntax"|"terminal"
            cmd = { 'delta' }, -- example for using `delta` as the external diff command
            ---@type vim.wo?|{} window options for the fancy diff preview window
            wo = {
              breakindent = true,
              wrap = true,
              linebreak = true,
              showbreak = '',
            },
          },
          git = {
            args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
          },
          file = {
            max_size = 1024 * 1024, -- 1MB
            max_line_length = 500, -- max line length
            ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
          },
          man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
        },
        ---@class snacks.picker.jump.Config
        jump = {
          jumplist = true, -- save the current position in the jumplist
          tagstack = false, -- save the current position in the tagstack
          reuse_win = false, -- reuse an existing window if the buffer is already open
          close = true, -- close the picker when jumping/editing to a location (defaults to true)
          match = false, -- jump to the first match position. (useful for `lines`)
        },
        toggles = {
          follow = 'f',
          hidden = 'h',
          ignored = 'i',
          modified = 'm',
          regex = { icon = 'R', value = false },
        },
        win = {
          -- input window
          input = {
            keys = {
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ['/'] = 'toggle_focus',
              ['<C-Down>'] = { 'history_forward', mode = { 'i', 'n' } },
              ['<C-Up>'] = { 'history_back', mode = { 'i', 'n' } },
              ['<C-c>'] = { 'cancel', mode = 'i' },
              ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
              ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
              ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
              ['<Esc>'] = 'cancel',
              ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
              ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
              ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
              ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
              ['<a-d>'] = { 'inspect', mode = { 'n', 'i' } },
              ['<a-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
              ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
              ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
              ['<a-r>'] = { 'toggle_regex', mode = { 'i', 'n' } },
              ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
              ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
              ['<a-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
              ['<c-a>'] = { 'select_all', mode = { 'n', 'i' } },
              ['<c-b>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['<c-d>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
              ['<c-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<c-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
              ['<c-j>'] = { 'list_down', mode = { 'i', 'n' } },
              ['<c-k>'] = { 'list_up', mode = { 'i', 'n' } },
              ['<c-n>'] = { 'list_down', mode = { 'i', 'n' } },
              ['<c-p>'] = { 'list_up', mode = { 'i', 'n' } },
              ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
              ['<c-s>'] = { 'edit_split', mode = { 'i', 'n' } },
              ['<c-t>'] = { 'tab', mode = { 'n', 'i' } },
              ['<c-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
              ['<c-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
              ['<c-r>#'] = { 'insert_alt', mode = 'i' },
              ['<c-r>%'] = { 'insert_filename', mode = 'i' },
              ['<c-r><c-a>'] = { 'insert_cWORD', mode = 'i' },
              ['<c-r><c-f>'] = { 'insert_file', mode = 'i' },
              ['<c-r><c-l>'] = { 'insert_line', mode = 'i' },
              ['<c-r><c-p>'] = { 'insert_file_full', mode = 'i' },
              ['<c-r><c-w>'] = { 'insert_cword', mode = 'i' },
              ['<c-w>H'] = 'layout_left',
              ['<c-w>J'] = 'layout_bottom',
              ['<c-w>K'] = 'layout_top',
              ['<c-w>L'] = 'layout_right',
              ['?'] = 'toggle_help_input',
              ['G'] = 'list_bottom',
              ['gg'] = 'list_top',
              ['j'] = 'list_down',
              ['k'] = 'list_up',
              ['q'] = 'cancel',
            },
            b = {
              minipairs_disable = true,
            },
          },
          -- result list window
          list = {
            keys = {
              ['/'] = 'toggle_focus',
              ['<2-LeftMouse>'] = 'confirm',
              ['<CR>'] = 'confirm',
              ['<Down>'] = 'list_down',
              ['<Esc>'] = 'cancel',
              ['<S-CR>'] = { { 'pick_win', 'jump' } },
              ['<S-Tab>'] = { 'select_and_prev', mode = { 'n', 'x' } },
              ['<Tab>'] = { 'select_and_next', mode = { 'n', 'x' } },
              ['<Up>'] = 'list_up',
              ['<a-d>'] = 'inspect',
              ['<a-f>'] = 'toggle_follow',
              ['<a-h>'] = 'toggle_hidden',
              ['<a-i>'] = 'toggle_ignored',
              ['<a-m>'] = 'toggle_maximize',
              ['<a-p>'] = 'toggle_preview',
              ['<a-w>'] = 'cycle_win',
              ['<c-a>'] = 'select_all',
              ['<c-b>'] = 'preview_scroll_up',
              ['<c-d>'] = 'list_scroll_down',
              ['<c-f>'] = 'preview_scroll_down',
              ['<c-j>'] = 'list_down',
              ['<c-k>'] = 'list_up',
              ['<c-n>'] = 'list_down',
              ['<c-p>'] = 'list_up',
              ['<c-q>'] = 'qflist',
              ['<c-g>'] = 'print_path',
              ['<c-s>'] = 'edit_split',
              ['<c-t>'] = 'tab',
              ['<c-u>'] = 'list_scroll_up',
              ['<c-v>'] = 'edit_vsplit',
              ['<c-w>H'] = 'layout_left',
              ['<c-w>J'] = 'layout_bottom',
              ['<c-w>K'] = 'layout_top',
              ['<c-w>L'] = 'layout_right',
              ['?'] = 'toggle_help_list',
              ['G'] = 'list_bottom',
              ['gg'] = 'list_top',
              ['i'] = 'focus_input',
              ['j'] = 'list_down',
              ['k'] = 'list_up',
              ['q'] = 'cancel',
              ['zb'] = 'list_scroll_bottom',
              ['zt'] = 'list_scroll_top',
              ['zz'] = 'list_scroll_center',
            },
            wo = {
              conceallevel = 2,
              concealcursor = 'nvc',
            },
          },
          -- preview window
          preview = {
            keys = {
              ['<Esc>'] = 'cancel',
              ['q'] = 'cancel',
              ['i'] = 'focus_input',
              ['<a-w>'] = 'cycle_win',
            },
          },
        },
        ---@class snacks.picker.icons
        icons = {
          files = {
            enabled = true, -- show file icons
            dir = '󰉋 ',
            dir_open = '󰝰 ',
            file = '󰈔 ',
          },
          keymaps = {
            nowait = '󰓅 ',
          },
          tree = {
            vertical = '│ ',
            middle = '├╴',
            last = '└╴',
          },
          undo = {
            saved = ' ',
          },
          ui = {
            live = '󰐰 ',
            hidden = 'h',
            ignored = 'i',
            follow = 'f',
            selected = '● ',
            unselected = '○ ',
            -- selected = " ",
          },
          git = {
            enabled = true, -- show git icons
            commit = '󰜘 ', -- used by git log
            staged = '●', -- staged changes. always overrides the type icons
            added = '',
            deleted = '',
            ignored = ' ',
            modified = '○',
            renamed = '',
            unmerged = ' ',
            untracked = '?',
          },
          diagnostics = {
            Error = ' ',
            Warn = ' ',
            Hint = ' ',
            Info = ' ',
          },
          lsp = {
            unavailable = '',
            enabled = ' ',
            disabled = ' ',
            attached = '󰖩 ',
          },
          kinds = {
            Array = ' ',
            Boolean = '󰨙 ',
            Class = ' ',
            Color = ' ',
            Control = ' ',
            Collapsed = ' ',
            Constant = '󰏿 ',
            Constructor = ' ',
            Copilot = ' ',
            Enum = ' ',
            EnumMember = ' ',
            Event = ' ',
            Field = ' ',
            File = ' ',
            Folder = ' ',
            Function = '󰊕 ',
            Interface = ' ',
            Key = ' ',
            Keyword = ' ',
            Method = '󰊕 ',
            Module = ' ',
            Namespace = '󰦮 ',
            Null = ' ',
            Number = '󰎠 ',
            Object = ' ',
            Operator = ' ',
            Package = ' ',
            Property = ' ',
            Reference = ' ',
            Snippet = '󱄽 ',
            String = ' ',
            Struct = '󰆼 ',
            Text = ' ',
            TypeParameter = ' ',
            Unit = ' ',
            Unknown = ' ',
            Value = ' ',
            Variable = '󰀫 ',
          },
        },
        ---@class snacks.picker.db.Config
        db = {
          -- path to the sqlite3 library
          -- If not set, it will try to load the library by name.
          -- On Windows it will download the library from the internet.
          sqlite3_path = nil, ---@type string?
        },
        ---@class snacks.picker.debug
        debug = {
          scores = false, -- show scores in the list
          leaks = false, -- show when pickers don't get garbage collected
          explorer = false, -- show explorer debug info
          files = false, -- show file debug info
          grep = false, -- show file debug info
          proc = false, -- show proc debug info
          extmarks = false, -- show extmarks errors
        },
      },

      dashboard = {
        width = 60,
        row = nil, -- dashboard position. nil for center
        col = nil, -- dashboard position. nil for center
        pane_gap = 4, -- empty columns between vertical panes
        autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
          -- Used by the `header` section
        },
        -- item field formatters
        formats = {
          icon = function(item)
            if item.file and item.icon == 'file' or item.icon == 'directory' then return Snacks.dashboard.icon(item.file, item.icon) end
            return { item.icon, width = 2, hl = 'icon' }
          end,
          footer = { '%s', align = 'center' },
          header = { '%s', align = 'center' },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ':~')
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ':h')
              local file = vim.fn.fnamemodify(fname, ':t')
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. '/…' .. file
              end
            end
            local dir, file = fname:match '^(.*)/(.+)$'
            return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
          end,
        },
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { section = 'startup' },
        },
      },
    },
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    lazy = false,
    keys = {
      -- load the session for the current directory
      { '<leader>ps', function() require('persistence').load() end, desc = 'load the session for the current directory' },

      -- select a session to load
      { '<leader>pS', function() require('persistence').select() end, desc = 'select a session to load' },

      -- load the last session
      { '<leader>pl', function() require('persistence').load { last = true } end, desc = 'load the last session' },

      -- stop Persistence => session won't be saved on exit
      { '<leader>pd', function() require('persistence').stop() end, desc = "stop Persistence => session won't be saved on exit" },
    },
    opts = {
      -- add any custom options here
    },
    config = function(_, opts)
      require('persistence').setup(opts)

      -- Close windows that don't restore well before saving the session
      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistenceSavePre',
        callback = function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local bt = vim.bo[buf].buftype
            if bt == 'terminal' or bt == 'help' or bt == 'nofile' then pcall(vim.api.nvim_win_close, win, true) end
          end
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistenceLoadPost',
        callback = function() vim.cmd 'Neotree reveal' end,
      })
    end,
  },
  {
    'mason-org/mason.nvim',
    ---@module 'mason.settings'
    ---@type MasonSettings
    ---@diagnostic disable-next-line: missing-fields
    opts = {},
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters = {
        stylua = {
          prepend_args = function(_, ctx)
            return {
              '--indent-width',
              tostring(vim.api.nvim_get_option_value('shiftwidth', { buf = ctx.buf })),
              '--indent-type',
              vim.api.nvim_get_option_value('expandtab', { buf = ctx.buf }) and 'Spaces' or 'Tabs',
            }
          end,
        },
        ruff_format = {
          prepend_args = { 'format', '--line-length', '100' },
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'super-tab',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          -- check if parser exists and load it
          if not vim.treesitter.language.add(language) then return end
          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          -- for more info on folds see `:help folds`
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo.foldmethod = 'expr'

          -- enables treesitter based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, { ---@diagnostic disable-line: missing-fields
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.keymap.set('n', '<leader>e', '<cmd>Neotree<CR>')
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
vim.lsp.enable { 'luals', 'pyright' }
-- Adds separator between horizontal splitz
vim.o.laststatus = 3
vim.cmd 'colorscheme onedark'
