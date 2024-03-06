---
title: Nix for Python, attempt number 2
date: 2023-05-19
keywords:
  - nix
  - python
---
[Last post](http://augustebaum.github.io/website/posts/2023-05-16-01-nix-for-python-attempt-no.-1/) we tried to make a Python project fully reproducible based on a detailed `requirements.txt` file. We ended up not managing to go the full Nix way, but we got pretty close. However, there are many ways to approach this, with language-specific tools getting published and archived on the regular.

At the end of the last post I mentioned [dream2nix](https://nix-community.github.io/dream2nix/) and their ["Build your Python project in 10 minutes" tutorial](https://nix-community.github.io/dream2nix/guides/getting-started-python.html) which I would try out in a future post. This is that post!

Like last time, the dream2nix team have prepared a flake template so that in our project we can just run the following to initialize our project flake:
```sh
nix flake init -t 'github:nix-community/dream2nix#simple'
```

Side note: The single quotes are my addition. I don't know why, but the Nix tutorials I've seen don't put in the quotes, so that my shell (zsh) complains:
```sh
zsh: no matches found: github:nix-community/dream2nix#simple
```

Here's what the `flake.nix` file looks like:
```nix
{
  inputs.dream2nix.url = "github:nix-community/dream2nix";
  outputs = inp:
    inp.dream2nix.lib.makeFlakeOutputs {
      systemsFromFile = ./nix_systems;
      config.projectRoot = ./.;
      source = ./.;
      projects = ./projects.toml;
    };
}
```
It has one input flake, `dream2nix`. As for the outputs, dream2nix does stuff so that we only have to focus on a few options. In particular, it assumes that a couple of files are present: `nix_systems` and `projects.toml`, in the root of the project.

---

[As the tutorial states](https://nix-community.github.io/dream2nix/guides/getting-started-python.html#nix_systems), `nix_systems` lists all the systems that this flake should work on; it looks like this:
```txt
x86_64-linux
x86_64-darwin
```
However, I think I prefer listing the systems directly in `flake.nix` because I don't like having another tiny file in the project root if I can help it. Following the dream2nix tutorial I can modify `flake.nix` like so:
```nix
{
  inputs.dream2nix.url = "github:nix-community/dream2nix";
  outputs = inp:
    inp.dream2nix.lib.makeFlakeOutputs {
      systems = [ "x86_64-darwin" ]; # I'm on MacOS
      config.projectRoot = ./.;
      source = ./.;
      projects = ./projects.toml;
    };
}
```
It's also possible to make use of the [flake-utils library](https://github.com/numtide/flake-utils) to simplify this part, but I'll cover that some other time.

---

The `projects.toml` file contains extra information about the project, but the tutorial does not expand on this; supposedly because the contents are highly dependent on the kind of project (programming language, package manager...).
We can run an auto-detection program provided by dream2nix (note the single quotes):
```sh
nix run 'github:nix-community/dream2nix#detect-projects' . > projects.toml
```
In our case, `projects.toml` looks like:
```toml
# projects.toml file describing inputs for dream2nix
#
# To re-generate this file, run:
#   nix run .#detect-projects $source
# ... where `$source` points to the source of your project.
#
# If the local flake is unavailable, alternatively execute the app from the
# upstream dream2nix flake:
#   nix run github:nix-community/dream2nix#detect-projects $source

[main]
name = "main"
relPath = ""
subsystem = "python"
translator = "pip-freeze"
translators = [ "pip-freeze",]
```

Here, some problems start. First, I don't understand what exactly this content means. Here is what I think is happening though: I think dream2nix has understood that this is a Python project, and it's understood that the requirements are declared with the `pip freeze` command, which sounds reasonable. However, the docs are not quite explicit enough for me to understand if I need to do anything else at this point. Let's assume everything is fine and dandy and carry on.
In fact, following the next step of the tutorial, I can see what Nix sees:
```sh
$ nix flake show
warning: Git tree '/Users/Auguste/Desktop/contact-app' is dirty
git+file:///Users/Auguste/Desktop/contact-app
├───apps
│   └───x86_64-darwin
│       └───detect-projects: app
├───devShells
│   └───x86_64-darwin
│       └───default: development environment 'nix-shell'
└───packages
    └───x86_64-darwin
        ├───default: package 'python3.10-default'
        └───resolveImpure: package 'resolve'
```
There is in fact a Python package here, and a devShell that I could supposedly drop into that has all the dependencies available.

Let's try this! According to the tutorial, we can build the project like so:
```sh
$ nix build '.#default'
warning: Git tree '/Users/Auguste/Desktop/contact-app' is dirty
error: getting status of '/nix/store/hharq96d2b9jni4scs4mxw573hsfx20b-source/requirements-dev.txt': No such file or directory
(use '--show-trace' to show detailed location information)
```
This fails and complains that there is no `requirements-dev.txt` file to be found. There is indeed none in the project, although it's not supposed to be mandatory. Strange...
Let's try again, having added an empty `requirements-dev.txt` in the root of our project.
```sh
$ touch requirements-dev.txt
$ nix build '.#default'
warning: Git tree '/Users/Auguste/Desktop/contact-app' is dirty
error: getting status of '/nix/store/hharq96d2b9jni4scs4mxw573hsfx20b-source/requirements-dev.txt': No such file or directory
(use '--show-trace' to show detailed location information)
```

Well, that changed nothing. 

I decided to go ahead and [ask the maintainters about this directly](https://github.com/nix-community/dream2nix/issues/521): maybe I missed some obvious step in the process. Tune in soon to see if I get an answer!

This is post number 002 of [#100daystooffload](https://100daystooffload.com/).