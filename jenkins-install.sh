#!/bin/bash

# Array of available Jenkins versions
declare -a JENKINS_VERSIONS=("2.426.1" "2.414.3" "2.414.2" "2.414.1" "2.401.3" "2.401.2" "2.401.1" "2.387.3" "2.387.2" "2.387.1" "2.375.4" "2.375.3")  # Add more versions as needed

select_version() {
    echo "Available Jenkins Versions:"
    for i in "${!JENKINS_VERSIONS[@]}"; do
        echo "$i: ${JENKINS_VERSIONS[$i]}"
    done

    read -p "Enter the number corresponding to the Jenkins version you want to install: " version_number

    if [[ ! $version_number =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a number."
        exit 1
    fi

    selected_version=${JENKINS_VERSIONS[$version_number]}
    if [ -z "$selected_version" ]; then
        echo "Invalid selection. Please choose a valid number."
        exit 1
    fi

    echo "Installing Jenkins version: $selected_version"
    # Call the appropriate installation function
    if [ -x "$(command -v apt)" ]; then
        install_debian "$selected_version"
    elif [ -x "$(command -v yum)" ]; then
        install_redhat "$selected_version"
    else
        echo "Unsupported distribution for Jenkins installation."
        exit 1
    fi
}

install_debian() {
    # Debian/Ubuntu installation logic
    sudo apt update
    sudo apt install -y default-jre
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sudo sh -c "echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list"
    sudo apt update
    sudo apt install -y "jenkins=$1"
}

install_redhat() {
    # Red Hat/CentOS installation logic
    sudo yum install -y java-1.8.0-openjdk
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo yum install -y "jenkins-$1"
}

# Start installation process
select_version
