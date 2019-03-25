#Change config.ini
salt 'usmainnet*prdr0?' cmd.run 'cp /ext/config/nylive.config.ini /ext/config/config.ini'
echo "changed to NYLIVE"
