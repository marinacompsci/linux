# Download
`curl -LO https://raw.githubusercontent.com/marinacompsci/linux/refs/heads/main/linux.sh`

## TODOS
1) Add current user to sudo group as root  
1.1) Become root while keeping current PATH  
`su -`  
1.2) Add user to sudo group  
`usermod -aG sudo <username>`  
2) Reboot  
`sudo reboot now`  
3) Remove iso DVD image from debian's sources.list(or else apt install won't work without the image being attached)  
`sudo vi /etc/apt/sources.list`  
4) Install curl  
`sudo apt install curl -y`  
5) Run installation script  
5.1) Curl script  
`curl -LO https://raw.githubusercontent.com/marinacompsci/linux/refs/heads/main/linux.sh`  
5.2) Make it executable  
`chmod u+x linux.sh`  
5.3) Run it  
`./linux.sh`  
6) Setup Firefox's font-size  
In **about:config** set `layout.css.devPixelsPerPx` to `2.0`  
