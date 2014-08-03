CURRENT_SESSION=${PWD##*/}

# Start up the tmux session with specific name
tmux new-session -d -s $CURRENT_SESSION

# VIM window
tmux send-keys 'vim' 'C-m'
tmux rename-window vim

# RSpec window for running tests
tmux new-window
tmux rename-window rspec

# RSpec window for running tests
tmux new-window
tmux rename-window pry
tmux send-keys 'pry' 'C-m'

# Window for running development server
#tmux new-window
#tmux rename-window server
#tmux send-keys 'mailcatcher' 'C-m'
#tmux send-keys 'rake server' 'C-m'

# Select the first window
tmux select-window -t 1

# Attach the tmux session
tmux attach -t $CURRENT_SESSION
