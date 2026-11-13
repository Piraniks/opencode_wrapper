# Opencode Wrapper

This repository is a Docker wrapper that runs the opencode CLI inside a container. Its purpose is isolation: the agent works on a project directory while the private files on the host stay outside its view.

## Architecture

- Container image: the built environment that provides the toolchain the agent operates in.
- Boundary: only the project working directory is exposed to the container. The rest of the host filesystem is not visible.

## Verifying a change

Rebuild and run the wrapper against a project directory, then run the tooling audit inside the container. A change is good when the wrapper starts, the agent sees only the project directory, and the audit reports the expected toolchain.

## Conventions

- Shell scripts are the primary implementation language for wrapper behavior; keep them small and composable.
- Shared configuration belongs with the repository; per-machine overrides belong in the local overrides area and must never be committed.
