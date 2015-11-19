#!/usr/bin/env bash

# Copyright (c) 2015. Zuercher Hochschule fuer Angewandte Wissenschaften
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Author: Piyush Harsh,
# URL: piyush-harsh.info

sudo apt-get update
sudo apt-get -y upgrade

### Installing Java ###
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get -y install python-software-properties
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y install oracle-java7-installer

### Installing Maven & git ###
sudo apt-get -y remove maven2
sudo apt-get -y install maven
sudo apt-get -y install git

### Getting the code from github ###
git clone https://github.com/icclab/expression-evaluator.git

### Building the package dependencies into single jar ###
sudo mkdir -p /var/log/tnova/expeval/
sudo chmod 777 /var/log/tnova/expeval/
echo "--------------------------IMP MSG-------------------------"
echo "| please update the log file path in the configuration file"
echo "| suggested path: /var/log/tnova/expeval/ followed by <filename>"
echo "| line to modify is: log4j.appender.file.File"
echo "----------------------------------------------------------"
read -p "Press any key to modify the logger settings."
cd ./expression-evaluator/
nano src/main/resources/log4j.properties
echo "--------------------------IMP MSG-------------------------"
echo "| Change DB file path in the program's configuration"
echo "----------------------------------------------------------"
read -p "Press any key to modify the program settings."
nano src/main/resources/expressionsolver.conf
mvn clean compile assembly:single

### Final message ###
mkdir -p $HOME/bin/
cp target/expressionsolver-0.1-jar-with-dependencies.jar $HOME/bin/
echo "If the compilation process was success, the executable jar is in $HOME/bin folder"
echo "To execute the server: java -jar $HOME/bin/expressionsolver-0.1-jar-with-dependencies.jar"