{ config, pkgs, ... }:

{
  # Home Manager configuration for MNT Pocket Reform

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "24.05";

  # Basic user information - should be customized per user
  home.username = "pocket-reform-user";
  home.homeDirectory = "/home/pocket-reform-user";

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;

  # Stylix configuration for system-wide theming
  stylix = {
    enable = true;
    
    # You can customize the base16 color scheme
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";
    
    # Set a wallpaper (optional)
    # image = ./wallpaper.jpg;
    
    # Configure target applications
    targets = {
      # Enable styling for various applications
      gtk.enable = true;
      vim.enable = true;
      tmux.enable = true;
      fish.enable = true;
      bash.enable = true;
      zsh.enable = true;
    };
  };

  # Essential command line tools
  home.packages = with pkgs; [
    # System utilities
    htop
    btop
    tree
    fd
    ripgrep
    fzf
    bat
    exa
    zoxide
    
    # Network tools
    curl
    wget
    rsync
    openssh
    
    # Development tools
    git
    vim
    neovim
    tmux
    screen
    
    # Archive tools
    unzip
    zip
    p7zip
    
    # System monitoring
    iotop
    nmon
    lsof
    psmisc
    
    # Text processing
    jq
    yq
    sed
    gawk
    
    # File management
    mc
    ranger
    
    # Hardware specific for ARM devices
    usbutils
    pciutils
    
    # Build tools that might be useful
    gnumake
    gcc
    pkg-config
  ];

  # Configure git (essential for development)
  programs.git = {
    enable = true;
    userName = "MNT Pocket Reform User";
    userEmail = "user@pocket-reform.local";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "vim";
    };
  };

  # Configure shell with useful aliases and settings
  programs.bash = {
    enable = true;
    
    shellAliases = {
      ll = "exa -la";
      la = "exa -la";
      ls = "exa";
      grep = "rg";
      find = "fd";
      cat = "bat";
      top = "btop";
    };
    
    bashrcExtra = ''
      # Custom prompt for MNT Pocket Reform
      export PS1='\[\033[01;32m\]\u@pocket-reform\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      
      # Initialize zoxide
      eval "$(zoxide init bash)"
    '';
  };

  # Configure vim with basic settings
  programs.vim = {
    enable = true;
    defaultEditor = true;
    
    extraConfig = ''
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      set smartindent
      syntax on
      set background=dark
      
      " Better search
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase
    '';
  };

  # Configure tmux for terminal multiplexing
  programs.tmux = {
    enable = true;
    
    extraConfig = ''
      # Improve colors
      set -g default-terminal "screen-256color"
      
      # Set prefix to Ctrl-a
      set -g prefix C-a
      unbind C-b
      bind C-a send-prefix
      
      # Easy config reload
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"
      
      # Mouse support
      set -g mouse on
      
      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1
    '';
  };

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
}