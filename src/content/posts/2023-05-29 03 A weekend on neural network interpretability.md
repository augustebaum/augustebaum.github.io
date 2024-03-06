---
title: A Weekend on Neural Network Interpretability
date: 2023-05-29
keywords:
  - ai safety
  - interpretability
---
This is a summary of my experience of [the weekend on interpretability](https://www.eventbrite.fr/e/billets-week-end-de-formation-intensive-en-interpretabilite-601236714197) I spent from 2023-05-27 morning to 2023-05-28 evening.
This was organized in Paris by [EffiSciences](https://www.effisciences.org/).

## Saturday Morning

We got an introduction to AI risk and the idea of interpretability was introduced as a possible way to counter [Goal Misgeneralization](https://deepmindsafetyresearch.medium.com/goal-misgeneralisation-why-correct-specifications-arent-enough-for-correct-goals-cf96ebc60924), whereby an AI can end up pursuing a goal that is different from the one that was intended, because it found a proxy to the "right solution". This implies that if the proxy behaves differently in deployment than in training, the agent will still just follow the proxy even if this yields bad outcomes.

Interpretability means figuring out what is going on inside a neural network in terms of what information it retains as relevant to taking a decision. For example, In [*Feature visualization*](https://distill.pub/2017/feature-visualization/) the authors present a method to get an example of an image that highly *excites* a particular neuron; this supposedly tells us what human-intelligible concept this neuron "recognizes". This is reminiscent of the [well-critiqued](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6822296/) "grandmother neuron" theory of representation of concepts in the human brain.

Then we went into a particular interpretability technique named [GradCam](https://ieeexplore.ieee.org/document/8237336). This method allows you to see which pixels are relevant to a particular input-output (e.g. image-class) pair.

In a workshop, we filled out a notebook implementing GradCam. In particular, I was made aware of the Einstein summation notation, implemented in the form of the [`einops` Python package](https://einops.rocks/) which is an elegant way to express complex linear tensor operations in few symbols.

According to [Adebayo *et al.*](https://dl.acm.org/doi/10.5555/3327546.3327621), GradCam is more reliable than other feature importance methods for images; the other methods seem closer to edge detectors.

---

## Saturday Afternoon

We got a quick introduction to Transformers as a core part of the architecture of many current state-of-the-art models. As my former internship supervisor said, AI practitioners tend to use it a lot, sometimes excessively:

![Flex-tape meme: AI engineers slap Transformers onto literally every task they come across.](https://i.imgflip.com/7nj36t.jpg)

We covered the attention block architecture, discussed the concept of residual stream and positional embedding. By that point in the day my brain was fried so things like the terminology of "queries", "keys" and "values" used when describing the attention mechanism felt a bit esoteric.

---

## Sunday Morning

We went over Transformers once more, then we were explained the [LogitLens](https://www.lesswrong.com/posts/AcKRB8wDpdaN6v6ru/interpreting-gpt-the-logit-lens) method. It's much simpler than to explain GradCam but I'm less sure that it's really believable. We spent the morning implementing it (by adding hooks onto a Hugging Face pre-trained GPT-2 model).

---

## Sunday Afternoon

We went over many (I'd say too many) papers on interpreting Transformers. Once again was brain was fried pretty quickly and my knowledge of transformers was too fresh to really get anything of what was going on. However, I do understand that attention blocks *seem* interpretable and there are some connections with linear algebra (e.g. the query-keys product is invariant by rotation of the two matrices, and something about working only in small subspaces of some big space).

[This illustration](https://www.lesswrong.com/posts/TvrfY4c9eaGLeyDkE/induction-heads-illustrated) is considered not bad, although you still have to ponder on it for a while.

We discussed the concern that interpretability itself is likely not a panacea but rather a nice, "cool" subject that can help to introduce ML practitioners to AI safety research.

---

## Takeaway

### Further Readings

- The same author wrote [*An Analogy for Understanding Transformers*](https://www.lesswrong.com/posts/euam65XjigaCJQkcN/an-analogy-for-understanding-transformers) very recently. He recommends having been through [Neel Nanda's tutorial on the subject](https://www.youtube.com/watch?v=bOYE6E8JrtU).
- The [Center for AI Safety introduction course](https://course.mlsafety.org/) which I intend to do already...

#### [SERI MATS streams](https://www.serimats.org/)

- Aligning Language Models
- Agent Foundations
- Consequentialist Cognition and Deep Constraints
- Cyborgism
- Deceptive AI
- Evaluating Dangerous Capabilities
- Interdisciplinary AI Safety
- Mechanistic Interpretability
- Multipolar AI Safety
- Powerseeking in Language Models
- Shard Theory
- Understanding AI Hacking

### Questions

- Is AI really that dangerous? As a student having taken courses on cryptography and privacy, I always find it surprisingly difficult to properly argue for the importance of privacy and safety with peers and practitioners who might be simply oblivious to these issues. The [AGI safety fundamentals](https://www.agisafetyfundamentals.com/ai-alignment-curriculum) could help give me arguments there?
- What is "grokking"?

### Final Thoughts

This was my first "formal" introduction to AI safety apart from hearing people talk about it around me and watching [Rob Miles videos](https://www.youtube.com/c/robertmilesai). Although the possibility of the future of humanity is supposedly at stake, my goal was just to get into some technical details. In the meantime I got to actually talk with very smart people that have been thinking about these issues for much longer than I have.

This is post number 003 of [#100daystooffload](https://100daystooffload.com/).
