#! /bin/zsh

# Original script is part of oh-my-zsh package:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/extract/extract.plugin.zsh

function extract() {
    local remove_archive
    local success
    local fname
    local dirname

    if (( $# == 0 )); then
        echo "Usage: extract [-option] [file ...]"
        echo
        echo Options:
        echo "    -r, --remove    Remove archive."
        echo
        echo "Report bugs to <sorin.ionescu@gmail.com>."
    fi

    remove_archive=1
    if [[ "$1" == "-r" || "$1" == "--remove" ]]; then
        remove_archive=0 
        shift
    fi

    while (( $# > 0 )); do
        if [[ ! -f "$1" ]]; then
            echo "extract: '$1' is not a valid file" 1>&2
            shift
            continue
        fi

        success=0
        fname=${$1:t}
        dirname=${$1:h}

        case "$fname" in
            (*.tar.gz|*.tgz)
            (*.tar.bz2|*.tbz|*.tbz2)
            (*.tar.xz|*.txz)
            (*.tar.lzma|*.tlz)
            (*.tar)
                tar xvf "$1" -C "$dirname" ;;
            (*.gz|*.Z)
                gzip -dvc "$1" > "${$1:r}" ;;
            (*.bz2)
                bzip2 -dkv "$1" ;;
            (*.xz|*.lzma)
                xz -dkv "$1" ;;
            (*.zip)
                unzip "$1" -d "$dirname" ;;
            (*.rar)
                unrar x "$1" ;;
            (*.7z)
                7za x "$1" -o"$dirname" ;;
            (*) 
                echo "extract: '$1' cannot be extracted" 1>&2
                success=1 
                ;; 
        esac

        (( success = $success > 0 ? $success : $? ))
        (( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
        shift
    done
}

alias x=extract
extract "$@"

# TODO: unrar into $dirname
