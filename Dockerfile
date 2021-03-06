# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-18.04

# Install soundconverter, since it's gnome, there are a couple dbus deps to keep it happy.
RUN add-pkg xterm sudo wget curl sed fuse soundconverter dbus-x11 dconf-editor
RUN apt-get update
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN apt -y install ubuntu-restricted-extras

# Directories
RUN mkdir /storage
RUN chmod 777 /storage
RUN mkdir /output
RUN chmod 777 /output

# Copy the start script.
COPY startapp.sh /startapp.sh

# # Test files
# COPY test.ogg /storage/
# COPY test.flac /storage/
# COPY test.mp3 /storage/
# COPY test.m4a /storage/
# RUN chmod 777 /storage/*

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]
VOLUME ["/output"]

# Metadata.
LABEL \
      org.label-schema.name="soundconverter" \
      org.label-schema.description="Docker container for Soundconverter" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/8layer8/docker-soundconverter" \
      org.label-schema.schema-version="1.0"

# Set the name of the application.
ENV APP_NAME="Soundconverter"

# Testing:
# docker rm docker-soundconverter-test
# docker rmi docker-soundconverter
# docker build -t docker-soundconverter .
# docker images
# docker run --rm -p 5805:5800 -name docker-soundconverter-test docker-soundconverter
# point browser at docker host ip + 5805
# like http://192.168.0.10:5805/
# or http://localhost:5805/
