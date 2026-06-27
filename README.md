# Opencode Docker Wrapper

This project serves as an opencode container wrapper. 
It keeps the private files on the host system outside the opencode view.

To run it requires installation of [sysbox](https://github.com/nestybox/sysbox) docker runtime.
It's required to provide running of docker-compose capabilities within the opencode container without providing a privileged status or passing a docker socket.

[Install guide](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md#installing-sysbox)

### How to use?

Add the following function to your shell e.g. `~/.zshrc`:
```bash
function ow() {
	echo "$PWD $HOME"
	if [ "$PWD" = "$HOME" ]; then
		echo "opencode: refusing to run in the home directory. Must be used inside a project." >$2
		return 1
	fi
	docker compose -f "$HOME/opencode_wrapper/docker-compose.yml" run --build --rm opencode_wrapper opencode "$@"
}
```

This will allow you to run `ow` to run the opencode wrapper + it automatically disallows use in $HOME.