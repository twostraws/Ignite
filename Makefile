install:
	@echo "Building the Ignite command-line tool...\\n"
	@swift build -c release --product IgniteCLI
	@(install .build/release/IgniteCLI /usr/local/bin/ignite 2> /dev/null && (echo \\n✅ Success! Run \`ignite\` to get started.)) || (echo \\n❌ Installation failed. You might need to run \`sudo make\` instead.\\n)