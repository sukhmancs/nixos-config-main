let
  pre-commit = import ./default.nix;
in
  (import <nixpkgs> {}).mkShell {
    shellHook = ''
      ${pre-commit.pre-commit-check.shellHook}
    '';
    buildInputs = pre-commit.pre-commit-check.enabledPackages;
  }
