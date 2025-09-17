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
    fastfetch

    # Development tools
    git
    neovim
    tmux
    screen
    lazygit
    tealdeer

    # TUI
    jellyfin-tui            
    reddit-tui

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
          "foreground": "#ffdd86",
          "style": "plain",
          "template": "{{ if .SSHSession }}{{ .UserName }}@{{ .HostName }} {{ end }}",
          "type": "session"
        },
        {
          "foreground": "#42a9ff",
          "style": "plain",
          "properties": {
             "style": "fish",
             "full_length_dirs": 1,
             "dir_legth": 3
          },
          "template": "{{ .Path }} ",
          "type": "path"
        },
        {
          "properties": {
            "branch_icon": "",
            "fetch_status": true
          },
          "style": "plain",
          "template": "git:{{ if or (.Working.Changed) (.Staging.Changed) (gt .StashCount 0) }}<#ffdd86>{{ .HEAD }}</>{{ else }}{{ .HEAD }}{{ end }}{{ if .Staging.Changed }} <#98c379>{{ .Staging.String }}</>{{ end }}{{ if .Working.Changed }} <#d16971>{{ .Working.String }}</>{{ end }}",
          "type": "git"
        }
      ],
      "type": "prompt"
    },
    {
      "alignment": "left",
      "newline": true,
      "segments": [
        {
          "foreground": "#ffdd86",
          "foreground_templates": [
            "{{ if gt .Code 0 }}#42a9ff{{ end }}"
          ],
          "properties": {
            "always_enabled": true
          },
          "style": "plain",
          "template": "> ",
          "type": "status"
        }
      ],
      "type": "prompt"
    }
  ],
  "version": 3
}
   ''));
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
       lg = "lazygit";
       nrs = "home-manager switch --flake $HOME/git_repos/mnt-pocket-reform-nix/.";
       man = "tldr";
       cat = "bat";
     };
     initContent = ''
     #source $HOME/shell_scripts/zsh_start.sh 
     if [ "$VSCODE_INJECTION" = "1" ]; then
       export EDITOR="code --wait" # or 'code-insiders' if you're using VS Code Insiders
     fi
     eval "$(ssh-agent -s)"
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
    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
       vim = {
          languages = { 
             nix.enable = true;
             python.enable = true;
             rust.enable = true;
             enableLSP = true;
             enableTreesitter = true;
          };
          viAlias = false;
          vimAlias = true;
          lsp = {
             enable = true;
          };
          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;
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
