FROM ubuntu:18.04

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
            python3-venv \
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
        && curl -o Python-3.5.6rc1.tgz -SL https://www.python.org/ftp/python/3.5.6/Python-3.5.6rc1.tgz \
        && tar xzf Python-3.5.6rc1.tgz \
        && cd  Python-3.5.6rc1 \
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

# set privileges for odoo files to odoo user
RUN chmod -R 775 /opt/odoo

# Set default user to download extra addons and run the container 
USER odoo

# Create data folder
RUN /bin/bash -c "mkdir -p /opt/odoo/data"

# Copy Odoo configuration & entrypoint files
COPY ./odoo.conf /opt/odoo
COPY ./entrypoint.sh /opt/odoo

# Copy Odoo configuration & entrypoint files
COPY ./odoo.conf /opt/odoo
COPY ./entrypoint.sh /opt/odoo

# Download Odoo with git and create extra-addons folder
RUN /bin/bash -c "cd /opt/odoo && wget https://github.com/odoo/odoo/archive/219d2296d67488855891573c979857c5fbfd1ebe.tar.gz && mkdir ./odoo && tar xzf 219d2296d67488855891573c979857c5fbfd1ebe.tar.gz --strip-components=1 -C odoo && rm 219d2296d67488855891573c979857c5fbfd1ebe.tar.gz"
RUN /bin/bash -c "mkdir -p /opt/odoo/custom-addons"

# Clone interesting OCA repositories
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/server-env -b 11.0 --single-branch --depth 1 server-env"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && git clone https://github.com/OCA/server-tools -b 11.0 --single-branch --depth 1 server-tools"

# Clone specific versions
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/account-financial-reporting/archive/33695a22f8be3fd7516aa2e7f3df289540595135.tar.gz && mkdir ./account-financial-reporting && tar xzf 33695a22f8be3fd7516aa2e7f3df289540595135.tar.gz --strip-components=1 -C account-financial-reporting && rm 33695a22f8be3fd7516aa2e7f3df289540595135.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/account-financial-tools/archive/86b973517783edf85273ba3d8cf153a560ac1365.tar.gz && mkdir ./account-financial-tools && tar xzf 86b973517783edf85273ba3d8cf153a560ac1365.tar.gz --strip-components=1 -C account-financial-tools && rm 86b973517783edf85273ba3d8cf153a560ac1365.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/account-invoicing/archive/1758b5e0a8baf2f0c9e0b6c381ce465ca73fb55b.tar.gz && mkdir ./account-invoicing && tar xzf 1758b5e0a8baf2f0c9e0b6c381ce465ca73fb55b.tar.gz --strip-components=1 -C account-invoicing && rm 1758b5e0a8baf2f0c9e0b6c381ce465ca73fb55b.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/Openworx/backend_theme/archive/24720a4e0f3862f3668f909509727744231a690f.tar.gz && mkdir ./backend_theme && tar xzf 24720a4e0f3862f3668f909509727744231a690f.tar.gz --strip-components=1 -C backend_theme && rm 24720a4e0f3862f3668f909509727744231a690f.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/bank-payment/archive/ff5efa0f20d7acaff653fba751c4c5116b614718.tar.gz && mkdir ./bank-payment && tar xzf ff5efa0f20d7acaff653fba751c4c5116b614718.tar.gz --strip-components=1 -C bank-payment && rm ff5efa0f20d7acaff653fba751c4c5116b614718.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/commission/archive/5c8657a4b15d8eec9ec256a007fbf7814da3fd7c.tar.gz && mkdir ./commission && tar xzf 5c8657a4b15d8eec9ec256a007fbf7814da3fd7c.tar.gz --strip-components=1 -C commission && rm 5c8657a4b15d8eec9ec256a007fbf7814da3fd7c.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/community-data-files/archive/205c561130ed4f34f734a0e1d71fb95a47d18b0b.tar.gz && mkdir ./community-data-files && tar xzf 205c561130ed4f34f734a0e1d71fb95a47d18b0b.tar.gz --strip-components=1 -C community-data-files && rm 205c561130ed4f34f734a0e1d71fb95a47d18b0b.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/l10n-spain/archive/6d524cdfdbda66931f023c74aebb9a829411d544.tar.gz && mkdir ./l10n-spain && tar xzf 6d524cdfdbda66931f023c74aebb9a829411d544.tar.gz --strip-components=1 -C l10n-spain && rm 6d524cdfdbda66931f023c74aebb9a829411d544.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/mis-builder/archive/962ad4f42d314bf17da287cf7642a17173dc945f.tar.gz && mkdir ./mis-builder && tar xzf 962ad4f42d314bf17da287cf7642a17173dc945f.tar.gz --strip-components=1 -C mis-builder && rm 962ad4f42d314bf17da287cf7642a17173dc945f.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/solvosci/Odoo-Material-Theme/archive/9c6167018f4d71c893affcc5a064d72554b25b6c.tar.gz && mkdir ./Odoo-Material-Theme && tar xzf 9c6167018f4d71c893affcc5a064d72554b25b6c.tar.gz --strip-components=1 -C Odoo-Material-Theme && rm 9c6167018f4d71c893affcc5a064d72554b25b6c.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/purchase-workflow/archive/5973bb878baba5656d08067079e07edd1ec6accc.tar.gz && mkdir ./purchase-workflow && tar xzf 5973bb878baba5656d08067079e07edd1ec6accc.tar.gz --strip-components=1 -C purchase-workflow && rm 5973bb878baba5656d08067079e07edd1ec6accc.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/reporting-engine/archive/9eb9a4248c4a08649ca6b8d6708f1fe2917f25df.tar.gz && mkdir ./reporting-engine && tar xzf 9eb9a4248c4a08649ca6b8d6708f1fe2917f25df.tar.gz --strip-components=1 -C reporting-engine && rm 9eb9a4248c4a08649ca6b8d6708f1fe2917f25df.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/sale-workflow/archive/e1149e3f39de09cf1ce5094f9ba1845d3e43eadd.tar.gz && mkdir ./sale-workflow && tar xzf e1149e3f39de09cf1ce5094f9ba1845d3e43eadd.tar.gz --strip-components=1 -C sale-workflow && rm e1149e3f39de09cf1ce5094f9ba1845d3e43eadd.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/server-ux/archive/0b60416d15691833f45c4ab240f5bdbf9e3d8aa8.tar.gz && mkdir ./server-ux && tar xzf 0b60416d15691833f45c4ab240f5bdbf9e3d8aa8.tar.gz --strip-components=1 -C server-ux && rm 0b60416d15691833f45c4ab240f5bdbf9e3d8aa8.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/solvosci/slv-hr/archive/9f2044c77bb8e2d79bfdb3e0da1913af4643805b.tar.gz && mkdir ./slv-hr && tar xzf 9f2044c77bb8e2d79bfdb3e0da1913af4643805b.tar.gz --strip-components=1 -C slv-hr && rm 9f2044c77bb8e2d79bfdb3e0da1913af4643805b.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && wget https://github.com/OCA/web/archive/7e22a6f8fe1b8ebc1053b471a07766f0fd023a61.tar.gz && mkdir ./web && tar xzf 7e22a6f8fe1b8ebc1053b471a07766f0fd023a61.tar.gz --strip-components=1 -C web && rm 7e22a6f8fe1b8ebc1053b471a07766f0fd023a61.tar.gz"

#Local addons
COPY ./aditional_addons/jackjack82.tar.gz /opt/odoo/custom-addons
COPY ./aditional_addons/slv.tar.gz /opt/odoo/custom-addons
RUN /bin/bash -c "cd /opt/odoo/custom-addons && tar xzf jackjack82.tar.gz && rm jackjack82.tar.gz"
RUN /bin/bash -c "cd /opt/odoo/custom-addons && tar xzf slv.tar.gz && rm slv.tar.gz"

# Create Virtual Enviroment
RUN /bin/bash -c "cd /opt/odoo && python3.5 -m venv venv"

# Python dependencies
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -U setuptools && pip install -r /opt/odoo/odoo/requirements.txt && pip install python-stdnum==1.8.1 && deactivate"

#OCA Dependencies
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/server-tools/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/account-financial-tools/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/community-data-files/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/reporting-engine/requirements.txt && deactivate"
RUN /bin/bash -c "cd /opt/odoo && source venv/bin/activate && pip install -r /opt/odoo/custom-addons/web/requirements.txt && deactivate"

VOLUME ["/opt/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

ENTRYPOINT ["/opt/odoo/entrypoint.sh"]