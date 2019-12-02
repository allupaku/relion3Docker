FROM centos:latest

RUN yum update -y

RUN yum install -y cmake kernel-devel kernel-headers make automake gcc gcc-c++ flex bison perl git wget
   
RUN  mkdir /tmp/fftw && cd /tmp/fftw/ && wget http://www.fftw.org/fftw-3.3.8.tar.gz && tar -xf fftw-3.3.8.tar.gz &&  cd fftw-3.3.8 && ./configure && \
make && make install && mkdir -p /opt/relion3 && cd /opt/relion3/ &&  git clone https://github.com/3dem/relion.git . && mkdir build 

#RUN mkdir -p /opt/cuda && cd /opt/cuda/ && wget https://developer.download.nvidia.com/compute/cuda/opensource/10.1.243/cuda-gdb-10.1.243.src.tar.gz && tar -xvf cuda-gdb-10.1.243.src.tar.gz && cd cuda-gdb-10.1.243 && ./configure && make 

RUN mkdir /opt/openmpi && cd /opt/openmpi/ &&  wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz && \
tar -xvf openmpi-4.0.2.tar.gz && cd openmpi-4.0.2 &&  mkdir build && ./configure && make && make install

RUN cd /opt/relion3/ && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DALTCPU=ON -DCUDA=OFF -DGUI=OFF && make

ENV PATH="/opt/relion3/bin:${PATH}"

CMD /bin/sh
