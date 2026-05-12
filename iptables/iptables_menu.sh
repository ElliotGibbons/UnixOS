if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    echo "Try running it with: sudo ./iptables_menu.sh"
    exit 1
fi
pause() {
    echo
    read -p "Press Enter to continue..."
}

select_chain() {
    echo "Select a chain:"
    echo "1) INPUT"
    echo "2) OUTPUT"
    echo "3) FORWARD"
    read -p "Enter choice: " chain_choice

    case $chain_choice in
        1)
            CHAIN="INPUT"
            ;;
        2)
            CHAIN="OUTPUT"
            ;;
        3)
            CHAIN="FORWARD"
            ;;
        *)
            echo "Invalid chain selection."
            return 1
            ;;
    esac

    return 0
}

add_rule() {
    echo "=== Add iptables Rule ==="

    select_chain || return

    read -p "Enter protocol tcp/udp/icmp/all: " PROTOCOL
    read -p "Enter source IP or leave blank for any: " SOURCE
    read -p "Enter destination port or leave blank for none: " PORT
    read -p "Enter action ACCEPT/DROP/REJECT: " ACTION

    COMMAND="iptables -A $CHAIN"

    if [[ "$PROTOCOL" != "all" && -n "$PROTOCOL" ]]; then
        COMMAND="$COMMAND -p $PROTOCOL"
    fi

    if [[ -n "$SOURCE" ]]; then
        COMMAND="$COMMAND -s $SOURCE"
    fi

    if [[ -n "$PORT" ]]; then
        COMMAND="$COMMAND --dport $PORT"
    fi

    COMMAND="$COMMAND -j $ACTION"

    echo
    echo "Running command:"
    echo "$COMMAND"
    eval "$COMMAND"

    echo "Rule added."
}

delete_rule() {
    echo "=== Delete iptables Rule ==="

    select_chain || return

    echo
    echo "Current rules for $CHAIN:"
    iptables -L "$CHAIN" --line-numbers

    echo
    read -p "Enter the rule number to delete: " RULE_NUM

    if [[ ! "$RULE_NUM" =~ ^[0-9]+$ ]]; then
        echo "Invalid rule number."
        return
    fi

    echo
    read -p "Are you sure you want to delete rule $RULE_NUM from $CHAIN? y/n: " CONFIRM

    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
        iptables -D "$CHAIN" "$RULE_NUM"
        echo "Rule deleted."
    else
        echo "Delete canceled."
    fi
}

modify_rule() {
    echo "=== Modify iptables Rule ==="

    select_chain || return

    echo
    echo "Current rules for $CHAIN:"
    iptables -L "$CHAIN" --line-numbers

    echo
    read -p "Enter the rule number to modify: " RULE_NUM

    if [[ ! "$RULE_NUM" =~ ^[0-9]+$ ]]; then
        echo "Invalid rule number."
        return
    fi

    echo
    echo "Enter the new rule information."

    read -p "Enter protocol tcp/udp/icmp/all: " PROTOCOL
    read -p "Enter source IP or leave blank for any: " SOURCE
    read -p "Enter destination port or leave blank for none: " PORT
    read -p "Enter action ACCEPT/DROP/REJECT: " ACTION

    COMMAND="iptables -R $CHAIN $RULE_NUM"

    if [[ "$PROTOCOL" != "all" && -n "$PROTOCOL" ]]; then
        COMMAND="$COMMAND -p $PROTOCOL"
    fi

    if [[ -n "$SOURCE" ]]; then
        COMMAND="$COMMAND -s $SOURCE"
    fi

    if [[ -n "$PORT" ]]; then
        COMMAND="$COMMAND --dport $PORT"
    fi

    COMMAND="$COMMAND -j $ACTION"

    echo
    echo "Running command:"
    echo "$COMMAND"
    eval "$COMMAND"

    echo "Rule modified."
}

print_rules() {
    echo "=== Print iptables Rules ==="

    echo "1) Print INPUT rules"
    echo "2) Print OUTPUT rules"
    echo "3) Print FORWARD rules"
    echo "4) Print all rules"
    read -p "Enter choice: " print_choice

    case $print_choice in
        1)
            iptables -L INPUT --line-numbers -n -v
            ;;
        2)
            iptables -L OUTPUT --line-numbers -n -v
            ;;
        3)
            iptables -L FORWARD --line-numbers -n -v
            ;;
        4)
            iptables -L --line-numbers -n -v
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

help_menu() {
    echo "=== Help Menu ==="
    echo
    echo "This script is a simple wrapper for iptables."
    echo
    echo "Options:"
    echo "1) Add Rule"
    echo "   Adds a new rule to INPUT, OUTPUT, or FORWARD."
    echo
    echo "2) Delete Rule"
    echo "   Lists rules with line numbers, then asks which rule to delete."
    echo "   It asks for confirmation before deleting."
    echo
    echo "3) Modify Rule"
    echo "   Replaces an existing rule with a new rule."
    echo
    echo "4) Print Rules"
    echo "   Displays iptables rules using --line-numbers."
    echo
    echo "5) Help"
    echo "   Displays this help menu."
    echo
    echo "6) Exit"
    echo "   Exits the program."
    echo
    echo "Common actions:"
    echo "ACCEPT - allows traffic"
    echo "DROP   - silently blocks traffic"
    echo "REJECT - blocks traffic and sends a rejection response"
    echo
    echo "Example rule:"
    echo "Chain: INPUT"
    echo "Protocol: tcp"
    echo "Source: leave blank"
    echo "Port: 22"
    echo "Action: ACCEPT"
    echo
    echo "That would allow SSH traffic on port 22."
}

while true; do
    clear
    echo "=============================="
    echo "       iptables Wrapper"
    echo "=============================="
    echo "1) Add rule"
    echo "2) Delete rule"
    echo "3) Modify rule"
    echo "4) Print rules"
    echo "5) Help menu"
    echo "6) Exit"
    echo "=============================="
    read -p "Enter your choice: " choice

    case $choice in
        1)
            add_rule
            pause
            ;;
        2)
            delete_rule
            pause
            ;;
        3)
            modify_rule
            pause
            ;;
        4)
            print_rules
            pause
            ;;
        5)
            help_menu
            pause
            ;;
        6)
            echo "Exiting program."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            pause
            ;;
    esac
done
