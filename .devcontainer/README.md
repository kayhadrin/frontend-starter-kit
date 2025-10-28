# DevContainer setup

Usable with VS Code:

- Builds a Docker container for the frontend
- Supports bash command history
- git config script
- Provides examples of useful bash aliases
- Examples of useful git aliases

More info about [Dev Containers.](https://containers.dev/)

## How to use

1. Install the `Docker for Desktop` software on your machine.
1. Install this VS Code extension: [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
1. Review the [<GIT_REPO>/.env.docker.example](../.env.docker.example) file and create a copy named `.env.docker` in the same folder. Customize it as you see fit.
1. Review the [./cli_helpers/.bash_aliases.example](./cli_helpers/.bash_aliases.example) file and create a copy named `.bash_aliases.local` in the same folder. Customize it as you see fit.
1. In VS Code, using the command palette tool (`Cmd+Shift P` usually), launch the command named `"Dev Container: open folder in container"`
1. Select the current git repo folder from your hard drive
1. The VS Code window should reload and open a workspace based on a Docker container. <br>
   Behind the scenes:
   - A new Docker image will be build (~5m)
   - VS Code extensions will be installed (you might need to install additional recommended extensions)
   - Your customised `.env.docker` file settings will be loaded in the container

1. Open a terminal within VS Code and run `yarn install && make dev`
