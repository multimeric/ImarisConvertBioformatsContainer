FROM ubuntu@sha256:bcc511d82482900604524a8e8d64bf4c53b2461868dac55f4d04d660e61983cb
RUN apt update && apt install -y \ 
    libboost-all-dev \
    libz3-4 \
    libz3-dev \
    libhdf5-103 \
    libhdf5-dev \
    liblz4-dev \
    lz4 \
    openjdk-11-jdk \
    libfreeimage-dev \
    libfreeimage3 \
    git \
    cmake \
    build-essential \
    wget
WORKDIR /opt
RUN git clone https://github.com/multimeric/ImarisConvertBioformats.git
WORKDIR ImarisConvertBioformats
RUN git clone https://github.com/imaris/ImarisWriter.git
RUN wget https://downloads.openmicroscopy.org/bio-formats/7.2.0/artifacts/bioformats_package.jar --directory-prefix /opt/ImarisConvertBioformats/bioformats
RUN mkdir -p ImarisConvertBioformats/build
WORKDIR ImarisConvertBioformats/build
RUN cmake .. -DJRE_HOME="/usr/lib/jvm/java-11-openjdk-amd64" -DCMAKE_BUILD_TYPE="Release" -DFreeImage_LIBRARIES="/usr/lib/x86_64-linux-gnu/libfreeimage.so"
RUN make
RUN make install
WORKDIR Release
ENTRYPOINT ["/opt/ImarisConvertBioformats/ImarisConvertBioformats/build/Release/ImarisConvertBioformats"]
