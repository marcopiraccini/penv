[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This has been strongly inspired by https://github.com/rylandg/myos . Please look at it, is a great idea!
This is differente because it assumes that everyone will customize the dockerfile with the tools actually
used. The one here is an example, but can be fullty customized.


## Description

I use different laptops, but I'd like to have the same conf that is OK for my workflow.
I could use .dotenv files, but actually while my personal laptop is on Linux I have to use a OSx laptop for work.
The idea is to use a docker container, so the dev env will be EXACTLY the same in both cases.

The tools intalled are:
- VIM
- zsh
- oh_my_zsh
- atom
- tmux

All i accessed through SSH.

## Usage
  [TODO]

### Prerequisites
  [TODO]

bash, docker, docker compose installed with last versions.
Tested in

### Setup

1. Clone the repo

    ```bash
  TODO
    ```

1. Alias the CLI or add it to your `PATH`

    ```bash
    alias myos="/path/to/myos/repo/myos.sh"
    ```

1. Modify the `Dockerfile` and `docker-compose` config to match your env.

    ```bash
    $ myos init ./somepath/
    $ ls somepath
      vim tmux zsh docker-compose.yml
    ```

1. Enter directory and create your environment

    ```bash
    TODO
    ```

1. Connect to the environment via ssh

    ```bash
    TODO
    ```


## Things to do
- x not really working on OSx
  [TODO]
