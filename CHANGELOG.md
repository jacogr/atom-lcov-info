## Releases

### 0.9.1

- Style update to be both less obtrusive, yet more visible.
- Gutter now has a little dot display, immediate visibility in addition to highlight.
- Gutter always displays, only line highlights can be switched off.

... prettier, but as they say, beauty is in the eye of the beer holder ...

### 0.9.0

- Allow the for the existence of duplicate lines as well as files in the `coverage/lcov.info` file, combining the data, hits and relevancy
- Line 0 should not be included, now it is ignored
- Local coverage map is not almost on-par (at least from a calculation perspective) with [coveralls.io](https://coveralls.io)
- Styles now fully adapted to use the shadow DOM, no conversion on the Atom side
- Be explicit in project overview, the previous 'Strength' is the 'Hits/Line'

... statistics, statistics, damn lies and statistics ...

### 0.8.4

- Load styles in the context of the text-editor, which allow for use with the shadow DOM (while not breaking "old/current mode")
- Welcome side-effect of using in the atom-text-editor context is that the current highlighted line still displays the decoration

... preparing for the future ...

### 0.8.3

- Always show the project info overview when found, even when specific file doesn't have coverage

... small fixes for more usability ...

### 0.8.2

... no change, muck-up in release, branch not merged - becomes 0.8.3 ...

### 0.8.1

- Update of the first screenshot, the first time-conversion didn't take

... ummm, nothing much to do there, but screenshots being correct are important ...

### 0.8.0

- Add overlay panel that shows the full project coverage information
- Project overview panel mangled beyond recognition from [https://github.com/philipgiuliani/coverage/](https://github.com/philipgiuliani/coverage/)
- Once again, screenshots updated to reflect the new UI

... not prefect, but getting closer to a local at-the-moment view of the brilliant [coveralls.io](https://coveralls.io) ...


### 0.7.0

- Only parse `coverage/lcov.info` once unless the file has changed on-disk
- Calculate global file coverage information (paves the way for future overall stats)
- Rework update of status & coverage information when switching tabs
- Update of highlights for line/gutter now works when you switch to a tab (no config update listener - keeping an eye on this)
- Style update to make the highlights display better in both light and dark environments
- Obligatory screen capture updates now that the styles look quite different

... making progress, getting more robust ...


### 0.6.0

- Split all the lcov.info handling into [lib/coverage-lcov.coffee](lib/coverage-lcov.coffee), keeping [lib/lcov-info-view.coffee](lcov-info-view.coffee) to deal with what it does best - managing the view
- Add link to the actual Atom package in [README.md](README.md), available via [https://atom.io/packages/lcov-info](https://atom.io/packages/lcov-info)
- Add first screenshot, helps when you can see it in action before installation
- Highlights can now be toggled to either show on the line (default) or the gutter (less obtrusive)

... now it really does become much easier to test, pondering how to extract coverage info to eat own dogfood on this specific project (not the other unrelated ones that lead to this plugin) ...


### 0.5.1

- Typo resulted in incorrect handling (error thrown) when the path started with `./` in the `lcon.info` file

... getting back to the flippant test coverage comment on this project ...

### 0.5.0

- Initial version & first Atom package registry entry
- Mangled beyond recognition using [https://github.com/benjamine/highlight-cov](https://github.com/benjamine/highlight-cov) as a starting point
- Toggle can be used globally to switch display on/off, no surprises
- Views each has their own decoration, these are updated as tabs are switched
- Statusbar reflects the per file coverage percentage as 100.00*covered-lines/total-lines
- Path matching happens on the business end of the filenames, i.e. `/Users/joe/Projects/test/src/xyz/something.coffee` matches `src/xyz/something.coffee` in the `coverage/lcov.info` file
- Both / and \ style path separators are supported, cross-matching in Atom and the `lcov.info` files
- Karma-style outputs, i.e. `./src/...` as well as Mocha-style, i.e. `src/...` works as expected
- Path matching stops on the first match, no extra comparisons are done

... the irony of not having full test-coverage for this package is not lost on me ...
