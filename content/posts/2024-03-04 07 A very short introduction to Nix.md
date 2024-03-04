---
title: A very short introduction to Nix
date: 2024-03-04
keywords:
  - nix
---
This post is adapted from a talk I gave at my place of work to convince them to try Nix for managing our projects' dependencies and deployment. It absolutely didn't work---make of that what you will.

## What is this thing called Nix?

This is usually the most confusing part. Nix is an ecosystem of tools centered on making things declarative (you describe what you want, not how to get it---think SQL or HTML) and reproducible (your project will still run with the same setup in 10 years, if all goes well).

The Nix Holy Trinity can be summed up in this image:
<figure>
   <img src="../assets/nix-trinity.svg" alt="The Nix trinity: 'Nix' in the center, 'Nixlang' above, 'NixPM' in the bottom left and 'NixOS' in the bottom right"/>
   <figcaption>The Nix trinity</figcaption>
</figure>

Allow me to present each part in more detail.

### Nix, the language

Nix first refers to a particular programming language, also called Nixlang, which can be described succinctly as "JSON with functions".
More precisely, it's a declarative, functional programming language, and it is a user's main way of interacting with the Nix ecosystem (e.g. through a REPL and by writing Nix into files).
Here's a sample of Nix code for your enjoyment:

```nix
{
  aList = [ 1 2 "hey" ]; # a list can contain things with different types

  anAttrSet = { # an attribute set is like a dictionary, but the keys must be strings
    "a" = 1;
    b = 2; # if the key is a literal, you don't need quotes
  };
  # notice this whole snippet is one big attribute set

  # you can define attribute sets by parts, the order doesn't matter
  anotherAttrSet.b = 4;
  anotherAttrSet.a = 3;

  # a function is a lambda first and foremost
  aFunction = x: x + 1;
  # functions are made to be curried
  anotherFunction = x: y: x + y;

  # you can interpolate strings
  name = "auguste";
  aString = "hello ${name}!"; # "hello auguste!"
  # ...in cool places!
  anotherAttrSet."${name}" = "hello!";

  # so in the end, the key `anotherAttrSet` maps to
  # {
  #   a = 3;
  #   auguste = "hello!";
  #   b = 4;
  # }
}
```

### Nix, the package manager

Installing Nix on your machine means you can use it to download and install packages from the internet, like Homebrew, Chocolatey, etc. However, it's not exactly the same: Nix packages don't necessarily have to be "installed" on your machine.

For example, I never use Inkscape, so I don't feel the need to do the full install process on my machine. But I wanted to use it to edit the Nix-trinity diagram, and so I ran:
```sh
nix-shell -p inkscape --run inkscape
```
Inkscape got downloaded and started up, I did my drawing and when I closed Inkscape, it was no longer on my machine. No worrying about keeping trash around that gobbles my precious disk space!
Well, actually this is only half true: Inkscape is still on my machine because this way, if I need to change the drawing, I'll save time and resources by not having to download Inkscape all over again.
But it's not "installed" in the sense that the icon is not shown on my desktop, and it will eventually be removed by my computer if I never use it.

This example brings me to Nixpkgs, the fourth member of the Nix trinity! Nixpkgs (pronounced "Nix packages") is a centralized repository of recipes for building software with Nix. For example, in the earlier command, I asked Nix to go look for Inkscape in Nixpkgs. In that respect it is similar to the AUR.
Nix doesn't require a central repository to exist; plenty of people are serving their packages through their own means. Yet, in a Nix user's day-to-day, Nixpkgs is the main point of interaction, for good reason: it provides an extensive collection of popular software, packaged with a high standard for documentation and comprehensively cached so that you barely ever have to build software on your machine.

Over time, the number of packages available through Nixpkgs has grown exponentially, to the point where as of writing, it is the largest repository of its kind with more than 90000 packages; the AUR is in second place with 76000 packages. If you count only up-to-date packages, Nixpkgs is still in first place with 60000 packages, while the AUR is still second with 24000 packages.[^1]
Finally, it has been shown that the package recipes in Nixpkgs still allow building "old" software.[^2]

[^1]: https://repology.org/
[^2]: [Malka et al., Reproducibility of Build Environments through Space and Time](https://arxiv.org/abs/2402.00424)

### Nix, the OS

Usually called NixOS, this is a Linux distribution that leverages Nix to achieve reproducibility at the infrastructure level. On NixOS, there is a file, `configuration.nix`, that describes how the machine you're in should be set up. For example, in it you can declare a list of packages you want installed on the machine (e.g. Git, SSH, vim), but you can also declare which desktop environment to use, configure your [network settings](https://search.nixos.org/options?channel=23.11&from=0&size=50&sort=relevance&type=packages&query=networking), what port some website should be served at...

## Why do I use Nix?

As you might have gathered, Nix is not a singular tool; it is a collection of many interconnected pieces of software. Thus, different Nix users might take advantage of different parts of the ecosystem, depending on their use-case. This section is about how *I* use Nix, and why I find it serves my use-case really well.

### It makes my day-to-day life easier

#### My configuration is centralized

I am kind of a control freak when it comes to my personal machines, and NixOS gives me that level of control.
Whenever I start wanting to configure a program, I'll reach for Nix to do so. Essentially, I have a single repository containing all of those configuration files, usually written in Nix, although you can often bootstrap the process by importing a pre-existing config file.
In particular, this allows me to re-use configuration transparently across programs: for example, I can put my bookmarks in some file, and that file can be read when computing the configuration for both Qutebrowser and Firefox.

#### I can easily try out software in a contained way

There are many ways to install software on a Nix-enabled system; which one you reach for depends on your use-case.
1. `nix-shell` can be used to drop yourself into a shell with the specified software installed.
```sh
# Here we are in our trusty shell
$ python3
The program 'python3' is not in your PATH. It is provided by several packages...

# Perform the magic incantation:
$ nix-shell -p python3

  # Now we're in a bash sub-shell, and...
  [nix-shell:~]$ python3
  Python 3.10.12 (...)
  >>> print("Python is installed!")
  Python is installed!
  
# Exit the sub-shell, and Python is no more
$ python3
The program 'python3' is not in your PATH. It is provided by several packages...
```
2. The nix-shell shebang (`#! /usr/bin/env nix-shell`) can be used in scripts; for example the following script is fully self-sufficient and I can run it just by putting it in some `script.py` file and executing it, with the guarantee that the versions are always the same:
```python
#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.requests
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/23.11.tar.gz

import requests

r = requests.get("https://google.com")
print(r.status_code)
# Should print 200
```
3. `shell.nix` is where you put your dependencies in your projects when you have more than one script and running `nix-shell -p python3Packages.package1 python3Packages.package2 python3Packages.package3 ...` all the time starts to get old. Think of it like `package.json` for NPM, or `requirements.txt` for Python---except it works for any project and can do more generic things like install Python or define environment variables.

No fear of installing junk that I'll never be able to remove, or of forgetting how to get set up to hack on a project.

### It makes me more confident with many things

#### It addresses the "Works on my machine" conundrum

By and large, if you have a piece of Nix code working on one NixOS machine, you can make it run on another NixOS machine and be reasonably sure that everything will work the same. This is really nice, say, for software engineering teams that need to ensure they all use the same tooling. But it is **really** nice for guaranteeing that several machines are running the same software, e.g. your production server and your staging server. That eliminates a host of problems which I feel should have been solved long ago.

As a side-note, during a research project I tried to replicate some results in an academic paper. The paper linked to a GitHub repository; "Yes," I exclaimed, "finally researchers that can actually *prove* that the results in their paper are genuine!"
I should have held my tongue: the repository contained some Python code, yes, but all I could find in terms of reproducibility was a `requirements.txt` with no versions, and it turned out it was out-of-date and thus of no use. I tried reverse-engineering the versions by correlating the commit dates of each package, but quickly gave up in disgust.

#### I don't forget what's installed on my machine anymore

As recently as two weeks ago, I migrated my Nextcloud server to NixOS from Debian. I was so scared of forgetting things when I did the migration: I had been running the Debian server for several years with no issues, but I had no recollection of ever setting it up. Even just SSH-ing into the machine made me stressed out, like I was walking into a house with a bunch of fragile stuff and having to second-guess every step I took.
Now, the configuration for my whole server is saved in a single directory in my Nix files; if I wanted to set up a new server, I could just download the config onto it and press a button. Not even that: you can update a machine's configuration remotely if you have SSH access, so you don't even have to go into it.

#### My system is never broken

In Nix/NixOS, modifications are organized into atomic "generations". When you deploy a new generation, say you're at generation $N$ and would thus go to $N+1$, if something fails, you'll just end up in generation $N$ again, free to correct your mistakes and try again. If you only find out too late that something is wrong, you can reboot, and decide *at boot time* which generation you want.
I have a tiny gripe with this though: generations are described by numbers by default, and Nix can't tell me the difference between two generations easily. I've seen people in videos addressing this with Git, automating the update process so that each generation is associated with a commit.[^3] 

[^3]: [No Boilerplate's take on this](https://www.youtube.com/watch?v=CwfKlX3rA6E&t=458s)

## Wait a minute, how is that different from Docker?

Just a word on this because this is often the first question I get when presenting Nix.
1. Docker is not reproducible unless you work hard for it: for example `ubuntu:latest` won't mean the same thing in 5 years as it does now.
2. Nix makes it easy to compose small modules, kind of like docker-compose. However, I've found it messy to share information between different parts of a `docker-compose.yml` file, as you mostly rely on environment variables. By contrast, Nix gives you the flexibility of a full programming language and just feels less clunky. Although, I'll admit I definitely have more experience with Nix than Docker at this point, so I'm still waiting to be proven wrong.
3. Nix is logically superior to Docker, in that [you can generate Docker images using Nix](https://nix.dev/tutorials/nixos/building-and-running-docker-images.html).

See also [Matthew Croughan's "Use flake.nix, not Dockerfile"](https://www.youtube.com/watch?v=0uixRE8xlbY).

## In conclusion

Thanks for reading all this. If you have questions or comments, consider sending me an [email](mailto:auguste.apple@gmail.com) or contacting me on [Mastodon](https://fosstodon.org/@augustebaum). Ta-ta!
