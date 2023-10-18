#!/bin/env bash

PATH_PREVIEW="${HOME}/SharedFiles/Projects/ts/colorscheme/src/test/"
SOCKET_GUI="/tmp/nvim-colorscheme-gui"
SOCKET_TTY="/tmp/nvim-colorscheme-tty"
TERMS=()


close_terminals() {
    for pid in "${TERMS[@]}"; do
        kill "${pid}"
    done
}

trap close_terminals EXIT

if [[ ${#} -eq 0 ]]; then
    alacritty --hold -e ${0} reference 1>/dev/null 2>&1 &
    TERMS+=($!)
    alacritty --hold -e ${0} gui 1>/dev/null 2>&1 &
    TERMS+=($!)
    kitty -e ${0} tty 1>/dev/null 2>&1 &
    TERMS+=($!)

    HIGHLIGHTS="./lua/termcolors/highlights.lua"
    COMMANDS_GUI=$(cat <<EOT
        m'
        <ESC>:set termguicolors      |\
        :Lazy reload termcolors.nvim |\
        :colorscheme termcolors<CR>  |\
        <CR>''
EOT
)
    COMMANDS_TTY=$(cat <<EOT
        m'
        <ESC>:set notermguicolors    |\
        :Lazy reload termcolors.nvim |\
        :colorscheme termcolors<CR>  |\
        <CR>''
EOT
)
    COMMANDS_JOINED=$(cat <<EOT
        nvim --server "${SOCKET_GUI}" --remote-send "${COMMANDS_GUI}" ;\
        nvim --server "${SOCKET_TTY}" --remote-send "${COMMANDS_TTY}"
EOT
)
    sleep 1

    echo "${HIGHLIGHTS}" | entr -s "${COMMANDS_JOINED}"
elif [[ "${1}" == "reference" ]]; then
    cd "${PATH_PREVIEW}"
    nvim
elif [[ "${1}" == "gui" ]]; then
    cd "${PATH_PREVIEW}"
    nvim --listen "${SOCKET_GUI}"
elif [[ "${1}" == "tty" ]]; then
    cd "${PATH_PREVIEW}"
    export TERM="linux"
    nvim --listen "${SOCKET_TTY}"
fi
