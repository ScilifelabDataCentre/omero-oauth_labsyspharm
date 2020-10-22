FROM openmicroscopy/omero-web-standalone:5.8.1
USER root
RUN yum -y install git

WORKDIR /opt

ADD . /opt/omero-oauth
WORKDIR /opt/omero-oauth
RUN /opt/omero/web/venv3/bin/python setup.py install

RUN cp /opt/omero-oauth/multi-example.yaml /opt/omero/web/config/oauth-providers.yaml
RUN echo "config append -- omero.web.apps '\"omero_oauth\"'" >> /opt/omero/web/config/omero-web-apps.omero

USER omero-web
COPY omeroweb-config.omero /opt/omero/web/config/
RUN /opt/omero/web/OMERO.web/bin/omero load omeroweb-config.omero
RUN /opt/omero/web/OMERO.web/bin/omero web restart

ENV PATH="/opt/omero/web/OMERO.web/bin:${PATH}"