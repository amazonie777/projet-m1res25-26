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
    && rm -rf /var/lib/apt/lists/*

# Préparation du service SSH
RUN mkdir -p /var/run/sshd && ssh-keygen -A

# Autoriser root à se connecter en SSH
# RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
# RUN sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
# RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

### config ssh_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'Port 22' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Exposer Nginx + SSH
EXPOSE 80 22

RUN echo "root:password" | chpasswd

# Démarrage de SSH
CMD ["/usr/sbin/sshd", "-D"]
