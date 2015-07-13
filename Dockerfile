# Dockerfile
# Yann Verry

FROM debian:jessie

# install build env
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get -y install wget git build-essential zlib1g-dev zlib1g zlibc locales ca-certificates
   
# OpenSSL
RUN cd /usr/src && \
    wget https://www.openssl.org/source/openssl-1.0.1p.tar.gz && \
    tar xf openssl-1.0.1p.tar.gz && \
    cd openssl-1.0.1p && \
    ./config shared && \
    make && \
    make install

# add CA and cacert
RUN mkdir /usr/local/share/ca-certificates/cacert.org && \
    wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt && \
    /usr/sbin/update-ca-certificates && \
    rmdir /usr/local/ssl/certs && \
    ln -s /etc/ssl/certs /usr/local/ssl/certs

# Ruby
RUN cd /usr/src && \
    wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz && \
    tar xf ruby-2.2.2.tar.gz && \
    cd ruby-2.2.2 && \
    ./configure --prefix=/usr --with-openssl=yes --with-openssl-dir=/usr/local/ssl && \
    make && \
    make install
# gem
RUN /usr/bin/gem install logging parallel ruby-progressbar httparty

# Set the locale
RUN locale-gen en_US.UTF-8  && \
    localedef -v -c -i en_US -f UTF-8 en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LANG C.UTF-8

# clone sslcheck
RUN cd /opt && \
    git clone https://github.com/yanntech/sslcheck

# expose volume output
VOLUME /opt/sslcheck/output

# CMD
CMD ["/opt/sslcheck/bin/check_https"]
