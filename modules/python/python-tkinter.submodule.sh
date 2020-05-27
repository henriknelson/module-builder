MAGISK_SUBMODULE_DESCRIPTION="Tkinter support for Python 3"
MAGISK_SUBMODULE_DEPENDS="tk"
MAGISK_SUBMODULE_INCLUDE="
bin/idle*
lib/python${_MAJOR_VERSION}/idlelib
lib/python${_MAJOR_VERSION}/tkinter
lib/python${_MAJOR_VERSION}/turtle.py
lib/python${_MAJOR_VERSION}/turtledemo
lib/python${_MAJOR_VERSION}/lib-dynload/_tkinter.cpython-${_MAJOR_VERSION/./}m.so
lib/python${_MAJOR_VERSION}/__pycache__/turtle.*.pyc
"
