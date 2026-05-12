# iptables Menu Wrapper

## Description

This project is a Bash script that acts as a menu-driven wrapper for `iptables`.

The program allows the user to manage basic Linux firewall rules without having to manually type every `iptables` command. The script provides options to add, delete, modify, and print firewall rules. It also includes a help menu explaining how the program works.

## Features

- Menu-driven interface
- Add iptables rules
- Delete iptables rules
- Modify existing iptables rules
- Print current rules with line numbers
- Help menu
- Root permission check
- Confirmation before deleting rules

## Files

| File | Description |
|---|---|
| `iptables_menu.sh` | Main Bash script |
| `Makefile` | Provides easy commands to run, install permissions, and clean |
| `README.md` | Project documentation |

## Requirements

This program requires:

- Linux
- Bash
- iptables
- sudo/root permissions

To check if `iptables` is installed, run:

```bash
iptables --version