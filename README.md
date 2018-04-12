# gh-pages
Makefile for copying a folder to the gh-pages branch

To use, create a Makefile, add definitions for the various GHP_\* variables, and then include this gh-pages.Makefile.

Example Makefile:

```Makefile
GHP_SRC=build
GHP_DEST=docs
include gh-pages.Makefile

# ... other Make rules
```

Then run `make gh-pages`.

