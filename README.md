# 📂 Smart Downloads Organizer

> **Automate file management. Eliminate clutter. Organize smarter.**

A lightweight Bash automation tool that transforms messy directories into organized folders based on file extensions. Designed to simplify file management with safe operations, preview mode, interactive controls, and undo functionality.

---


![Bash](https://img.shields.io/badge/Made_with-Bash-4EAA25?logo=gnu-bash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-blue)
![Testing](https://img.shields.io/badge/Tests-Passing-success)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Project](https://img.shields.io/badge/Project-Open%20Source-purple)


## 📌 Overview

Managing a cluttered Downloads folder with files of different formats can be frustrating and time-consuming.

**Smart Downloads Organizer** automates this process by scanning a specified directory, identifying file types, creating categorized folders, and moving files to their respective locations.

The tool is built entirely using Bash and focuses on simplicity, safety, and practical automation.

## 🎯 Problem Statement

Unorganized directories create several problems:

- Difficulty locating important files
- Time wasted manually sorting files
- Accumulation of unnecessary clutter
- Risk of accidental overwriting during manual organization

### 💡 Solution

A command-line utility that automatically categorizes files, organizes them into structured directories, and provides control over every operation.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 📁 Automatic Categorization | Classifies files according to their extensions |
| 🔍 Dry-Run Mode | Preview operations without moving files |
| 💬 Interactive Mode | Allows confirmation before performing operations |
| ↩️ Undo Functionality | Restore files from the previous organization operation |
| 🛡️ Duplicate Protection | Prevents overwriting files with identical names |
| 📝 Logging | Records file organization operations |
| 📊 Summary Reports | Displays categorized file statistics |
| ⚙️ CLI Options | Supports flexible command-line arguments |
| 📄 Space-Safe Handling | Supports filenames containing spaces |

---

## 📂 File Categories

| Category | Supported File Types |
|---|---|
| 📄 Documents | DOC, DOCX, TXT |
| 📕 PDFs | PDF |
| 🖼️ Images | JPG, JPEG, PNG, and other supported image formats |
| 🎵 Audio | MP3, WAV, and supported audio formats |
| 🎬 Videos | MP4, MKV, and supported video formats |
| 📦 Archives | ZIP, RAR, TAR, and supported archive formats |
| 💻 Code | C, CPP, PY, SH, and supported source files |
| ⚙️ Installers | EXE, MSI |
| 📌 Others | Unknown extensions and extensionless files |

---

## 🛠️ Tech Stack

- **Bash** — Core scripting and automation
- **Git Bash** — Bash environment on Windows
- **Git** — Version control
- **GitHub** — Repository hosting
- **VS Code** — Development environment

---

## 📸 Demonstration

### Before Organization

```text
Downloads/
├── report.pdf
├── photo.jpg
├── music.mp3
├── project.zip
├── script.py
├── notes.txt
├── video.mp4
└── installer.exe
```

### After Organization

```text
Downloads/
├── Documents/
│   └── notes.txt
├── PDFs/
│   └── report.pdf
├── Images/
│   └── photo.jpg
├── Audio/
│   └── music.mp3
├── Archives/
│   └── project.zip
├── Code/
│   └── script.py
├── Videos/
│   └── video.mp4
└── Installers/
    └── installer.exe
```

---

## 🚀 Getting Started

### Prerequisites

- Windows / Linux
- Git
- Git Bash (Windows users)

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/YOUR-USERNAME/SmartDownloadsOrganizer.git
```

**2. Navigate to the project directory**

```bash
cd SmartDownloadsOrganizer
```

**3. Make the script executable**

```bash
chmod +x src/organizer.sh
```

---

## 💻 Usage

### 1. Preview the Organization

Preview what will happen without modifying any files.

```bash
./src/organizer.sh --directory "$HOME/Downloads" --dry-run
```

### 2. Organize Files

Execute the organization process.

```bash
./src/organizer.sh --directory "$HOME/Downloads"
```

### 3. Interactive Mode

Confirm operations interactively.

```bash
./src/organizer.sh --directory "$HOME/Downloads" --interactive
```

### 4. Undo the Previous Operation

Restore files moved during the previous organization.

```bash
./src/organizer.sh --undo
```

### 5. Display Help

View available commands and options.

```bash
./src/organizer.sh --help
```

---

## ⚙️ Command-Line Options

| Option | Description |
|---|---|
| `--directory PATH` | Specify the target directory |
| `--directory=PATH` | Specify directory using equals syntax |
| `-d PATH` | Short form for directory |
| `--dry-run` | Preview changes without moving files |
| `-n` | Short form for dry-run |
| `--interactive` | Enable interactive confirmation |
| `-i` | Short form for interactive mode |
| `--undo` | Undo the previous organization |
| `-u` | Short form for undo |
| `--verbose` | Display detailed information |
| `-v` | Short form for verbose |
| `--help` | Display help information |
| `-h` | Short form for help |

---

## 🧪 Testing

The project includes an automated test suite that validates the core functionality using temporary directories.

### Run the Tests

```bash
bash src/tests/test_organizer.sh
```

### Test Scenarios

- File categorization
- File organization
- Dry-run execution
- Handling filenames containing spaces
- Duplicate filename handling
- Undo functionality
- Temporary directory isolation

### Test Status

```text
All tests passed.
```

---

## 🏗️ Project Structure

```text
SmartDownloadsOrganizer/
│
├── src/
│   ├── organizer.sh
│   │
│   ├── lib/
│   │   ├── categories.sh
│   │   ├── cli.sh
│   │   └── helpers.sh
│   │
│   └── tests/
│       └── test_organizer.sh
│
├── demo/
│   └── Sample files for demonstration
│
├── docs/
│   └── SETUP_WINDOWS.md
│
├── logs/
│   └── Generated log files
│
├── run_demo.sh
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🔐 Safety & Reliability

- Preview file operations before execution
- Avoid overwriting existing files
- Handle filenames containing spaces
- Maintain logs for tracking operations
- Support undo for previous operations
- Test using isolated temporary directories

> ⚠️ **Always use dry-run mode before organizing important directories.**

---

## 🔮 Future Enhancements

- [ ] Recursive directory scanning
- [ ] Custom user-defined categories
- [ ] File duplicate detection using hashes
- [ ] File size statistics
- [ ] Scheduled automatic organization
- [ ] Interactive terminal dashboard
- [ ] Backup before moving files
- [ ] Cross-platform improvements

---

## 🎓 Learning Outcomes

Through this project, I explored and implemented:

- Bash scripting and automation
- Command-line argument parsing
- File system operations
- Associative arrays
- Error handling
- Logging and transaction management
- Safe file handling
- Automated testing
- Git version control

---

## 🤝 Contributing

Contributions, suggestions, and bug reports are welcome.

If you have ideas for improving this project, feel free to fork the repository and submit a pull request.

---

## 📜 License

This project is licensed under the **MIT License**. See the `LICENSE` file for more information.

---

### 💻 Built with Bash | Automated File Management

*Turning cluttered directories into organized workspaces.*