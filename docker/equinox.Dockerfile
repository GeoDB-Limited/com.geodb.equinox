# alpine linux with OpenJDK 11 jre
FROM openjdk:11.0.6-jre-stretch

# Fix stretch
RUN apt update && \
    apt install openjdk-8-jre procps nano telnet openssh-client sshpass -y && \
    rm /etc/ssl/certs/java/cacerts && \
    update-ca-certificates --fresh

# Configure equinox
RUN wget -cO - http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/equinox/drops/R-4.13-201909161045/EclipseRT-OSGi-StarterKit-4.13-linux-gtk-x86_64.tar.gz > /opt/equinox.tar.gz && \
    cd /opt && \
    tar -zxf equinox.tar.gz && \
    rm equinox.tar.gz && mv rt equinox && \
    cd equinox && \
    mv rt.ini equinox.ini && \
    mv rt equinox

# Expose port
EXPOSE 5000

# run equinox
CMD /opt/equinox/equinox -console 5000
