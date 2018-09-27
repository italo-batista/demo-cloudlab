#!/bin/bash

# input_path is tar.gz file storing the input directory
# we assume that a given path/input_path.tar.gz after
# decompressed will generata a directory name path/input/path/ that stores the tiff files and MTL to generate ndvi
input_path=$1
input_dir=$(echo $1 | cut -d"." -f1)

# the name of the generated png image
output_path=$2

working_dir="./"

function setup {
    apt-get -y update
    apt-get -y install tar
    apt-get -y install make
    apt-get -y install libtiff-dev

    apt-get -y install git

    #install image_magick
    apt-get -y install imagemagick

    #build ndvi dep
    git clone https://github.com/simsab-ufcg/ndvi-gen.git
    cd ndvi-gen
    make
    cd -
}

function generate_ndvi {
    ./ndvi-gen/run $input_dir $working_dir
}

function export_to_png {
    #by convention, the output is named as ndvi.tif
    convert $working_dir/ndvi.tif $output_path
}

###############################################
# This scripts generates the vegetation index
# for a given tiff file, exports the index
# as a png file and stores it in cloud storage.

# build dependencies
setup

# descompress input data
tar xzvf $input_path

# generate the vegetation index
generate_ndvi

# exports the vegetation index as a png file
export_to_png
