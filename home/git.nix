{ pkgs, ...}:
{
  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        email = "me@brandonbenn.xyz";
        name = "Brandon Duval Benn";
      };
      core.editor = "${pkgs.helix}/bin/hx";
      status.short = true;
      pull.rebase = true;
      fetch.prune = true;
      push.default = "current";
      log.abbrevCommit = true;
      format.pretty = "oneline";
      alias = {
        wip = "!git add -A && git commit -m 'WIP'";
        lazy = ''!git add -A && git commit -m "$(git diff --name-status)"'';
        undo = "!git reset HEAD~1 --mixed";
        am = "!git commit --amend";
        sync = "!f() { git fetch --tags && git pull && git push; };f";
        c = let
          scriptPath = builtins.toFile "lazy-commit.sh" ''
          	#!/bin/sh
          	# Add all changes to staging area
          	git add .

          	# Get a list of modified, added, and deleted files
          	modified_files=$(git diff --name-only --cached --diff-filter=M | awk '{printf "%s%s", sep, $1; sep=", "}')
          	added_files=$(git diff --name-only --cached --diff-filter=A | awk '{printf "%s%s", sep, $1; sep=", "}')
          	deleted_files=$(git diff --name-only --cached --diff-filter=D | awk '{printf "%s%s", sep, $1; sep=", "}')

          	# Formulate the commit message
          	commit_message="Auto-commit:"
          	[ -n "$modified_files" ] && commit_message="$commit_message Modified files - $modified_files"
          	[ -n "$added_files" ] && commit_message=", $commit_message Added files - $added_files"
          	[ -n "$deleted_files" ] && commit_message=", $commit_message Deleted files - $deleted_files"
          	# Commit the changes
          	git commit -m "$commit_message"
          	echo "Committed changes."
          '';
          in "!sh ${scriptPath}";
      };
    };
  };
}
