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
        #url = "https://raw.githubusercontent.com/lukeaurio/nixos-configs/refs/heads/main/Pictures/Desktop_Backgrounds/ForestTemple.png";
        #hash = "sha256-+OiCAgVZQ1TFhmnRs47S3aXdGqED9mlmvZ36gWx+RcI=";
        #desert
        #url = "https://raw.githubusercontent.com/lukeaurio/nixos-configs/refs/heads/main/Pictures/Desktop_Backgrounds/DesertVista.jpg";
        #hash = "sha256-lZjfYxB/8qDNK97W/4Oafo+R26eImOLe6nLvWhZb6+M=";
        #Magenta Mountain
        url = "https://raw.githubusercontent.com/lukeaurio/mnt-pocket-reform-nix/refs/heads/main/PurplePagoda.png";
        hash = "sha256-X8jg0+aS4bque6UdR4tnyXq54IZ7bhH4TUnyvY14qMk=";
      };
      polarity = "dark";

      fonts = {
        monospace = {
           package = pkgs.nerd-fonts.hasklug;
           name = "Hasklug Nerd Font Mono";
        };
        serif = config.stylix.fonts.monospace;
      	sansSerif = config.stylix.fonts.monospace;
      	emoji = config.stylix.fonts.monospace;
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
    lazynpm 
    tealdeer
    
    #Programming Frameworks
    hugo
    nodePackages.nodejs
    python312
    poetry

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
      core.editor = "nvim";
    };
  };

  programs.oh-my-posh = {
     enable = true;
     enableZshIntegration = true;
     #Based off of this https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/M365Princess.omp.json
     settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (''
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "palette": {
    "white": "#FFFFFF",
    "tan": "#CC3802",
    "teal": "#047E84",
    "plum": "#9A348E",
    "blush": "#DA627D",
    "salmon": "#FCA17D",
    "sky": "#86BBD8",
    "teal_blue": "#33658A"
  },
  "blocks": [
    {
      "alignment": "left",
      "segments": [
        {
          "type": "text",
          "style": "diamond",
          "leading_diamond": "\ue0b6",
          "foreground": "p:white",
          "background": "p:tan",
          "template": "{{ if .Env.PNPPSHOST }} \uf8c5 {{ .Env.PNPPSHOST }} {{ end }}"
        },
        {
          "type": "text",
          "style": "powerline",
          "foreground": "p:white",
          "background": "p:teal",
          "powerline_symbol": "\ue0b0",
          "template": "{{ if .Env.PNPPSSITE }} \uf2dd {{ .Env.PNPPSSITE }}{{ end }}"
        },
        {
          "type": "text",
          "style": "diamond",
          "trailing_diamond": "\ue0b4",
          "foreground": "p:white",
          "background": "p:teal",
          "template": "{{ if .Env.PNPPSSITE }}\u00A0{{ end }}"
        }
      ],
      "type": "rprompt"
    },
    {
      "alignment": "left",
      "segments": [
         {
          "background": "p:plum",
          "foreground": "p:white",
          "leading_diamond": "\ue0b6",
          "style": "diamond",
          "template": "\uf313",
          "type": "session"
        },
        {
          "background": "p:blush",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",        
          "properties": {
             "style": "fish",
             "full_length_dirs": 1,
             "dir_legth": 3
          },
          "style": "powerline",
          "template": " {{ .Path }} ",
          "type": "path"
        },
        {
          "background": "p:salmon",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "branch_icon": "",
            "fetch_status": false,
            "fetch_upstream_icon": true
          },
          "style": "powerline",
          "template": " \u279c ({{ .UpstreamIcon }}{{ .HEAD }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }}) ",
          "type": "git"
        },
        {
          "background": "p:sky",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "style": "powerline",
          "template": " \ue718 {{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}{{ .Full }} ",
          "type": "node"
        }
      ],
      "type": "prompt"
    },
    {
      "alignment": "left",
      "newline": true,
      "segments": [
        {
          "foreground": "#757575",
          "style": "plain",
          "template": "\u2514 ",
          "type": "text"
        },
        {
          "foreground": "#p:white",
          "style": "plain",
          "template": ">",
          "type": "text"
        }
      ],
      "type": "prompt"
    }
  ],
  "final_space": true,
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
       nixclean = "nix-env --delete-generations old && nix-store --gc";
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
       plugins = [ "git"
                   "dotenv"
                   "poetry"
                   "tailscale"
                   "tmux"
                   "zoxide" 
                 ];
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
             go.enable = true;
             #enableLSP = true;
             enableTreesitter = true;
          };
          viAlias = false;
          vimAlias = true;
          lsp = {
             enable = true;
          };
          startPlugins = [
             "harpoon"
             "nvim-notify"
             "render-markdown-nvim"
          ];
          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;
          assistant.copilot = {
             enable = true;
             cmp.enable = true;
             setupOpts = {
                panel = {
                   enable = true;
                   position = "right";
                };
             };
          };
          #visuals.tiny-devicons-auto-colors.enable = true;
          withNodeJs = true;
          withPython3 = true;
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

  # PackageManagement
  programs.uv = {
    enable = true;
    settings = {};
  };

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    #TERMINAL = "ghostty";
  };
}
