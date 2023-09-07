#!/bin/sh

. /opt/odoo/venv/bin/activate && python3.5 /opt/odoo/odoo/odoo-bin -c /opt/odoo/odoo.conf -d odoo-11

#Extra line added in the script to run all command line arg uments
exec "$@";
