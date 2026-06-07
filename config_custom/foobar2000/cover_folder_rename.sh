find . -type f \( -name 'cover' -o -name 'cover.*' \) -exec sh -c '
for f do
    dir=${f%/*}
    [ "$dir" = "$f" ] && dir=.
    base=${f##*/}
    case $base in
        cover) new=folder ;;
        cover.*) new=folder.${base#cover.} ;;
    esac
    mv -- "$f" "$dir/$new"
done
' sh {} +
