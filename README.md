# Opencode Docker Wrapper

This project serves as an opencode container wrapper. 
It keeps the private files on the host system outside the opencode view.

To run it requires installation of `sysbox-runc` docker runtime.
It's required to provide running of docker-compose capabilities within the opencode container without providing a privileged status or passing a docker socket.
