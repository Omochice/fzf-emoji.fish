function fzf-emoji
  # url is from b4b4r07/emoji-cli
  set -f url "https://raw.githubusercontent.com/b4b4r07/emoji-cli/master/dict/emoji.json"
  # Set source json's path
  # priority:
  #   - $XDG_CONFIG/fzf_emoji/emoji.json
  #   - $HOME/.config/fzf_emoji/emoji.json
  if test -n $XDG_CONFIG_HOME
    set -f destination $XDG_CONFIG_HOME/fzf-emoji
  else
    set -f destination $HOME/.config/fzf-emoji
  end

  # If not exist json, download it.
  # priority:
  #   - curl
  #   - wget
  if test ! -e $destination/emoji.json
      command mkdir -p $destination
      if type "curl" >/dev/null 2>&1
          command curl $url --output $destination/emoji.json
      else if type "wget" >/dev/null 2>&1
          command wget --output-document $destination/emoji.json $url
      else
          command echo "Error `curl` or `wget` is needed." 1>&2
          exit 1
      end
  end

  # Select Emoji using fzf
  # copy command priority
  #   - xsel
  #   - pbcopy
  if type "xsel" >/dev/null 2>&1
      set -f copy "xsel --clipboard --input"
  else if type "pbcopy" >/dev/null 2>&1
      set -f copy "pbcopy"
  else
      command echo "Error `xsel` or `pbcopy` is needed." 1>&2
      exit 1
  end
  command cat $destination/emoji.json | jq -r '.[]  | ":" + .aliases[] + ":" + " " + .emoji ' | fzf --height=10 | cut -d" " -f1 | $copy
  commandline -f repaint
end
