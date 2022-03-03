#!/bin/bash

dir=$(dirname $(realpath -s $0))
dataset_root="/home/ezeng/projects/object-pose/dataset/"
docker run -v $dir:/workspace -v $dataset_root:/dataset -it --ipc host --gpus all ffb6d /bin/bash
