{ pkgs, ...}:
{
  programs.starship = {
    enable = true;
    settings = {
      git_branch = {
        symbol = "  ";
      };
      format = ''
      [$directory$git_branch$git_state$git_commit$git_status](bold green)
      [❤️ $hostname](bold #ff9ad2)$character
      '';
      right_format = ''$golang$python$nix_shell'';
      character = {
        success_symbol = "➜";
        error_symbol = "➜";
      };
      git_status = {
        conflicted = "🏳 ";
        ahead = "🏎💨 ";
        behind = "😰 ";
        diverged = "😵 ";
        up_to_date = "✓ ";
        untracked = "🤷 ";
        stashed = "📦 ";
        modified = "📝 ";
        staged = "[++\($count\)](green) ";
        renamed = "👅 ";
        deleted = "🗑";
      };
      golang = {
        format = "go($version)";
      };
    };
  };
}
