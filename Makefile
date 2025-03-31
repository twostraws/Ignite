PREFIX_DIR := /usr/local/bin

build:
	@echo "Building the Ignite command-line tool...\\n"
	@swift build -c release --product IgniteCLI

install:
	@echo "Installing the Ignite command-line tool...\\n"
	@mkdir -p $(PREFIX_DIR) 2> /dev/null || ( echo "❌ Unable to create install directory \`$(PREFIX_DIR)\`. You might need to run \`sudo make\`\\n"; exit 126 )
	@(install .build/release/IgniteCLI $(PREFIX_DIR)/ignite && \
	  install Sources/IgniteCLI/server.py $(PREFIX_DIR)/ignite-server.py && \
	  chmod +x $(PREFIX_DIR)/ignite && \
	  (echo \\n✅ Success! Run \`ignite\` to get started.)) || \
	 (echo \\n❌ Installation failed. You might need to run \`sudo make\` instead.\\n)

clean:
	@echo "Cleaning the Ignite build folder...\\n"
	@rm -rf .build/
