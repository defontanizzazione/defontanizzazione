# CONTROLLA PUNTI DI MOUNT

if (df /mnt /mnt/boot/); then
    :
else
    exit
fi

# INSALLAZIONE SISTEMA BASE
pacstrap -K /mnt/ base base-devel linux linux-firmware linux-headers grub vim efibootmgr os-prober networkmanager sddm git

# MODIFICA DI SUDOERS PER ABILITARE SUDO
touch /mnt/etc/sudoer
sed 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers > /mnt/etc/sudoer
rm /mnt/etc/sudoers
mv /mnt/etc/sudoer /mnt/etc/sudoers
