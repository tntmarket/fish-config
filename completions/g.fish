complete -r -f -c g -n '__fish_subcommand fix' -a '(__fish_git_ci_fixup)' --description 'sha'

function __fish_git_ci_fixup
    command git log --pretty=oneline --abbrev-commit '@{u}..' | \
    fzf_complete --preview 'git show {1} --color=always' --with-nth 2.. --tiebreak begin,index --no-sort | \
    cut -d ' ' -f 1
end

function __fish_subcommand
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end
