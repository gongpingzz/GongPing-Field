# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
# case 选择语句，每个 case 分支用右圆括号开始，用两个分号 ;; 表示 break，即执行结束
# $-：当前shell的flag, eg: i: Short for “interactive”, which is good, because this is a shell with which I’m interacting


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# 当shell退出时，历史清单将添加到以HISTFILE变量的值命名的文件中，而不是覆盖文件 

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# -x file  如果文件存在且可执行,返回true
# && 表示当前一条命令执行成功时,执行后一条命令
# ||表示当前一条命令执行失败时,才执行后一条命令
# & 表示将任务置于后台运行
# | 表示将前一条命令的输出，用作后一条命令的输入

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# chroot: change root, 更改root目录
# -r file 如果文件存在且可读返回ture
# -z var 如果字符串的长度为零返回ture
# The file /etc/debian_chroot is when you have a chrooted debian system inside another debian system (ubuntu is based on debian).

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi
# -n var 如果字符串的长度不为零返回true


if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
# = : 检测两个字符串是否相等，相等返回 true

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# -x file 检测文件是否可执行，如果是，则返回 true

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# -f file 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。
# source 命令即 . 

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# 启用bash可编程功能（比如启用之后Tab键能自动不全）


# add my custom prompt
Black=$(tput setaf 0);
Red=$(tput setaf 1);
Green=$(tput setaf 2);
Yellow=$(tput setaf 3);
Blue=$(tput setaf 4);
Purple=$(tput setaf 5);
Cyan=$(tput setaf 6);
White=$(tput setaf 7);
bold=$(tput bold);
reset=$(tput sgr0);

PS1="\[\033]0;\w\007\]"; # Displays current working directory as title of the terminal
PS1+="\[${bold}\]\[${Cyan}\]\T ";
PS1+="\u at \h in "; # Displays username at hostname in
PS1+="\[${Blue}\]\w"; # Displays base path of current working directory
PS1+="\n"
PS1+="\[${Red}\]-> \[${reset}\]";


