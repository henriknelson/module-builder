MAGISK_MODULE_HOMEPAGE=http://www.thekelleys.org.uk/dnsmasq/doc.html
MAGISK_MODULE_DESCRIPTION="Dnsmasq provides network infrastructure for small networks"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=2.80
MAGISK_MODULE_SRCURL=http://www.thekelleys.org.uk/dnsmasq/dnsmasq-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=cdaba2785e92665cf090646cba6f94812760b9d7d8c8d0cfb07ac819377a63bb
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_module_pre_configure() {
	#CFLAGS=" -static"
	LDFLAGS+=" -static"
}
