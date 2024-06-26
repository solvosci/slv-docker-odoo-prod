FROM ubuntu:20.04

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND noninteractive

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            build-essential \
            ccze \
            curl \
            ntp \
            socat \
            sudo \
            git \
            nano \
            gcc \
            python3-dev \
            libxml2-dev \
            libxslt1-dev \
            libevent-dev \
            libsasl2-dev \
            libldap2-dev \
            libpq-dev \
            libpng-dev \
            libjpeg-dev \
            node-less \
            node-clean-css \
            xfonts-75dpi \
            xfonts-base \
            wget \
            xz-utils \
            libxmlsec1-dev \
            sudo \
            git \
            ca-certificates \
            libsasl2-dev \
            libldap2-dev \
            libssl-dev \
            libffi-dev \
            node-less \
            python3-pip \
            python3-virtualenv \
            python3-pyldap \
            python3-qrcode \
            python3-renderpm \
            python3-setuptools \
            python3-vobject \
            python3-watchdog \
            python3-dev \
            libxmlsec1-dev \
            xz-utils \
            nodejs \
            fontconfig \
            libx11-6 \
            libxcb1 \
            libxext6 \
            libxrender1 \
            xfonts-75dpi \
            xfonts-base \
        && curl -o wkhtmltox.deb -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
        && echo 'f1689a1b302ff102160f2693129f789410a1708a wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb\
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* wkhtmltox. \
        && apt install libssl-dev build-essential zlib1g-dev \
        && curl -o Python-3.8.10.tgz -SL https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz \
        && tar xzf Python-3.8.10.tgz \
        && cd  Python-3.8.10 \
        && ./configure \
        && make altinstall

# Create the odoo user and password
RUN useradd --create-home --home-dir /opt/odoo --no-log-init odoo
RUN echo "odoo:odoo" | chpasswd

# Install latest postgresql-client
RUN apt-get update  \
    && apt-get install --no-install-recommends -y postgresql-client \
    && rm -f /etc/apt/sources.list.d/pgdg.list \
    && rm -rf /var/lib/apt/lists/*

# Copy Odoo configuration & entrypoint files
COPY --chown="odoo:odoo" ./odoo.conf /opt/odoo
COPY --chown="odoo:odoo" ./entrypoint.sh /opt/odoo

# set privileges for odoo files to odoo user
RUN chmod -R 775 /opt/odoo

# set execution permissions to entrypoint.sh
RUN chmod u+x /opt/odoo/entrypoint.sh

# Set default user to download extra addons and run the container 
USER odoo

# Download Odoo with git and create extra-addons folder
RUN /bin/bash -c "cd /opt/odoo && git clone https://github.com/odoo/odoo --branch 13.0 --single-branch --depth 1"
RUN /bin/bash -c "mkdir -p /opt/odoo/custom-addons"

# Create Virtual Enviroment
RUN /bin/bash -c "cd /opt/odoo && virtualenv -p python3.8 venv"

COPY ./requirements.txt /opt/odoo/odoo

# Python dependencies
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -U setuptools && pip3 install -r /opt/odoo/odoo/requirements.txt && deactivate"

# Clone interesting OCA repositories
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/web -b 13.0 --single-branch --depth 1 web"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/website -b 13.0 --single-branch --depth 1 website"

VOLUME ["/opt/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

ENTRYPOINT ["/opt/odoo/entrypoint.sh"]
