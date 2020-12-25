#! /bin/bash

# Andrew Barlow 
# github.com/dandrewbarlow
# A simple script to quickly setup a project from my templates

# create a unique readme
readme() {
    read -p "Enter project name: " name
    read -p "Enter a description: " desc

    readme="${projectDir}README.md"

    echo "# $name" > "$readme"
    echo "## by [Andrew Barlow](https://github.com/dandrewbarlow)" >> "$readme"
    echo "" >> "$readme"
    echo "### Description" >> "$readme"
    echo "$desc" >> "$readme"
}

# c++ project
cpp () {
    git clone https://github.com/dandrewbarlow/cpp-template "$projectDir"

    read -p "include GTK? [y/n]: " gtk

    if [[ "$gtk" = [yY] ]]
    then
        git checkout gtk
    fi
}

# python project
python () {
    git clone https://github.com/dandrewbarlow/python-template "$projectDir"
}

# website
web() {
    git clone https://github.com/dandrewbarlow/Boilerplate "$projectDir"
    
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
}

# Pick what kind of project to initialize
chooseProject() {
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

    readme

    createRepo
}

createRepo() {

    echo "Deleting template git repo [using superuser priveledges]"
    sudo rm -r "${projectDir}.git"

    read -p "Create new git repo? [y/n]: " git

    if [[ "$git" =~ [yY] ]]
    then 
        git init
    fi
}

read -p "Initialize new project in current directory? [y/n]: " confirmation

if [[ "$confirmation" =~ [yY] ]]
then
    projectDir="./"
    chooseProject

elif [[ "$confirmation" =~ [nN] ]]
then

    read -p "Initialize new project in new directory? [y/n]: " newDir

    if [[ "$newDir" =~ [yY] ]]
    then 
        read -p "Enter new directory name: " dirName
        mkdir "$dirName"
        projectDir="$dirName/"
        chooseProject
    else
        echo "Ok then"
    fi
    
else
    echo "Error: Invalid input"
fi
