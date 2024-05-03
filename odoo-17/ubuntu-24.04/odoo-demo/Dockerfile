FROM ubuntu:24.04

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
            ccze \
            curl \
            ntp \
            socat \
            sudo \
            git \
            ca-certificates \
            libsasl2-dev \
            libldap2-dev \
            libssl-dev \
            libffi-dev \
            node-less \
            python3 \
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
            #libjpeg62-turbo \
            libx11-6 \
            libxcb1 \
            libxext6 \
            libxrender1 \
            xfonts-75dpi \
            xfonts-base \
        && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb \
        && dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb \
        && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.focal_amd64.deb \
        && echo 'ae4e85641f004a2097621787bf4381e962fb91e1 wkhtmltox.deb' | sha1sum -c - \
        && apt install -y --no-install-recommends ./wkhtmltox.deb \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
        && apt install libssl-dev build-essential zlib1g-dev
# Create the odoo user and password
RUN useradd --create-home --home-dir /opt/odoo --no-log-init odoo
RUN echo "odoo:odoo" | chpasswd

# Copy Odoo configuration & entrypoint files
COPY --chown="odoo:odoo" ./odoo.conf /opt/odoo
COPY --chown="odoo:odoo" ./entrypoint.sh /opt/odoo
COPY --chown="odoo:odoo" ./requirements.txt /opt/odoo

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
RUN /bin/bash -c "cd /opt/odoo && git clone https://github.com/odoo/odoo --branch 17.0 --single-branch --depth 1"
RUN /bin/bash -c "mkdir -p /opt/odoo/custom-addons"

# Clone interesting OCA repositories
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/account-analytic -b 17.0 --single-branch --depth 1 account-analytic"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/account-financial-reporting -b 17.0 --single-branch --depth 1 account-financial-reporting"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/account-financial-tools -b 17.0 --single-branch --depth 1 account-financial-tools"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/account-invoicing -b 17.0 --single-branch --depth 1 account-invoicing"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/bank-payment -b 17.0 --single-branch --depth 1 bank-payment"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/community-data-files -b 17.0 --single-branch --depth 1 community-data-files"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/connector -b 17.0 --single-branch --depth 1 connector"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/crm -b 17.0 --single-branch --depth 1 crm"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/e-commerce -b 17.0 --single-branch --depth 1 e-commerce"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/edi -b 17.0 --single-branch --depth 1 edi"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/field-service -b 17.0 --single-branch --depth 1 field-service"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/hr -b 17.0 --single-branch --depth 1 hr"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/hr-attendance -b 17.0 --single-branch --depth 1 hr-attendance"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/hr-expense -b 17.0 --single-branch --depth 1 hr-expense"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/hr-holidays -b 17.0 --single-branch --depth 1 hr-holidays"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/l10n-spain -b 17.0 --single-branch --depth 1 l10n-spain"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/mis-builder -b 17.0 --single-branch --depth 1 mis-builder"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/partner-contact -b 17.0 --single-branch --depth 1 partner-contact"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/payroll -b 17.0 --single-branch --depth 1 payroll"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/pos -b 17.0 --single-branch --depth 1 pos"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/product-attribute -b 17.0 --single-branch --depth 1 product-attribute"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/purchase-reporting -b 17.0 --single-branch --depth 1 purchase-reporting"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/purchase-workflow -b 17.0 --single-branch --depth 1 purchase-workflow"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/queue -b 17.0 --single-branch --depth 1 queue"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/reporting-engine -b 17.0 --single-branch --depth 1 reporting-engine"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/sale-financial -b 17.0 --single-branch --depth 1 sale-financial"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/sale-reporting -b 17.0 --single-branch --depth 1 sale-reporting"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/sale-workflow -b 17.0 --single-branch --depth 1 sale-workflow"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/server-ux -b 17.0 --single-branch --depth 1 server-ux"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/server-tools -b 17.0 --single-branch --depth 1 server-tools"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/stock-logistics-barcode -b 17.0 --single-branch --depth 1 stock-logistics-barcode"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/stock-logistics-reporting -b 17.0 --single-branch --depth 1 stock-logistics-reporting"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/stock-logistics-warehouse -b 17.0 --single-branch --depth 1 stock-logistics-warehouse"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/stock-logistics-workflow -b 17.0 --single-branch --depth 1 stock-logistics-workflow"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/timesheet -b 17.0 --single-branch --depth 1 timesheet"
# RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/web -b 17.0 --single-branch --depth 1 web"

# Create Virtual Enviroment
RUN /bin/bash -c "cd /opt/odoo && virtualenv -p python venv"

#OCA Dependencies

# Python dependencies
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -U setuptools && pip3 install -r /opt/odoo/requirements.txt && deactivate"

VOLUME ["/opt/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

ENTRYPOINT ["/opt/odoo/entrypoint.sh"]