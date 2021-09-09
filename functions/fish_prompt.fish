# Theme based on Bira theme from oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/bira.zsh-theme
# Some code stolen from oh-my-fish clearance theme: https://github.com/bpinto/oh-my-fish/blob/master/themes/clearance/

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
  echo -n (set_color --bold blue)(dirs) (set_color normal) 
end

function __git_status
  set -l touched  "🖉 "
  set -l ahead    "🡑"
  set -l behind   "🡓"
  set -l diverged "⇅"
  set -l none     "🗸"

  if [ (git_branch_name) ]
    if git_is_touched
      set git_info '⎇ ['(git_branch_name)']'$touched
    else
      set git_info '⎇ ['(git_branch_name)']'(git_ahead $ahead $behind $diverged $none)
    end

    echo -n (set_color yellow)$git_info(set_color normal) 
  end
end

function fish_prompt
  set -l st $status
  
  if [ $st != 0 ];
    echo (set_color red --bold)'['↵ $st']'(set_color normal)
  end
  echo -n (set_color white)"╭─["(set_color normal)
  __user_host
  echo -n (set_color normal)"] "
  __current_path
  __git_status
  echo -e ''
  echo (set_color white)"╰─"(set_color --bold white)"\$ "(set_color normal)
end
