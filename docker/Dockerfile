# add /overwrite FROM with your base image, and do whatever you like here :)
FROM snaplogic/snaplex:latest

# Overwrite the default run script to also assign the 0/root group
# to the /opt/snaplogic/etc/ folder before the GroundPlex JCC starts
# up
ADD run.sh /.docker
RUN chmod a+x /.docker/run.sh

# change group ownership of /opt/snaplogic/ to root
RUN chown -R 1000650000:root /opt/snaplogic/

# Switch to root user to change the mode of the /opt/snaplogic/etc
# directory to g+w, execute GroundPlex node to generate keys with
# the root user.
#RUN usermod -a -G root snapuser \
#    && chmod g+w /opt/snaplogic/etc/ \
#    && /opt/snaplogic/bin/jcc.sh genkey \
#    && chmod -R g+w /opt/snaplogic/

RUN /opt/snaplogic/bin/jcc.sh genkey

# Add the root group to be allowed to read the configuration
# in /etc/snaplogic
RUN chmod g+rwx /etc/snaplogic/ \
    && chmod g+rw /etc/snaplogic/* 

# change the default user of the container to be the snaplogic user
# USER snapuser
    