if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'

    fish_add_path $HOME/scripts
    fish_add_path $HOME/.local/bin

    set -gx EDITOR nvim
    set -gx QT_STYLE_OVERRIDE kvantum

    oh-my-posh init fish --config ~/.config/ohmyposh/brian.omp.json | source

    set fish_greeting ""

    function reload_on_sigusr1 --on-signal SIGUSR1
        oh-my-posh init fish --config ~/.config/ohmyposh/brian.omp.json | source
    end

    fastfetch
end
