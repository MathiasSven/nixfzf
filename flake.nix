{
  description = "Search nixpkgs quickly from cli";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system}; 
      name = "nixfzf";
    in
      {
        packages.${name} = pkgs.runCommand name {
          src = ./.;
          buildInputs = [ pkgs.makeWrapper ];
        } ''
        mkdir -p $out/bin
        cp $src/${name} $out/bin
        wrapProgram $out/bin/${name} --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [ curl bat jq fzf yq-go ])};
        '';
        packages.default = self.packages.${system}.${name};
      }
    );
}
