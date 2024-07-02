FROM centos:centos7
MAINTAINER John Tat <jtat@mitre.org>

# Add user
RUN useradd -m tpy4

# Install X Window System
RUN yum -y groupinstall "X Window System" "Fonts"
RUN yum -y group install "Development Tools"

# Install system tools and libraries.
RUN yum -y install glibc-static
RUN yum -y install net-tools
RUN yum -y install pciutils-devel
RUN yum -y install libpcap

# Install other tools.
RUN yum -y install vim
RUN yum -y install unzip
RUN yum -y install dos2unix 

# TPY4 RES dependencies
RUN yum -y install mesa-libGLU 
RUN yum -y install mesa-libGLU-devel 
RUN yum -y install qt5-qtbase 
RUN yum -y install qt5-qtbase-devel 
RUN yum -y install qt5-qttools 
RUN yum -y install qt5-designer 
RUN yum -y install qt5-qtsvg 
RUN yum -y install httpd 
RUN yum -y install httpd-tools
RUN yum -y install fftw-devel 
RUN yum -y install fftw-libs 
RUN yum -y install clutter
RUN yum -y install centos-release-scl
RUN yum -y install devtoolset-7

# log4cplus
RUN mkdir /opt/log4cplus

ADD libs/log4cplus/log4cplus-1.1.3-rc8.zip /opt/log4cplus
ADD scripts/build_log4cplus.sh /opt/log4cplus

RUN chmod +x /opt/log4cplus/build_log4cplus.sh
RUN /opt/log4cplus/build_log4cplus.sh

# ace library
RUN mkdir /opt/ace

ADD libs/ace/ACE+TAO-6.4.1.tar.gz /opt/ace
ADD scripts/build_ace.sh /opt/ace

RUN chmod +x /opt/ace/build_ace.sh
RUN /opt/ace/build_ace.sh

RUN ldconfig -v

# tao library
ADD scripts/build_tao.sh /opt/ace

RUN chmod +x /opt/ace/build_tao.sh
RUN /opt/ace/build_tao.sh

# boost
RUN mkdir /opt/boost

ADD libs/boost/boost_1_53_0.tar.gz /opt/boost
ADD scripts/build_boost.sh /opt/boost

RUN chmod +x /opt/boost/build_boost.sh
RUN /opt/boost/build_boost.sh

# glibc
RUN mkdir /opt/glibc
ADD libs/glibc/* /opt/glibc/

ADD scripts/build_glibc.sh /opt/glibc

RUN chmod +x /opt/glibc/build_glibc.sh
RUN /opt/glibc/build_glibc.sh

# TPY
RUN mkdir /opt/tpy4
ADD rpm/* /opt/tpy4/
ADD scripts/install_tpy4.sh /opt/tpy4

RUN chmod +x /opt/tpy4/install_tpy4.sh
RUN /opt/tpy4/install_tpy4.sh

# default directory
WORKDIR /home/tpy4

# http ports
EXPOSE  80
CMD     ["/usr/sbin/httpd","-D","FOREGROUND"]