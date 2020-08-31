FROM php:7.2-cli
EXPOSE 8000
RUN mkdir /gouravproject
COPY index.php /gouravproject
WORKDIR /gouravproject
CMD ["php", "-S", "0.0.0.0:8000", "index.php"]
