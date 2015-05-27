#!/bin/bash

# This script maps PO and POT files to transifex ressources
# on https://transifex.mandriva.com

if [[ ! -d core && ! -d mds && ! -d pulse2 ]]; then
	echo "Run this script at the top dir of the repository"
	exit 1
fi

which tx > /dev/null
if [ $? -ne 0 ]; then
	echo "Install the transifex client v0.4 (pip install transifex-client==0.4)"
	exit 1
fi

test -d .tx || tx init --host=https://transifex.mandriva.com

mmc_modules="base ppolicy services dashboard report report-templates"
mds_modules="bulkimport mail network proxy samba sshlpk userquota shorewall squid radius"
pulse2_modules="dyngroup glpi imaging inventory msc pkgs pulse2 backuppc update support"

dir=`pwd`

cd core/web
bash scripts/build_pot.sh
cd $dir

for mod in $mmc_modules
do
	tx set --execute --auto-local -r mds.$mod -s en -f core/web/modules/$mod/locale/$mod.pot "core/web/modules/$mod/locale/<lang>/LC_MESSAGES/$mod.po"
done

cd core/agent
bash scripts/build_pot.sh
cd $dir

tx set --execute --auto-local -r mds.report-templates -s en -f core/agent/mmc/plugins/report/locale/templates.pot "core/agent/mmc/plugins/report/locale/<lang>/LC_MESSAGES/templates.po"

cd mds/web
bash scripts/build_pot.sh
cd $dir

for mod in $mds_modules
do
	tx set --execute --auto-local -r mds.$mod -s en -f mds/web/modules/$mod/locale/$mod.pot "mds/web/modules/$mod/locale/<lang>/LC_MESSAGES/$mod.po"
done

cd pulse2/web
bash scripts/build_pot.sh
cd $dir

for mod in $pulse2_modules
do
	tx set --execute --auto-local -r pulse2.$mod -s en -f pulse2/web/modules/$mod/locale/$mod.pot "pulse2/web/modules/$mod/locale/<lang>/LC_MESSAGES/$mod.po"
done

echo ""
echo "Setup complete. You can now push/pull translations from transifex for the following ressources:"
for mod in $mmc_modules; do echo "- mds.$mod"; done
for mod in $mds_modules; do echo "- mds.$mod"; done
for mod in $pulse2_modules; do echo "- pulse2.$mod"; done

echo ""
echo "See help.transifex.net/features/client/index.html for details."
