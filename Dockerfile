FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour + installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    nginx \
    openssh-server \
    iputils-ping \
    net-tools \
    nano \
    python3 \
    sudo \
    sshpass \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Préparation du service SSH
RUN mkdir -p /var/run/sshd && ssh-keygen -A

# Configuration SSH
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'Port 22' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Mot de passe root SSH
RUN echo "root:password" | chpasswd

# Supprimer la page par défaut de Nginx
RUN rm -f /var/www/html/index.nginx-debian.html

# Copier ton site dans Nginx
COPY Index.html /var/www/html/index.html
COPY style.css /var/www/html/style.css
COPY script.js /var/www/html/script.js

# Exposer Nginx + SSH
EXPOSE 80
EXPOSE 22

# Démarrer SSH + Nginx
CMD service ssh start && nginx -g "daemon off;"
