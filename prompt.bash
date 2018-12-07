build_prompt () {
    BOLD=\\[$(tput bold)\\]
    WHITEFG=\\[$(tput setaf 7)\\]
    GREENFG=\\[$(tput setaf 46)\\]
    YELLOWFG=\\[$(tput setaf 215)\\]
    YELLOWBG=\\[$(tput setab 215)\\]
    BLACKBG=\\[$(tput setab 0)\\]
    RESET=\\[$(tput sgr0)\\]
    TRIANGLE=$'\uE0B0'

    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
    then
        HOSTFG=\\[$(tput setaf 199)\\]
        HOSTBG=\\[$(tput setab 199)\\]
    else
        HOSTFG=\\[$(tput setaf 239)\\]
        HOSTBG=\\[$(tput setab 239)\\]
    fi

    if [ "${PWD##/home/}" != "${PWD}" ]
    then
        PATHFG=\\[$(tput setaf 24)\\]
        PATHBG=\\[$(tput setab 24)\\]
    else
        PATHFG=\\[$(tput setaf 52)\\]
        PATHBG=\\[$(tput setab 52)\\]
    fi

    if [ $RETVAL -eq 0 ]
    then
        ICON=$'\u2713'
        STATUS="${GREENFG}${ICON}${WHITEFG}"
    else
        ICON=$'\u2757'
        STATUS="${ICON}"
    fi

    PS1="${BOLD}${HOSTBG}${STATUS} \h ${PATHBG}${HOSTFG}${TRIANGLE}${WHITEFG}${PATHBG} \w ${PATHFG}"
    GIT_BRANCH=$(__git_ps1)
    if [[ $GIT_BRANCH == "" ]]
    then
        PS1="${PS1}${BLACKBG}${TRIANGLE}"
    else
        PS1="${PS1}${YELLOWBG}${TRIANGLE} ${GIT_BRANCH} ${YELLOWFG}${BLACKBG}${TRIANGLE}"
    fi
    PS1="${PS1}${RESET} "
}

check_focus () {
    if [ $(xdotool getwindowfocus) -ne $WINDOWID ]
    then
        if [ $RETVAL -eq 0 ]
        then
            notify-send -i utilities-terminal "Terminal" "Command Completed Successfuly"
        else
            notify-send -i utilities-terminal "Terminal" "Command Failed"
        fi
    fi
}

bootstrap () {
    RETVAL=$?
    build_prompt
    check_focus
}

PROMPT_COMMAND=bootstrap
