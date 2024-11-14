#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" check for venv """

import os
from pathlib     import Path
from subprocess  import CalledProcessError
import sys
from typing      import Optional
from typing      import *
from typing      import ParamSpec

from structlog   import get_logger

P     :ParamSpec = ParamSpec('P')
logger           = get_logger()

class NotVEnvException(Exception):
	""" venv ACTIVATE !!! """

def check_venv()->bool:
	is_venv    :bool          = (sys.prefix != sys.base_prefix)

	virtual_env:Optional[str] = os.getenv('VIRTUAL_ENV')
	if(not is_venv):
		assert(virtual_env is None)
		logger.debug('not in venv')
		return False
	assert is_venv
	assert isinstance(virtual_env,str)
	assert Path(virtual_env).is_dir()
	assert(virtual_env == sys.prefix), f'(virtual_env={virtual_env}) != (sys.prefix={sys.prefix})'
	#assert(virtual_env == sys.base_prefix), f'(virtual_env={virtual_env}) != (sys.prefix={sys.base_prefix})'
	logger.debug('in venv')
	return True

def verify_venv()->None:
	is_venv:bool = check_venv()
	if is_venv:
		logger.info('in venv')
		return
	logger.info('not in venv')
	raise NotVEnvException('not in venv')

def main()->None:
	is_venv:bool = check_venv()
	print('is venv:', is_venv,)

if __name__ == '__main__':
	main()

__author__:str = 'you.com' # NOQA
