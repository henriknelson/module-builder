MAGISK_MODULE_HOMEPAGE=https://github.com/rapidloop/rtop
MAGISK_MODULE_DESCRIPTION="Command-line fuzzy finder"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.0
MAGISK_MODULE_SRCURL=https://github.com/rapidloop/rtop/archive/release_${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=44ab02299a204befe49d725bdb76a249db419807e13b7ca451ba14ea5d3de1c2

magisk_step_make() {
	magisk_setup_golang

	export GOPATH=$MAGISK_MODULE_BUILDDIR

	mkdir -p $GOPATH/src/github.com/rapidloop
	mv $MAGISK_MODULE_SRCDIR $GOPATH/src/github.com/rapidloop/rtop
	MAGISK_MODULE_SRCDIR=$GOPATH/src/github.com/rapidloop/rtop

	cd $GOPATH/src/github.com/rapidloop/rtop
	go get -d -v github.com/rapidloop/rtop
	go build -v -o rtop -trimpath -ldflags "-L /system/lib -linkmode external -extldflags \"-lc -static\""
}

magisk_step_make_install() {
	cd $GOPATH/src/github.com/rapidloop/rtop

	install -Dm700 rtop $MAGISK_PREFIX/bin/rtop

	# Install the fzf.1 man page:
	#mkdir -p $MAGISK_PREFIX/share/man/man1/
	#cp $MAGISK_MODULE_SRCDIR/man/man1/rtop.1 $MAGISK_PREFIX/share/man/man1/

	# Install bash completion script:
	#mkdir -p $MAGISK_PREFIX/share/bash-completion/completions/
	#cp $MAGISK_MODULE_SRCDIR/shell/completion.bash $MAGISK_PREFIX/share/bash-completion/completions/fzf

	# Install the rest of the shell scripts:
	#mkdir -p $MAGISK_PREFIX/share/promp
	#cp $MAGISK_MODULE_SRCDIR/shell/* $MAGISK_PREFIX/share/fzf/

	# Install the nvim plugin:
	#mkdir -p $MAGISK_PREFIX/share/nvim/runtime/plugin
	#cp $MAGISK_MODULE_SRCDIR/plugin/fzf.vim $MAGISK_PREFIX/share/nvim/runtime/plugin/
}
