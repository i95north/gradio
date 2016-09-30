# Gradio
A GTK3 app for finding and listening to internet radio stations.

<p align="center">
  <img alt="Library View" src="http://i.imgur.com/AN4df36.png" />
</p>


## Install Gradio

### Ubuntu 
A PPA is available. Gradio needs Ubuntu 16.04 or higher.

[More details](https://code.launchpad.net/~haecker-felix/+archive/ubuntu/gradio-daily)


### Fedora
A copr is available. Gradio needs Fedora 24 or higher.

[More details](https://copr.fedorainfracloud.org/coprs/heikoada/gradio/)


### openSUSE 
Gradio is available in the official openSUSE repository. 


### Arch Linux
Gradio is available in the AUR. 

[More details](https://aur.archlinux.org/packages/?O=0&K=Gradio)


### Other 
For unsupported distributions you can install gradio from source:

```bash
cd ~/Downloads
git clone https://github.com/haecker-felix/gradio.git
cd gradio
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX= usr ..
make
sudo make install
```

## Releases
All Gradio releases can be found [here](https://github.com/haecker-felix/gradio/releases)


## FAQ

### A station is missing. How I can add a new station to the database?
It is possible to add new stations here: 

http://www.radio-browser.info

In a further release of gradio it will be easier to add new stations.


### A feature is missing. Can you add it?
Maybe. Open a new Github issue and I'll look at it.


### Why is there no ubuntu 14.04 support?
Gradio needs GTK 3.18 or higher. Ubuntu 14.04 provides GTK 3.12 which is definitely too old. 


### Does a flatpak/snap exist?
Not yet, but soon!


## Technical Details
### Dependencies
For gradio:
* glib-2.0
* gtk+-3.0 _>=3.18_
* gstreamer-1.0
* json-glib-1.0
* gio-2.0
* gee-0.8
* libsoup-2.4

For compiling:
* General c/c++ libs & compiler
* cmake
* git