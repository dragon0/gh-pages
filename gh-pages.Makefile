GIT?=git

GHP_SRC?=.
GHP_DEST?=.
GHP_CACHE_DIR?=../.gh-pages-cache
GHP_BRANCH?=gh-pages
GHP_REMOTE?=origin
GHP_DEPTH?=1
GHP_RM?=.
GHP_COMMIT_MESSAGE?=Updates

GHP_REPO?=$(shell git config --get remote.$(GHP_REMOTE).url)

GCD=cd $(GHP_CACHE_DIR); $(GIT)

gh-pages: ghp-publish
	@echo not implemented; false

ghp-publish: ghp-clone ghp-verify-url ghp-clean ghp-fetch ghp-checkout ghp-rm ghp-copy ghp-set-user ghp-commit ghp-push

ghp-clone:

ghp-verify-url:

ghp-clean:

ghp-fetch:

ghp-checkout:

ghp-rm:

ghp-copy:

ghp-set-user:

ghp-commit:

ghp-push:

gh-pages-clean:

