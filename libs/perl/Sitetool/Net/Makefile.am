##
## Input file for automake
##
## Copyright (C) 2008, 2009 Francesco Salvestrini
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program; if not, write to the Free Software Foundation, Inc.,
## 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
##

include $(top_srcdir)/Makefile.sub

SUBDIRS =					\
	WWW

perllibdir = $(pkgvlibsdir)/perl/Sitetool/Net

dist_perllib_DATA =				\
	Email.pm

##
## Maintainer related targets
##
update-local: Makefile

maintainer-check-whitespaces: Makefile $(dist_perllib_DATA) $(nodist_perllib_DATA)
	$(WHITESPACE_DETECT) $(dist_perllib_DATA) $(nodist_perllib_DATA)

maintainer-check-wordwraps: Makefile $(dist_perllib_DATA) $(nodist_perllib_DATA)
	$(WORDWRAP_DETECT) --tab-size 8 --columns 80 $(dist_perllib_DATA) $(nodist_perllib_DATA)

maintainer-check-local: Makefile		\
	maintainer-check-whitespaces		\
	maintainer-check-wordwraps
