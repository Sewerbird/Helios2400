# Helios2400 <img src="https://travis-ci.org/Sewerbird/Helios2400.svg?branch=master" />

![Helios2400 Header](https://github.com/Sewerbird/Helios2400/blob/master/SemiFancyScreenie.png)

Helios 2400 is a Grand Strategy game set in the future Solar System: Imperial and Colonial factions of the solar empire vie for supremacy in the wake of a failed succession of the Terran throne.

## Inspiration

Helios2400 aims to be a spiritual remake of the 1996 Holistic Design game ["Emperor of the Fading Suns"](https://en.wikipedia.org/wiki/Emperor_of_the_Fading_Suns), updated for the 21st century. The king-of-the-hill and diplomatic aspects married to detailed planetary invasion are of particular import, and will be the core of Helios2400 gameplay.


## Installation

- Download & Install [LÖVE2D](https://love2d.org/) for your platform.
- Checkout this repository with [Git](https://git-scm.com/downloads).
- Run with `love .` in the repository root. You may have to set up an alias in your terminal.
- run_dev.sh (included in the repo) will run tests and then the game, assuming love.app is installed in your applications folder (**Mac only script**)

## Testing

- Uses [Busted](http://olivinelabs.com/busted/) for unit testing
- Run tests with `busted spec/` after installing busted ([luarocks](https://luarocks.org/) recommended)

## Getting Started

There are a few places to consider consulting in order to begin collaborating on Helios 2400:

- The [Project Page](https://github.com/Sewerbird/Helios2400/projects) here on Github holds the currently planned roadmaps. Here you can see which issues are being worked on actively and which issues are prioritized.
- The [Issue Page](https://github.com/Sewerbird/Helios2400/issues) is full of stuff that can be worked on. Please submit an issue if you found a problem that has not been noted already. Suggestion issues are welcome too, but please tag them as such.
- The [Github Wiki](https://github.com/Sewerbird/Helios2400/wiki) serves as a container for general documentation, although (as tends to be the case), the source-code is the base truth.
- Feel free to stop by [my blog](https://sewerbird.github.io) to get recent State of the Game announcements. There should be a section dedicated to Helios 2400, or conspicuous postings.

## Pull Request Process

The Helios2400 project accepts pull requests against the `master` branch. **Please make your pull requests relate to a single issue where possible: I'd prefer 3 pull requests for 3 issues than 1 pull request for 3 only-barely-related issues.**

I recommend writing your pull request summary and naming your branch following existing convention to keep things tidy:

- Branch names ideally follow the format `issue_##_briefdescription`
- Please rebase your commit history into semantic commits. I'd prefer not to have 'some changes', 'quick fix', and 'oops' as commit descriptions
- Pull requests should have a descriptive name, link to the issue being addressed, a checklist of features/items to be implemented, and finally any additional notes.
- Pull requests are reviewed using the built-in Github code review process before being merged into master.

If all of this is making you uneasy, **Don't Panic!** The workflow is explained better by [this quick summary](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow). We're basically aiming to make each issue a feature branch ;)

## Planned Design Departures

Although the game is very much inspired by Emperor of the Fading Suns, it is not a direct port. In particular, pragmatism suggests that NPC elements of the original game (the Church, the League, the Symbiots, and the Vau) won't have counterparts in Helios2400 at first. The initial minimal viable product will only implement the 'player houses', the Imperial agencies (including the Imperial Guard), Byzantium II (in the form of 2400AD Earth), and the Rebels. Additionally, tech-tree advancement is unprioritized. Other core elements of Emperor of the Fading Suns like diplomacy, ground-based combat, sceptres & nobles, and the Imperial Regency remain and are emphasized.

Although the removal of the NPC factions is a bit unfortunate, Helios2400 will introduce some of its own distinctive features:

- Helios2400's solar system map will include planet maps for each solid spherical body in the Solar System, and will introduce notions of Gravity and Atmosphere for units.
- Helios2400 could potentially feature a simultaneous playmode like Europa Universalis 4, although this would be dependent on results from playtesting. Otherwise Helios2400 will be turn-based like Emperor of the Fading Suns.

## Premium Plans

Although Helios2400 is open source software, there are plans to seek funding for its development and art assets. A premium version of Helios2400 with lovely art assets and expanded scenarios is in the works. The source-code and art assets shared on this repository, however, are covered by the permissive license listed at the bottom of this readme.

## Acknowledgements

Thanks goes to [Coderbunker](http://www.coderbunker.com/) for support in finding developers and funding and encouragement for Helios2400.

### Contributors

- **Edward Miller** Producer & Lead Developer of Helios2400
- **Ricky Ng-Adam** Coderbunker Founder

### Music

"Ritual" **Kevin MacLeod** (incompetech.com)
Licensed under Creative Commons: By Attribution 3.0 License
http://creativecommons.org/licenses/by/3.0/

## License/Legal

This entire repository's source code is licensed under [The MIT License](https://github.com/Sewerbird/Helios2400/blob/master/LICENSE.md), listed in this repository's root directory in LICENSE.md
