MAGISK_MODULE_HOMEPAGE=http://caca.zoy.org/wiki/toilet
MAGISK_MODULE_DESCRIPTION="FIGlet-compatible display of large colourful characters in text mode"
MAGISK_MODULE_LICENSE="WTFPL"
MAGISK_MODULE_VERSION=0.3
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/xbmc/mDNSResponder/archive/master.zip
MAGISK_MODULE_SHA256=SKIP_CHECKSUM
#MAGISK_MODULE_DEPENDS="libcaca,zlib"
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_post_configure() {
	export CFLAGS=""
	return
commonFlags="-O2 -g -fno-strict-aliasing    -D_GNU_SOURCE     -DHAVE_IPV6    -DNOT_HAVE_SA_LEN    -DPLATFORM_NO_RLIMIT    -DMDNS_DEBUGMSGS=0    -DMDNS_UDS_SERVERPATH=\"/dev/socket/mdnsd\"     -DMDNS_USERNAME=\"mdnsr\"     -W     -Wall     -Wextra     -Wno-array-bounds     -Wno-pointer-sign    -Wno-unused     -Wno-unused-but-set-variable    -Wno-unused-parameter    -Werror=implicit-function-declaration"

     export LOCAL_CFLAGS="$(commonFlags)  -DTARGET_OS_LINUX   -DMDNS_VERSIONSTR_NODTS=1    -DUSES_NETLINK "

     commonSources="mDNSShared/dnssd_clientlib.c   mDNSShared/dnssd_clientstub.c    mDNSShared/dnssd_ipc.c"

     commonLibs="libcutils liblog"

daemonSources="mDNSCore/mDNS.c                  mDNSCore/DNSDigest.c                     mDNSCore/uDNS.c                             mDNSCore/DNSCommon.c                      mDNSShared/uds_daemon.c                mDNSShared/mDNSDebug.c               mDNSShared/dnssd_ipc.c                     mDNSShared/GenLinkedList.c                  mDNSShared/PlatformCommon.c                 mDNSPosix/PosixDaemon.c                     mDNSPosix/mDNSPosix.c  mDNSPosix/mDNSUNP.c"
daemonIncludes="external/mdnsresponder/mDNSCore  external/mdnsresponder/mDNSShared  external/mdnsresponder/mDNSPosix"


     export LOCAL_FORCE_STATIC_EXECUTABLE=true
     export LOCAL_INIT_RC=mdnsd.rc
#include $(BUILD_EXECUTABLE)
#include $(CLEAR_VARS)
	export LOCAL_SRC_FILES=$(daemonSources)
	export LOCAL_MODULE=mdnsd
	export LOCAL_MODULE_TAGS=optional
	export LOCAL_C_INCLUDES=$(daemonIncludes)


	#export CACA_LIBS="-lcaca -lz -lncursesw"
}

mmagisk_step_post_extract_module() {
	rm -r $MAGISK_MODULE_SRCDIR/*
	tar xf $MAGISK_MODULE_CACHEDIR/master.tar.gz -C $MAGISK_MODULE_SRCDIR
}

mmagisk_step_make() {
	printenv
	#tree
	#echo $(pwd)
	cd $MAGISK_MODULE_SRCDIR/mDNSPosix
	cc="$CC" CFLAGS="$CFLAGS --host aarch64-linux-android" make V=1 -j4 os=linux-cglibc
}
