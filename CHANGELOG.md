## 0.8.0

- Add overlay panel that shows the full project coverage information
- Project overview mangled beyond recognition from [https://github.com/philipgiuliani/coverage/](https://github.com/philipgiuliani/coverage/)

## 0.7.0

- Only parse `coverage/lcov.info` once unless the file has changed on-disk
- Calculate global file coverage information (paves the way for future overall stats)
- Rework update of status & coverage information when switching tabs
- Update of highlights for line/gutter now works when you switch to a tab (no config update listener - keeping an eye on this)
- Style update to make the highlights display better in both light and dark environments
- Obligatory screen capture updates now that the styles look quite different

... making progress, getting more robust ...

## 0.6.0

- Split all the lcov.info handling into [lib/coverage-lcov.coffee](lib/coverage-lcov.coffee), keeping [lib/lcov-info-view.coffee](lcov-info-view.coffee) to deal with what it does best - managing the view
- Add link to the actual Atom package in [README.md](README.md), available via [https://atom.io/packages/lcov-info](https://atom.io/packages/lcov-info)
- Add first screenshot, helps when you can see it in action before installation
- Highlights can now be toggled to either show on the line (default) or the gutter (less obtrusive)

... now it really does become much easier to test, pondering how to extract coverage info to eat own dogfood on this specific project (not the other unrelated ones that lead to this plugin) ...

## 0.5.1

- Typo resulted in incorrect handling (error thrown) when the path started with `./` in the `lcon.info` file

... getting back to the flippant test coverage comment on this project ...

## 0.5.0

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
