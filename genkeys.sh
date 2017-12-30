keyfile=keys/vagrantssh.key
if [[ ! -f $keyfile".pub" ]]; then
	rm $keyfile
	ssh-keygen -N '' -f $keyfile
	chmod 600 $keyfile
fi
ssh-add $keyfile
