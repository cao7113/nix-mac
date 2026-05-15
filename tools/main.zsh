tools_rc_script="${(%):-%x}"
tools_rc_dir=${tools_rc_script:A:h}

if (( ${+functions[source_dir_files]} )); then
  # DEBUG=1 DRY=1
  DEPTH=1 source_dir_files
else
  # ref dot-zsh for this function
  print -P "%F{red}Error:%f 'source_dir_files' not found. Check script: $(dot-sec script)!" >&2
fi