#!/bin/bash

# Controlla defontanizzazione
testdir="$PWD"

if [[ $testdir == /mnt/defontanizzazione ]]; then
    :
else
    echo "non si fa"
fi

# Controlla se root è montato

if (df /mnt /mnt/boot/); then
    :
else
    echo "no mountpoints"
    exit
fi

copy_configs () {
    # sddm
    mkdir -p /mnt/etc/sddm.conf.d/
    cp kde_settings.conf /mnt/etc/sddm.conf.d/

    # grub
    cp -r openSUSE /mnt/usr/share/grub/themes
    rm /mnt/etc/default/grub
    cp grub /mnt/etc/default/

    # pacman
    rm /mnt/etc/pacman.conf
    mv pacman.conf /mnt/etc/

    # zsh
    cp .zshrc /home/user/

    # sfondi
    rm -rf /mnt/usr/share/wallpapers/Next
    cp -r wallpapers/* /mnt/usr/share/wallpapers
    touch /mnt/usr/share/look-and-feel/org.kde.breeze.desktop/metadata.json.tmp
sed 's/Next/openSUSEdefault/g' /mnt/usr/share/look-and-feel/org.kde.breeze.desktop/metadata.json > /mnt/usr/share/look-and-feel/org.kde.breeze.desktop/metadata.json.tmp
    cat /mnt/usr/share/plasma/look-and-feel/org.kde.breeze.desktop/metadata.json.tmp > /mnt/usr/share/plasma/look-and-feel/org.kde.breeze.desktop/metadata.json
    rm /mnt/usr/share/plasma/look-and-feel/org.kde.breeze.desktop/metadata.json.tmp

}

install_packages () {
    arch-chroot /mnt bash -c "pacman -Sy flatpak --noconfirm && flatpak install flathub com.visualstudio.code -y"
    arch-chroot /mnt bash -c 'pacman -Sy plasma konsole dolphin firefox kcalc kcharselect kmines git unzip vlc doxygen wireshark-qt tigervnc gimp jdk11-openjdk libreoffice-still ark kate kleopatra kmousetool kompare spectacle ktnef kmag ksudoku kreversi kmahjongg gwenview okular skanlite kmail konversation kwalletmanager plymouth netbeans power-profiles-daemon --noconfirm'
}

# Installazione sistema base
pacman -Sy archlinux-keyring --noconfirm --needed
pacstrap -K /mnt/ base base-devel linux linux-firmware linux-headers grub vim efibootmgr os-prober networkmanager sddm git zsh

# Modifica di visudo per consentire l'accesso a sudo per utenti non-root
sed 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers > /mnt/etc/sudoers.tmp
cat /mnt/etc/sudoers.tmp > /mnt/etc/sudoers
rm /mnt/etc/sudoers.tmp

install_packages
copy_configs

arch-chroot /mnt bash -c 'grub-install --efi-directory=/boot/ && grub-mkconfig -o /boot/grub/grub.cfg'

# Installazione pacchetti

# Comandi per rendere il sistema "usabile"
arch-chroot /mnt bash -c 'systemctl enable sddm && systemctl enable NetworkManager && useradd -m -G wheel -s /usr/bin/zsh user && chpasswd < /defontanizzazione/passwords.txt'
genfstab -U /mnt > /mnt/etc/fstab


# Locali
# en_US.UTF-8

sed 's/#en_US.UTF-8/en_US.UTF-8/g' /mnt/etc/locale.gen > /mnt/etc/locale.gen.tmp
cat /mnt/etc/locale.gen.tmp > /mnt/etc/locale.gen
rm /mnt/etc/locale.gen.tmp

# it_IT.UTF-8

sed 's/#it_IT.UTF-8/it_IT.UTF-8/g' /mnt/etc/locale.gen > /mnt/etc/locale.gen.tmp
cat /mnt/etc/locale.gen.tmp > /mnt/etc/locale.gen
rm /mnt/etc/locale.gen.tmp

arch-chroot /mnt bash -c 'locale-gen'
arch-chroot /mnt bash -c 'systemd-firstboot --locale=it_IT.UTF-8 --locale-messages=it_IT.UTF-8 --keymap=it'
ln -sf ../mnt/usr/share/zoneinfo/Europe/Rome /mnt/etc/localtime

echo "finito, fai 'reboot' per continuare"

# Magari eviterei di fare il reboot automatico con lo stato in qui è questo script rn
# reboot
