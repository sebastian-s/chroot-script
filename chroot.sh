#!/bin/zsh

# Script um nach Gentoo HARDENED nach '/mnt/gentoo' zu mounten,
# danach werden /dev, /proc und /sys gemountet und chroot
# ausgeführt.

# mounten der Laufwerke
echo "Laufwerke einhängen..."
mount -O noatime,discard UUID="b5632168-fd83-423e-92ea-e36b59055ea4" /mnt/gentoo &&      # Das root-Lfw (/dev/sdb4)
mount -O noatime UUID="d541458a-70b4-4a94-b3d8-c48a3119d01d" /mnt/gentoo/usr/portage &&  # Der portage-tree (dev/vg_182tib/portage_tree)
mount -o noatime,discard UUID="01f75b97-df45-4ff5-be55-6bc5753132ca" /mnt/gentoo/boot && # Das /boot-Lfw (/dev/sdb2)
echo "...Fertig"

# mounten der Spezialordner
echo "Spezialordner einhängen..."
mount -t proc proc /mnt/gentoo/proc &&
mount -t sysfs /sys /mnt/gentoo/sys &&
mount --rbind /dev /mnt/gentoo/dev &&
echo "...Fertig"

# chroot ausführen (bevorzugt mit ZSH, sonst mit BASH)
echo "chroot ausführen..."
if [ -e /mnt/gentoo/bin/zsh ]
	then
		echo "ZSH gefunden und wird verwendet..."
		chroot /mnt/gentoo /bin/bash &&
	else
		echo "BASH wird verwendet..."
		chroot /mnt/gentoo /bin/bash &&
fi
echo "...Fertig"

# unmounten der Laufwerke (Umgekehrte Reihenfolge beachten!)
echo "Spezialordner und Laufwerke aushängen..."
umount -l /mnt/gentoo/sys &&
umount -l /mnt/gentoo/proc &&
umount -l /mnt/gentoo/dev &&
umount -l /mnt/gentoo/usr/portage &&
umount -l /mnt/gentoo/boot &&
umount -l /mnt/gentoo &&
echo "...Fertig"
echo ""
echo "UND RAUS"
