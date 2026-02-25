# CONTROLLA PUNTI DI MOUNT

if (df /mnt /mnt/boot/); then
    :
else
    exit
fi

# INSALLAZIONE SISTEMA BASE
pacman -Sy archlinux-keyring --needed
pacstrap -K /mnt/ base base-devel linux linux-firmware linux-headers grub vim efibootmgr os-prober networkmanager sddm git

# MODIFICA DI SUDOERS PER ABILITARE SUDO
sed 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers > /mnt/etc/sudoers.tmp
cat /mnt/etc/sudoers.tmp > /mnt/etc/sudoers
rm /mnt/etc/sudoers.tmp

# MODIFICA DEI LOCALI
# en_US.UTF-8

sed 's/#en_US.UTF-8/en_US.UTF-8/g' /mnt/etc/locale.gen > /mnt/etc/locale.gen.tmp
cat /mnt/etc/locale.gen.tmp > /mnt/etc/locale.gen
rm /mnt/etc/locale.gen.tmp

# it_IT.UTF-8

sed 's/#it_IT.UTF-8/it_IT.UTF-8/g' /mnt/etc/locale.gen > /mnt/etc/locale.gen.tmp
cat /mnt/etc/locale.gen.tmp > /mnt/etc/locale.gen
rm /mnt/etc/locale.gen.tmp

arch-chroot /mnt locale-gen && localectl set-locale it_IT.UTF-8 && localectl set-keymap it

ln -sf ../mnt/usr/share/zoneinfo/Europe/Rome /mnt/etc/localtime

# SETUP ROBE BOH
# SDDM

mkdir -p /mnt/etc/sddm.conf.d/
cp kde_settings.conf /mnt/etc/sddm.conf.d/

#GRUB

cp openSUSE /mnt/usr/share/grub/themes
rm /mnt/etc/default/grub
mv grub /mnt/etc/default/

arch-chroot /mnt grub-install --efi-directory=/boot/ && grub-mkconfig -o /boot/grub/grub.cfg
