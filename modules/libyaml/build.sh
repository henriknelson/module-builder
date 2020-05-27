MAGISK_MODULE_HOMEPAGE=https://pyyaml.org/wiki/LibYAML
MAGISK_MODULE_DESCRIPTION="LibYAML is a YAML 1.1 parser and emitter written in C"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=0.2.4
MAGISK_MODULE_SRCURL=https://github.com/yaml/libyaml/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=02265e0229675aea3a413164b43004045617174bdb2c92bf6782f618f8796b55
MAGISK_MODULE_BREAKS="libyaml-dev"
MAGISK_MODULE_REPLACES="libyaml-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --enable-shared"

magisk_step_pre_configure() {
	./bootstrap
}

magisk_step_post_make_install() {
	cd $MAGISK_PREFIX/lib
	ln -s -f libyaml-0.so libyaml.so
}
