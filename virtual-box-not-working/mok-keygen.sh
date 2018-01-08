#!/bin/bash

# Setting env KBUILD_SIGN_PIN for encrypted keys
echo "You are going to provide a password to encrypt the signing certificate"
echo
printf "Provide a passphrase to encrypt the private key : "; read -s
export SIGN_PIN_1="$REPLY"
echo
printf "Repeat the passphrase to encrypt the private key : "; read -s
export KBUILD_SIGN_PIN="$REPLY"

if [ $SIGN_PIN_1 != $KBUILD_SIGN_PIN ]
then
    echo
    echo "Passphrase does not match, exiting"
    exit 1
fi

openssl req -new -x509 -newkey rsa:2048 -passout env:KBUILD_SIGN_PIN -keyout MOK.priv -outform DER -out MOK.der -days 36500 -subj "/CN=PJW Locally signed vbox drivers/"

sudo mokutil --import MOK.der
