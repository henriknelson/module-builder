MAGISK_MODULE_HOMEPAGE=https://www.tcpdump.org
MAGISK_MODULE_DESCRIPTION="Library for network traffic capture"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.9.1
MAGISK_MODULE_SHA256=028c199f4b7334c128b92cb76e4652e5a0a644bac6c9b356c2e2275824994dde
# The main tcpdump.org was down 2017-04-12, so we're using a mirror:
MAGISK_MODULE_SRCURL=https://fossies.org/linux/misc/libpcap-1.9.1.tar.xz
# ac_cv_lib_nl_3_nl_socket_alloc=no to avoid linking against libnl:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_lib_nl_3_nl_socket_alloc=no --with-pcap=linux"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/pcap-config share/man/man1/pcap-config.1"
MAGISK_MODULE_BUILD_IN_SRC="yes"
