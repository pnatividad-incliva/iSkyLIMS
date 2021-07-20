#FROM debian:buster-slim
#FROM python:3.8-slim-buster
#ENV TZ=Europe/Madrid
#ARG DEBIAN_FRONTEND=noninteractive
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#RUN apt-get update && apt-get upgrade -y

# Essential software
#RUN apt-get install -y \
#    lightdm git apt-utils libcairo2 libcairo2-dev  wget gnuplot python3-pip \
#    default-mysql-client default-libmysqlclient-dev apache2 apache2-dev vim 

FROM ubuntu:20.04
# ENV PYTHONUNBUFFERED 1
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Updates
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y

# Essential software
RUN apt-get install -y \
    lightdm git apt-utils libcairo2 libcairo2-dev  wget gnuplot python3-pip \
    libmysqlclient-dev apache2 apache2-dev vim 

RUN wget https://github.com/Illumina/interop/releases/download/v1.1.15/InterOp-1.1.15-Linux-GNU.tar.gz
RUN tar -xvf  InterOp-1.1.15-Linux-GNU.tar.gz
RUN ln -s InterOp-1.1.15-Linux-GNU interop
RUN rm InterOp-1.1.15-Linux-GNU.tar.gz


RUN mkdir /opt/iSkyLIMS

WORKDIR /opt/iSkyLIMS

RUN git clone https://github.com/BU-ISCIII/iSkyLIMS.git .

RUN git submodule init
RUN git checkout develop
RUN git submodule init
RUN git submodule update --recursive --checkout
RUN cd iSkyLIMS_wetlab git 



RUN mkdir -p /opt/iSkyLIMS/documents/wetlab/tmp
RUN mkdir -p /opt/iSkyLIMS/documents/drylab
RUN mkdir -p /opt/iSkyLIMS/logs



# Starting iSkyLIMS
RUN python3 -m pip install -r conf/pythonPackagesRequired.txt
RUN django-admin startproject iSkyLIMS .
RUN /bin/bash -c 'grep ^SECRET iSkyLIMS/settings.py > ~/.secret'


# Copying config files and script
RUN cp conf/settings.py /opt/iSkyLIMS/iSkyLIMS/.
RUN cp conf/urls.py /opt/iSkyLIMS/iSkyLIMS/
COPY scripts/migrations /opt/iSkyLIMS/
RUN chmod 750 migrations
RUN sed -i "/^SECRET/c\\$(cat ~/.secret)" iSkyLIMS/settings.py
ENV PATH="usr/bin:$PATH"
# Expose and run
EXPOSE 8000
CMD python3 manage.py runserver 0:8000