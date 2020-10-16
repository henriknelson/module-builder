MAGISK_MODULE_HOMEPAGE=https://github.com/junegunn/fzf
MAGISK_MODULE_DESCRIPTION="Command-line fuzzy finder"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=0.22.0
MAGISK_MODULE_SRCURL=https://github.com/junegunn/fzf/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=3090748bb656333ed98490fe62133760e5da40ba4cd429a8142b4a0b69d05586

# Depend on findutils as fzf uses the -fstype option, which busybox
# find does not support, when invoking find:
MAGISK_MODULE_DEPENDS="bash, findutils"

magisk_step_make() {
	magisk_setup_golang

	export GOPATH=$MAGISK_MODULE_BUILDDIR

	mkdir -p $GOPATH/src/github.com/junegunn
	mv $MAGISK_MODULE_SRCDIR $GOPATH/src/github.com/junegunn/fzf
	MAGISK_MODULE_SRCDIR=$GOPATH/src/github.com/junegunn/fzf

	cd $GOPATH/src/github.com/junegunn/fzf
	go get -d -v github.com/junegunn/fzf
	go build -v -o fzf -trimpath -ldflags "-L /system/lib -linkmode external -extldflags \"-lc -static\""
}

magisk_step_make_install() {
	cd $GOPATH/src/github.com/junegunn/fzf

	install -Dm700 fzf $MAGISK_PREFIX/bin/fzf

	# Install fzf-tmux, a bash script for launching fzf in a tmux pane:
	install -Dm700 $MAGISK_MODULE_SRCDIR/bin/fzf-tmux $MAGISK_PREFIX/bin/fzf-tmux

	# Install the fzf.1 man page:
	mkdir -p $MAGISK_PREFIX/share/man/man1/
	cp $MAGISK_MODULE_SRCDIR/man/man1/fzf.1 $MAGISK_PREFIX/share/man/man1/

	# Install bash completion script:
	mkdir -p $MAGISK_PREFIX/share/bash-completion/completions/
	cp $MAGISK_MODULE_SRCDIR/shell/completion.bash $MAGISK_PREFIX/share/bash-completion/completions/fzf

	# Install the rest of the shell scripts:
	mkdir -p $MAGISK_PREFIX/share/fzf
	cp $MAGISK_MODULE_SRCDIR/shell/* $MAGISK_PREFIX/share/fzf/

	# Install the nvim plugin:
	mkdir -p $MAGISK_PREFIX/share/nvim/runtime/plugin
	cp $MAGISK_MODULE_SRCDIR/plugin/fzf.vim $MAGISK_PREFIX/share/nvim/runtime/plugin/
}
