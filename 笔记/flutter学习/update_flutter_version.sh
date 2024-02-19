#!/bin/bash -l

version=$1
echo "$version"
flutter_home=/Users/wangkunkun/app/flutter
rm -rf $flutter_home/current
ln -s $flutter_home/$version $flutter_home/current
echo "$flutter_home"
source ~/.bash_profile
echo 'Done'
