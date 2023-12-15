---
title: "Getting started with reproduce.work"
---

## Pre-requisites

*Knowledge*: 

- Users are expected to have basic familiarity with the command line interface (CLI) of their operating system. The following instructions are for users of Linux and macOS. Windows users should install [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) and follow the instructions for Linux users. 
- Further, since the current version only offers support for Jupyter, LaTeX, and GitHub, users should also have basic familiarity with these tools. Support for more frameworks will be possible with future releases.

*Software*: 

- The reproduce.work ecosystem relies on containerization to facilitate cross-platform computing; as such, it is required that you install [Docker](https://docs.docker.com/get-docker/) (or a suitable drop-in replacement such as [OrbStack](https://orbstack.dev/); recommended for Apple Silicon machines). You do not need deep familiarity with Docker or containerization to use reproduce.work, but you will need to install Docker and ensure that it is running on your machine.

- While not required, it is also recommended that you install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and publish your reproducible projects to GitHub, as this will allow you to easily share your work openly with others and take advantage of the full suite of features offered by reproduce.work.

Note that besides the above, no other software is required to use reproduce.work. All other dependencies will be installed automatically when you run the `reproduce-work build` command.

## Installation

for buildializing new projects. It can be installed by running the following command:

```bash
curl -sSL https://reproduce.work/install | bash
```

You will be prompted with two options:
1. Install to your machine (in `/usr/local/bin`) for use anywhere in your command line
2. Install to your current directory. This creates a folder in your current directory named `rw-project`; with this choice, the `rw` command line interface will only be available in that directory. 

## Usage

There are THREE main commands in the reproduce.work workflow:

1. `reproduce-work init`: buildialize a new project
2. `reproduce-work build`: develop your project; analyze data, publish results, write report
3. `reproduce-work develop`: run your project to reproduce results


### 1. `reproduce-work init <project_name>`

By default, the `reproduce-work build` command will buildialize a new project using the following default options:

```bash
reproduce-work build --sci-env=python --doc-env=latex
```


```bash
reproduce-work init --sci-env=RStudio --doc-env=docx
```

### 2. `reproduce-work build`

### 3. `reproduce-work develop`

#### Note!
> Due to idiosyncrasies within the Jupyter ecosystem, when using publish_data or publish_file, you must first run register_notebook('code/<path to this notebook>.ipynb'). If you have multiple notebooks open simultaneously, keep in mind that only the most recently registered notebook will be used as the generating script for any data published with publish_data or publish_file.


### Installing packages

While in the development environment, you can install packages in one of two ways:

- **Persistent**: Add your desired packages on separate lines to `code/requirements.txt` and run `rw build` again. After "building" your dev environment, you can stop and restart it and your packages will be installed.

- **Temporary**: While your dev environment is running, you can use `pip install <package_name>`; however keep in mind that packages installed this way will not persist across sessions (i.e. if you stop and restart your dev environment, you will need to reinstall them). This is suitable for development/testing, but packages that are core to your project should be added to `code/requirements.txt`.





<!-- Invisible Link to Include the File in Build -->
<a href="files/dist/reproduce-work-linux" style="display:none;">Invisible Link</a>
<a href="files/dist/reproduce-work-macos" style="display:none;">Invisible Link</a>
<a href="files/dist/install.sh" style="display:none;">Invisible Link</a>
