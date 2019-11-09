FROM centos:centos7

USER root

RUN yum install -y expect
RUN yum install -y tcl
RUN yum install -y tcl-devel
RUN yum install -y tk
RUN yum install -y tk-devel
RUN mkdir -p /tcllib
RUN yum -y install gcc
RUN yum -y install gcc-c++
RUN yum -y install make
RUN cd /tcllib && curl https://core.tcl-lang.org/tcllib/uv/tcllib-1.19.tar.gz --output tcllib-1.19.tar.gz
RUN cd /tcllib && tar -xzf tcllib-1.19.tar.gz
RUN cd /tcllib/tcllib-1.19 && ./configure -libdir /usr/share/tk8.5
RUN cd /tcllib/tcllib-1.19 && make install exec_prefix="/usr/share"