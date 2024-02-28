---
title: Why you should try mob programming
date: 2024-02-26
keywords:
  - mob
---
This post is adapted from a talk I gave at my place of work to convince them to try mob programming. I took some inspiration from Woody Zuil's ["Mob Programming and the Power of Flow"](https://youtu.be/28S4CVkYhWA) talk, but the arguments reflect my own personal experiences at work---if your experience doesn't match mine, that's okay.

Succinctly, mob programming consists in working on a task together with a group of people (a "mob"), usually software development. One programmer has control of the keyboard and types stuff, while the others talk things out and tell the typist what to do. Every 10 minutes or so, someone else becomes the typist, and so on.

Here is the plan:
1. 10 reasons to implement mob programming
2. 3 (bad) reasons not to do it

## A top 10 of reasons to implement mob programming

### It encourages everyone to focus on what matters

When I'm working on a project on my own, it can be easy to start [bike-shedding](https://en.wikipedia.org/wiki/Law_of_triviality). The mob stops me from getting side-tracked, for fear of wasting everyone's time.

### The mob is as fast as its fastest member...

As long as one person knows what to do enough that they can describe it to the mob, development will not be stalled. If no-one knows what to do, then it's also faster to search for stuff online.
Compare this to everyone working individually: when you get stuck, you can ask an AI or tear at your co-workers' concentration by asking for their help.

### ...but eventually everyone is the fastest member

As well as bringing your expertise to the mob, the mob brings theirs to you. Compare this to the individual case where you get always pushed towards what you already know how to do.

### It fosters flow state

Because you are focused on the most important task and everyone is working on the same thing, there is no-one to come and ask about some other random thing. Hence it is unsurprisingly easy to get "in the zone" and finish the day with a sensation of a job well done.

### It makes onboarding a no-brainer

You can't bring a new colleague into the mob without giving them context on the problem at hand and showing them the tools; otherwise they're just a spectator, and better off not taking part.
Compare this to the individual case where newbies are expected to "just get it", with no obligation from the team to explain anything because they're too busy with their own work.

### It is easier to get time off from the mob than the opposite

If for some reason you don't feel like joining a session, it presumably won't matter given all the other mobsters know what to do. On the contrary, if by default everyone is expected to work on their own, why would they "waste their time" working together?

### It makes team communication a no-brainer

Don't agree with the style-guide? Think the tests shouldn't take that long to run? Feel like a proposed feature needs clarification before implementation can start? All you have to do is say it!

### It greatly improves product quality

In order for a bug to get through to production, it has to get past **everyone in the team**; similarly, for some code to be written, it has to make sense to **everyone in the team**. Compare this to the usual case where a developer gets a half-assed review by an over-worked senior engineer.

### It makes the team resilient

Is your [*10x engineer*](https://www.quora.com/topic/10X-Engineers) on sick leave? No matter: everyone else has learned alongside them and they all have the same priorities in mind. Note that I'm not saying every developer should be replaceable: I'm saying the team as a whole should suffer as little as possible.

### It makes work fun

There is no other way of putting it:
- constantly exposing your thoughts to your co-workers and confronting them with theirs is an incredible learning experience;
- the way the mob breezes through work is refreshing;
- seeing other people's workflows and getting their perspective on their craft makes you grow and feel like you belong
- all of the above actually **makes me want to go to work**.

Software engineering is not a production line where each worker has their bolt to screw; it is a social activity that benefits when everyone brings their knowledge to the table and gets to learn something in return.

## 3 (bad) reasons not to implement mob programming

### "Surely dividing tasks is more productive"

Person-hours are not independent of the number of persons.
To borrow from Pierre-Joseph Proudhon (freely translated from French), consider the task of raising the [Luxor obelisk](https://en.wikipedia.org/wiki/Luxor_Obelisks) (a 20 meter-high monument in Paris): you'll pay the same amount if you give 200 people one hour to do it as if you give one person 200 hours to do it, but you won't get the same result.[^1] 
In other words, by dividing workers' efforts you'll make them busy but you won't make them productive.


### "Surely the different working styles will clash and make work annoying for all concerned"

It's true that programming is often thought of as a solitary endeavour, but this is simply wrong: [programming is social](https://lemire.me/blog/2020/11/19/programming-is-social/).
By contrast, when workers are separate, the less experienced spend their time lost and have to go ask their much busier superiors for help, thereby hindering them in their work. This is a much greater annoyance that the supposed one brought about by mob programming.

### "Why would I pay 2 or more people to do a job that can be done by one?"

Because they will do a better job, and the learning they each do in the process will pay dividends in the next job they'll do for you. By the way, if the job can be done by one person, why would you hire more?

## Closing remarks

To put these arguments in perspective, you should know that I've experienced mob programming in specific contexts:
- with experienced co-workers
- working on software engineering tasks
- with a team of no more than 5 workers

I've also experienced mob programming in different professional settings:
- A part-time job where mob programming was the only way to work (it was not allowed to work alone outside of the sessions)
- A full-time job where I had to convince co-workers and management to try mob programming and we ended up with spotty engagement, mobbing an average of a few hours a day for a few weeks.

For the full-time job, I made the mistake of not being forward enough with my proposal: I didn't want to rush people out of their work habits. In the end, people generally didn't want to get invested for fear of losing time on "their" tasks, and the mob was never more than 3 out of the 6 working developers. In particular, the most experienced devs are those that mobbed the *least*, presumably because:
1. They felt more in control than less experienced devs and thus didn't seek for the support of the mob;
2. They had more work to get done, and couldn't afford to "waste" time.

I make no promises about other contexts, but I can only encourage you to try it and see where it takes you---and report back when you do!

This is post number 006 of [#100daystooffload](https://100daystooffload.com/).

[^1]: <https://www.cairn.info/revue-cites-2010-3-page-127.htm#pa10>
