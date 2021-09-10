function __user_host
  set -l content 
  if [ (id -u) = "0" ];
    echo -n (set_color --bold red)
  else
    echo -n (set_color --bold green)
  end
  echo -n $USER@(hostname|cut -d . -f 1) (set color normal)
end

function __current_path
  echo -n (set_color --bold blue)(dirs)(set_color normal) 
end


function __git_status
  set -l touched  "🖉 "
  set -l ahead    "🡑"
  set -l behind   "🡓"
  set -l diverged "⇅"
  set -l none     "🗸 "

  if [ (git_branch_name) ]
    if git_is_touched
      set git_info '🜉 '(git_branch_name)' '$touched
    else
      set git_info '🜉 '(git_branch_name)' '(git_ahead $ahead $behind $diverged $none)
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
end


function fish_prompt
  set -l st $status
  if [ $st != 0 ]
    echo (set_color red --bold)'['↵ $st']'(set_color normal)
  end

  tput sc # Save the cursor position
  __upper_right
  tput rc # Restore the cursor position
  __upper_left
  echo ""
  echo (set_color white)"╰> "(set_color normal) # Suggestions: ╰, └ && \$, >, ᗒ, ᐅ, ⮞, ❯
end
