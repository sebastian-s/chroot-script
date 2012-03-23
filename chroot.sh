#!/bin/zsh

#Copyright (c) 2012 Sebastian Simon

#Permission is hereby granted, free of charge, to any person obtaining a copy of
#this software and associated documentation files (the "Software"), to deal in
#the Software without restriction, including without limitation the rights to
#use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
#of the Software, and to permit persons to whom the Software is furnished to do
#so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.


# Script um nach Gentoo HARDENED nach '/mnt/gentoo' zu mounten,
# danach werden /dev, /proc und /sys gemountet und chroot
# ausgeführt.


# Überprüfen ob /mnt/gentoo existiert, wenn nicht erzeugen
echo "Überprüfen ob '/mnt/gentoo' existiert..."
if [-d /mnt/gentoo ]
then
    echo "Ordner '/mnt/gentoo' existiert und wird verwendet..."
else
    echo "Ordner '/mnt/gentoo' wird erstellt und verwendet..."
    md /mnt/gentoo
fi

# mounten der Laufwerke
echo "Laufwerke einhängen..."

# Das root-Lfw (/dev/sdb4)
mount -o noatime,discard UUID="b5632168-fd83-423e-92ea-e36b59055ea4" /mnt/gentoo &&
# Der portage-tree (dev/vg_raid5/portage_tree)
mount -o noatime UUID="962ca6aa-cd07-402b-9848-21ebe3c43b38" /mnt/gentoo/usr/portage &&
# Das /boot-Lfw (/dev/sdb2)
mount -o noatime,discard UUID="01f75b97-df45-4ff5-be55-6bc5753132ca" /mnt/gentoo/boot &&
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
        chroot /mnt/gentoo /bin/zsh &&
    else
        echo "BASH wird verwendet..."
        chroot /mnt/gentoo /bin/bash &&
fi
echo "...Fertig"

# unmounten der Laufwerke (Reihenfolge beachten)
echo "Spezialordner und Laufwerke aushängen..."
umount -l /mnt/gentoo/sys &&
umount -l /mnt/gentoo/proc &&
umount -l /mnt/gentoo/dev &&
umount -l /mnt/gentoo/usr/portage &&
umount -l /mnt/gentoo/boot &&
umount -l /mnt/gentoo &&
echo "...Fertig"

# entfernen von /mnt/gentoo
echo "Ordner '/mnt/gentoo' entfernen..."
rm /mnt/gentoo
echo "...Fertig"
