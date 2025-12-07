distrobox create --name debian13 \
--image debian:13 \
--init \
--additional-packages "systemd libpam-systemd"

distrobox create --name arch \
--image archlinux:latest \
--init \
--additional-packages "systemd git"