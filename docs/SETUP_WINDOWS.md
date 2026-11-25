# SETUP_WINDOWS.md

## Windows development setup for **Smart Downloads Organizer**

This guide assumes you are using **Windows 10/11** and want to develop/run the project with **Git Bash** (the Bash shell that ships with Git for Windows). All steps are command‑line focused; you can also follow them in the Explorer UI if you prefer.

---

### 1️⃣ Install Git for Windows
1. Open a web browser and go to <https://git-scm.com/download/win>.
2. Click the **Download** button – the installer will start automatically.
3. Run the installer and keep the default options (they include *Git Bash* and the *Git GUI*).
4. When the installation finishes, you should have a **Git Bash** shortcut on the Start menu.

> **Tip:** The installer also adds `git` and basic Unix utilities (`rm`, `mkdir`, `find`, `realpath`, etc.) to your `PATH` for the Bash environment.

---

### 2️⃣ Install Visual Studio Code (optional but recommended)
1. Download VS Code from <https://code.visualstudio.com/download> – choose the Windows x64 installer.
2. Run the installer and accept the defaults. Enable the *"Add to PATH"* option; it lets you type `code .` inside Git Bash to open the current folder in VS Code.
3. Launch VS Code and install the **Bash IDE** extension (search for *"Bash IDE"*). This provides syntax highlighting, linting (via ShellCheck), and code navigation.

---

### 3️⃣ Clone / create the project directory
```bash
# Open Git Bash
# Choose a folder where you keep your projects, e.g. ~/code
mkdir -p ~/code && cd ~/code

# Clone the repo (replace with your own URL if you already have a remote)
git clone https://github.com/yourusername/SmartDownloadsOrganizer.git
cd SmartDownloadsOrganizer
```
If you prefer to start from a zip you downloaded, simply unzip it into a folder and `cd` into that folder.

---

### 4️⃣ Make the main script executable (optional on Windows)
Git Bash treats the *execute* bit like Unix. It is safe to set it:
```bash
chmod +x src/organizer.sh
```
Even if you skip this step, you can still run the script by explicitly invoking `bash`:
```bash
bash src/organizer.sh --directory "$HOME/Downloads"
```

---

### 5️⃣ Run a quick sanity check
```bash
# Show the help banner
./src/organizer.sh --help
```
You should see a colourful usage description. If you get *command not found* errors for utilities like `realpath`, install them via the *Git for Windows* optional packages or use the fallback logic already present in the script.

---

### 6️⃣ Run the test suite
```bash
cd src/tests
bash test_organizer.sh
```
All tests should pass and you will see `All tests passed.` at the end. The test suite creates its own temporary directories, so nothing in your real `Downloads` folder will be touched.

---

### 7️⃣ Common Windows pitfalls
| Issue | Why it happens | How to fix |
|-------|----------------|-----------|
| **`realpath` not found** | Older Git Bash versions omit `realpath`. | The script falls back to `cd`/`pwd -P`. You can also install `coreutils` via `pacman -S coreutils`. |
| **File permissions** | Windows paths contain backslashes; Bash expects forward slashes. | Use Git Bash quoting (`"C:/Users/you/..."`) or `$HOME` shortcuts. |
| **Spaces in paths** | Unquoted variables split on spaces. | The script quotes all variables; when typing manually, wrap the path in quotes. |
| **PowerShell vs. Bash** | The script relies on Bash syntax (`[[ ... ]]`, associative arrays). | Run it in *Git Bash* **only**; it will not work in PowerShell or CMD. |

---

### 8️⃣ Next steps
* Explore the source code under `src/` – the modular layout mirrors real‑world projects.
* Add your own files to `examples/unorganized/` and run the organiser to see the transformation.
* Follow the *Future Improvements* section in the README to extend the tool.

You are now ready to develop, test, and showcase **Smart Downloads Organizer** on GitHub!
