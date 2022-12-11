---
title: Fishdots Rewritten
---

Fishdots v1 and its plugins were groaning under their own weight. It's in-memory
function definitions model, inherited from before it was even a fishy thing, led
to some serious load time lag. Combine that with extensive use of tmux, and you
have a recipe for frustration!

The repo [fishdots2](http://github.com/aabs/fishdots2) ports everything over to
use the inate autoloading capabilities of fish shell. In the process of the
rewrite, I've taken the chance to break it up, and make it simpler and more
clearly focused.

It now has these roles:

1. auto-run user and machine supplied dotfiles during shell startup
2. provide logging functions
3. simple autoenv style functionality
4. simple file finding, selection and searching

Everything else that it used to do is now gone.  This includes installers, plugin commands etc.  In future just use fisher or omf.  It's still needed as a common foundation for the other plugins, and may help you if you plan to make some fish shellplugins of you own.

Over the next few weeks, expect more plugins to be released, as I port existing fishdots v1 plugins over.