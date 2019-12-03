# Remaster Raspberry Pi Images

Tested using a laptop running Linux Mint 32-bit from a Live USB stick.

BYO raspbian image and leave with a remastered raspbian image.

# Steps

1. Boot into Linux Mint/Ubuntu on Desktop/PC
2.

```sh
#Run as root
curl -sSL https://raw.githubusercontent.com/raspberrypisig/remaster-pi-images/master/get.sh | bash -
cd remaster-pi-images
```
3. Add raspbian image (eg. 2019-09-26-raspbian-buster.img) to the directory
4. Edit config.toml
   
   At minimum, you might want to edit the ORIGINAL_IMAGE and REMASTERED_IMAGE variables.
5. Add files you want in the final image into the **files** directory
6. Add scripts you want to run inside the image container (eg. to install packages) into the **scripts** directory. There are scripts
   included by default to do an apt-update and install nodered.
7. 
```sh
#Run as root
bash remaster.sh
```
