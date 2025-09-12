{
  description = "Nix flake for MNT Pocket Reform ARM64 device with home-manager and stylix";

  inputs = {
    # Track nixpkgs unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Stylix for system-wide theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }:
    let
      system = "aarch64-linux"; # ARM64 architecture for MNT Pocket Reform
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Home Manager configuration
      homeConfigurations = {
        # Default user configuration - can be customized
        "pocket-reform-user" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          
          modules = [
            # Enable stylix for theming
            stylix.homeManagerModules.stylix
            
            # Main home configuration
            ./home.nix
          ];
        };
      };

      # Development shell for working with this flake
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixFlakes
          git
        ];
        
        shellHook = ''
          echo "MNT Pocket Reform Nix Development Environment"
          echo "To apply home-manager configuration:"
          echo "  home-manager switch --flake .#pocket-reform-user"
        '';
      };

      # Package the configuration for easy deployment
      packages.${system} = {
        homeConfiguration = self.homeConfigurations."pocket-reform-user".activationPackage;
      };
    };
}