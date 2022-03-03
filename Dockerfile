ARG BASE_IMAGE=pytorch/pytorch:1.4-cuda10.1-cudnn7-devel
# ARG BASE_IMAGE=nvcr.io/nvidia/pytorch:20.01-py3
FROM $BASE_IMAGE

ARG BASE_IMAGE
RUN echo "Installing Apex on top of ${BASE_IMAGE}"
# make sure we don't overwrite some existing directory called "apex"
WORKDIR /tmp/unique_for_apex
# uninstall Apex if present
RUN pip uninstall -y apex || :
# SHA is something the user can touch to force recreation of this Docker layer,
# and therefore force cloning of the latest version of Apex
RUN SHA=ToUcHMe git clone https://github.com/NVIDIA/apex.git
WORKDIR /tmp/unique_for_apex/apex
RUN export TORCH_CUDA_ARCH_LIST="6.0;6.1;6.2;7.0;7.5" 
# see https://github.com/NVIDIA/apex/issues/1043
RUN git reset --hard 3fe10b5597ba14a748ebb271a6ab97c09c5701ac
RUN pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" .
WORKDIR /workspace


ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
         wget \
         libopencv-dev \
         python-opencv \
         build-essential \
         cmake \
         git \
         curl \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
         axel \
         zip \
         unzip \
         g++ \
         python3-tk
RUN pip install cython
RUN pip install h5py \
         numpy \
         pyyaml \
         enum34 \
         future \
         scipy==1.4.1 \
         opencv_contrib_python==3.4.2.17 \
         matplotlib==3.0.2 \
         transforms3d==0.3.1 \
         lmdb==0.94 \
         setuptools==41.0.0 \
         cffi==1.11.5 \
         easydict==1.7 \
         plyfile==0.6 \
         glumpy==1.0.6 \
         pillow==8.2.0
RUN pip install scikit_image tensorboardX

# Other evaluation deps
RUN pip install scikit-learn


RUN echo "Installing normalSpeed on top of ${BASE_IMAGE}"
RUN pip install "pybind11[global]"
# make sure we don't overwrite some existing directory called "normalspeed"
WORKDIR /tmp/unique_for_normalspeed
RUN SHA=ToUcHMe git clone https://github.com/hfutcgncas/normalSpeed.git
WORKDIR /tmp/unique_for_normalspeed/normalSpeed/normalSpeed
RUN python setup.py install --user
WORKDIR /workspace

RUN echo "compiling RandLA-Net"
WORKDIR /tmp/unique_for_randla_net
RUN SHA=ToUcHMe git clone https://github.com/qiqihaer/RandLA-Net-pytorch.git
WORKDIR /tmp/unique_for_randla_net/RandLA-Net-pytorch
RUN sh compile_op.sh
WORKDIR /workspace

RUN pip install pandas termcolor

# RUN useradd -m dev
# USER dev
