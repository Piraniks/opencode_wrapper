# Opencode Docker Wrapper

This project serves as an opencode container wrapper. 
It keeps the private files on the host system outside the opencode view.

To run it requires installation of [sysbox](https://github.com/nestybox/sysbox) docker runtime.
It's required to provide running of docker-compose capabilities within the opencode container without providing a privileged status or passing a docker socket.

[Install guide](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md#installing-sysbox)

