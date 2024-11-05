# File Tagging Tool

This script provides a simple tagging system for files on Linux. It allows you to add tags to files, list files by tag, remove tags, and retrieve the relative path of tagged files. The tool uses hard links and manages tags in a hidden directory within your home directory.

## Features

- **Add Tags:** Assign tags to files.
- **List Tags:** Display all files associated with a specific tag.
- **Remove Tags:** Remove a tag from a file.
- **Get Path:** Retrieve the relative path of a tagged file.

## Installation

1. **Download the Script**

   Download the script and save it as `tag.sh`.

2. **Make the Script Executable**

   ```sh
   chmod +x tag.sh
   ```

3. **Set TAGS_DIRS Variable**

   Before using the script, set the `TAGS_DIRS` variable to include all desired volumes for tagging. For example:

   ```sh
   export TAGS_DIRS="$HOME:/media/usb1"
   ```

## Usage

### Add a Tag to a File

To add a tag to a file, use the following command:

```sh
./tag.sh add <TAG_NAME> <FILE>
```

**Example:**

```sh
./tag.sh add work project.txt
```

This command tags the file `project.txt` with the tag `work`.

### List All Files with a Specific Tag

To list all files associated with a specific tag, use the following command:

```sh
./tag.sh list <TAG_NAME>
```

**Example:**

```sh
./tag.sh list work
```

This command lists all files that are tagged with `work`.

### Remove a Tag from a File

To remove a tag from a file, use the following command:

```sh
./tag.sh rm <TAG_NAME> <VOLUME> <FILE>
```

**Example:**

```sh
./tag.sh rm work /media/usb1/project.txt
```

This command removes the tag `work` from the file `project.txt` located on the specified volume.

### Get the Relative Path of a Tagged File

To get the path of a file associated with a tag, use the following command:

```sh
./tag.sh get <TAG_NAME> <VOLUME> <FILE>
```

**Example:**

```sh
./tag.sh get work /media/usb1/project.txt
```

This command prints the path to `project.txt`, which would be something like `$HOME/.tags/work/project.txt`.

## Error Handling

- **File Does Not Exist:** If the specified file does not exist, an error message will be displayed.
- **Tag Directory Does Not Exist:** If the specified tag does not exist when listing, removing, or getting, an error message will be displayed.
- **File Already Tagged:** When adding a tag, if the file is already tagged with the same tag, an error message will be displayed.
- **File Not Tagged:** When removing or getting a tag, if the file is not tagged with the specified tag, an error message will be displayed.
- **Volume Not Taggable:** If the specified volume is not taggable, an error message will be displayed.

## Requirements

- **Shell Compatibility:** This script is compatible with POSIX-compliant `sh` shells.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

If you have suggestions for improvements or bug fixes, feel free to submit a pull request or open an issue.
