magisk_step_massage() {
	cd "$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX"

	# Remove lib/charset.alias which is installed by gettext-using modules:
	rm -f lib/charset.alias

	# Remove non-english man pages:
	test -d usr/share/man && (cd usr/share/man; for f in $(ls | grep -v man); do rm -Rf $f; done )

	# Remove all man pages:
	#rm -Rf share/man

	if [ -z "${MAGISK_MODULE_KEEP_INFOPAGES+x}" ]; then
		# Remove info pages:
		rm -Rf usr/share/info
	fi

	# Remove locale files we're not interested in::
	rm -Rf usr/share/locale

	# Remove old kept libraries (readline):
	find . -name '*.old' -delete


	# Remove static libraries:
	#if [ $MAGISK_MODULE_KEEP_STATIC_LIBRARIES = "false" ]; then
		#find . -name '*.a' -delete
		#find . -name '*.so*' -delete
	#fi

	# Move over sbin to bin:
	if [ -d "$(pwd)/sbin" ]; then
		for file in $(find sbin/ -type f -maxdepth 1); do if test -f "$file"; then mv "$file" bin/; fi; done;
	fi

	# Remove world permissions and add write permissions.
	# The -f flag is used to suppress warnings about dangling symlinks (such
	# as ones to /system/... which may not exist on the build machine):
	find . -exec chmod -f u+w,g-rwx,o-rwx \{\} \;

	if [ "$MAGISK_DEBUG" = "" ]; then
		# Strip binaries. file(1) may fail for certain unusual files, so disable pipefail.
		set +e +o pipefail
		find . -type f | xargs -r file | grep -E "(executable|shared object)" | grep ELF | cut -f 1 -d : | \
			xargs -r "$STRIP" --strip-unneeded --preserve-dates
		set -e -o pipefail
	fi
	# Remove DT_ entries which the android 5.1 linker warns about:
	#find . -type f -print0 | xargs -r -0 "$MAGISK_ELF_CLEANER"

	# Fix shebang paths:
	#while IFS= read -r -d file
	#do
	#	head -c 100 "$file" | grep -E "^#\!.*\\/bin\\/.*" | grep -q -E -v "^#\! ?\\/system" && sed --follow-symlinks -i -E "1 s@^#\!(.*)/bin/(.*)@#\!$MAGISK_PREFIX/bin/\2@" "$file"
	#done < <(find -L . -type f -print0)

	test ! -z "$MAGISK_MODULE_RM_AFTER_INSTALL" && rm -Rf $MAGISK_MODULE_RM_AFTER_INSTALL

	find . -type d -empty -delete # Remove empty directories

	#if [ -d sshare/man ]; then
	#	# Compress man pages with gzip:
	#	find usr/share/man -type f ! -iname \*.gz -print0 | xargs -r -0 gzip

		# Update man page symlinks, e.g. unzstd.1 -> zstd.1:
	#	while IFS= read -r -d '' file
	#	do
	#		local _link_value
	#		_link_value=$(readlink $file)
	#		rm $file
	#		ln -s $_link_value.gz $file.gz
	#	done < <(find usr/share/man -type l ! -iname \*.gz -print0)
	#fi
	magisk_create_submodules

	# .. remove empty directories (NOTE: keep this last):
	find . -type d -empty -delete
	# Make sure user can read and write all files (problem with dpkg otherwise):
	chmod -R u+rw .
}
