# Use Octave docker image
FROM       gnuoctave/octave:6.4.0

# Usage:
# docker run -it -v <your directory>:/documents/

USER root
# Install base packages
RUN apt-get update && apt-get install -y -q python3-pip pandoc unzip curl
RUN apt-get install -y -q liboctave-dev
RUN apt-get install -y -q libmpfrc++-dev

# Choose compiler version
RUN apt-get install -y -q g++-7
RUN sudo ln -s /usr/bin/gcc-7 /usr/local/bin/gcc
RUN sudo ln -s /usr/bin/g++-7 /usr/local/bin/g++


RUN mkdir /workspace

RUN chmod 777 -R /workspace

CMD ["/bin/bash"]

# Copies the entrypoint script
COPY entrypoint.sh /

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

