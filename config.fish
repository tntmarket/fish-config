function vi
    vim $argv
end

if status --is-login # it is a login shell
    if [ $XDG_VTNR = 1 ] # tty is 1
        exec startx -- -keeptty
    end
end

function __check_pipenv --on-variable PWD --description 'Enter pipenv'
  status --is-command-substitution; and return
  if test -e Pipfile.lock
     pipenv shell
  end
end

set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx NPM_PACKAGES '/home/dave/.npm-packages'
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes
set -g theme_display_virtualenv yes
