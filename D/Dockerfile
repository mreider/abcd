FROM php:7.4-cli
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN apt-get update && apt-get install -y unzip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN composer install
CMD [ "php", "-S", "0.0.0.0:8083", "-t", "public" ]
EXPOSE 8083
