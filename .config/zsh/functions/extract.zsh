#! /bin/zsh

# Original script is part of oh-my-zsh package:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/extract/extract.plugin.zsh

function extract() {
    local remove_archive
    local success
    local fname
    local basename
    local extension

    if (( $# == 0 )); then
        echo "Usage: extract [-option] [file ...]"
        echo
        echo Options:
        echo "    -r, --remove    Remove archive."
        echo
    fi

    remove_archive=0
#    if [[ "$1" == "-r" || "$1" == "--remove" ]]; then
#        remove_archive=1
#        shift
#    fi

    while (( $# > 0 )); do
        if [[ ! -f "$1" ]]; then
            echo "extract: '$1' is not a valid file" 1>&2
            shift
            continue
        fi

        success=0
        fname="$1"
        extension=${fname:e}

        # remove extension from basename
        basename=${fname:r:t}

        # hack to recognize .tar.gz etc as extension
        if [[ "${basename:e}" == "tar" ]]; then
            extension="${basename:e}.$extension"
            basename=${basename:r:t}
        fi

        case "$extension" in
            (tar.gz|tgz|tar.bz2|tbz|tbz2|tar.xz|txz|tar.lzma|tlz|tar)
                mkdir "$basename"
                tar xvf "$fname" -C "$basename"
                ;;
            (gz|Z)
                gzip -dvc "$fname" > "$basename"
                ;;
            (bz2)
                bzip2 -dkv "$fname"
                ;;
            (xz|lzma)
                xz -dkv "$fname"
                ;;
            (zip)
                unzip "$fname" -d "$basename"
                ;;
            (rar)
                unrar x "$fname"
                ;;
            (7z)
                7za x "$fname" -o"$basename"
                ;;
            (*)
                echo "extract: '$fname' cannot be extracted" 1>&2
                ;;
        esac 

        (( success = $success > 0 ? $success : $? ))
        (( $success == 0 )) && (( $remove_archive == 1 )) && rm -f "$fname"

        shift
    done
}

alias x=extract
#extract "$@"

# TODO: unrar into $dirname
