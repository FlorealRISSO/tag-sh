#!/bin/sh

# Directory to store tags
TAGS_DIRS=${TAGS_DIRS:-$HOME}
TAGS_DIR=".tags"

get_mountpoint() {
	df -P "$1" | awk 'NR==2 {print $6}'
}

is_taggable() {
	local_file="$1"
	IFS=':'
	for dir in $TAGS_DIRS; do
		if [ "$dir" = "$local_file" ]; then
			return 0
		fi
	done
	return 1
}

die() { echo "$*" >&2; exit 1; }

add_tag() {
	tag_name=$1
	file=$2
	tag_file_basename=$(basename "$file")

	[ ! -f "$file" ] && die "Error: File '$file' does not exist."

	mountpoint=$(get_mountpoint "$file")
	[ -z "$mountpoint" ] && die "Error: Could not determine mountpoint for '$file'."
	is_taggable "$mountpoint" || die "Error: '$mountpoint' is not taggable."

	tag_dir="$mountpoint/$TAGS_DIR/$tag_name"
	mkdir -p "$tag_dir"

	[ -f "$tag_dir/$tag_file_basename" ] &&
		die "Error: File '$file' is already tagged with '$tag_name'."

 	
	(cd "$tag_dir"; ln "$file" "$tag_file_basename")
	echo "Tagged '$file' with '$tag_name'"
}

list_tag() {
	tag_name=$1

	IFS=':'
	for dir in $TAGS_DIRS; do
		tag_dir="$dir/$TAGS_DIR/$tag_name"
		if [ -d "$tag_dir" ]; then
			ls -1 "$tag_dir" | awk -v dir=$dir '{print dir,$0}'
		fi
	done
}

rm_tag() {
	tag_name=$1
	dir=$2
	file=$3
	tag_file_basename=$(basename "$file")
	tag_dir="$dir/$TAGS_DIR/$tag_name"

	is_taggable "$dir" || die "Error: '$dir' is not taggable".
	[ ! -d "$tag_dir" ] && die "Tag '$tag_name' does not exist."
	[ ! -f "$tag_dir/$tag_file_basename" ] &&
		die "Error: File '$file' is not tagged with '$tag_name'."

	rm "$tag_dir/$tag_file_basename"
	echo "Removed tag '$tag_name' from '$file'"
}

get_tag() {
	tag_name=$1
	dir=$2
	file=$3
	tag_file_basename=$(basename "$file")
	tag_dir="$dir/$TAGS_DIR/$tag_name"

	is_taggable "$dir" || die "Error: '$dir' is not taggable".
	[ ! -d "$tag_dir" ] && die "Tag '$tag_name' does not exist."
	[ ! -f "$tag_dir/$tag_file_basename" ] &&
		die "Error: File '$file' is not tagged with '$tag_name'."

	echo "$tag_dir/$tag_file_basename"
}

case $1 in
add)
	if [ -z "$2" ] || [ -z "$3" ]; then
		die "Usage: $0 add <TAG_NAME> <FILE>"
	fi
	add_tag "$2" "$3"
	;;
list)
	if [ -z "$2" ]; then
		die "Usage: $0 list <TAG_NAME>"
	fi
	list_tag "$2"
	;;
rm)
	if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
		die "Usage: $0 rm <TAG_NAME> <VOLUME> <FILE>"
	fi
	rm_tag "$2" "$3" "$4"
	;;
get)
	if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
		die "Usage: $0 get <TAG_NAME> <VOLUME> <FILE>"
	fi
	get_tag "$2" "$3" "$4"
	;;
*)
	progname=$(basename "$0")
	{
		echo "Usage: $progname add <TAG_NAME> <FILE>"
		echo "       $progname list <TAG_NAME>"
		echo "       $progname rm <TAG_NAME> <VOLUME> <FILE_BASENAME>"
		echo "       $progname get <TAG_NAME> <VOLUME> <FILE_BASENAME>"
	} >&2
	exit 1
	;;
esac
