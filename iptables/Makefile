SCRIPT = iptables_menu.sh

.PHONY: run chmod check print help clean

run:
	sudo ./$(SCRIPT)

chmod:
	chmod +x $(SCRIPT)

check:
	@echo "Checking if script exists..."
	@test -f $(SCRIPT) && echo "$(SCRIPT) found." || echo "$(SCRIPT) not found."
	@echo "Checking if iptables is installed..."
	@iptables --version || echo "iptables is not installed."

print:
	sudo iptables -L --line-numbers -n -v

help:
	@echo "Available make commands:"
	@echo "  make chmod   - Gives execute permission to the script"
	@echo "  make run     - Runs the iptables menu script with sudo"
	@echo "  make check   - Checks if the script and iptables exist"
	@echo "  make print   - Prints current iptables rules"
	@echo "  make clean   - Removes backup files"

clean:
	rm -f *~
	rm -f *.bak