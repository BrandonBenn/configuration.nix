set positional-arguments

command :=  if os() == "linux" { "sudo nixos-rebuild" } else { "darwin-rebuild" }

alias r := rebuild
@rebuild:
	eval "{{command}} switch --flake ."

alias u := update
@update *package:
	nix flake update {{package}}

alias c := check
@check:
	nix flake check -L

alias co := commit
@commit:
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
