#!/bin/bash
USERNAME=d3v0psag3nt1
PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHL/8oGFziO2X/AfsnjA51PYp1Ba5ayrHj/5nrYYAa35 devopsone@mojocreator"

help()
{
   # Display Help
   echo
   echo "Fill Up the USERNAME and PUBKEY variable inside the script and then run the script"
   echo "Syntax: ./add_user.sh"
   echo
}

check()
{
   # Check if the username parameter is provided or not
   if [ -z "$USERNAME" ];
   then
   help
   exit
   fi
}

add_user()
{
   useradd $USERNAME --create-home --home-dir /home/$USERNAME --shell /bin/bash

   echo "$PASSWORD
$PASSWORD" | passwd $USERNAME

   usermod -aG wheel $USERNAME || usermod -aG sudo $USERNAME
   cd /home/$USERNAME
   mkdir -p .ssh
   chmod -R go= .ssh
   cd .ssh
   echo "$PUBKEY" >> authorized_keys
   chown -R $USERNAME:$USERNAME /home/$USERNAME
}

passwordless_sudo()
{
   cat /etc/sudoers > /tmp/sudoers
   sed -i -E 's/^%wheel.+$/%wheel    ALL=(ALL)   NOPASSWD: ALL/g' /tmp/sudoers
   sed -i -E 's/^%sudo.+$/%sudo  ALL=(ALL)   NOPASSWD: ALL/g' /tmp/sudoers
   if visudo -cf /tmp/sudoers;
   then
      mv -f /tmp/sudoers /etc/sudoers
   fi
}

check && add_user && passwordless_sudo

