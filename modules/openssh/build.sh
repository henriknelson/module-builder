MAGISK_MODULE_HOMEPAGE=https://www.openssh.com/
MAGISK_MODULE_DESCRIPTION="Secure shell for logging into a remote machine"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=8.0p1
MAGISK_MODULE_REVISION=4
MAGISK_MODULE_SHA256=bd943879e69498e8031eb6b7f44d08cdc37d59a7ab689aa0b437320c3481fd68
MAGISK_MODULE_SRCURL=https://fastly.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_DEPENDS="libandroid-support, ldns, openssl, libedit, termux-auth, krb5, zlib"
MAGISK_MODULE_CONFLICTS="dropbear"
# --disable-strip to prevent host "install" command to use "-s", which won't work for target binaries:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--disable-etc-default-login
--disable-lastlog
--disable-libutil
--disable-pututline
--disable-pututxline
--disable-strip
--disable-utmp
--disable-utmpx
--disable-wtmp
--disable-wtmpx
--sysconfdir=$MAGISK_PREFIX/etc/ssh
--with-cflags=-Dfd_mask=int
--with-ldns
--with-libedit
--with-mantype=man
--without-ssh1
--without-stackprotect
--with-pid-dir=$MAGISK_PREFIX/var/run
--with-privsep-path=$MAGISK_PREFIX/var/empty
--with-xauth=$MAGISK_PREFIX/bin/xauth
--with-kerberos5
ac_cv_func_endgrent=yes
ac_cv_func_fmt_scaled=no
ac_cv_func_getlastlogxbyname=no
ac_cv_func_readpassphrase=no
ac_cv_func_strnvis=no
ac_cv_header_sys_un_h=yes
ac_cv_search_getrrsetbyname=no
ac_cv_func_bzero=yes
"
MAGISK_MODULE_MAKE_INSTALL_TARGET="install-nokeys"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/slogin share/man/man1/slogin.1"
MAGISK_MODULE_CONFFILES="etc/ssh/ssh_config etc/ssh/sshd_config var/service/sshd/run var/service/sshd/log/run"

magisk_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $MAGISK_PREFIX.
	if $MAGISK_ON_DEVICE_BUILD; then
		magisk_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	fi

	autoreconf

    ## Configure script require this variable to set
    ## prefixed path to program 'passwd'
    export PATH_PASSWD_PROG="${MAGISK_PREFIX}/bin/passwd"

	CPPFLAGS+=" -DHAVE_ATTRIBUTE__SENTINEL__=1 -DBROKEN_SETRESGID"
	LD=$CC # Needed to link the binaries
	LDFLAGS+=" --static -llog" # liblog for android logging in syslog hack
}

magisk_step_post_configure() {
	# We need to remove this file before installing, since otherwise the
	# install leaves it alone which means no updated timestamps.
	rm -Rf $MAGISK_PREFIX/etc/moduli
}

magisk_step_post_make_install() {
	# "PrintMotd no" is due to our login program already showing it.
	# OpenSSH 7.0 disabled ssh-dss by default, keep it for a while in Termux:
	echo -e "PrintMotd no\nPasswordAuthentication yes\nPubkeyAcceptedKeyTypes +ssh-dss\nSubsystem sftp $MAGISK_PREFIX/libexec/sftp-server" > $MAGISK_PREFIX/etc/ssh/sshd_config
	printf "PubkeyAcceptedKeyTypes +ssh-dss\nSendEnv LANG\n" > $MAGISK_PREFIX/etc/ssh/ssh_config
	install -Dm700 $MAGISK_MODULE_BUILDER_DIR/source-ssh-agent.sh $MAGISK_PREFIX/bin/source-ssh-agent
	install -Dm700 $MAGISK_MODULE_BUILDER_DIR/ssh-with-agent.sh $MAGISK_PREFIX/bin/ssha
	install -Dm700 $MAGISK_MODULE_BUILDER_DIR/sftp-with-agent.sh $MAGISK_PREFIX/bin/sftpa

	# Install ssh-copy-id:
	cp $MAGISK_MODULE_SRCDIR/contrib/ssh-copy-id.1 $MAGISK_PREFIX/share/man/man1/
	cp $MAGISK_MODULE_SRCDIR/contrib/ssh-copy-id $MAGISK_PREFIX/bin/
	chmod +x $MAGISK_PREFIX/bin/ssh-copy-id

	mkdir -p $MAGISK_PREFIX/var/run
	echo "OpenSSH needs this folder to put sshd.pid in" >> $MAGISK_PREFIX/var/run/README.openssh

	mkdir -p $MAGISK_PREFIX/etc/ssh/
	cp $MAGISK_MODULE_SRCDIR/moduli $MAGISK_PREFIX/etc/ssh/moduli

	# Setup sshd services
	mkdir -p $MAGISK_PREFIX/var/service
	cd $MAGISK_PREFIX/var/service
	mkdir -p sshd/log
	echo '#!/bin/sh' > sshd/run
	echo 'exec sshd -D -e 2>&1' >> sshd/run
	chmod +x sshd/run
	touch sshd/down
	ln -sf $MAGISK_PREFIX/usr/share/termux-services/svlogger sshd/log/run
}

magisk_step_post_massage() {
	# Verify that we have man pages packaged (#1538).
	local manpage
	for manpage in ssh-keyscan.1 ssh-add.1 scp.1 ssh-agent.1 ssh.1; do
		if [ ! -f usr/share/man/man1/$manpage.gz ]; then
			magisk_error_exit "Missing man page $manpage"
		fi
	done
}

magisk_step_create_debscripts() {
	echo "#!$MAGISK_PREFIX/bin/sh" > postinst
	echo "mkdir -p \$HOME/.ssh" >> postinst
	echo "touch \$HOME/.ssh/authorized_keys" >> postinst
	echo "chmod 700 \$HOME/.ssh" >> postinst
	echo "chmod 600 \$HOME/.ssh/authorized_keys" >> postinst
	echo "" >> postinst
	echo "for a in rsa dsa ecdsa ed25519; do" >> postinst
	echo "	  KEYFILE=$MAGISK_PREFIX/etc/ssh/ssh_host_\${a}_key" >> postinst
	echo "	  test ! -f \$KEYFILE && ssh-keygen -N '' -t \$a -f \$KEYFILE" >> postinst
	echo "done" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
