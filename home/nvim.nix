{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true; # required by coc
    coc = {
      enable = true;
      settings = {
        "rust-analyzer.serverPath" = "rust-analyzer";
      };
    };
    plugins = with pkgs.vimPlugins; [
      coc-clangd
      coc-json
      coc-pyright
      coc-yaml
      fzf-vim

      emmet-vim
      vim-polyglot
      nerdtree
      vim-indent-guides
      {
        plugin = vimtex;
        config = ''
          let g:latex_view_general_viewer = "zathura"
          let g:vimtex_view_method = "zathura"
          let g:tex_flavor = "latex"
        '';
      }
      {
        plugin = onedark-vim;
        config = ''
          let g:onedark_color_overrides = {
                      \ "black": {"gui": "#1c1c1c", "cterm": "235", "cterm16": "0" }
          \}

          " onedark.vim override: Don't set a background color when running in a terminal;
          " just use the terminal's background color
          " `gui` is the hex color code used in GUI mode/nvim true-color mode
          " `cterm` is the color code used in 256-color mode
          " `cterm16` is the color code used in 16-color mode
          if (has("autocmd") && !has("gui_running"))
            augroup colorset
              autocmd!
              let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
              autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
            augroup END
          endif

          set background=dark
          colorscheme onedark
          let g:airline_theme = "onedark"

          if (has("termguicolors"))
            set termguicolors
          endif
        '';
      }
    ];
    extraConfig = ''
      set nocompatible
      filetype off

      " Enable syntax highlight
      syntax on
      " Enable filetype detection for plugins and indentation options
      filetype plugin indent on
      " Force encoding to UTF-8
      set encoding=utf-8
      " Reload file when changed
      set autoread
      " Set amount of lines under and above cursor
      set scrolloff=5
      " Show command being executed
      set showcmd
      " Show current mode
      set showmode
      " Always show status line
      set laststatus=2
      " Display whitespace characters
      set list
      set listchars=tab:›\ ,eol:¬,trail:⋅
      " Indentation options
      """""""""""""""""""""""""""""
      " Length of a tab
      " Read somewhere it should always be 8
      set tabstop=8
      " Number of spaces inserted when using < or >
      set shiftwidth=4
      " Number of spaces inserted with Tab
      " -1 = same as shiftwidth
      set softtabstop=-1
      " Insert spaces instead of tabs
      set expandtab
      " When tabbing manually, use shiftwidth instead of tabstop and softtabstop
      set smarttab
      set autoindent
      nnoremap <silent> <space> za
      set foldlevel=99
      set t_Co=256
      set vb t_vb=".
      set smartcase
      set browsedir=buffer
      set tw=80
      set wrap
      set mouse=a
      set relativenumber

      set number
      set colorcolumn=80
      highlight colorcolumn ctermbg=4

      set clipboard=unnamed

      " Use tab for trigger completion with characters ahead and navigate
      " NOTE: There's always complete item selected by default, you may want to enable
      " no select by `"suggest.noselect": true` in your configuration file
      " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
      " other plugin before putting this into your config
      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

      " Make <CR> to accept selected completion item or notify coc.nvim to format
      " <C-g>u breaks current undo, please make your own choice
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction
    '';
  };
}
