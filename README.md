# Easing_ReaScript
Draw easing function envelope for reaper.

I write it for learning purposes.
Probably useful for creating sound effects for movies and games, and for various music compose.

![GIF](https://github.com/crackerjacques/Easing_ReaScript/blob/main/011_0.gif?raw=true)


# How to Use

Download or clone this repo.

```
git clone https://github.com/crackerjacques/Easing_ReaScript.git
```

import lua files  from

__Actions -> Show Action List -> New Action -> Load ReaScript__

That's all. enjoy!

# Appendix

If you want to use the toolbar, import the Reamenu file in the toobar dir.

There are also icons for toolbars, so copy the contents of the toobar_icons dir to your toorbar_icons folder if necessary.


SendOSC.lua does not work on Windows.
To run SendOSC.lua

__For Mac or Linux__

```
brew install sendosc
```


or visit this repository.
https://github.com/yoggy/sendosc

In some cases, a symbolic link to /usr/local/bin is required.
