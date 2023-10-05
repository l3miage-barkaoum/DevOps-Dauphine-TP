
FROM wordpress:latest
# les variables d'environnement pour la base de données
ENV WORDPRESS_DB_USER=wordpress
ENV WORDPRESS_DB_PASSWORD=ilovedevops
ENV WORDPRESS_DB_NAME=wordpress
ENV WORDPRESS_DB_HOST=34.121.146.103