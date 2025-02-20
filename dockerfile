FROM python:3.11-slim

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    cmake \
    git \
    swig \
    python3-dev \
    python3-pip \
    rtl-sdr \
    librtlsdr-dev


RUN git clone https://github.com/pothosware/SoapySDR.git /SoapySDR
WORKDIR /SoapySDR
RUN mkdir -p build && cd build && cmake ..
WORKDIR /SoapySDR/build
RUN make && make install

RUN git clone https://github.com/pothosware/SoapyRTLSDR.git /SoapyRTLSDR
WORKDIR /SoapyRTLSDR
RUN mkdir -p build && cd build && cmake ..
WORKDIR /SoapyRTLSDR/build
RUN make && make install


RUN git clone https://github.com/xmikos/simplesoapy.git /simplesoapy
WORKDIR /simplesoapy
RUN pip install .

# Clone the soapy_power repository
RUN git clone https://github.com/xmikos/soapy_power.git /soapy_power

# Change working directory
WORKDIR /soapy_power
COPY spectrum-capture .
COPY .env .
# Install soapy_power
RUN pip install .


RUN ldconfig
# Set the entrypoint
CMD ["spectrum-capture"]