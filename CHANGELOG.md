## 06 Dec 2104: 0.5.1

- Typo resulted in incorrect handling (error thrown) when the path started with `./` in the `lcon.info` file

... getting back to the flippant test coverage comment on this project ...

## 06 Dec 2014: 0.5.0

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
