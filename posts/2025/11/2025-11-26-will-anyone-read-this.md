---
thumbnail: /gfx/news/2025/11/release-notes-thumbnail.png
summary: A lesson in experimentation and UX design.
---

# Will anyone read this?

*A lesson in experimentation and UX design.*

<img src="/gfx/news/2025/11/release-notes-partial.png" class="float-right-md" />

I recently watched a driver use Sidecar for the first time.

For context, when Sidecar first runs, or when a new major release launches, Sidecar shows release notes. With the iOS 26 update, I made the release notes appear as a half sheet by default, taking advantage of the new glass effect.

Back to the new driver though. They installed and launched Sidecar, the release notes appeared...and they immediately swiped them away 😭 I had an immediate flashback to the ["Devs watching QA test the product"](https://www.tiktok.com/@tired_actor/video/6912855387788102918) video.

<iframe width="320" src="https://www.youtube.com/embed/baY3SaIhfl0?si=HU_cimuYjZ9PYXU7" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

To be fair, it's well understood that people rarely read documentation, much less release notes. But it got me thinking: was the half-sheet presentation part of the problem?

Turns out it was.

---

## The experiment

I recently started using [Statsig](https://statsig.com), which has been an awesome tool for this.

I set up a simple A/B test: 50% of drivers would see the release notes as a half-sheet (the control), and 50% would see them full-screen (the test).

<div style="display: flex; gap: 1rem;">
  <figure style="margin: 0; text-align: center; flex: 1;">
    <figcaption style="margin-bottom: 0.5rem;">Half-sheet (control)</figcaption>
    <img src="/gfx/news/2025/11/release-notes-partial.png" style="width: 100%;" />
  </figure>
  <figure style="margin: 0; text-align: center; flex: 1;">
    <figcaption style="margin-bottom: 0.5rem;">Full-screen (test)</figcaption>
    <img src="/gfx/news/2025/11/release-notes-fullscreen.png" style="width: 100%;" />
  </figure>
</div>

The question I wanted to answer was "Are drivers more likely to read the release notes to the end if the sheet is presented full-screen?"

I created a simple ratio metric that measures the % of drivers who scroll to the bottom of the content and have been running the experiment ran for about a week now.

---

## The results

**Drivers are 39.7% more likely to read everything when the notes are presented full-screen.**

The half-sheet group had a ~5.5% completion rate while the full-screen group hit ~8%. This confirms both that very few people read the release notes, but also that the experiment caused more people to read them than otherwise would have.

![100%](/gfx/news/2025/11/release-notes-statsig-results.png)

Digging into the results a bit more it's also interesting to see that the effect is strongest among non-members, with ~48% of non-members being more likely to read the full notes vs only ~6.5% of members.

![100%](/gfx/news/2025/11/release-notes-statsig-members.png)

## My takeaway

The "less intrusive" choice was also less effective, and people who might have otherwise read the release notes were bouncing off before they had a chance to read them. I'll very likely be promoting the full-screen variant for release notes as a result.

This is one of those changes I didn't give a ton of thought to when I made it originally, but as I start to ramp up focus on the new user experience I'm excited to keep trying different experiments like this.

Drive safe, and happy thanksgiving to those in the states!

-- Jeff
