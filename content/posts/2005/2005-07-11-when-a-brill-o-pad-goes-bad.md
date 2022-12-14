---
title: When a brill-o-pad goes bad...
date: 2005-07-11
author: Andrew Matthews
ignored-tags: software, Work
slug: when-a-brill-o-pad-goes-bad
status: published
---

...sometimes you get out your brill-o-pad with the best of intentions and it all goes bad. Nitrogen has had something installed on it that disagrees with it and performance is getting progressively worse. There are a few suspects: SQL Server 2005 CTP, VS.NET 2005 beta 2, and a limitless number of other crud that oughtn't to be on there. I think that whatever it was it infected N via the settings migration wizard that XP uses to port My Docs etc between systems. This performance degradation is inherited from its previous setup.

I think this is a form of karmic punishment, for no sooner was Nitrogen reincarnated that it was beset by the ills and sins of its previous life. If only there were a way to enter the enlightened state of having a hardware platform that natively runs an emulation layer that can be saved, rolled back and otherwise fiddled with. In fact if that were the case you could have an easy way to start running VMs on third party machines (you could access them via VNC for instance). That way you could lease a clean installation with some additional storage space where you could put your data. The OS and apps could be reinstantiated for you each time you run the computer, and then connected to the the data disk that stores what you were doing last time.

I think that if the price (and performance) was right I would consider running such a virtualised machine. Especially if I could alternate between different OS's depending on my requirements.

Question: what technique could OS manufacturers use to store settings modifications? If you had a transactional file system that allowed you to rollback, you could wipe out changes if they proved to be negative. But what if you only discovered the problem after performing lots of beneficial changes? I wonder how difficult it would be to have an OS that set baselines on the file system so that you could identify a specific set of changesand excise them without removing subsequent changes as well. How much overhead would that require? Would be enormous.
