MAGISK_MODULE_HOMEPAGE=https://dejavu-fonts.github.io/
MAGISK_MODULE_DESCRIPTION="Font family based on the Bitstream Vera Fonts with a wider range of characters"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=2.37
MAGISK_MODULE_REVISION=7
MAGISK_MODULE_SRCURL=https://downloads.sourceforge.net/project/dejavu/dejavu/${MAGISK_MODULE_VERSION}/dejavu-fonts-ttf-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=fa9ca4d13871dd122f61258a80d01751d603b4d3ee14095d65453b4e846e17d7
MAGISK_MODULE_PLATFORM_INDEPENDENT=true
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_CONFFILES="
etc/fonts/conf.d/20-unhint-small-dejavu-sans-mono.conf
etc/fonts/conf.d/20-unhint-small-dejavu-sans.conf
etc/fonts/conf.d/20-unhint-small-dejavu-serif.conf
etc/fonts/conf.d/57-dejavu-sans-mono.conf
etc/fonts/conf.d/57-dejavu-sans.conf
etc/fonts/conf.d/57-dejavu-serif.conf
"

magisk_step_make_install() {
	## Install fonts.
	mkdir -p "${MAGISK_PREFIX}/usr/share/fonts/TTF"
	cp -f ttf/*.ttf "${MAGISK_PREFIX}/usr/share/fonts/TTF/"

	## Install config files used by 'fontconfig' package.
	mkdir -p "${MAGISK_PREFIX}/etc/fonts/conf.d"
	cp -f fontconfig/*.conf "${MAGISK_PREFIX}/etc/fonts/conf.d/"
}
