# -*- coding: utf-8 -*-
import os


def pyenv(*a, **k):
	segs = ["pyenv"]
	try:
		env = os.popen("pyenv local 2>&1").read().strip()
		if env.find("no local version configured") >= 0:
			return None
		else:
			if os.popen("pyenv virtualenvs 2>&1").read().find(env) >=0 :
				segs.insert(0, "venv")
				env = "(%s)" % env
			return [{"contents": env, "highlight_group": segs}]
	except:
		pass

	return None
