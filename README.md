# Auguste Baum's personal website

This is the source code for my personal website,
[augustebaum.com](https://augustebaum.com).
For now, the website is hosted on 
[augustebaum.github.io](https://augustebaum.github.io).

It is built with [Hugo](https://gohugo.io) along with my custom version
of the [cactus theme](https://github.com/monkeyWzr/hugo-theme-cactus).

## TODO

- [ ] Move introduction paragraph to "About" page
- [ ] Make intro paragraph one sentence (e.g. what I'm up to right now)
- [ ] Remove "Tags" section
- [ ] Update "Socials" section
- [ ] Add CV section/add CV info to "About" page
- [ ] Adapt GH Pages workflow to move site to [augustebaum.com](https://augustebaum.com)

## Hacking
The site can be built by running
```sh
hugo
```
in your shell, in the root directory.

You can also run
```sh
hugo serve
```
to have the site served locally and reloaded whenever you make
a change to the code. If you use this, I recommend using a
browser with "incognito mode" or equivalent to deactivate caching
of resources. This will ensure that the site is rebuilt with
only the new information (e.g. when you change an image).

Run
```sh
hugo help
```
or see the [online Hugo docs](https://gohugo.io) for more information.
