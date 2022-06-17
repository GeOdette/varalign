FROM 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:02ab-main


# Solving module erro
RUN pip3 install biopython

RUN apt-get install -y curl unzip
RUN apt-get install sudo
# Install utilities
RUN sudo apt-get install wget
#essentials
RUN sudo apt-get install -y build-essential libssl-dev &&\
   cd /tmp &&\
   wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz &&\
   tar -zxvf cmake-3.20.0.tar.gz &&\
   cd cmake-3.20.0 &&\
   ./bootstrap &&\
   make &&\
   sudo make install 




# Set up environment and install dependencies
# RUN apt-get update && apt-get -y upgrade && \
# DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y cmake g++ g++-10 gcc-10 libboost-all-dev libgsl-dev libjemalloc-dev make unzip wget zlib1g-dev

# Install Bowtie2 v2.4.3
RUN wget "https://github.com/BenLangmead/bowtie2/releases/download/v2.4.3/bowtie2-2.4.3-source.zip" && \
   unzip bowtie2-*-source.zip && \
   cd bowtie2-* && \
   make && \
   make install && \
   cd .. && \
   rm -rf bowtie2-* && \
   rm -rf /root/.cache /tmp/*

# Install DRAGMAP v1.2.1
#RUN wget -qO- "https://github.com/Illumina/DRAGMAP/archive/refs/tags/1.2.1.tar.gz" | tar -zx && \
#cd DRAGMAP-* && \
#HAS_GTEST=0 make CFLAGS:= && \
#HAS_GTEST=0 make install && \
#d .. && \
#rm -rf DRAGMAP-* && \
#rm -rf /root/.cache /tmp/*

# Install HISAT2 v2.2.1
RUN wget -qO- "https://github.com/DaehwanKimLab/hisat2/archive/refs/tags/v2.2.1.tar.gz" | tar -zx && \
   cd hisat2-* && \
   make && \
   mv hisat2 hisat2-* hisat2_*.py /usr/local/bin/ && \
   cd .. && \
   rm -rf hisat2-* && \
   rm -rf /root/.cache /tmp/*

# Install Minimap2 v2.24
RUN wget -qO- "https://github.com/lh3/minimap2/archive/refs/tags/v2.24.tar.gz" | tar -zx && \
   cd minimap2-* && \
   make && \
   chmod a+x minimap2 && \
   mv minimap2 /usr/local/bin/minimap2 && \
   cd .. && \
   rm -rf minimap2-* && \
   rm -rf /root/.cache /tmp/*

# Install NGMLR v0.2.7
RUN wget -qO- "https://github.com/philres/ngmlr/archive/refs/tags/v0.2.7.tar.gz" | tar -zx && \
   cd ngmlr-* && \
   mkdir -p build && \
   cd build && \
   cmake .. && \
   make && \
   mv ../bin/ngmlr-*/ngmlr /usr/local/bin/ngmlr && \
   cd ../.. && \
   rm -rf ngmlr-* && \
   rm -rf /root/.cache /tmp/*

# Install STAR v2.7.5c
RUN wget -qO- "https://github.com/alexdobin/STAR/archive/refs/tags/2.7.9a.tar.gz" | tar -zx && \
   mv STAR-*/bin/Linux_*_static/* /usr/local/bin/ && \
   rm -rf STAR-* && \
   rm -rf /root/.cache /tmp/*

# Install Unimap (latest)
RUN wget "https://github.com/lh3/unimap/archive/refs/heads/master.zip" && \
   unzip master.zip && \
   cd unimap-master && \
   make && \
   mv unimap /usr/local/bin/unimap && \
   cd .. && \
   rm -rf master.zip unimap-master && \
   rm -rf /root/.cache /tmp/*

# Install wfmash v0.7.0
#RUN git clone --recursive https://github.com/ekg/wfmash.git &&\
#cd wfmash &&\
#cmake -H. -Bbuild && cmake --build build -- -j 3

# Set up ViralMSA
RUN wget -O /usr/local/bin/ViralMSA.py "https://raw.githubusercontent.com/niemasd/ViralMSA/master/ViralMSA.py" && \
   chmod a+x /usr/local/bin/ViralMSA.py

# Install requirements
# COPY requirements.txt requirements.txt
# RUN pip install -r requirements.txt


# STOP HERE:
# The following lines are needed to ensure your build environement works
# correctly with latch.
COPY wf /root/wf
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
RUN python3 -m pip install --upgrade latch
WORKDIR /root
