GIT?=git

# These can be set to override some behavior
#GHP_USER=
#GHP_EMAIL=
#GHP_PUSH=

GHP_SRC?=.
GHP_DEST?=.
GHP_CACHE_DIR?=../.gh-pages-cache
GHP_BRANCH?=gh-pages
GHP_REMOTE?=origin
GHP_DEPTH?=1
GHP_RM?=.
GHP_COMMIT_MESSAGE?=Updates

GHP_REPO?=$(shell git config --get remote.$(GHP_REMOTE).url)

ifeq ($(OS),Windows_NT)
GCD=cd $(GHP_CACHE_DIR) & $(GIT)
GHP_CACHE_DIR:=$(subst /,\,$(GHP_CACHE_DIR))
else
GCD=cd $(GHP_CACHE_DIR); $(GIT)
endif

gh-pages: ghp-publish

ghp-publish: ghp-clone ghp-verify-url ghp-clean ghp-fetch ghp-checkout ghp-rm ghp-copy ghp-set-user ghp-commit ghp-push

ghp-clone:
	$(GIT) clone $(GHP_REPO) $(GHP_CACHE_DIR) --branch $(GHP_BRANCH) --single-branch --origin $(GHP_REMOTE) --depth $(GHP_DEPTH)

ghp-verify-url:
ifeq ($(OS),Windows_NT)
	cd $(GHP_CACHE_DIR) & FOR /f "tokens=*" %%i IN ('$(GIT) config --get remote.$(GHP_REMOTE).url') DO if not "%%i" == "$(GHP_REPO)" exit 2
else
	test "`$(GCD) config --get remote.$(GHP_REMOTE).url`" = $(GHP_REPO)
endif

ghp-clean:
	$(GCD) clean -f -d

ghp-fetch:
	$(GCD) fetch $(GHP_REMOTE)

ghp-checkout:
ifeq ($(OS),Windows_NT)
	(($(GCD) ls-remote --exit-code . $(GHP_REMOTE)/$(GHP_BRANCH)) && ($(GCD) checkout $(GHP_BRANCH))) || ($(GCD) checkout --orphan $(GHP_BRANCH))
	$(GCD) clean -f
	$(GCD) reset --hard $(GHP_REMOTE)/$(GHP_BRANCH)
else
	$(GCD) ls-remote --exit-code . $(GHP_REMOTE)/$(GHP_BRANCH) && ($(GIT) checkout $(GHP_REMOTE)/$(GHP_BRANCH); $(GIT) clean; $(GIT) reset --hard $(GHP_REMOTE)/$(GHP_BRANCH)) || $(GIT) checkout --orphan $(GHP_BRANCH)
endif

ghp-rm:
ifneq ($(GHP_RM),)
	$(GCD) rm --ignore-unmatch -r -f $(GHP_RM)
endif

ghp-copy:
ifeq ($(OS),Windows_NT)
	xcopy /Y /I $(GHP_SRC) $(GHP_CACHE_DIR)\\$(GHP_DEST)
else
	find $(GHP_SRC) -type d -exec mkdir -p "$(GHP_CACHE_DIR)/$(GHP_DEST)/{}" \; -o -type f -exec cp '{}' "$(GHP_CACHE_DIR)/$(GHP_DEST)/{}" \;
endif

ghp-set-user:
ifdef GHP_USER
	$(GCD) config user.name $(GHP_USER)
	$(GCD) config user.email $(GHP_EMAIL)
endif

ghp-commit:
	$(GCD) add .
	$(GCD) diff-index --quiet HEAD || $(GIT) commit -m $(GHP_COMMIT_MESSAGE)
	$(GCD) tag $(GHP_TAG) || true

ghp-push:
ifdef GHP_PUSH
	$(GCD) push --tags $(GHP_REMOTE) $(GHP_BRANCH)
endif

gh-pages-clean:
ifeq ($(OS),Windows_NT)
	rmdir /S /Q $(GHP_CACHE_DIR)
else
	$(RM) -r $(GHP_CACHE_DIR)
endif

.PHONY: gh-pages ghp-publish ghp-clone ghp-verify-url ghp-clean ghp-fetch ghp-checkout ghp-rm ghp-copy ghp-set-user ghp-commit ghp-push gh-pages-clean

