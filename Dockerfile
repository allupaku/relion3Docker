FROM nvidia/cuda:${cuda_version}-${cuda_env}-${os}

RUN yum update -y && yum install -y cmake patch kernel-devel kernel-headers make automake gcc gcc-c++ flex bison perl git wget tbb \
libtiff libtiff-devel ImageMagick ImageMagick-devel ghostscript which&& \
mkdir /tmp/fftw && cd /tmp/fftw/ && wget http://www.fftw.org/fftw-3.3.8.tar.gz && tar -xf fftw-3.3.8.tar.gz &&  cd fftw-3.3.8 && ./configure && \
make && make install && mkdir -p /opt/relion3 && cd /opt/relion3/ &&  git clone https://github.com/3dem/relion.git . && mkdir build

RUN mkdir /opt/openmpi && cd /opt/openmpi/ &&  wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz && \
tar -xvf openmpi-4.0.2.tar.gz && cd openmpi-4.0.2 &&  mkdir build && ./configure && make && make install

RUN yum groupinstall -y "Development Tools" &&  yum install -y fftw3-devel bzip2 gtk3-devel && \
mkdir -p /opt/wxwidgets && cd /opt/wxwidgets && \
wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.3/wxWidgets-3.1.3.tar.bz2 && \
bzip2 -d wxWidgets-3.1.3.tar.bz2 && tar -xvf wxWidgets-3.1.3.tar && \
cd wxWidgets-3.1.3 && ./configure && make && make install

RUN mkdir -p /opt/ctffind && cd /opt/ctffind && \
curl "https://grigoriefflab.umassmed.edu/system/tdf?path=ctffind-4.1.13-linux64.tar.gz&file=1&type=node&id=26" -o ctffind.tar.gz && \
tar -xvf ctffind.tar.gz && mv bin/* /usr/local/bin/

RUN cd /opt/relion3/ && cmake -DCMAKE_INSTALL_PREFIX=/usr/local && make && make install

RUN cd /usr/local/bin && wget https://www.mrc-lmb.cam.ac.uk/kzhang/Gctf/Gctf_v1.18_b2/bin/Gctf_v1.18_b2_sm60_cu8.0 && \
mv Gctf_v1.18_b2_sm60_cu8.0 gctf && chmod +x gctf

ENV PATH="/opt/relion3/bin:${PATH}"
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

RUN curl "https://www.mrc-lmb.cam.ac.uk/kzhang/Gctf/Gctf_v1.18_b2/bin/Gctf_v1.18_b2_sm30_cu9.2" -o /usr/bin/gctf

ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/cuda/lib64:/usr/local/nvidia/lib64

RUN yum install csh -y

WORKDIR /data

ENTRYPOINT [ "/bin/bash", "-c"]

CMD ["which relion_run_motioncorr"]
