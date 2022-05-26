# SIPTS lib-shell

 Library containing shell scripts shared among components of SIPTS.

# Usage

This library must be included as a git submodule under `lib-shell`.

If the project has been cloned into `my-project`, `lib-shell` must be cloned as a git submodule into `my-project/lib-shell`; the configuration file of `my-project` is expected to be located at `my-project/lib/config.js`.

# Docker

The default docker entrypoint script for all containers is located at `Docker/sipts_entyrpoint.sh`.
