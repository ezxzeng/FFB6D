#!/bin/bash
n_gpu=1
cls='ape'
python -m torch.distributed.launch --nproc_per_node=$n_gpu train_lm.py --gpus=$n_gpu --cls=$cls
