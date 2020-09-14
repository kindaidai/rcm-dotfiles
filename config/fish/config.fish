set PATH /usr/local/bin /usr/sbin /usr/bin $PATH
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
#source '/Users/kindaichidai/.anyenv/envs/rbenv/libexec/../completions/rbenv.fish'
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
# nodenv
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

# anyenv pyenv
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

# anyenv goenv
set -x GOENV_ROOT "$HOME/.anyenv/envs/goenv"
set -x PATH $PATH "$GOENV_ROOT/bin"
set -gx PATH '/Users/kindaichidai/.anyenv/envs/goenv/shims' $PATH
set -gx RBENV_SHELL fish
source '/Users/kindaichidai/.anyenv/envs/goenv/libexec/../completions/goenv.fish'
command goenv rehash 2>/dev/null
function goenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (goenv "sh-$command" $argv|psub)
  case '*'
    command goenv "$command" $argv
  end
end


# aws-cli
# set PATH $HOME/.local/bin $PATH

# for npm bin
# set -gx PATH '/Users/kindaichidai/.anyenv/envs/nodenv/versions/10.14.0/bin' $PATH

# for mysql
set -gx PATH '/usr/local/opt/mysql@5.7/bin' $PATH

# for postgresql
# set -gx PATH '/usr/local/opt/postgresql@9.6/bin' $PATH

#fisherパッケージoh-my-fish/plugin-pecoの設定
function fish_user_key_bindings
  bind \cr peco_select_history # Bind for prco history to Ctrl+r
end

# diff-highlight for git
ln -s /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin/diff-highlight

#  +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.
set -gx OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES

# change directory color
set -gx LSCOLORS gxfxcxdxbxegedabagacad

# GOPATH
set -gx GOPATH '/Users/kindaichidai/go'

# fzf
set -U FZF_LEGACY_KEYBINDINGS 0

# .node_modules/.bin
set PATH './node_modules/.bin' $PATH

# gpg
set -gx GPG_TTY (tty)
