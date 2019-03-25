#Change config.ini
salt 'usmainnet*prdr0?' cmd.run 'cp /ext/config/sjlive.config.ini /ext/config/config.ini'
echo "changed to SJLIVE"
