MAGISK_MODULE_HOMEPAGE=https://github.com/dandavison/delta
MAGISK_MODULE_DESCRIPTION="A syntax-highlighter for git and diff output"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=0.4.3
MAGISK_MODULE_SRCURL=https://github.com/dandavison/delta/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=78ee36ec30194fe261ccb585111b67adae5166e79170f9636e54cbf5427da54a
#MAGISK_MODULE_DEPENDS="git"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	rm -f Makefile release.Makefile
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"
	export LDFLAGS="$LDFLAGS -static"
}

magisk_step_post_make_install() {
	install -Dm700 -t "$MAGISK_PREFIX"/bin \
		"$MAGISK_MODULE_SRCDIR/target/$CARGO_TARGET_NAME"/release/delta
	install -Dm600 "$MAGISK_MODULE_SRCDIR"/etc/completion/completion.bash \
		"$MAGISK_PREFIX"/share/bash-completion/completions/delta
}
