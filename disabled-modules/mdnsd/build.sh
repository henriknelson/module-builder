MAGISK_MODULE_HOMEPAGE=http://caca.zoy.org/wiki/toilet
MAGISK_MODULE_DESCRIPTION="FIGlet-compatible display of large colourful characters in text mode"
MAGISK_MODULE_LICENSE="WTFPL"
MAGISK_MODULE_VERSION=0.3
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/evilperfect/Android-mDnsdResponder/archive/master.zip
MAGISK_MODULE_SHA256=SKIP_CHECKSUM
#MAGISK_MODULE_DEPENDS="libcaca,zlib"
MAGISK_MODULE_BUILD_IN_SRC=yes

setups() {
	#LOCAL_PATH=$(call my-dir)

	##############  mdnsd  #################

	#include $(CLEAR_VARS)
	export LOCAL_SRC_FILES="mDNSPosix/PosixDaemon.c    \
                    mDNSPosix/mDNSPosix.c      \
                    mDNSPosix/mDNSUNP.c        \
                    mDNSCore/mDNS.c            \
                    mDNSCore/DNSDigest.c       \
                    mDNSCore/uDNS.c            \
                    mDNSCore/DNSCommon.c       \
                    mDNSShared/uds_daemon.c    \
                    mDNSShared/mDNSDebug.c     \
                    mDNSShared/dnssd_ipc.c     \
                    mDNSShared/GenLinkedList.c \
                    mDNSShared/PlatformCommon.c \
                    mDNSCore/anonymous.c        \
                    mDNSCore/CryptoAlg.c"


	LOCAL_MODULE=mdnsd
	LOCAL_MODULE_TAGS=optional

	LOCAL_C_INCLUDES="external/mdnsresponder/mDNSPosix \
                    external/mdnsresponder/mDNSCore  \
                    external/mdnsresponder/mDNSShared"

LOCAL_CFLAGS=" -O2 -g -W -Wall "
LOCAL_CFLAGS+="-D__ANDROID__  "
LOCAL_CFLAGS+="-D_GNU_SOURCE "
LOCAL_CFLAGS+="-DHAVE_IPV6=1 "
LOCAL_CFLAGS+="-DNOT_HAVE_SA_LEN "
LOCAL_CFLAGS+="-DUSES_NETLINK=1"
LOCAL_CFLAGS+="-DTARGET_OS_LINUX" 
LOCAL_CFLAGS+="-fno-strict-aliasing "
LOCAL_CFLAGS+="-DHAVE_LINUX=1 "
LOCAL_CFLAGS+="-DMDNS_DEBUGMSGS=0 "
LOCAL_CFLAGS+="-DMDNS_UDS_SERVERPATH=\"/dev/socket/mdnsd\" "
LOCAL_CFLAGS+="-DMDNS_USERNAME=\"mdnsr\" "
LOCAL_CFLAGS+="-DPLATFORM_NO_RLIMIT "


LOCAL_SYSTEM_SHARED_LIBRARIES="libc libcutils"

#include $(BUILD_EXECUTABLE)

#############  libmdnssd  #############

#include $(CLEAR_VARS)
LOCAL_SRC_FILES="mDNSShared/dnssd_clientlib.c  \
                    mDNSShared/dnssd_clientstub.c \
                    mDNSShared/dnssd_ipc.c"

LOCAL_MODULE=libmdnssd
LOCAL_MODULE_TAGS=optional

LOCAL_CFLAGS=" -O2 -g -W -Wall"
LOCAL_CFLAGS+="-D__ANDROID__ "
LOCAL_CFLAGS+="-D_GNU_SOURCE "
LOCAL_CFLAGS+="-DHAVE_IPV6=1 "
LOCAL_CFLAGS+="-DNOT_HAVE_SA_LEN "
LOCAL_CFLAGS+="-DUSES_NETLINK=1 "
LOCAL_CFLAGS+="-DTARGET_OS_LINUX "
LOCAL_CFLAGS+="-fno-strict-aliasing "
LOCAL_CFLAGS+="-DHAVE_LINUX=1"
LOCAL_CFLAGS+="-DMDNS_UDS_SERVERPATH=\"/dev/socket/mdnsd\" "
LOCAL_CFLAGS+="-DMDNS_DEBUGMSGS=0"


LOCAL_SYSTEM_SHARED_LIBRARIES="libc libcutils"

#include $(BUILD_SHARED_LIBRARY)

#############    dnssd     ################

#include $(CLEAR_VARS)
LOCAL_SRC_FILES="Clients/dns-sd.c \
                    Clients/ClientCommon.c"

LOCAL_MODULE=dnssd
LOCAL_MODULE_TAGS=optional

LOCAL_C_INCLUDES=external/mdnsresponder/mDNSShared

LOCAL_CFLAGS=" -O2 -g -W -Wall "
LOCAL_CFLAGS+="-D__ANDROID__ "
LOCAL_CFLAGS+="-D_GNU_SOURCE "
LOCAL_CFLAGS+="-DHAVE_IPV6=1 "
LOCAL_CFLAGS+="-DNOT_HAVE_SA_LEN "
LOCAL_CFLAGS+="-DUSES_NETLINK=1 "
LOCAL_CFLAGS+="-DTARGET_OS_LINUX "
LOCAL_CFLAGS+="-fno-strict-aliasing "
LOCAL_CFLAGS+="-DHAVE_LINUX=1"
LOCAL_CFLAGS+="-DMDNS_UDS_SERVERPATH=\"/dev/socket/mdnsd\" "
LOCAL_CFLAGS+="-DMDNS_DEBUGMSGS=0"



LOCAL_SYSTEM_SHARED_LIBRARIES="libmdnssd libc libcutils"

#include $(BUILD_EXECUTABLE)

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

magisk_step_make() {
	printenv
	#tree
	#echo $(pwd)
	cd $MAGISK_MODULE_SRCDIR/mdnsresponder/mDNSPosix
	setups
	#make clean
	ls
	cc="$CC" CFLAGS="$CFLAGS --host aarch64-linux-android" make
}
