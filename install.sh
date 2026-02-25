# CONTROLLA PUNTI DI MOUNT

if (df /mnt /mnt/boot/); then
    :
else
    exit
fi

# INSALLAZIONE SISTEMA BASE
pacstrap -K /mnt/ base base-devel linux linux-firmware linux-headers grub vim efibootmgr os-prober networkmanager sddm git
