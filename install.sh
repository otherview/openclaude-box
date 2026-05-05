#!/usr/bin/env bash
set -euo pipefail

BIN_NAME="openclaude-box"
INSTALL_DIR="$HOME/.local/bin"
REPO="otherview/openclaude-box"
BRANCH="main"
SCRIPT_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/${BIN_NAME}"

echo "📦 Installing ${BIN_NAME}..."

# Create install directory if needed
if [[ ! -d "$INSTALL_DIR" ]]; then
  mkdir -p "$INSTALL_DIR"
  echo "📁 Created $INSTALL_DIR"
fi

# Download the script
if command -v curl &>/dev/null; then
  curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$BIN_NAME"
elif command -v wget &>/dev/null; then
  wget -qO "$INSTALL_DIR/$BIN_NAME" "$SCRIPT_URL"
else
  echo "❌ Error: curl or wget is required to install."
  exit 1
fi

# Make it executable
chmod +x "$INSTALL_DIR/$BIN_NAME"

# Check if install dir is on PATH
if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
  echo "✅ Done. Run '${BIN_NAME} init' to get started."
else
  echo "✅ Installed to $INSTALL_DIR/$BIN_NAME"
  echo ""
  echo "⚠️  $INSTALL_DIR is not on your PATH."
  echo "   Add this to your shell config (~/.zshrc, ~/.bashrc, etc.):"
  echo "     export PATH=\"$INSTALL_DIR:\$PATH\""
  echo ""
  echo "   Or run directly:"
  echo "     $INSTALL_DIR/$BIN_NAME init"
fi
