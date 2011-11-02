from setuptools import setup
from distutils.sysconfig import get_python_lib
import glob


setup(
    name = "cythoncmakeexample",
    package_dir = {'': 'src'},
    data_files = [(get_python_lib(), glob.glob('src/*.so')),
        ('bin', ['bin/rectangle-props'])],
    author = 'Matt McCormick',
    description = 'Use the CMake build system to make Cython modules.',
    license = 'Apache',
    keywords = 'cmake cython build',
    url = 'http://github.com/thewtex/cython-cmake-example',
    test_require = ['nose'],
    zip_safe = False,
    )
