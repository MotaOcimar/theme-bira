function __user_host
  if set -q SSH_CLIENT; or set -q SSH_TTY
    echo -n (set_color --bold yellow)$USER(set_color --bold red)
  else
    echo -n (set_color --bold green)$USER
  end
  echo -n @(hostname|cut -d . -f 1) (set color normal)
end

function __current_path
  echo -n (set_color --bold blue)(dirs)(set_color normal) 
end


function __git_status
  set -l editing  "🖉 "
  set -l ahead    "🡑"
  set -l behind   "🡓"
  set -l diverged "⇅ "
  set -l none     "🗸 "
  set -l untracked_files (git_untracked)

  if [ (git_branch_name) ]
    if git_is_touched; or test -n "$untracked_files"
      set git_info '🜉 '(git_branch_name)' '(git_ahead "$ahead $editing" "$behind $editing" "$diverged $editing" "$editing")      
    else
      set git_info '🜉 '(git_branch_name)' '(git_ahead "$ahead" "$behind" "$diverged" "$none")
    end

    echo -n (set_color yellow)$git_info(set_color normal) 
  end
end


function __upper_left
  echo -n (set_color white)"╭╴"(set_color normal) # Suggestion: ╭╴, ┌╴
  __user_host
  echo -n " "
  __current_path
  echo -n "  "
  __git_status
end


function __upper_right
  set -l upper_right_text (date "+%H:%M:%S")
  set -l new_position (math $COLUMNS - (expr length $upper_right_text))
  
  set_color $fish_color_autosuggestion 2> /dev/null; or set_color 555
  tput cuf $new_position; echo -n $upper_right_text
  set_color normal
  tput cub $COLUMNS
end


function fish_prompt
  set -l st $status
  if [ $st != 0 ]
    echo (set_color red --bold)'['↵ $st']'(set_color normal)
  end

  __upper_right
  __upper_left
  echo ""
  echo (set_color white)"╰>"(set_color normal) # Suggestions: ╰, └ && \$, >, ＞, ᗒ, ᐅ, ⮞, ❯, ≫, ⪧
end
