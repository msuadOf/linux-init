mount -o subvol=/ -U 4aa4c9c0-b7f4-4230-852c-db3fde6bec52 /mnt

# 然后我们需要在 /mnt 下新建一个子卷 
# (比如 root 分区建议起名 @ ，home 分区的话建议起名 @home)，
# 然后把根目录的文件迁移进去。
# 幸运的是我们可以通过快照功能来方便快速（几乎不消耗时间和空间）的完成这项工作：

btrfs subvol snapshot /mnt /mnt/@
touch /mnt/@/"$(date)"
umount /mnt

#=====
btrfs subvol set-default xx /
mount -o subvolid=xx -U 4aa4c9c0-b7f4-4230-852c-db3fde6bec52 /mnt
mount -o bind /dev /mnt/dev                        
mount -o bind /proc /mnt/proc                      
mount -o bind /sys /mnt/sys
mount -o bind /boot /mnt/boot
chroot /mnt