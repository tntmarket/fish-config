function g
   if test -z $argv[1]
      git branch
      return
   end

   set command $argv[1]
   set rest_of_args $argv[2..-1]
   switch $command
      case co
         dev cmd "git co $rest_of_args"
         git co $rest_of_args

      case pull
         dev cmd "git pull"
         __sync_files

      case delete
         dev cmd "git branch -D $rest_of_args"
         git branch -D $rest_of_args
         git push -d origin $rest_of_args

      case stash
         dev cmd "git add -A; git stash"
         git add -A
         git stash

      case pop
         dev cmd "git stash pop"
         git stash pop

      case clean
         dev cmd "git reset HEAD; git checkout .; git clean -df"
         git reset HEAD
         git checkout .
         git clean -df

      # Work on a new repo
      case clone --argument-names repo_path
         dev cmd "git clone git@git.yelpcorp.com:$rest_of_args $rest_of_args"
         git clone git@git.yelpcorp.com:$rest_of_args $rest_of_args
         cd $rest_of_args
         git remote add 'dev' ssh://davelu@dev31-uswest1adevc/nail/home/davelu/pg/$rest_of_args

      # Resolve merge conflicts
      case resolve
         dev cmd "git add -A && git rebase --continue"
         git add -A
         git rebase --continue

      case sync
         git fetch dev
         git reset --hard dev/(__branch_name)

      case b
         git branch
   end
end


function __branch_name
   git rev-parse --abbrev-ref HEAD
end
