FROM ubuntu:18.04

# # Define Config Proxy ENVs
# ARG proxy
# ARG sproxy
# ARG no_proxy

# ENV http_proxy="$proxy"
# ENV https_proxy="$sproxy"
# ENV no_proxy="$no_proxy"

# # Config Proxy For APT
# RUN touch /etc/apt/apt.conf.d/proxy.conf
# RUN echo Acquire::http::Proxy "$proxy"; > /etc/apt/apt.conf.d/proxy.conf
# RUN echo Acquire::https::Proxy "$sproxy"; >> /etc/apt/apt.conf.d/proxy.conf
# # update package list

# install curl and git
RUN apt update && apt install -y curl git

# install apache
RUN apt-get install -y apache2

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y tzdata \
    && ln -fs /usr/share/zoneinfo/America/Fortaleza /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# install php
RUN apt-get -y install php7.2 mcrypt php-mbstring php7.2-mysql php-pear php7.2-dev php7.2-xml php7.2-gd php7.2-opcache php7.2-curl --allow-unauthenticated
RUN apt-get install -y libapache2-mod-php7.2 

# install pre requisites
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
# RUN source ~/.bashrc
RUN apt-get install unixodbc-dev

#enabling pdo_mysql
# RUN phpenmod pdo_mysql

# install driver sqlsrv
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv

# # load driver sqlsrv
RUN echo "extension=sqlsrv.so" > /etc/php/7.2/mods-available/sqlsrv.ini
RUN ln -s /etc/php/7.2/mods-available/sqlsrv.ini /etc/php/7.2/cli/conf.d/20-sqlsrv.ini
RUN echo "extension=pdo_sqlsrv.so" > /etc/php/7.2/mods-available/pdo_sqlsrv.ini
RUN ln -s /etc/php/7.2/mods-available/pdo_sqlsrv.ini /etc/php/7.2/cli/conf.d/30-pdo_sqlsrv.ini
RUN phpenmod -v 7.2 sqlsrv pdo_sqlsrv

# install composer
RUN cd /usr/local/bin && curl -sS https://getcomposer.org/installer | php -- --filename=composer
#RUN composer install

# install locales
RUN apt-get install -y locales && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# change default to port to 81
COPY configs/ccbs.conf /etc/apache2/sites-available/000-default.conf

RUN apt-get install -y nano

# enable mod_rewrite
RUN a2enmod rewrite && service apache2 restart

EXPOSE 80

WORKDIR /var/www/html/

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]