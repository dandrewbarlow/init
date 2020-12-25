#! /bin/bash

# Andrew Barlow 
# github.com/dandrewbarlow
# A simple script to quickly setup a project from my templates


# FUNCTIONS
#======================================================

# create a unique readme
readme() {

    read -p "create README.md? [y/n]: " readmeConfirmation

    if [[ "$readmeConfirmation" =~ [yY] ]]
    then
        read -p "Enter project name: " name
        read -p "Enter a description: " desc

        readme="${projectDir}README.md"

        echo "# $name" > "$readme"
        echo "## by [Andrew Barlow](https://github.com/dandrewbarlow)" >> "$readme"
        echo "" >> "$readme"
        echo "### Description" >> "$readme"
        echo "$desc" >> "$readme"
    fi
}

# c++ project
cpp () {
    git clone https://github.com/dandrewbarlow/cpp-template "$projectDir"

    read -p "include GTK? [y/n]: " gtk

    if [[ "$gtk" =~ [yY] ]]
    then
        git checkout gtk
    fi
}

c() {
    git clone https://github.com/dandrewbarlow/c-template/tree/main "$projectDir"

    read -p "include GTK? [y/n]: " gtk

    if [[ "$gtk" =~ [yY] ]]
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

latex() {
    git clone https://github.com/dandrewbarlow/latex-template "$projectDir"

    read -p "Custom Title? [empty for no or type title]: " latexTitle

    if [ ! -z "$latexTitle" ]
    then
        for file in "${projectDir}main"*
        do
            sed -i '' -e "s/main/$latexTitle/g" "$file"
            mv "$file" "${file/main/$latexTitle}"
            rm -rf "$file"
        done

    fi
}

# Pick what kind of project to initialize
chooseProject() {
    read -p "Choose project type [C++/C/Python/Web/Latex]: " projectType

    case $projectType in
        [cC]\+\+)
            cpp
            ;;
        [cC])
            c
            ;;
        [pP]ython)
            python
            ;;
        [Ww]eb)
            web
            ;;
        [Ll]atex)
            latex
            ;;
        *)
            echo "Error: invalid input"
    esac

    readme

    createRepo
}

createRepo() {

    rm -rf "${projectDir}.git"

    read -p "Create new git repo? [y/n]: " git

    if [[ "$git" =~ [yY] ]]
    then 
        git init "$projectDir"
    fi
}


# SCRIPT
#======================================================
read -p "Initialize new project in current directory? (Must be empty) [y/n]: " confirmation

if [[ "$confirmation" =~ [yY] ]]
then
    # check for files
    files=$(ls | wc -l)
    if [ $files -gt 0 ]
    then
        echo "Error: directory not empty"
        exit 1
    fi

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
        exit 1
    fi
    
else
    echo "Error: Invalid input"
fi
