build:
	@echo "Building the Ignite command-line tool...\\n"
	@swift build -c release --product IgniteCLI

install:
	@echo "Installing the Ignite command-line tool...\\n"
	@[ $(shell id -u) -eq 0 ] && sudo mkdir -p /usr/local/bin || { echo "You do not have root permissions. Either manually create the /usr/local/bin directory or run as \'sudo\'"; exit 126; }
	@(install .build/release/IgniteCLI /usr/local/bin/ignite 2> /dev/null && (echo \\n✅ Success! Run \`ignite\` to get started.)) || (echo \\n❌ Installation failed. You might need to run \`sudo make\` instead.\\n)

clean:
	@echo "Cleaning the Ignite build folder...\\n"
	@rm -rf .build/