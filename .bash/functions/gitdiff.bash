function gitdiff() {
    commit=""
    folder_name="$(basename $PWD)"
    date="$(date +'%Y%m%d')"
    notes_directory="fondazione-cologni/git-diff"
    prefix="diff"
    exclude_files=""
    
    OPTIND=1;
    TEMP=$(getopt -o 'c:f:d:p:' --long 'commit:,foldername:,date:,notesdir:,prefix:,exclude:' -n 'gitdiff.bash' -- "$@")
    eval set -- "$TEMP"
    unset TEMP
    
    while true; do
        case "$1" in
            '-c'|'--commit')
                commit=$2
                shift 2
                continue
            ;;
            '-f'|'--foldername')
                folder_name=$2
                shift 2
                continue
            ;;
            '-d'|'--date')
                date=$2
                shift 2
                continue
            ;;
            '-p'|'--prefix')
                prefix=$2
                shift 2
                continue
            ;;
            '--notesdir')
                notes_directory=$2
                shift 2
                continue
            ;;
            '--exclude')
                exclude_files=$2
                shift 2
                continue
            ;;
            '--')
                shift
                break
            ;;
            *)
                echo 'Internal error!' >&2
                exit 1
            ;;
        esac
    done

    target_directory="$HOME/Documents/Notes/$notes_directory/$date"
    if [ ! -d "$target_direcoty" ]; then
	mkdir -p $target_directory
    fi
    
    if [ -z $commit ]; then
	echo -e "commit not specified\nterminating..."
	return 1
    fi

    git diff $commit --name-status > $prefix-$folder_name.md
    git diff $commit ':!*.css' ':!package-lock.json' ':!*.min.*' $exclude_files > $prefix-$folder_name-all.md
    mv $prefix-$folder_name* $target_directory
}
