# -*- coding: utf-8 -*-
import os


def pyenv(*a, **k):
	segs = ["pyenv"]
	try:
		env = os.popen("pyenv local 2>&1").read().strip()
		if env.find("no local version configured") >= 0:
			env = os.popen("pyenv global 2>&1").read().strip()
			if env.find("system")>=0:
				return None
		virtualenvs = os.popen("pyenv virtualenvs 2>&1 | cut -d ' ' -f 2- | awk '{print $1}'").read().strip().split("\n")
		if env in virtualenvs:
			segs.insert(0, "venv")
		env = "ℙ %s" % env
		return [{"contents": env, "highlight_group": segs}]
	except:
		pass

	return None


if __name__ == "__main__":
	print(pyenv())

