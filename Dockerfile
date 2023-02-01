FROM httpd:2.4

COPY ./app/page/ /usr/local/apache2/htdocs/

ENV PORT 80
EXPOSE 80