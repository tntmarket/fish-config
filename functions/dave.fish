function dave
   set command $argv[1]
   switch $command
      case submit
         if test $argv[2]
            set description $argv[2]
            if test (git_branch_name) = master
               echo "Creating new branch... $description"
               __new_branch (__description_to_branch_name $description)
            end
            echo "Saving new work..."
            __save "$description"
         else
            if test (git_branch_name) = master
               echo "You have to provide a description!"
            else
               echo "Amending previous work..."
               __amend
            end
         end
      case yolo
         set description $argv[2]
         if __git_commit $description
            g sync
         end
      case --complete
         __dave_complete
   end
end

function __description_to_branch_name --argument-names description
   echo $description | sed -e 's/ /_/g'
end

function __new_branch --argument-names branch_name
   dev cmd "git fetch "(__canonical_remote)"; git checkout "(__canonical_remote)"/master -b $branch_name; git push origin HEAD"
   git fetch (__canonical_remote)
   git checkout (__canonical_remote)/master -b $branch_name
end

function __save --argument-names description
   if __git_commit $description
      g sync
      if dev cmd "git config branch."(git_branch_name)".reviewnumber"
         dev cmd "git push origin HEAD && review-branch --publish --change-description \"$description\""
      else
         dev cmd "git push origin HEAD && review-branch --publish"
      end
   else
   end
end

function __amend
   if __git_amend
      g sync
      dev cmd "git push origin HEAD --force && review-branch --publish"
   else
   end
end

function __git_commit --argument-names description
   dev cmd "git add -A && git config --global user.name 'Dave Lu' && git config --global user.email 'davelu@yelp.com' && git commit -m \"$description\""
end

function __git_amend
   dev cmd "git add -A && git config --global user.name 'Dave Lu' && git config --global user.email 'davelu@yelp.com' && git commit --no-edit --amend"
end

function __dave_complete
   complete -xc dave -n "__fish_use_subcommand" -a submit -d "Commit changes, and post them for review"
   complete -xc dave -n "__fish_use_subcommand" -a yolo -d "Push changes directly to master"
end

function __canonical_remote
   if test (git remote | grep canon)
      echo canon
   else
      echo origin
   end
end
