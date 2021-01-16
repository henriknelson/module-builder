MAGISK_MODULE_HOMEPAGE=https://github.com/asciinema
MAGISK_MODULE_DESCRIPTION="Command-line fuzzy finder"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=2.0.2
MAGISK_MODULE_SRCURL=https://github.com/asciinema/asciinema/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=2578a1b5611e5375771ef6582a6533ef8d40cdbed1ba1c87786fd23af625ab68
#MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_extract_module() {
	git clone -b golang https://github.com/asciinema/asciinema.git $MAGISK_MODULE_SRCDIR
}

magisk_step_make() {
	magisk_setup_golang

	export GOPATH=$MAGISK_MODULE_BUILDDIR

	mkdir -p $GOPATH/src/github.com/asciinema
	mv $MAGISK_MODULE_SRCDIR $GOPATH/src/github.com/asciinema/asciinema
	MAGISK_MODULE_SRCDIR=$GOPATH/src/github.com/asciinema/asciinema

	cd $GOPATH/src/github.com/asciinema/asciinema
	go get -d -v github.com/asciinema/asciinema
	#patch -i $MAGISK_MODULE_BUILDER_DIR/pty_linux.go.patch
	#CC=aarch64-linux-android-clang make build
	go build -v -o asciinema -trimpath -ldflags "-L /system/lib -linkmode external -extldflags \"-lc -lm -ldl -static\""
}

magisk_step_make_install() {
	cd $GOPATH/src/github.com/asciinema/asciinema
	install -Dm700 bin/asciinema $MAGISK_PREFIX/bin/asciinema

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
