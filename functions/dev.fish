# function dev-new
#    ssh -A davelu@dev31-uswest1adevc -t "agenttmux2 -CC new -s "(__dev_path)""
# end
#
# function dev-attach
#    ssh -A davelu@dev31-uswest1adevc -t "agenttmux2 -CC attach -t "(__dev_path)""
# end

function dev
   if test -z $argv[1]
      ssh -At "dev31-uswest1adevc" "cd "(dev path)"; exec bash -l"
      return
   end

   set command $argv[1]
   set rest_of_args $argv[2..-1]
   switch $command
      case cmd
         ssh -A "dev31-uswest1adevc" "cd "(dev path)"; $rest_of_args"

      case tmux
         ssh -A davelu@dev31-uswest1adevc -t "agenttmux2 -CC attach"

      case path
         pwd|sed "s=$HOME/pg=~/pg="
   end
end

