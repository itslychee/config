{
  description = "My python project";
  outputs = { nixpkgs, ...}:nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"] 
  (system: with nixpkgs.legacyPackages.${system}; {
    devShells."${system}".default = mkShell {
      # Fix library stuff
      env.LD_LIBRARY_PATH = lib.makeLibraryPath [ stdenv.cc.cc ];
      # Packages
      packages = [
        python311.withPackages(py: with py; [
          pip
          stdenv
        ])
      ];
      # Automatic venv initiation
      shellHook = ''
        if [ -d .venv ];
        then
          python -m venv .venv
        fi
        source .venv/bin/activate
      '';
    };
  }
}
