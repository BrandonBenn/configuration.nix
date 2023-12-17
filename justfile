set positional-arguments

command :=  if os() == "linux" { "sudo nixos-rebuild" } else { "darwin-rebuild" }

alias r := rebuild
rebuild:
	eval "{{command}} switch --flake ."

alias u := update
update argument:
	nix flake update $@

alias c := check
check:
	nix flake check -L
