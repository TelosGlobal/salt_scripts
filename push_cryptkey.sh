#Copy the cryptkey file to a target server
sudo salt-key
read -p "What is the target server?: " target
echo "Copying .gitattributes to $target..." 
sudo salt $target cp.get_file salt://crypt/.gitattributes /root/bootstrap/.gitattributes makedirs=True
echo "Done."
echo "Copying the cryptkey to $target..." 
sudo salt $target cp.get_file salt://crypt/cryptkey /root/bootstrap/cryptkey makedirs=True
echo "Done."
