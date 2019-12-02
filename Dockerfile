FROM centos:latest

RUN yum update -y

RUN yum install -y cmake kernel-devel kernel-headers make automake gcc gcc-c++ flex bison perl git wget && \
mkdir /tmp/fftw && cd /tmp/fftw/ && wget http://www.fftw.org/fftw-3.3.8.tar.gz && tar -xf fftw-3.3.8.tar.gz &&  cd fftw-3.3.8 && ./configure && \
make && make install && mkdir -p /opt/relion3 && cd /opt/relion3/ &&  git clone https://github.com/3dem/relion.git . && mkdir build  && \
mkdir /opt/openmpi && cd /opt/openmpi/ &&  wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz && \
tar -xvf openmpi-4.0.2.tar.gz && cd openmpi-4.0.2 &&  mkdir build && ./configure && make && make install && \
cd /opt/relion3/ && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DALTCPU=ON -DCUDA=OFF -DGUI=OFF -DCMAKE_EXE_LINKED_FLAGS="-static" -DBUILD_SHARED_LIBS=OFF && \
yum remove -y cmake kernel-devel make automake gcc gcc-c++ perl git && rm -rf /tmp/fftw && rm -rf /opt/openmpi && rm -rf /opt/relion3/external/fftw/*.gz && rm -rf /opt/relion3/external/fftw/fftw3/ && \
rm -rf /opt/relion3/external/tbb/tbb2018U3/jni && rm -rf /opt/relion3/external/tbb/tbb2018U3/.git* && cd /opt/relion3/external/tbb/tbb2018U3/ && rm -rf README.md cmake examples CHANGES LICENSE Makefile doc examples index.html src && \
cd /opt/relion3/external && rm -rf tbb/tbb*.gz

ENV PATH="/opt/relion3/bin:${PATH}"

CMD /bin/sh
