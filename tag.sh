#!/bin/sh

# Directory to store tags
TAGS_DIR=${TAGS_DIR:-$HOME/.tags}

die() { echo "$*" >&2; exit 1; }

add_tag() {
	tag_name=$1
	file=$2
	tag_dir=$TAGS_DIR/$tag_name
	tag_file_basename=$(basename "$file")

	[ ! -f "$file" ] && die "Error: File '$file' does not exist."

	mkdir -p "$TAGS_DIR"
	mkdir -p "$tag_dir"

	[ -f "$tag_dir/tag_file_basename" ] &&
		die "Error: File '$file' is already tagged with '$tag_name'."

	ln "$file" "$tag_dir/tag_file_basename"
	echo "Tagged '$file' with '$tag_name'"
}

list_tag() {
	tag_name=$1
	tag_dir=$TAGS_DIR/$tag_name
	[ ! -d "$tag_dir" ] && die "Tag '$tag_name' does not exist."
	ls -1 "$tag_dir" | awk 'NF'
}

rm_tag() {
	tag_name=$1
	file=$2
	tag_dir=$TAGS_DIR/$tag_name
	tag_file_basename=$(basename "$file")

	[ ! -d "$tag_dir" ] && die "Tag '$tag_name' does not exist."
	[ ! -f "$tag_dir/tag_file_basename" ] &&
		die "Error: File '$file' is not tagged with '$tag_name'."

	rm "$tag_dir/tag_file_basename"
	echo "Removed tag '$tag_name' from '$file'"
}

get_tag() {
	tag_name=$1
	file=$2
	tag_dir=$TAGS_DIR/$tag_name
	tag_file_basename=$(basename "$file")

	[ ! -d "$tag_dir" ] && die "Tag '$tag_name' does not exist."
	[ ! -f "$tag_dir/tag_file_basename" ] &&
		die "Error: File '$file' is not tagged with '$tag_name'."

	echo "$tag_dir/tag_file_basename"
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
	if [ -z "$2" ] || [ -z "$3" ]; then
		die "Usage: $0 rm <TAG_NAME> <FILE>"
	fi
	rm_tag "$2" "$3"
	;;
get)
	if [ -z "$2" ] || [ -z "$3" ]; then
		die "Usage: $0 get <TAG_NAME> <FILE>"
	fi
	get_tag "$2" "$3"
	;;
*)
	progname=$(basename "$0")
	{
		echo "Usage: $progname add <TAG_NAME> <FILE>"
		echo "       $progname list <TAG_NAME>"
		echo "       $progname rm <TAG_NAME> <FILE>"
		echo "       $progname get <TAG_NAME> <FILE>"
	} >&2
	exit 1
	;;
esac
