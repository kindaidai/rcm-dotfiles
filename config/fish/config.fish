
set -g theme_display_git_master_branch yes
# ruby version
set -g theme_display_ruby yes
set -g theme_display_user yes

# ssh-agent
# https://gist.github.com/gerbsen/5fd8aa0fde87ac7a2cae
# content has to be in .config/fish/config.fish
# if it does not exist, create the file
setenv SSH_ENV $HOME/.ssh/environment

function start_agent
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    ssh-add -K ~/.ssh/github_rsa
    ssh-add -K ~/.ssh/id_rsa_mhack_default
end

function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add -K ~/.ssh/github_rsa
        ssh-add -K ~/.ssh/id_rsa_mhack_default
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ]
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else
        start_agent
    end
end

# anyenv path
set -x PATH $HOME/.anyenv/bin $PATH
#eval (anyenv init - | source)
#bashで実行しようとするため文法エラーになる

#anyenv rbenv
#see https://patorash.hatenablog.com/entry/2017/09/15/154649
set -x RBENV_ROOT "$HOME/.anyenv/envs/rbenv"
set -x PATH $PATH "$RBENV_ROOT/bin"
set -gx PATH '/Users/kindaichidai/.anyenv/envs/rbenv/shims' $PATH
set -gx RBENV_SHELL fish
source '/Users/kindaichidai/.anyenv/envs/rbenv/libexec/../completions/rbenv.fish'
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (rbenv "sh-$command" $argv|psub)
  case '*'
    command rbenv "$command" $argv
  end
end

# anyenv nodenv
# ndenv
set -x NODENV_ROOT "$HOME/.anyenv/envs/nodenv"
set -x PATH $PATH "$NODENV_ROOT/bin"
set -gx PATH '/Users/kindaichidai/.anyenv/envs/nodenv/shims' $PATH
set -gx NODENV_SHELL fish
source '/Users/kindaichidai/.anyenv/envs/nodenv/libexec/../completions/nodenv.fish'
command nodenv rehash 2>/dev/null
function nodenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (nodenv "sh-$command" $argv|psub)
  case '*'
    command nodenv "$command" $argv
  end
end

# anyenv nodenv
# pyenv
set -x PYENV_ROOT "$HOME/.anyenv/envs/pyenv"
set -x PATH $PATH "$PYENV_ROOT/bin"
set -gx PATH '/Users/kindaichidai/.anyenv/envs/pyenv/shims' $PATH
set -gx PYENV_SHELL fish
source '/Users/kindaichidai/.anyenv/envs/pyenv/libexec/../completions/pyenv.fish'
command pyenv rehash 2>/dev/null
function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (pyenv "sh-$command" $argv|psub)
  case '*'
    command pyenv "$command" $argv
  end
end
# for python 3.7.3 install in pyenv
# https://github.com/pyenv/pyenv/issues/1184#issuecomment-458358654

# aws-cli
set PATH $HOME/.local/bin $PATH

# for npm bin
set -gx PATH '/Users/kindaichidai/.anyenv/envs/nodenv/versions/10.14.0/bin' $PATH

# for mysql
set -gx PATH '/usr/local/opt/mysql@5.7/bin' $PATH
