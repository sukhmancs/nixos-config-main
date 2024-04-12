#
# VSCode-insider
# enable and customize vscode for current user
#
{ config, lib, pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs.vscode = {
      enable = true;
      package =
      (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
        src = (builtins.fetchTarball {
          url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
          sha256 = "15ili2kmhpbbks2mba73w7pv0ba41wq45qbn4waxjx78r38kb74y"; # In the first build, an error might occur if the SHA256 value changes. Check the error message for the new SHA256 value and update it accordingly.
        });
        version = "latest";

        buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
      });
      extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
      bbenoist.nix
      jnoortheen.nix-ide
      ms-python.python
      dart-code.flutter
      mkhl.direnv
      ];
      userSettings = {
        "files.autoSave" = "on";
        "explorer.compactFolders" = false;
        "update.showReleaseNotes" = false;
        "explorer.confirmDragAndDrop" = false;
        "workbench.startupEditor" = "none";
        "update.mode" = "none";
        "security.workspace.trust.untrustedFiles" = "open";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "github.copilot.enable" = {
          "markdown" = "true";
          "plaintext" = "true";
        };
      };
      keybindings = [
        {
          key = "ctrl+c";
          command = "editor.action.clipboardCopyAction";
          when = "textInputFocus";
        }
        {
          key = "shift+enter";
          command = "jupyter.execSelectionInteractive";
          when = "editorTextFocus && isWorkspaceTrusted && jupyter.ownsSelection && !findInputFocussed && !notebookEditorFocused && !replaceInputFocussed && editorLangId == 'python'";
        }
      ];
    };
  };
}
