# Opencode Docker Wrapper

This project serves as an opencode container wrapper. 
It keeps the private files on the host system outside the opencode view.

To run it requires installation of [sysbox](https://github.com/nestybox/sysbox) docker runtime with [the installation guide](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md#installing-sysbox).
It's required to run docker compose used by the opencode container command without privileged containers or mounting a docker socket in.


### How to use?

Add the following function to your shell e.g. `~/.zshrc`:
```bash
function ow() {
	if [ "$PWD" = "$HOME" ]; then
		echo "opencode: refusing to run in the home directory. Must be used inside a project." >&2
		return 1
	fi
	docker compose -f "$HOME/opencode_wrapper/docker-compose.yml" run --build --rm opencode_wrapper opencode "$@"
}
```

This will allow you to run `ow` to run the opencode wrapper + it automatically disallows use in $HOME.