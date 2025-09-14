{ config, pkgs, nixgl, ... }:

{
  # Home Manager configuration for MNT Pocket Reform

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "25.05";

  # Basic user information - should be customized per user
  home.username = "willberto";
  home.homeDirectory = "/home/willberto";

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;

  #Add Graphics Libs Needed for Running Cool stuff
  #nixGL = {
  #   packages = import nixgl { inherit pkgs; };
  #   defaultWrapper = "vulkan";
  #   installScripts = [ "vulkan" ];
  #};

  # Stylix configuration for system-wide theming
  stylix = {
      enable = true;
      autoEnable = true;
      image = pkgs.fetchurl {
        #Forest
        url = "https://raw.githubusercontent.com/lukeaurio/nixos-configs/refs/heads/main/Pictures/Desktop_Backgrounds/ForestTemple.png";
        hash = "sha256-+OiCAgVZQ1TFhmnRs47S3aXdGqED9mlmvZ36gWx+RcI=";
        #desert
        #url = "https://raw.githubusercontent.com/lukeaurio/nixos-configs/refs/heads/main/Pictures/Desktop_Backgrounds/DesertVista.jpg";
        #hash = "sha256-lZjfYxB/8qDNK97W/4Oafo+R26eImOLe6nLvWhZb6+M=";
      };
      polarity = "dark";

      #fonts = {
      #  monospace = {
      #     package = pkgs.nerd-fonts.jetbrains-mono;
      #     name = "JetBrains Nerd Font Mono";
      #  };
      #  serif = config.stylix.fonts.monospace;
      #	sansSerif = config.stylix.fonts.monospace;
      #	emoji = config.stylix.fonts.monospace;
      #};
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
    zoxide
    
    # Network tools
    curl
    wget
    rsync
    openssh
    tailscale
    fastfetch

    # Development tools
    git
    neovim
    tmux
    screen
    lazygit
    tealdeer

    # System monitoring
    iotop
    nmon
    lsof
    psmisc
    
    # Text processing
    jq
    yq
    
    # File management
    mc
    ranger
    
    # Hardware specific for ARM devices
    usbutils
    pciutils
  ];

  # Configure git (essential for development)
  
  programs.keychain = {
    enable = true;
    #agents = [ "ssh" ];
    keys = [ "id_ed25519" ];
    extraFlags = [
      "--quiet" 
      "--ssh-allow-forwarded"
    ];
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName  = "Lukas Aurio";
    userEmail = "lukeaurio@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nano";
    };
  };

  programs.oh-my-posh = {
     enable = true;
     enableZshIntegration = true;
     settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (''
    {
      "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
      "blocks": [
        {
          "alignment": "left",
          "segments": [
            {
              "background": "#18354c",
              "foreground": "#ffc107",
              "leading_diamond": "\ue0b6",
              "properties": {
                "style": "fish",
                "full_length_dirs": 1,
                "dir_legth": 3
              },
              "style": "diamond",
              "template": " \ue5ff {{ .Path }} ",
              "trailing_diamond": "\ue0b0",
              "type": "path"
            },
            {
              "background": "#18354c",
              "foreground": "#ffc107",
              "powerline_symbol": "\ue0b0",
              "properties": {
                "fetch_upstream_icon": true
              },
              "style": "powerline",
              "template": " {{ .UpstreamIcon }}{{ .HEAD }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }} ",
              "type": "git"
            },
            {
              "background": "#ffc107",
              "foreground": "#18354c",
              "powerline_symbol": "\ue0b0",
              "style": "powerline",
              "template": " \ue235 {{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ end }}{{ .Full }}{{ end }} ",
              "type": "python"
            },
            {
              "background": "#ffc107",
              "foreground": "#18354c",
              "powerline_symbol": "\ue0b0",
              "style": "powerline",
              "template": " \uf0e7 ",
              "type": "root"
            }
          ],
          "type": "prompt"
        }
      ],
      "final_space": true,
      "version": 3
    }''));
  };


  #Configure usefull shell aliases
  programs.zsh = {
     enable = true;
     enableCompletion = true;
     syntaxHighlighting.enable = true;

     shellAliases = {
       update = "sudo nixos-rebuild switch";
       ".." = "cd ..";
       "..." = "cd ../..";
       "...." = "cd ../../..";
       ls = "tree -L 1";
       l = "ls -lh";
       la = "ls -lAh";
       ll = "ls -lah";
       #nixgit = "git --git-dir=$HOME/.nixos-config/ --work-tree=$HOME";
       #lazynix = "lazygit --git-dir=$HOME/.nixos-config/ --work-tree=$HOME";
       ghostcuts = "ghostty +list-keybinds --default";
       nrs = "home-manager switch --flake $HOME/git_repos/mnt-pocket-reform-nix/.";
       man = "tldr";
       cat = "bat";
     };
     initContent = ''
     #source $HOME/shell_scripts/zsh_start.sh 
     if [ "$VSCODE_INJECTION" = "1" ]; then
       export EDITOR="code --wait" # or 'code-insiders' if you're using VS Code Insiders
     fi
     ''; #https://mynixos.com/home-manager/option/programs.zsh.initContent
     oh-my-zsh = { # "ohMyZsh" without Home Manager
       enable = true;
       plugins = [ "git" "terraform" "zoxide"  ];
       theme = "robbyrussell";
     };
     history.size = 10000;
  };
  

  # Configure vim with basic settings
  programs.nvf = {
    enable = true;
    enableManpages = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
      };
    };
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
    #TERMINAL = "ghostty";
  };
}
