FROM ubuntu:22.04

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

# Copy Odoo configuration & entrypoint files
COPY ./odoo.conf /opt/odoo
COPY ./entrypoint.sh /opt/odoo

# Install latest postgresql-client
RUN apt-get update  \
    && apt-get install --no-install-recommends -y postgresql-client \
    && rm -f /etc/apt/sources.list.d/pgdg.list \
    && rm -rf /var/lib/apt/lists/*

# set privileges for odoo files to odoo user
RUN chmod -R 775 /opt/odoo

# set execution permissions to entrypoint.sh
RUN chmod u+x /opt/odoo/entrypoint.sh

# Set default user to download extra addons and run the container 
USER odoo

# Download Odoo with git and create extra-addons folder
RUN /bin/bash -c "cd /opt/odoo && git clone https://github.com/odoo/odoo --branch 15.0 --single-branch --depth 1"
RUN /bin/bash -c "mkdir -p /opt/odoo/custom-addons"

# Clone interesting OCA repositories
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/account-analytic -b 15.0 --single-branch --depth 1 account-analytic"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/account-financial-reporting -b 15.0 --single-branch --depth 1 account-financial-reporting"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/account-financial-tools -b 15.0 --single-branch --depth 1 account-financial-tools"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/account-invoicing -b 15.0 --single-branch --depth 1 account-invoicing"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/bank-payment -b 15.0 --single-branch --depth 1 bank-payment"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/community-data-files -b 15.0 --single-branch --depth 1 community-data-files"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/connector -b 15.0 --single-branch --depth 1 connector"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/crm -b 15.0 --single-branch --depth 1 crm"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/e-commerce -b 15.0 --single-branch --depth 1 e-commerce"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/edi -b 15.0 --single-branch --depth 1 edi"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/field-service -b 15.0 --single-branch --depth 1 field-service"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/l10n-spain -b 15.0 --single-branch --depth 1 l10n-spain"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/mis-builder -b 15.0 --single-branch --depth 1 mis-builder"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/partner-contact -b 15.0 --single-branch --depth 1 partner-contact"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/pos -b 15.0 --single-branch --depth 1 pos"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/product-attribute -b 15.0 --single-branch --depth 1 product-attribute"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/purchase-reporting -b 15.0 --single-branch --depth 1 purchase-reporting"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/purchase-workflow -b 15.0 --single-branch --depth 1 purchase-workflow"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/queue -b 15.0 --single-branch --depth 1 queue"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/reporting-engine -b 15.0 --single-branch --depth 1 reporting-engine"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/sale-financial -b 15.0 --single-branch --depth 1 sale-financial"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/sale-reporting -b 15.0 --single-branch --depth 1 sale-reporting"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/sale-workflow -b 15.0 --single-branch --depth 1 sale-workflow"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/server-ux -b 15.0 --single-branch --depth 1 server-ux"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/server-tools -b 15.0 --single-branch --depth 1 server-tools"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/stock-logistics-barcode -b 15.0 --single-branch --depth 1 stock-logistics-barcode"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/stock-logistics-reporting -b 15.0 --single-branch --depth 1 stock-logistics-reporting"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/stock-logistics-warehouse -b 15.0 --single-branch --depth 1 stock-logistics-warehouse"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/stock-logistics-workflow -b 15.0 --single-branch --depth 1 stock-logistics-workflow"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/timesheet -b 15.0 --single-branch --depth 1 timesheet"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/web -b 15.0 --single-branch --depth 1 web"

# Create Virtual Enviroment
RUN /bin/bash -c "cd /opt/odoo && virtualenv -p python3.8 venv"

#OCA Dependencies
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/account-financial-tools/requirements.txt && deactivate"
# RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/bank-payment/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/community-data-files/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/connector/requirements.txt && deactivate"
# RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/edi/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/l10n-spain/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/queue/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/reporting-engine/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/server-ux/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/stock-logistics-barcode/requirements.txt && deactivate"
# RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/web/requirements.txt && deactivate"
# RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/server-tools/requirements.txt && deactivate"

# Python dependencies
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -U setuptools && pip3 install -r /opt/odoo/odoo/requirements.txt && deactivate"

VOLUME ["/opt/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

ENTRYPOINT ["/opt/odoo/entrypoint.sh"]