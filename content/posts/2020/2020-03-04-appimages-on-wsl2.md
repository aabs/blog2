---
title: AppImages on WSL2
date: 2020-03-04
author: Andrew Matthews
tags: ["sysops"]
series: ["A Fish shell based dotfiles management framework"]
slug: appimages-on-wsl2
status: published
attachments: 2020/03/fish-logo.png
---

This is a reminder to self, for those times when you just gotta have  `vim` and
`fishdots` on a recent version of  `fish` shell (and someone upstream has
completely screwed up the CA certificates so you can't use  `apt` or linux `brew `
because they can't be configured to relax cacert security).

First, create a place for them to live

```
mkdir -p ~/bin; cd /tmp
```

Now get fish shell

```
wget --no-check-certificate https://download.opensuse.org/repositories/shells:/fish:/nightly:/master/AppImage/fish-latest-x86_64.AppImage
chmod a+x fish-latest-x86_64.AppImage
./fish-latest-x86_64.AppImage --appimage-extract
mv ./squashfs-root/ ~/bin/fish_root
abbr -a fish ~/bin/fish_root/AppRun
```

Then download neovim

```
wget --no-check-certificate
https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
mv ./squashfs-root/ ~/bin/nvim_root
abbr -a nvim ~/bin/nvim_root/AppRun
```

Lovely. Now you have the one true shell and the one true editor. All's well with the world.
