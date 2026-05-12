
pause_program() {
    echo
    read -p "Press Enter to return to the main menu..."
}

#Count files in a directory
count_files() {
    echo
    echo "----- Count Files in Directory -----"
    echo "Current directories in this location:"
    ls -d */ 2>/dev/null

    echo
    read -p "Enter the directory path you want to check: " dir

    if [ -d "$dir" ]; then
        file_count=$(find "$dir" -maxdepth 1 -type f | wc -l)
        echo "The number of files in '$dir' is: $file_count"
    else
        echo "Error: '$dir' is not a valid directory."
    fi

    pause_program
}

#Number game
guessing_game() {
    echo
    echo "----- Number Guessing Game -----"
    echo "I am thinking of a number between 1 and 100."

    random_number=$((RANDOM % 100 + 1))
    guess=0
    attempts=0

    while [ "$guess" -ne "$random_number" ]; do
        read -p "Enter your guess: " guess

        # Validate number input
        if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
            echo "Please enter a valid number."
            continue
        fi

        attempts=$((attempts + 1))

        if [ "$guess" -lt "$random_number" ]; then
            echo "Too low!"
        elif [ "$guess" -gt "$random_number" ]; then
            echo "Too high!"
        else
            echo "Correct! The number was $random_number."
            echo "You guessed it in $attempts attempts."
        fi
    done

    pause_program
}

# 10 files with a prefix
create_files() {
    echo
    echo "----- Create 10 Files -----"

    read -p "Enter the directory where you want to create the files: " dir

    if [ ! -d "$dir" ]; then
        echo "That directory does not exist."
        read -p "Would you like to create it? (y/n): " create_dir

        if [[ "$create_dir" == "y" || "$create_dir" == "Y" ]]; then
            mkdir -p "$dir"
            echo "Directory created: $dir"
        else
            echo "File creation canceled."
            pause_program
            return
        fi
    fi

    read -p "Enter the file prefix: " prefix

    for i in {1..10}; do
        touch "$dir/${prefix}${i}.txt"
    done

    echo "Created 10 files in '$dir' with the prefix '$prefix'."
    echo "Example: ${prefix}1.txt, ${prefix}2.txt, ... ${prefix}10.txt"

    pause_program
}

#Date display menu
date_menu() {
    while true; do
        echo
        echo "----- Date Display Menu -----"
        echo "1) Display date as MM/DD/YY HH:MM:SS"
        echo "2) Display date as YYYY/MM/DD"
        echo "3) Display epoch seconds"
        echo "4) Display date 7 days in the future"
        echo "5) Return to main menu"
        echo

        read -p "Choose a date option: " date_choice

        case $date_choice in
            1)
                echo "Current date and time: $(date '+%m/%d/%y %H:%M:%S')"
                ;;
            2)
                echo "Current date: $(date '+%Y/%m/%d')"
                ;;
            3)
                echo "Epoch seconds: $(date '+%s')"
                ;;
            4)
                echo "Date 7 days in the future: $(date -d '+7 days' '+%A, %B %d, %Y')"
                ;;
            5)
                return
                ;;
            *)
                echo "Invalid option. Please choose 1-5."
                ;;
        esac
    done
}

#Exit
exit_program() {
    echo "Exiting program. Goodbye!"
    exit 0
}

# Main menu
main_menu() {
    while true; do
        clear
        echo "=============================="
        echo "        Bash Menu Program"
        echo "=============================="
        echo "1) Count files in a directory"
        echo "2) Play number guessing game"
        echo "3) Create 10 files with a prefix"
        echo "4) Display/manipulate date"
        echo "5) Exit"
        echo "=============================="
        echo

        read -p "Choose an option: " choice

        case $choice in
            1)
                count_files
                ;;
            2)
                guessing_game
                ;;
            3)
                create_files
                ;;
            4)
                date_menu
                ;;
            5)
                exit_program
                ;;
            *)
                echo "Invalid option. Please choose 1-5."
                pause_program
                ;;
        esac
    done
}

main_menu
