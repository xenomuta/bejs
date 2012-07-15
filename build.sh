#!/bin/bash
current_dir=`pwd`
src=$current_dir/src
dist=$current_dir/dist
coffee_bin=`which coffee`
CMD="$coffee_bin --compile --output $dist $src"
$CMD