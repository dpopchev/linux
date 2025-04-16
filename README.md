# linux dotfiles

Linux setup per my linking.

## Install

```bash
git clone --depth 1 https://github.com/dpopchev/linux
cd linux
bash setup_dotfiles # usage
```

## Usage

`setup_dotfiles` is a bash script that defines basic actions for linking dotfiles.

See usage by running without flags

### Make dotfile entry

Use `bash setup_dotfiles -i DOTFILENAME`, which will:

- create directory with same name, e.g. `dotfiles/DOTFILENAME`
- will create template `dotfiles/DOTFILENAME/main`

Edit the `main` by **not** altering the names of existing functions -- those are
the interface `setup_dotfiles` needs to create the links. Add other local
variables and such, or any other of the following:

- `link_together` links symbolically config file with target
- `make_path` ensures directory path exists
- `make_path_to` ensures path to file exists
- `backup` makes in place backup of existing file with appended suffix `${BACKUP_SUFFIX}`
- `restore` reverts action by renaming target with appending suffix
`${CLEANUP_SUFFIX}` and restoring the local `${BACKUP_SUFFIX}` file or doing
- `link_dotfile` backups exiting target and links it with this repo dotfile

### Comparison


#### makefile

My initial implementation was to have `Make` tracking links and a single
repository for program. That turned out rather overwhelming and I merged those
into one repo with single makefile. This also turned out a mess.

#### ansible

Looked promising and trendy, but it is overkill. Complying with directory
protocol become daunting -- in the end I just want to quickly run my commands,
not set clusters of hosts what not in a state.

#### straw

Found about the program rather late, and honestly too lazy to figure it out. On
first glance it is not offering control which configs -- it is all or nothing. I was
already too deep into writing things myself so just went ahead with that.

## License

[MIT License](https://choosealicense.com/licenses/mit/)
