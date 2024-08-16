#!/bin/sh

# Directory to store tags
TAGS_DIR="$HOME/.tags"

# Function to create the tags directory if it doesn't exist
create_tags_dir() {
	if [ ! -d "$TAGS_DIR" ]; then
		mkdir -p "$TAGS_DIR"
			fi
}

# Function to add a tag to a file
add_tag() {
	tag_name="$1"
		file="$2"

# Check if file exists
		if [ ! -f "$file" ]; then
			echo "Error: File '$file' does not exist." >&2
				exit 1
				fi

# Create the tag directory if it doesn't exist
				create_tags_dir
				tag_dir="$TAGS_DIR/$tag_name"
				if [ ! -d "$tag_dir" ]; then
					mkdir -p "$tag_dir"
						fi

# Check if the file is already tagged
						if [ -f "$tag_dir/$(basename "$file")" ]; then
							echo "Error: File '$file' is already tagged with '$tag_name'." >&2
								exit 1
								fi

# Create a hard link to the file in the tag directory
								ln "$file" "$tag_dir/$(basename "$file")"
								echo "Tagged '$file' with '$tag_name'"
}

# Function to list all files with a specific tag
list_tag() {
	tag_name="$1"
		tag_dir="$TAGS_DIR/$tag_name"

# Check if the tag exists
		if [ ! -d "$tag_dir" ]; then
			echo "Tag '$tag_name' does not exist." >&2
				exit 1
				fi

# List all files under the tag directory, omitting the empty first line
				ls -1 "$tag_dir" | awk 'NF'
}

# Function to remove a tag from a file
rm_tag() {
	tag_name="$1"
		file="$2"
		tag_dir="$TAGS_DIR/$tag_name"

# Check if the tag exists
		if [ ! -d "$tag_dir" ]; then
			echo "Tag '$tag_name' does not exist." >&2
				exit 1
				fi

# Check if the file is tagged
				if [ ! -f "$tag_dir/$(basename "$file")" ]; then
					echo "Error: File '$file' is not tagged with '$tag_name'." >&2
						exit 1
						fi

# Remove the hard link
						rm "$tag_dir/$(basename "$file")"
						echo "Removed tag '$tag_name' from '$file'"
}

# Function to get the relative path of a file given a tag and filename
get_tag() {
	tag_name="$1"
		file="$2"
		tag_dir="$TAGS_DIR/$tag_name"

# Check if the tag exists
		if [ ! -d "$tag_dir" ]; then
			echo "Tag '$tag_name' does not exist." >&2
				exit 1
				fi

# Check if the file is tagged
				if [ ! -f "$tag_dir/$(basename "$file")" ]; then
					echo "Error: File '$file' is not tagged with '$tag_name'." >&2
						exit 1
						fi

# Output the path
						echo "$tag_dir/$(basename "$file")"
}

# Main script logic using case
case "$1" in
add)
if [ -z "$2" ] || [ -z "$3" ]; then
echo "Usage: $0 add <TAG_NAME> <FILE>" >&2
exit 1
fi
add_tag "$2" "$3"
;;
list)
if [ -z "$2" ]; then
echo "Usage: $0 list <TAG_NAME>" >&2
exit 1
fi
list_tag "$2"
;;
rm)
if [ -z "$2" ] || [ -z "$3" ]; then
echo "Usage: $0 rm <TAG_NAME> <FILE>" >&2
exit 1
fi
rm_tag "$2" "$3"
;;
get)
if [ -z "$2" ] || [ -z "$3" ]; then
echo "Usage: $0 get <TAG_NAME> <FILE>" >&2
exit 1
fi
get_tag "$2" "$3"
;;
*)
echo "Usage: $0 add <TAG_NAME> <FILE>" >&2
echo "       $0 list <TAG_NAME>" >&2
echo "       $0 rm <TAG_NAME> <FILE>" >&2
echo "       $0 get <TAG_NAME> <FILE>" >&2
exit 1
;;
esac

