#!/bin/sh

# Generate host keys if not present.
ssh-keygen -A

# Check wether a random root-password is provided.
if [ ! -z "${ROOT_PASSWORD}" ] && [ "${ROOT_PASSWORD}" != "root" ]; then
	echo "root:${ROOT_PASSWORD}" | chpasswd
fi

# Do not detach (-D), log to stderr (-e), passthrough other arguments.
exec /usr/sbin/sshd -D -e "$@"
