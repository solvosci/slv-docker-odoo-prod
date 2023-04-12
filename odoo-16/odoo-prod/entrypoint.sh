#!/bin/sh

. /opt/odoo/venv/bin/activate && /opt/odoo/odoo/./odoo-bin -c /opt/odoo/odoo.conf -d odoo-16

#Extra line added in the script to run all command line arg uments
exec "$@";
