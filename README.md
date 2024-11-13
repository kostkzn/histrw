# Bash History Saver

A simple utility to save selected commands from your Bash history to a text file. Designed and tested for **Ubuntu**.

## Features

- Save the last executed command
- Save a specific command by its history number
- Add custom comments to the saved history
- Commands are saved to a customizable text file

## Installation

```bash
git clone https://github.com/kostkzn/histrw.git
cd histrw
source ./alias_add.sh
```

This will:

- Create a `~/bin` directory if it doesn't exist
- Copy the script to your `~/bin` directory
- Add the `add` alias to your `.bashrc`

## Usage

```bash
add                  # Save the last executed command
add 123              # Save command number 123 from history
add "# My comment"   # Add a comment to the history saver file
```

The commands are saved to `~/hostname_histrw.txt` by default.

## Requirements

- Basic Unix utilities (awk)
