Prerequisites
=============

0. Assumed dir structure::

	./
		packages/
			forks/
				django/
				elixir/
				PIL/
				pisa/
				satchmo/
				suds/
			trml2pdf/
		modules-git/
			blcore/
				blcore/
				setup.py
				...
			blconfig/
			...
		brighttrac/
			brighttrac2/
			setup.py
			...
		nasm/
			brighttrac_NASM/
			setup.py
			...

	#. For a new client, pull down the client custom code::

		% mkdir nasm
		% cd nasm
		% git svn clone svn+ssh://svn.thebrightlink.com/var/svn/brighttrac/clients/NASM/trunk .

1. Make sure core, modules, and packages/forks are all up to date


Engage!
=======

