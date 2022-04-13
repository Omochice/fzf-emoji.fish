# fzf-emoji.fish

The fish plugin that choose emoji by using [fzf](https://github.com/junegunn/fzf)

## Installation

### Using [Fisher](https://github.com/jorgebucaran/fisher)

```console
$ fisher install Omochice/fzf-emoji.fish
```

The first time you run command, json file will be downloaded to `$XDG_CONFIG_HOME/fzf-emoji` or `$HOME/.config/fzf-emoji`.

## Dependencies

- `fzf`
- `jq`
- `curl` or `wget`
- `xsel` or `pbcopy`
- `cut`

After installing, write the keybinding in `$XDG_CONFIG_HOME/fish/functions/fish_user_key_bindings.fish`.

```bash
function fish_user_key_bindings
    bind \cE fzf-emoji
end
```

##  Inspirations

- https://github.com/b4b4r07/emoji-cli
    - Json of emojis is from this repo. Thanks!
- https://github.com/tosuke/emoji-cli

## License

MIT
