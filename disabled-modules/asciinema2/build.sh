MAGISK_MODULE_HOMEPAGE=https://asciinema.org/
MAGISK_MODULE_DESCRIPTION="Record and share your terminal sessions, the right way"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=2.0.2
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=https://github.com/asciinema/asciinema/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=2578a1b5611e5375771ef6582a6533ef8d40cdbed1ba1c87786fd23af625ab68
# ncurses-utils for tput which asciinema uses:
MAGISK_MODULE_DEPENDS="python, ncurses-utils"
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_PLATFORM_INDEPENDENT=true
MAGISK_MODULE_HAS_DEBUG=false

_PYTHON_VERSION=3.9

MAGISK_MODULE_RM_AFTER_INSTALL="
lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
lib/python${_PYTHON_VERSION}/site-packages/site.py
lib/python${_PYTHON_VERSION}/site-packages/__pycache__
"

magisk_step_make() {
	return
}

magisk_step_make_install() {
	export PYTHONPATH=$MAGISK_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/
	python${_PYTHON_VERSION} setup.py install --prefix=$MAGISK_PREFIX --force
}
