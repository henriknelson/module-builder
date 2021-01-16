MAGISK_MODULE_HOMEPAGE=https://lastpass.com/
MAGISK_MODULE_DESCRIPTION="LastPass command line interface tool"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=1.3.3
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=https://github.com/lastpass/lastpass-cli/archive/v$MAGISK_MODULE_VERSION/lastpass-cli-$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=f38e1ee7e06e660433a575a23b061c2f66ec666d746e988716b2c88de59aed73
MAGISK_MODULE_DEPENDS="libcurl, libxml2, openssl, pinentry"
MAGISK_MODULE_SUGGESTS="magisk-api"
#MAGISK_MODULE_EXTRA_CONFIGURE_ARGS=""

magisk_step_pre_configure() {
	export LDFLAGS="-L/system/lib -lz -lxml2 $LDFLAGS"
}

magisk_step_post_make_install() {
	ninja install-doc

	install -Dm600 "$MAGISK_MODULE_SRCDIR"/contrib/lpass_zsh_completion \
		"$MAGISK_PREFIX"/usr/share/zsh/site-functions/_lpass

	install -Dm600 "$MAGISK_MODULE_SRCDIR"/contrib/completions-lpass.fish \
		"$MAGISK_PREFIX"/usr/share/fish/completions/lpass.fish
}
