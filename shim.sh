
#!/usr/bin/env bash
set -x

# Run as root

touch 2019-09-26-raspbian-buster-lite.img 
mount --bind ../2019-09-26-raspbian-buster-lite.img 2019-09-26-raspbian-buster-lite.img  
bash remaster.sh
umount 2019-09-26-raspbian-buster-lite.img 
