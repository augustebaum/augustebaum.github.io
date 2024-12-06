---
title: 20% Progress Report (1)
date: 2024-12-06
---

Since May of this year I have been working as a software engineer at Probabl. I'm allowed to pursue personal projects during 20% of my working hours (one full day per week), as long as it's reasonably close to my normal work, and that I regularly share what I learned with others. This post aims to fulfill the second condition!

For each project I'll give a description that answers these questions:
- What am I doing?
- What is my goal?
- What have I learned?
- What will happen next?

So without further ado:

## Table of Contents

- [rrr, a TUI file explorer in Rust](#rrr-a-tui-file-explorer-in-rust)
- [Shape Up, a book about Basecamp's ways of working](#shape-up-a-book-about-basecamps-ways-of-working)
- [datalog, a logic-inspired query language](#datalog-a-logic-inspired-query-language)
- [jujutsu and git-branchless, alternatives to Git](#jujutsu-and-git-branchless-alternatives-to-git)
- [bandit-experiment, an HTMX web app](#bandit-experiment-an-htmx-web-app)
- [mkdocs, an alternative to sphinx](#mkdocs-an-alternative-to-sphinx)
- [automerge, a CRDT library in Javascript](#automerge-a-crdt-library-in-javascript)

## rrr, A TUI File Explorer in Rust

[rrr](https://codeberg.org/augustebaum/rrr) is a clone of [nnn](https://github.com/jarun/nnn), my file explorer of choice, written in Rust, meant for me to learn Rust. I am aiming to make it a drop-in replacement.
At the same time, this is the opportunity for me to get a better feel for UI programming: how exactly do you display information and controls, and react to user inputs?

My reasons for learning Rust boil down to:
- It might make me a better programmer
    - Rust tackles low-level concepts, but strives to make it "fearless". This speaks to me, as C/C++ feel like an Everest at this point, but with Rust I can dive into these topics at my own pace.
- I want to be able to contribute to certain projects, like [tvix](https://github.com/tvlfyi/tvix), [helix](https://helix-editor.com/), [typst](https://github.com/typst/typst)...

### What I Learned

- I still don't know how to update a data structure while I'm iterating in it.
    - I previously participated in another Rust project, [sklearn_rust_engine](https://github.com/fcharras/sklearn_rust_engine), where I hit a road-block while implementing [a pseudo-code algorithm for DBSCAN](https://en.wikipedia.org/wiki/DBSCAN#Original_query-based_algorithm).
- The `Result` pattern seems to me like a great step for programming, but it can definitely make things frustrating. For instance, here is a helper I wrote to list the contents of a directory ([link](https://codeberg.org/augustebaum/rrr/src/commit/c619f0ca0e40a6e81552b7128d21c191607af038/src/main.rs#L30-L41)):
```rust
fn get_contents(directory: PathBuf) -> Vec<PathBuf> {
    directory
        .read_dir()
        .expect("read_dir failed")
        .map(|res| res.map(|e| e.path()))
        .collect::<io::Result<Vec<_>>>()
        .expect("listing current directory failed")
        .iter()
        .sorted()
        .map(|x| x.to_owned())
        .collect()
}
```
`res.map`? `collect::<io::Result<Vec<_>>>`? `to_owned`? It's already complicated, but the previous iteration looked more like [this](https://codeberg.org/augustebaum/rrr/src/commit/a1ff8e316a1476ceea481ebe84dadee5911f8c2a/src/main.rs#L77-L94)... Yeah, you can kind of feel the frustration through the lines.
On the other hand, bugs in production code are also frustrating.
- When to use `String` versus `&str`: there we have it, the first thing you learn in Rust that makes no sense unless you've worked with systems programming before. On this point specifically, see [this post by Steve Klabnik](https://steveklabnik.com/writing/when-should-i-use-string-vs-str/).
- The standard library is missing some things which feels off, for example the `sorted()` function in the `get_contents` snippet in fact comes from [the `itertools` third party crate](https://docs.rs/itertools/0.7.2/itertools/trait.Itertools.html#method.sorted). See also [this post](https://kerkour.com/rust-stdx) which considers the security implications of the Rust project's dependencies strategy.
- I like `match`ing, and the type system. I dream of the day that [pydantic](https://docs.pydantic.dev) manages to replicate that feeling of confidence that Rust's type system brings, without being so contaminating.
- I like that in many cases `clone()` is enough to please the compiler: when I want to extract better performance, I'll think about making rid of those hacks.
- Coming from Python, Rust tooling like `cargo` is a breath of fresh air. To the point where people are catching on and want the same experience in their language of trade, and using Rust to achieve that: Ruff and UV for Python, Biome and Oxc for JavaScript...

#### So, What's Next?

- Keep implementing features
- Write some tests and think more about testing automatically in general
	- For example, I have no idea what happens if e.g. a directory is deleted while `rrr` is looking at it.
- In the same vein, what's the next step of error handling after `expect` (which just crashes)?
- take a look at `anyhow` for potentially making `Result`s more ergonomic

#### Related but Couldn't Fit Anywhere

- Another project I started before rrr was to learn [Textual](https://textual.textualize.io/), a Python library to build TUIs. Importantly, it includes first-class support for "reactive" values, which is the pattern used in React.
- Other file explorers like nnn that could be looked into for inspiration: [fff](https://github.com/dylanaraps/fff) (bash) and [yazi](https://github.com/sxyazi/yazi) (Rust)

## Shape Up, A Book about Basecamp's Ways of Working

[*Shape Up*](https://basecamp.com/shapeup) is a book written by people at Basecamp, presenting an alternative Agile methodology which is used in Basecamp itself. The initial hook that drew me to look into was [this post by DHH](https://world.hey.com/dhh/software-estimates-have-never-worked-and-never-will-a41a9c71) about software estimates.
I wanted to see different, potentially non-standard ways of working, as I am already a proponent of [mob programming](https://augustebaum.github.io/posts/2024-02-22-06-why-you-should-try-mob-programming).

### What I Learned

The authors developed a whole language to convey how they work.
Here are some of the points I wrote down during my reading:
- Estimating how long a feature will take to implement is hard---too hard. Instead, it's more productive to give ourselves a deadline, and to narrow down the scope of the task/problem to where we're confident that we can do it by the deadline. An estimation is a process that takes a design, and outputs a duration, whereas an `appetite` is a process that takes a duration, and outputs a design.
- Two-week sprints are typically too short to bring a complex idea from design to finished. Also, doing a big planning meeting every 2 weeks in too much overhead. In the Shape Up philosophy, a `cycle` lasts 6 weeks. Features should take one cycle to implement, once the project has been chosen to be implemented.
    - That's 6 weeks of uninterrupted work. Interrupting work for "just a few hours" can kill a day of momentum.
    > if it’s a real crisis, we can always hit the brakes. But true crises are very rare.
    - No extensions, and no shipping if the work is not done. This forces the shapers to really consider the feasibility of a project in 6 weeks, and it forces the implementers to make trade-offs.
- Some people in the team are implementers (designers and coders). Others are "shapers": they take a vague feature idea, and work it into a 6-week project. They `shape`.
- The output of the shaping stage is a `pitch`, to convince upper management that there is a problem that needs solving, how long it should take (the `appetite`), and a solution. The pitch can also mention rabbit holes (hard decisions that we had to make for the solution to work in practice), and what we should do about it) and no-gos (what we're *not* doing in this project).
    - The solution part of the pitch is not a full, complete specification. When doing the project, the implementers are the ones that will iron out the design and technical details. A solution will rather include high-level visualizations, such as `breadboard`s and `fat marker sketch`es. The point is to avoid "boxing in the designers".
- When they are ready to pitch, projects are brought to the `betting` stage. A few stakeholders meet (e.g. C-level people), and decide what projects we'll do in the next `cycle`. The projects on the table are those that someone lobbied for (either a new project, or a project that was presented in the past but wasn't chosen).
    - There is no backlog.
    > It’s easy to overvalue ideas. The truth is, ideas are cheap. They come up all the time and accumulate into big piles.
    >
    > Really important ideas will come back to you. When’s the last time you forgot a really great, inspiring idea? And if it’s not that interesting—maybe a bug that customers are running into from time to time—it’ll come back to your attention when a customer complains again or a new customer hits it. If you hear it once and never again, maybe it wasn’t really a problem. And if you keep hearing about it, you’ll be motivated to shape a solution and pitch betting time on it in the next cycle.
    <https://basecamp.com/shapeup/2.1-chapter-07#:~:text=It%E2%80%99s%20easy%20to,the%20next%20cycle.>

## Datalog, A Logic-inspired Query Language

[Datalog](https://www.learndatalogtoday.org/) is a declarative query language inspired by logic programming.

I mostly followed [this tutorial](https://www.learndatalogtoday.org/) on the Datomic flavour of Datalog. This was super fun and worked very well for giving me an idea of the mindset (the exercises really help for this).

Later I discovered that it seems like [SPARQL](https://en.wikipedia.org/wiki/SPARQL), a query language for e.g. knowledge graphs, has a similar syntax.

### What I Learned

In the Datalog world, data are presented in the form of *facts*. Every fact has 3 components: a binary relationship, and its two operands.
For example, `"Bruce Willis" | is a | actor` or `"Bruce Willis" | is in the credits of | "Die Hard"`.
Well, not exactly. The above are not proper facts, because `"Bruce Willis"` is a string.
Facts don't apply to strings, but rather to abstract *entities*, which are kind of like classes; a proper fact would be something like (in our pseudo-code syntax):
```
?entity | is named | "Bruce Willis"
?entity | is a | actor
?entity | is in the credits of | "Die Hard"
```
and a Datalog engine would be able to take the above "query", along with a movie database, and tell you whether or not there is an entity in the database that satisfies these facts. The `?` syntax tells you that `?entity` is a variable.

More powerful though, is the idea of pattern matching in queries.
For example, you could write something like
```
find me
    ?actor_name
where
    ?entity | is a | actor
    ?entity | is in the credits of | "Die Hard"
    ?entity | is named | ?actor_name
```
which will return all the actor names that satisfy these facts. In this case you'd likely get several results, e.g. `"Bruce Willis"` and `"Alan Rickman"` at least.

Even more powerful, you can encode facts *about* the data, in this model.
In actuality, facts can contain more than 3 bits of information (those being *entity*, *attribute* and *value*). They can also contain a *transaction*, e.g.
```
?entity | is named | "Bruce Willis" | ?tx
```

Here `?tx` is a variable that can be used in the rest of the query, for example you can use it to know when the fact `?entity | is named | "Bruce Willis"` was added to the database, for every `?entity` that matches the fact.

If this piques your interest, then I heavily recommend the tutorial, as it really helps to have each new concept accompanied by examples, and exercises to practice.

### What's next

The tutorial mentioned earlier uses the Clojure dialect of Datalog. I'm interested in Clojure, and might look into how Datalog can be used in practice. See for example [datascript](https://github.com/tonsky/datascript).


## jujutsu And git-branchless, Alternatives to Git

As of 2024, Git is huge: nearly every developer entering the market is expected to know how to use it, and yet it suffers from a huge learning curve because of its unergonomic interface.

But there are alternatives to Git. [`jujutsu`](https://github.com/martinvonz/jj) and [`git-branchless`](https://github.com/arxanas/git-branchless) are Git-compatible clients which allow you to manipulate changes with more ease, and generally challenge you about what Git could be.

### What I Learned

One of my first forays into this subject was when I discovered `jujutsu` while looking for ways to implement the "Stacked PRs" workflow. I tried to use it... and couldn't. Then, I discovered `git-branchless`, which is a sort of middle-ground between git and jujutsu.

In fact, the maintainer of git-branchless themselves have now migrated to jujutsu.

#### Git-branchless

It took me a while to understand the point of `git-branchless`.

The most visible thing that I found useful is `git branchless smartlog`. This shows you the commits in your Git repo, in a graph form that is much cleaner and more intelligible than `git log --graph`. It shows where your branches, well, *branch* off, which of them aren't up-to-date with `main` and could be rebased, etc.

Now suppose you want to work on a new feature. You'd like to work off of `main`. With git-branchless, you would do
```sh
git sw main --detach
```
This moves `HEAD` to the commit `main` points to, and detaches `HEAD` from `main`. Then write your change, and when you commit, this will not move the `main` branch. The output of `git smartlog` should look something like
```
⋮
◇ 69fa3c8 1d (main) do this and that
┣━┓
┃ ◯ 7c1ae9f 1d some change, part 1
┃ ┃
┃ ◯ 76015a8 6h (some-named-branch) some change, part 2
┃
● 2bcbf69 3s my new change
```
This shows you that you have in fact, created a new thing that looks like a branch (in the "tree" sense of the word), but without creating a `branch` (in the Git-jargon sense). You can always name your new branch later, when you feel like it---but *you don't have to*. Hence the name of the tool.

Well, that is, unless you're interacting with GitHub. Indeed, GitHub, unlike other online Git hosting services, implements the Pull Request workflow, which *requires* you to push your changes in a *named* branch. But even then, you can always wait until the last moment to create a named branch. You don't need the ceremony of naming a branch before you start doing the actual work that needs doing; just `git sw main -d` and get to work.

If you try this out for yourself, you might, have felt uneasy at the idea of detaching `HEAD` (I certainly have). This is normal, as Git itself discourages the user from doing this with a scary warning:
```
You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -
```
which I translate in my head to:
```
The changes you are about to make are not in a named branch; it'd be a shame if something happened to them...
```
As far as I know, with git-branchless installed, your commits are safe, even if not on a named branch (obligatory disclaimer: this is not git advice). You can always find them using `git smartlog`, except if you wish to hide them from view with `git hide`.

There are lots of other cool features to git-branchless (special mention to `git sync --update` which pulls main and rebases all my branches on top of main at once, fast), and I'd rather expand on them in a future post. For now, let's go on to discuss jujutsu.

#### Jujutsu

What really got me started with using jujutsu for my own projects is [this tutorial](https://steveklabnik.github.io/jujutsu-tutorial/).

You can set up jujutsu in a pre-existing Git repository with `jj git init --colocate`.
Like in git-branchless, `jj log` shows you a nice (albeit a bit crowded) graph of all the changes in the project.
Also like in git-branchless, named branches are superfluous in jujutsu (although there is an equivalent so that jujutsu can be used with GitHub). But this is just the tip of the iceberg.

##### Committing

In Git, when you work on a change, this change is just in the working copy. That is to say, it is in a limbo between life and death, until you decide to give it an identity with `git commit`, or erase from existence with `git reset --hard`. Also there is also a second limbo in the form of `git stash`.
Want to work on something else? Well, too bad: you have to decide if your current change lives or dies first. Sorry.

In jujutsu, when you make a change to your working copy, it's tracked in a commit, whether you like it or not. That's it.
Goodbye `git add` and `git commit`; thanks for nothing.

But how do you separate a change from another then? Well this is done with `jj new <change-id>`. This is kind of equivalent to `git branchless switch --detach <commit-or-branch-id>` in that you do this when you want to *start* new work. This is in contrast with `git add`/`git commit` which you use to *end* work.

If you run `jj new` you should see something like this in your log:
```
│
@  tnwsoxzk <your-email> now cd53c289
   (empty) (no description set)
```
- `(empty)` means this change is empty: no files have been changed in any way.
- `(no description set)` means the description of this change (equivalent to Git's commit message) is also empty.
- The little `@` means you are editing *this* change right now (kind of like Git's `HEAD`).

Yes, I know: an empty commit, with an empty message! Is that feeling of unease creeping up on you again?
No fear. Just start working, and the `(empty)` tag will disappear. When you're ready, give the change a description with `jj describe` and `jj log` will show that message instead of `(no description set)`. You can do this whenever you want---before you start working, after you're done... You don't even have to name the commit at all!

I hope this properly conveys the feeling that many of these weird things Git make you learn are *not necessary*. Like every designer knows,
> Good design is attained not when nothing can be added, but when nothing can be removed.

(see [here](http://www.kapanen.fi/xj/design-is-perfect-when/) for a history of this paraphrase of Saint-Exupéry)

But wait, there is more.

##### Rebasing

In git, `rebase` is as revered as it is feared. It can make your commit history look like gold, but it can make your life crap.
In particular, one thing that's scary and weird with rebasing in Git is that conflicts are blocking. Once a conflict has been detected, a red alert is sounded and nothing can be done unless the conflict is resolved, or the rebase is aborted.

But conflicts in jujutsu are not the end of the world. They're important and need to be dealt with eventually, sure, but not necessarily *right now*.
And if you really, really don't want to see the conflicts and would rather go back to how things were before the rebase? Just `jj undo`. Did I mention that undo exists in jujutsu? undo exists in jujutsu. In a version control system. Sounds unreal, right?
You can use `jj op log` to navigate the history of all changes to the repository.

### Finishing Thoughts

jujutsu is gaining [a fair amount of traction](https://star-history.com/#martinvonz/jj) these days (nearly 10k GitHub stars as of right now). But there are many other VCS systems, whether they be Git extensions or other programs entirely, with different design goals and constraints: [sapling](https://sapling-scm.com/), [git-town](https://www.git-town.com/), [pijul](https://pijul.com/), [fossil](https://fossil-scm.org/)... If what I described earlier interests you, feel free to check them out too!

Finally, that there are of course other ways of making version control easier for *all* users, not just nerd-sniped software developers.
For example, [GitButler](https://gitbutler.com/) is the new kid in town when it comes to Git GUIs, and [Graphite](https://graphite.dev/) also has utilities for the Stacked PRs workflow and has a GUI. Excitingly, GitButler [took inspiration from jujutsu's conflict management paradigm](https://blog.gitbutler.com/fearless-rebasing/).

By the way, on the topic of merge conflicts, check out [mergiraf](https://mergiraf.org/).

### What's next

jujutsu still has rough edges, and it might be nice to dive into how it works to help it improve.
In the meantime I'll continue using jujutsu and git-branchless every day.

## bandit-experiment, An HTMX Web App

[bandit-experiment](https://codeberg.org/augustebaum/bandit-experiment) (clever name TBD) is a web app implementing a 2-arm bandit process, which is often used in cognitive science research to study decision-making (see [here](https://www.nature.com/articles/ncomms9096#Fig1) for example).
The goal of this project is for me to get a better understanding of full-stack webapps, in order to expand my worldview from just the backend.

This one is very much a work-in-progress as I have been pondering design choices. For instance, at first I started with a Flask server and some HTML, then I considered going for a completely static website in JS (that could be downloaded once and then run offline).
Now I'm going back to my initial plan of a Flask/FastAPI server and will probably use HTMX in order to limit the amount of custom-made JS.

## mkdocs, An Alternative to Sphinx

Probabl's [skore](https://github.com/probabl-ai/skore) tool uses sphinx for its documentation because this way we benefit from the years of hindsight that Probabl's Open Source team got when documenting scikit-learn. However, I was kind of hoping to try out [mkdocs](https://www.mkdocs.org/) as I've seen used in many places and it felt like a more modern solution. So I took some time to try and migrate our docs from sphinx to mkdocs. In the end, the experiment was inconclusive (although I still got pretty far despite not working on it for very long at all).

Positives:
- The [material-mkdocs](https://squidfunk.github.io/mkdocs-material/) theme is good-looking and modern. I feel it inspires more confidence than sphinx-pydata-theme, maybe from seeing it in so many cool projects (but also because it's just more appealing).
- Markdown feels so much better to write in than rST.
- Docs build very quickly, although this may be because i couldn't build the examples.
- `mkdocs serve/build` is straightforward, doesn't imply some weird Makefile like Sphinx does.
Negatives:
- Some things that are provided out of the box by sphinx are provided by 3rd parties in mkdocs.
- Using MyST in mkdocs [makes no sense apparently](https://github.com/mkdocs/mkdocs/issues/2898)? Everything Markdown-related is "covered" by `python-markdown`, and you activate various extensions for each new thing you need, e.g. the [toc](https://python-markdown.github.io/extensions/toc/) extension for table-of-contents. Now I'm really confused because we also couldn't get MyST to work with sphinx, so where can we really use MyST? Are we stuck with rST forever?
- [mkdocstrings](https://mkdocstrings.github.io/) seems to work well for rendering docstrings (even numpy-style), but it's weird:
  changing a docstring doesn't trigger an automatic rebuild of the docs. Also, the name of the class/function etc. doesn't show up in the built docs; why is this the default behaviour?
- [mkdocs-gallery](https://github.com/smarie/mkdocs-gallery) is kind of hard to work with, although unfortunately I don't have a record of why. Also I think it only supports mkdocs-material which is unnecessary lock-in.

### What's next

Since I got pretty far in just one day, I think another day might be useful. I'd really like the elucidate the MyST question.

## Automerge, A CRDT Library in Javascript

I was reminded of CRDTs when I saw [a talk about leveraging it in Jupyter notebooks](https://youtu.be/VXXLnmGqAO4). I find the idea very elegant and I was hoping to delve a little deeper into it.
The implementation I looked at is [automerge](https://automerge.org/), which is developed by folks at Ink & Switch, an independent research laboratory focusing on the future of programming. I became a follower of their work after being blown away by their report on [Inkbase](https://www.inkandswitch.com/inkbase/).

Because of it being a Javascript library and I'm reluctant to get into Javascript proper, I haven't spent much time yet properly tinkering with automerge.

Here is a quote from the docs that resonated with me though:

> Automerge is designed for creating local-first software, i.e. software that treats a user's local copy of their data (on their own device) as primary, rather than centralising data in a cloud service. The local-first approach enables offline working while still allowing several users to collaborate in real-time and sync their data across multiple devices.
>
> <https://automerge.org/docs/hello#:~:text=Automerge%20is%20designed,across%20multiple%20devices>

### What's next

I'd like to see Automerge in action, and for this I'd like a use-case. Feel free to suggest ideas!
