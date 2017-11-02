FROM centos:6

ENV EL="6" \
    EL_SUB="" \
    OPENSSL="1.1.0g" \
    NGINX="1.13.6" \
    NREV="-1" \
    NJS="0.1.14-1"

ENV PKGS="nginx-$NGINX$NREV.el${EL}${EL_SUB}.ngx.src.rpm \
nginx-module-geoip-$NGINX$NREV.el${EL}${EL_SUB}.ngx.src.rpm \
nginx-module-image-filter-$NGINX$NREV.el${EL}${EL_SUB}.ngx.src.rpm \
nginx-module-njs-$NGINX.$NJS.el${EL}${EL_SUB}.ngx.src.rpm \
nginx-module-perl-$NGINX$NREV.el${EL}${EL_SUB}.ngx.src.rpm \
nginx-module-xslt-$NGINX$NREV.el${EL}${EL_SUB}.ngx.src.rpm"

RUN yum -y update &&\
    yum -y install epel-release &&\
    yum -y install wget openssl-devel libxml2-devel libxslt-devel gd-devel \
        perl-ExtUtils-Embed GeoIP-devel rpmdevtools gcc gcc-c++ make which \
        pcre-devel libedit-devel

RUN echo -e '#!/bin/bash\nwhile true; do sleep 1; done' \
    >/docker-entrypoint.sh &&\
    chmod +x /docker-entrypoint.sh

RUN useradd builder
USER builder

RUN for pkg in ${PKGS}; do \
        rpm -ivh "https://nginx.org/packages/mainline/centos/${EL}/SRPMS/${pkg}"; \
    done

WORKDIR /home/builder/rpmbuild
RUN sed -i "/Epoch: .*/d" SPECS/*.spec &&\
    sed -i "/Name: .*/a Epoch: 100" SPECS/*.spec &&\
    sed -i "/Source12: .*/a Source100: https://www.openssl.org/source/openssl-$OPENSSL.tar.gz" SPECS/nginx.spec &&\
    sed -i "s|--with-http_ssl_module|--with-http_ssl_module --with-openssl=openssl-$OPENSSL|g" SPECS/nginx.spec &&\
    sed -i "/%setup -q/a tar zxf %{SOURCE100}" SPECS/nginx.spec &&\
    sed -i "/^Requires: openssl.*/d" SPECS/nginx.spec &&\
    sed -i "s/%define main_release .*/%define main_release 2\%{\?dist}.ngx/g" SPECS/nginx.spec
RUN spectool -g -R SPECS/nginx.spec
RUN rpmbuild -ba SPECS/nginx.spec && \
    mv SPECS/nginx.spec{,.done} && \
    rpmbuild -ba SPECS/*.spec

