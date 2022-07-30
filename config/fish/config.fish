set -g PATH /opt/homebrew/bin /usr/local/bin /usr/sbin /usr/bin $PATH
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
    # ssh-add -K ~/.ssh/id_rsa_mhack_default
end

function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add -K ~/.ssh/github_rsa
        # ssh-add -K ~/.ssh/id_rsa_mhack_default
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
set -x RBENV_ROOT "$HOME/.anyenv/envs/rbenv"
set -x PATH $PATH "$RBENV_ROOT/bin"
set -gx PATH '/Users/kindaichi/.anyenv/envs/rbenv/shims' $PATH
set -gx RBENV_SHELL fish
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    rbenv "sh-$command" $argv|source
  case '*'
    command rbenv "$command" $argv
  end
end
#see https://patorash.hatenablog.com/entry/2017/09/15/154649
#source '/Users/kindaichi/.anyenv/envs/rbenv/libexec/../completions/rbenv.fish'

# aws-cli
# set PATH $HOME/.local/bin $PATH

# for openssl@1.1
set PATH /opt/homebrew/opt/openssl@1.1/bin $PATH

# for mysql
set PATH /opt/homebrew/opt/mysql@5.7/bin $PATH
# set -gx PATH '/usr/local/opt/mysql@5.7/bin' $PATH

# for mysql-client
set PATH /opt/homebrew/opt/mysql-client@5.7/bin $PATH

# for imagemagick@6
set PATH /opt/homebrew/opt/imagemagick@6/bin $PATH

#fisherパッケージoh-my-fish/plugin-pecoの設定
function fish_user_key_bindings
  bind \cr peco_select_history # Bind for prco history to Ctrl+r
end

#  +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.
# set -gx OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES

# change directory color
# set -gx LSCOLORS gxfxcxdxbxegedabagacad

# fzf
set -U FZF_LEGACY_KEYBINDINGS 0

# .node_modules/.bin
set PATH './node_modules/.bin' $PATH

# gpg
set -gx GPG_TTY (tty)

# bundler
set -gx BUNDLER_EDITOR /opt/homebrew/bin/code

# homebrew
set -gx HOMEBREW_EDITOR /opt/homebrew/bin/code

# volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# tabechoku
set -gx AWS_PROFILE tabechoku-sso

# Go
set -gx GOPATH $HOME/go
set -gx PATH "$GOPATH/bin" $PATH

# fzf with fd
set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"
