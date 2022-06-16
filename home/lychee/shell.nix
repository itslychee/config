{ pkgs, ...}:
let
  ignorePatterns = [
    "cd"
    "pkill"
    "neofetch"
  ];
in {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autpair.fish";
          rev = "1222311994a0730e53d8e922a759eeda815fcb62";
          sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
      {
        name = "fish_logo";
        src = pkgs.fetchFromGitHub {
          owner = "laughedelic";
          repo = "fish_logo";
          rev = "dc6a40836de8c24c62ad7c4365aa9f21292c3e6e";
          sha256 = "sha256-DZXQt0fa5LdbJ4vPZFyJf5FWB46Dbk58adpHqbiUmyY=";
        };
      }
    ];
    functions = {
      fish_prompt = {
        body = ''
          set -l PROMPT
          set -a PROMPT '['(set_color cyan)$hostname(set_color normal)
          set -a PROMPT (set_color f98cb4)(id -un)(set_color normal)']'
          set -a PROMPT (set_color -o red)(string replace ~ '~' (pwd))(set_color normal)

          set BRANCH (git branch --show-current --format="%(refname)" 2>/dev/null)
          if test "$BRANCH" != ""
            set -a PROMPT '[G:'(set_color yellow)$BRANCH(set_color normal)']'
          end

          set -a PROMPT (set_color green)'µ'(set_color normal)'> '
          echo
          echo $PROMPT
        '';
      };
      fish_greeting.body = "fish_logo";
      ls.body = "command ls --color=auto $argv";
    };
    shellInit = ''
      set -gx GPG_TTY (tty)
    '';
  };
}
