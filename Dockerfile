# Start package
FROM ubuntu:16.04

RUN apt-get update


# install build-essentail, including c and c++ compiler
RUN apt-get install -y build-essential

# install apt-utils
RUN apt-get install -y apt-utils

# Install swig
RUN apt-get install -y swig

# Install autoconf
RUN apt-get install -y autoconf

# Install xutils-dev
RUN apt-get install -y xutils-dev

# install python
RUN apt-get install -y python


# Install DBM
COPY /dbm /dbm
WORKDIR /dbm/modules
RUN make
RUN make install


# Install PyDBM
WORKDIR ../../
COPY /python_dbm /python_dbm
WORKDIR python_dbm/
RUN python ./setup.py build
RUN python ./setup.py install

WORKDIR ../

CMD /bin/bash


