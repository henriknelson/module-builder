MAGISK_MODULE_HOMEPAGE=https://github.com/owenthereal/ccat
MAGISK_MODULE_DESCRIPTION="Command-line fuzzy finder"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.1.0
MAGISK_MODULE_SRCURL=https://github.com/owenthereal/ccat/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=b02d2c8d573f5d73595657c7854c9019d3bd2d9e6361b66ce811937ffd2bfbe1

mmagisk_step_pre_configure() {
	tree $MAGISK_MODULE_BUILDDIR
}

magisk_step_make() {
	magisk_setup_golang

	#MUSL_PATH=/usr/local/musl/bin
        #export PATH=$MUSL_PATH:$PATH
	export TARGET=aarch64-linux-android
	export CFLAGS="-I/$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/include -g -O0"
	export CC=${TARGET}-gcc
	export GCC=${TARGET}-g++
	export LD=${TARGET}-ld
	#export GCC=$MUSL_PATH/${TARGET}-gcc
	#export LD=$MUSL_PATH/${TARGET}-ld
	export GOPATH=$MAGISK_MODULE_BUILDDIR

	mkdir -p $GOPATH/src/github.com/jingweno
	mv $MAGISK_MODULE_SRCDIR $GOPATH/src/github.com/jingweno/ccat
	MAGISK_MODULE_SRCDIR=$GOPATH/src/github.com/jingweno/ccat

	cd $GOPATH/src/github.com/jingweno/ccat
	go get -d -v github.com/jingweno/ccat
	tree $GOPATH
	#CC=aarch64-linux-android-gcc
	#CXX=aarch64-linux-android-g++
	#CC="/usr/local/musl/bin/aarch64-linux-musl-gcc"
	#LDFLAGS+=" -L$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/lib"
	#CFLAGS+=" -I$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/include -stdlib=libc++"
	#export CC_FOR_TARGET=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang
	#export CC=$CC_FOR_TARGET
	#export CGO_LDFLAGS="-L/system/lib -static"
	echo "building"
	go env
	#CXXFLAGS="$CFLAGS"
	#CPPFLAGS="$CFLAGS"
	go get -d -v github.com/jingweno/ccat
        go build -x -v -ldflags "-linkmode external -extldflags \"-v -L/system/lib -ldl -static\""

	#go get -v
	#export CGO_LDFLAGS+=" -Wl,-unresolved-symbols=ignore-all"
	#go build -x -v -o ccat -ldflags "-linkmode external -extldflags \"-L/system/lib -lc -ldl -static\""
	#go tool compile
	#go tool link -v -a -d -ldflags " -v -linkmode external -extldflags \"-static\""
}

magisk_step_make_install() {
	cd $GOPATH/src/github.com/owenthereal/ccat

	install -Dm700 ccat $MAGISK_PREFIX/bin/ccat

	# Install fzf-tmux, a bash script for launching fzf in a tmux pane:
	#install -Dm700 $MAGISK_MODULE_SRCDIR/bin/fzf-tmux $MAGISK_PREFIX/bin/fzf-tmux

	# Install the fzf.1 man page:
	#mkdir -p $MAGISK_PREFIX/share/man/man1/
	#cp $MAGISK_MODULE_SRCDIR/man/man1/fzf.1 $MAGISK_PREFIX/share/man/man1/

	# Install bash completion script:
	#mkdir -p $MAGISK_PREFIX/share/bash-completion/completions/
	#cp $MAGISK_MODULE_SRCDIR/shell/completion.bash $MAGISK_PREFIX/share/bash-completion/completions/fzf

	# Install the rest of the shell scripts:
	#mkdir -p $MAGISK_PREFIX/share/fzf
	#cp $MAGISK_MODULE_SRCDIR/shell/* $MAGISK_PREFIX/share/fzf/

	# Install the nvim plugin:
	#mkdir -p $MAGISK_PREFIX/share/nvim/runtime/plugin
	#cp $MAGISK_MODULE_SRCDIR/plugin/fzf.vim $MAGISK_PREFIX/share/nvim/runtime/plugin/
}
