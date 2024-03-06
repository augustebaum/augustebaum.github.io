---
title: Nix for Python, attempt number 1
date: 2023-05-16 00:15:00
keywords:
  - nix
  - python
---
Disclaimer: This is less of a tutorial and more of a record of my past experience---in particular, I end up not reaching my stated goal for this post.

I've been reading this book on [Hypermedia Systems](https://hypermedia.systems), and one of the things they do is develop a small CRUD application in Python for which the code can be found [here](https://github.com/bigskysoftware/contact-app). Like the good software citizens they are, they've included a full detailed list of their project dependencies as a [`requirements.txt` file](https://github.com/bigskysoftware/contact-app/blob/master/requirements.txt).

However, if I, a budding hypermedia aficionado, wished to run and even improve on their work, and I didn't know Python, I'd enjoy a "one method to rule them all" to, say, install all the dependencies and drop myself into a shell exposing all of these dependencies. This is where Nix comes in.

AFAIU, Nix offers a way to declare dependencies of a software project, totally and precisely. With this, you can create isolated environments that contain exactly what is needed to run that software.
In this post, we'll be writing a `flake.nix` file which encodes all of that information and will make development safer and more streamlined.

---

The [official wiki](https://nixos.wiki/wiki/Flakes) gives instructions on how to use flakes, which are an experimental (yet widely used) feature of the Nix ecosystem. Let's start here!

I fork the hypermedia project repository and clone it on my machine. I create an initial `flake.nix`  with
```sh
nix flake init
```
and stage it (otherwise Nix won't take it into account):
```sh
git add flake.nix
```

Here are the contents of our dummy flake file:
```nix
{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
```

What is this supposed to mean?

The [Nix wiki page can tell us about that](https://nixos.wiki/wiki/Flakes#Flake_schema):
> The flake.nix file is a Nix file but that has special restrictions (more on that later).
>
> It has 4 top-level attributes:
>
> -  `description` is a string describing the flake.
> -  `inputs` is an attribute set of all the dependencies of the flake. The schema is described below.
> -  `outputs` is a function of one argument that takes an attribute set of all the realized inputs, and outputs another attribute set which schema is described below.
> -  `nixConfig` is an attribute set of values which reflect the [values given to nix.conf](https://nixos.org/manual/nix/stable/command-ref/conf-file.html). This can extend the normal behavior of a user's nix experience by adding flake-specific configuration, such as a binary cache.

So, our basic flake has the `description` attribute and the `outputs` attribute; the latter is a function that takes an attribute set as input and outputs some stuff. The attribute set contains two attributes, `self` and `nixpkgs`.
Neither of these two attributes are defined elsewhere in the file, so I guess these names are known by the Nix system---although I don't know what they refer to yet.

The flake doesn't have `inputs` or `nixConfig` attributes, so I guess they're not strictly necessary, or perhaps the Nix system fills them with default values on its own.

I see in the [output schema](https://nixos.wiki/wiki/Flakes#Output_schema) that one possible standard attribute is `devShells`. This sounds like the kind of place one might specify packages to install in an isolated development environment.

---

Doing a little digging, it would seem that the [devenv](devenv.sh) project seeks to simplify the process of specifying development environments even more. Let's take a look at [their Flakes tutorial](https://devenv.sh/guides/using-with-flakes/).

They recommend creating the flake file using their own template:
```sh
nix flake init --template github:cachix/devenv
```

I run this, after deleting the old `flake.nix`---I can always get it back with `nix flake init`.

The new flake file we get is:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = [ pkgs.hello ];

                  enterShell = ''
                    hello
                  '';
                }
              ];
            };
          });
    };
}
```

This flake has the `inputs` and `outputs` attributes, but it no longer has a `description`. Oh well, wasn't too important I guess.

Of interest might be the `systems` value. My hunch is that this lets us iterate over a number of possible system architectures (linux, darwin AKA MacOS, windows...) so that we only have to declare our dependencies once and the flake should still work for all of these systems. I might take the time to research this later, but it's out of scope for now.

Okay, so how do we declare that we want Python installed?

The devenv team have written example flakes for many types of projects, including for Python projects using virtualenv and for those using poetry (another reproducible software solution).
I don't really see the point of using poetry for now, so let's stick to venv for the time being. Besides, I know from experience that [some packages are currently difficult to install through poetry](https://github.com/pytorch/pytorch/issues/76557).

Side note: it seems that a process similar to this one is discussed in this [Tweag blog post](https://www.tweag.io/blog/2020-08-12-poetry2nix/), except they focus on projects using poetry. Side side note: if you don't follow Tweag's blog, you're missing out!

Let's add one line to `flake.nix` to have Python installed:
```nix
{
  ...
      modules = [
        {
          packages = ...

          # Install Python, please!
          languages.python.enable = true;

          enterShell = ...
  ...
}
```

Oh, and devenv also created a `.envrc` file for use with [direnv](https://direnv.net/), a program that automatically loads stuff when you `cd` into the project directory. The contents of that file will always be the same when using Nix flakes, as all of the loading logic will be described in the flake.

If you have direnv installed, it should be enough to just change `flake.nix`. If you don't, try opening the shell with
```sh
nix develop --impure
```
as explained in [the devenv tutorial](https://devenv.sh/guides/using-with-flakes/#getting-started).

After getting into the shell, you should see that the `python` executable is available and maps to somewhere in the Nix store:
```sh
$ python --version
Python 3.10.11

$ which python
/nix/store/x67wafvv3r3ndf2c959qf85nwk1qd9d9-devenv-profile/bin/python
```

However, predictably, the app won't run because the Python packages are not installed:
```sh
$ python app.py
Traceback (most recent call last):
  File "/Users/Auguste/Desktop/contact-app/app.py", line 1, in <module>
    from flask import (
ModuleNotFoundError: No module named 'flask'
```

So, what do we do now?

---

Ideally, we would just say in `flake.nix` which packages we need and get the guarantee that Nix will find a combination of versions that works. However, we cannot expect Nix to know how to do that for all past and future languages with package management capabilities.

Since we already have a list of packages and their versions that supposedly works, in the form of a `requirements.txt`, we should be able to somehow tell Nix to use those.

It turns out `pip2nix` does something like this.

I follow the instructions in [their README](https://github.com/nix-community/pip2nix) to get a working `pip2nix` executable which I can run on the `requirements.txt` file. I tried to use the commands verbatim, but those work for Python 3.6, which is too old for the package versions listed in `requirements.txt`. Replacing `python36` by `python39` (the latest version supported by `pip2nix` at the moment) made everything work.
When this succeeds, we get a `python-packages.nix` file containing precise information on how to build the project dependencies, written in Nix.

We need to pipe this into our flake file, but where?

Our Python packages are project dependencies, so based on the Nix wiki, it would make sense for them to fit in the `inputs` attribute of the flake. However, the inputs are [supposed to be flakes themselves](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#flake-inputs), which our python packages aren't. So, are we done? I suspect there is a way to create some ad hoc flakes that serve only for pleasing Nix, but I don't know how to do that. ^^'

---

A little later, I settled for an easier yet less reproducible solution: install virtualenv and install the dependencies stated in `requirements.txt` using pip.This requires adding this line to `flake.nix`:
```nix
{
  ...
      modules = [
        {
          packages = ...

          # Install Python, please!
          languages.python.enable = true;
          # Also virtualenv, please!
          languages.python.virtualenv.enable = true;

          enterShell = ...
  ...
}
```
After that, Nix will do what it needs to do, and after I am dropped into the devshell I can run
```sh
pip install -r requirements.txt
```

In conclusion, even within Nix, there are many concurrent ways to make the process of tracking dependencies easier---and I'll need to do some more digging to find the right one for me. For example, [dream2nix](https://nix-community.github.io/dream2nix/) aims to be the one tool to be used for solving this for all languages, but it unstable and only supports a handful of languages. Perhaps I'll try their ["Build you Python project in 10 minutes" tutorial](https://nix-community.github.io/dream2nix/guides/getting-started-python.html) in a future post.

---

Final note: This post relies on the assumption that the app of interest will not be further developed; keeping the dependencies synced between `requirements.txt` and `flake.nix` during development is a problem for another time. However, Nix can still help us at least easily and reliably run code, even long after it was written.

This is post number 001 of [#100daystooffload](https://100daystooffload.com/).