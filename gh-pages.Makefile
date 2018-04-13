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

ghp-publish: ghp-clone ghp-verify-url ghp-clean ghp-fetch ghp-checkout ghp-rm ghp-copy ghp-set-user ghp-commit ghp-push

ghp-clone:
	$(GIT) clone $(GHP_REPO) $(GHP_CACHE_DIR) --branch $(GHP_BRANCH) --single-branch --origin $(GHP_REMOTE) --depth $(GHP_DEPTH)

ghp-verify-url:
	test "`$(GCD) config --get remote.$(GHP_REMOTE).url`" = $(GHP_REPO)

ghp-clean:
	$(GCD) clean -f -d

ghp-fetch:
	$(GCD) fetch $(GHP_REMOTE)

ghp-checkout:
	$(GCD) ls-remote --exit-code . $(GHP_REMOTE)/$(GHP_BRANCH) && ($(GIT) checkout $(GHP_REMOTE)/$(GHP_BRANCH); $(GIT) clean; $(GIT) reset --hard $(GHP_REMOTE)/$(GHP_BRANCH)) || $(GIT) checkout --orphan $(GHP_BRANCH)

ghp-rm:
	test -n $(GHP_RM) && $(GIT) rm --ignore-unmatch -r -f $(GHP_RM)

ghp-copy:
	find $(GHP_SRC) -type d -exec mkdir -p "$(GHP_CACHE_DIR)/$(GHP_DEST)/{}" \; -o -type f -exec cp '{}' "$(GHP_CACHE_DIR)/$(GHP_DEST)/{}" \;

ghp-set-user:
	test -n $(GHP_USER) && $(GIT) config user.name $(GHP_USER) && git config user.email $(GHP_EMAIL)

ghp-commit:
	$(GIT) add .
	$(GIT) diff-index --quiet HEAD || $(GIT) commit -m $(GHP_COMMIT_MESSAGE)
	$(GIT) tag $(GHP_TAG) || true

ghp-push:
	$(GIT) push --tags $(GHP_REMOTE) $(GHP_BRANCH)

gh-pages-clean:
	$(RM) -r $(GHP_CACHE_DIR)

.PHONY: gh-pages ghp-publish ghp-clone ghp-verify-url ghp-clean ghp-fetch ghp-checkout ghp-rm ghp-copy ghp-set-user ghp-commit ghp-push gh-pages-clean

