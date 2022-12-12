---
title: Note To Self - How to Reclaim Disk Space in a Hurry (Windows 10)
date: 2021-10-20
tags: ["sysops"]
---

When you suddenly discover that your disk is full, consider doing the following:

1. Work out where the disk is being used, with tree size free

```
$ cinst -y treesizefree
```

2. If you don't use hibernation on your machine you could save a lot of space by turning it off
```
$ powercfg.exe /hibernate off
```

3. Compact the WSL disk if you use WSL

```
$ wsl --shutdown
$ optimize-vhd -Path "C:\Users\a30006806\AppData\Local\Docker\wsl\data\ext4.vhdx" -Mode full
```

4. Purge unwanted docker images and containers

```
$ docker system prune
```

If that still doesn't reclaim enough space, then there is the '*nuclear options*', described [here](https://marcroussy.com/2020/12/01/cleaning-up-docker-disk-space-in-wsl2/) by Marc Roussy.

Enjoy