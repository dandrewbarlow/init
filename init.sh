#! /bin/bash

# Andrew Barlow 
# github.com/dandrewbarlow
# A simple script to quickly setup a project from my templates

readme() {
    read -p "Enter project name: " name
    read -p "Enter a description: " desc

    echo "# $name" > README.md
    echo "## by [Andrew Barlow](https://github.com/dandrewbarlow)" >> README.md
    echo "" >> README.md
    echo "### Description" >> README.md
    echo "$desc" >> README.md
}

cpp () {
    git clone https://github.com/dandrewbarlow/cpp-template ./

    read -p "include GTK? [y/n]: " gtk

    if [[ "$gtk" = [yY] ]]
    then
        git checkout gtk
    fi
    echo "Superuser permissions required to remove template git repo"
    
    sudo rm -r .git
    
    readme
}

python () {
    git clone https://github.com/dandrewbarlow/python-template ./
    
    echo "Superuser permissions required to remove template git repo"
    sudo rm -r .git

    readme
}

web() {
    git clone https://github.com/dandrewbarlow/Boilerplate ./
    read -p "Initialize a node.js package? [y/n]: " node
    if [[ "$node" =~ [yY] ]]
    then
        npm init
        read -p "Install gulp & browser-sync? [y/n]: " gulp
        if [[ "$gulp" =~ [yY] ]]
        then
            npm install --save-dev gulp gulp-sass browser-sync gulp-autoprefixer gulp-sourcemaps
        fi
    fi

    echo "Superuser permissions required to remove template git repo"
    sudo rm -r .git

    readme
}

read -p "Initialize new project in current directory? [y/n]: " confirmation

if [[ "$confirmation" =~ [yY] ]]
then
    read -p "Choose project type [C++/Python/Web]: " projectType

    case $projectType in
        [cC]\+\+)
            cpp
            ;;
        [pP]ython)
            python
            ;;
        [Ww]eb)
            web
            ;;
        *)
            echo "Error: invalid input"
    esac
else if [[ "$confirmation" =~ [nN] ]]
then
    echo "Ok then"
else
    echo ""
fi
