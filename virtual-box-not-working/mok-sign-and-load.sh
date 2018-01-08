#!/bin/bash

#Uncomment to make sure this runs as root
[ "`whoami`" = root ] || exec sudo "$0" "$@"

# Setting env KBUILD_SIGN_PIN for encrypted keys
echo "You need the passphrase you used to secure the modeule signing key"
echo "If you can;t remember it you will need to run mok-keygen.sh to"
echo "generate a new pair, and enroll the public key with secure boot"

printf "Enter the passphrase protecting the module signing key : "; read -s
export KBUILD_SIGN_PIN="$REPLY"

# Sign and load modules
for module in vboxdrv vboxnetflt vboxnetadp vboxpci; do
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n $module)
    printf "$module: "
    echo `hexdump -e '"%_p"' $(modinfo -n $module) | tail | grep signature`
    modprobe $module && echo -e "\e[92m$module successfully loaded\e[0m" || echo -e "\e[91mFailed to load $module, s the public key enrolled with secure boot?\e[0m"
done

