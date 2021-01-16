MAGISK_MODULE_HOMEPAGE=https://github.com/manifoldco/promptui
MAGISK_MODULE_DESCRIPTION="Command-line fuzzy finder"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=0.8.0
MAGISK_MODULE_SRCURL=https://github.com/manifoldco/promptui/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=3ef92d9991f3fe9fa85bdeb8546ae5b2c81a5a478c6ebcf356b2a6c25a59f219

# Depend on findutils as fzf uses the -fstype option, which busybox
# find does not support, when invoking find:
MAGISK_MODULE_DEPENDS="bash, findutils"

magisk_step_make() {
	magisk_setup_golang

	export GOPATH=$MAGISK_MODULE_BUILDDIR

	mkdir -p $GOPATH/src/github.com/manifoldco
	mv $MAGISK_MODULE_SRCDIR $GOPATH/src/github.com/manifoldco/promptui
	MAGISK_MODULE_SRCDIR=$GOPATH/src/github.com/manifoldco/promptui

	cd $GOPATH/src/github.com/manifoldco/promptui
	go get -d -v github.com/manifoldco/promptui
	go build -v -o libpromptui.a -trimpath -ldflags "-L /system/lib -linkmode external -extldflags \"-lc -static\""
}

magisk_step_make_install() {
	cd $GOPATH/src/github.com/manifoldco/promptui

	install -Dm700 libpromptui.a $MAGISK_PREFIX/lib/libpromptui.a

	# Install the fzf.1 man page:
	#mkdir -p $MAGISK_PREFIX/share/man/man1/
	#cp $MAGISK_MODULE_SRCDIR/man/man1/promptui.1 $MAGISK_PREFIX/share/man/man1/

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
