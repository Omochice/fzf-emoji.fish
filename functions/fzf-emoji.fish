function fzf-emoji
  # url is from b4b4r07/emoji-cli
  set --function url "https://raw.githubusercontent.com/b4b4r07/emoji-cli/master/dict/emoji.json"
  # Set source json's path
  # priority:
  #   - $XDG_CONFIG/fzf_emoji/emoji.json
  #   - $HOME/.config/fzf_emoji/emoji.json
  if test -n $XDG_CONFIG_HOME
    set --function destination $XDG_CONFIG_HOME/fzf-emoji
  else
    set --function destination $HOME/.config/fzf-emoji
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
  #   - win32yank
  if type "xsel" >/dev/null 2>&1
      set --function copy "xsel --clipboard --input"
  else if type "pbcopy" >/dev/null 2>&1
      set --function copy "pbcopy"
  else if type "win32yank" >/dev/null 2>&1
      set --function copy "win32yank"
  else
      command echo "Error `xsel` or `pbcopy` or `win32yank` is needed." 1>&2
      exit 1
  end

  set --local selected \
    (command cat $destination/emoji.json \
    | jq -r '.[] | .tags[] + ": " + .emoji + " " + ":" + .aliases[] + ":"' \
    | fzf --height=10 --with-nth=..-2)

  echo $selected | string match --regex ":\w+:" | $copy
  commandline --function repaint
end
