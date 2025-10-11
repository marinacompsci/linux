# Scripts
`curl -LO https://raw.githubusercontent.com/marinacompsci/linux/refs/heads/main/install.sh`  
`curl -LO https://raw.githubusercontent.com/marinacompsci/linux/refs/heads/main/post-install.sh`  

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
4) Install cURL  
`sudo apt install curl -y`  
5) Run installation scripts  
5.1) Curl install scripts  
`curl -LO https://raw.githubusercontent.com/marinacompsci/linux/refs/heads/main/install.sh`  
`curl -LO https://raw.githubusercontent.com/marinacompsci/linux/refs/heads/main/post-install.sh`  
5.2) Make them executable  
`chmod u+x install.sh post-install.sh`  
5.3) Run them  
`./install.sh && ./post-install.sh`  
6) Setup Firefox  
6.1) Set CSS's devPixel to pixel ratio  
In **about:config** set `layout.css.devPixelsPerPx` to `1.7`  
6.2) Set Graphics WebRender to true(Videos Rendering)  
In **about:config** set `gfx.webrender.all` to `true`  
6.3) Allow for CSS customization  
In **about:config** set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`
