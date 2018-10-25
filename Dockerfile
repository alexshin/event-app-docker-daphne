FROM python:3.7
LABEL maintainer "Alex Shinkevich <alex.shinkevich@gmail.com>"

# Packages versions
ENV TINI_VERSION=v0.18.0 \
	DAPHNE_VERSION=2.2.2 \
	CHANNELS_VERSION=2.1.5

# System settings
ENV DAPHNE_USER=daphne \
	DAPHNE_PORT=8000 \
	APP_WORKDIR=/opt/app

# Add additional tools and thirdparties
# Init manager for containers
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

# Entrypoint
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]

# Install python requirements
RUN pip install --no-cache-dir \
		channels==${CHANNELS_VERSION} \
		daphne==${DAPHNE_VERSION}

# Some system stuff
RUN useradd -U ${DAPHNE_USER} \
	&& mkdir -p ${APP_WORKDIR} \
	&& chown -R ${DAPHNE_USER}:${DAPHNE_USER} ${APP_WORKDIR}

# Docker specifics
WORKDIR ${APP_WORKDIR}
USER ${DAPHNE_USER}
EXPOSE ${DAPHNE_PORT}

# Django specifics
ENV DJANGO_SETTINGS_MODULE=proj.channel_settings

# Entrypoint for ASGI
COPY asgi.py ${APP_WORKDIR}

# Custom command
CMD []
