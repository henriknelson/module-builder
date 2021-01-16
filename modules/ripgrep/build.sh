MAGISK_MODULE_HOMEPAGE=https://github.com/BurntSushi/ripgrep
MAGISK_MODULE_DESCRIPTION="Search tool like grep and The Silver Searcher"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=12.1.1
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/BurntSushi/ripgrep/archive/$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=2513338d61a5c12c8fea18a0387b3e0651079ef9b31f306050b1f0aaa926271e
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_post_make_install() {
	# Install man page:
	mkdir -p $MAGISK_PREFIX/share/man/man1/
	cp $(find . -name rg.1) $MAGISK_PREFIX/share/man/man1/

	# Install bash completion script:
	mkdir -p $MAGISK_PREFIX/share/bash-completion/completions/
	cp $(find . -name rg.bash) $MAGISK_PREFIX/share/bash-completion/completions/rg

	# Install fish completion script:
	mkdir -p $MAGISK_PREFIX/share/fish/completions/
	cp $(find . -name rg.fish) $MAGISK_PREFIX/share/fish/completions/

	# Install zsh completion script:
	mkdir -p $MAGISK_PREFIX/share/zsh/site-functions/
	cp complete/_rg $MAGISK_PREFIX/share/zsh/site-functions/
}
