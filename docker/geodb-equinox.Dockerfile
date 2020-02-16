FROM equinox:4.13

# build arguments
ARG p2_user
ARG p2_host
ARG p2_pass

# environment variables
ENV DEBUG false
ENV LOG false

# ini scripts
RUN \
cp /opt/equinox/equinox.ini /opt/equinox/equinox.ini.log_no_debug && \
cp /opt/equinox/equinox.ini /opt/equinox/equinox.ini.no_log_no_debug && \
cp /opt/equinox/equinox.ini /opt/equinox/equinox.ini.log_debug && \
cp /opt/equinox/equinox.ini /opt/equinox/equinox.ini.no_log_debug && \
sed -i '/console/d' /opt/equinox/equinox.ini.no_log_no_debug && \
sed -i '/console/d' /opt/equinox/equinox.ini.no_log_debug && \
echo "-Xdebug\n-Xnoagent\n-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=*:5001" >> /opt/equinox/equinox.ini.no_log_debug && \
echo "-Xdebug\n-Xnoagent\n-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=*:5001" >> /opt/equinox/equinox.ini.log_debug

# Generate start script
RUN \
printf '#!/bin/sh\n\
sshpass -p "%s" ssh -fN -L *:10000:localhost:10000 %s@%s \n\
\
l="no_log"\n\
if [ $LOG = true ]; then\n\
   l="log"\n\
fi\n\
\
d="no_debug"\n\
if [ $DEBUG = true ]; then\n\
   d="debug"\n\
fi\n\
\
cp /opt/equinox/equinox.ini."$l"_"$d" /opt/equinox/equinox.ini\n\
\
/opt/equinox/equinox -console 5000' "$p2_pass" "$p2_user" "$p2_host" > /opt/equinox/start.sh && \
chmod +x /opt/equinox/start.sh && \
mkdir /root/.ssh && \
ssh-keyscan "$p2_host" >> /root/.ssh/known_hosts

# Add repo
RUN \
printf '#/bin/sh\n\
echo "Repository configuration requires 30 seconds"\n\
\
LOG=false\n\
DEBUG=false\n\
\
nohup bash -c "/opt/equinox/start.sh &"\n sleep 5\n\
\
(\n\
echo "open localhost 5000"\n sleep 2\n\
echo "start 7"\n sleep 2\n\
echo "provaddrepo http://localhost:10000/repository"\n sleep 20\n\
echo "shutdown"\n sleep 5\
) | telnet\n\
\
exit 0' > /opt/equinox/configure.sh && \
chmod +x /opt/equinox/configure.sh && \
/opt/equinox/configure.sh

CMD /opt/equinox/start.sh
