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

SITE_SRCS =					\
	contents.as				\
	files.as				\
	footer.sxml				\
	header.sxml				\
	layout.sxml				\
	map.as					\
	pages.as				\
	site.css				\
						\
	index.scm				\
	installation.scm			\
	downloads.scm				\
	development.scm

SITE_BUILT_SRCS =				\
	site.as					\
	news.sxml				\
	todos.sxml				\
	grammar.scm

EXTRA_DIST = $(SITE_SRCS) site.as.in
CLEANFILES =

site.as: $(srcdir)/site.as.in Makefile
	( rm -f $@ $@.tmp && \
	  $(do_subst) < $(srcdir)/site.as.in > $@.tmp && \
	  chmod -x $@.tmp && \
	  chmod a-w $@.tmp && \
	  mv -f $@.tmp $@ ) || { \
		rm -f $@ $@.tmp ; \
		exit 1 ; \
	}
CLEANFILES += site.as

news.dump: $(DNT_DB)
	$(DNT_BIN)				\
	       --database=$(DNT_DB)		\
	       --mono				\
	       show				\
	       --indent-fill="(ul "		\
	       --unindent-fill=")"		\
	       --line-format="(li \"%t\")"	\
	       --width=0			\
	       --output=news.dump		\
	       --filter="done" || {		\
		rm -f news.dump ;		\
		exit 1 ;			\
	}
CLEANFILES += news.dump

news.sxml: news.dump
	rm -f news.sxml && \
	touch news.sxml && \
	echo "(h2 \"NEWs\")" >> news.sxml && \
	cat news.dump >> news.sxml || { \
		rm -f news.sxml ; \
		exit 1 ; \
	}
CLEANFILES += news.sxml

todos.dump: $(DNT_DB)
	$(DNT_BIN)				\
	       --database=$(DNT_DB)		\
	       --mono				\
	       show				\
	       --indent-fill="(ul "		\
	       --unindent-fill=")"		\
	       --line-format="(li \"%t\")"	\
	       --width=0			\
	       --output=todos.dump		\
	       --filter="not done" || {		\
		rm -f todos.dump ;		\
		exit 1 ;			\
	}
CLEANFILES += todos.dump

todos.sxml: todos.dump
	rm -f todos.sxml && \
	touch todos.sxml && \
	echo "(h2 \"TODOs\")" >> todos.sxml && \
	cat todos.dump >> todos.sxml || { \
		rm -f todos.sxml ; \
		exit 1 ; \
	}
CLEANFILES += todos.sxml

grammar.scm: $(top_srcdir)/docs/grammar.txt Makefile
	rm -f grammar.scm                                 &&    \
	touch grammar.scm                                 &&    \
	echo "(h2 "GRAMMAR")"              >> grammar.scm &&    \
	echo "(pre (@ class \"terminal\")" >> grammar.scm &&    \
	echo "\""                          >> grammar.scm &&    \
	cat $(top_srcdir)/docs/grammar.txt >> grammar.scm &&    \
	echo "\""                          >> grammar.scm &&    \
	echo ")" >> grammar.scm || {                            \
	        rm -f grammar.scm ;                             \
	        exit 1 ;                                        \
	}
CLEANFILES += grammar.scm

site: $(SITE_SRCS) $(SITE_BUILT_SRCS)
	SITETOOL_LIBRARY_PATH="$(top_builddir)/libs" ; \
	export SITETOOL_LIBRARY_PATH ; \
	SITETOOL_BINARY_PATH="$(top_builddir)/src" ; \
	export SITETOOL_BINARY_PATH ; \
	SITETOOL_DATA_PATH="$(top_builddir)/data" ; \
	export SITETOOL_DATA_PATH ; \
	SITETOOL="$(top_builddir)/src/sitetool" ; \
	$$SITETOOL -v --mode initialize && \
	$$SITETOOL -v --mode build && \
	$$SITETOOL -v --mode validate && \
	touch site.stamp || { \
		echo $$SITETOOL -v --mode clean ; \
		echo rm -f site.stamp \
		exit 1 ; \
	}

maintainer-clean-local:
	if test -e site.stamp ; then \
		SITETOOL_LIBRARY_PATH="$(top_builddir)/libs" ; \
		export SITETOOL_LIBRARY_PATH ; \
		SITETOOL_BINARY_PATH="$(top_builddir)/src" ; \
		export SITETOOL_BINARY_PATH ; \
		SITETOOL_DATA_PATH="$(top_builddir)/data" ; \
		export SITETOOL_DATA_PATH ; \
		SITETOOL="$(top_builddir)/src/sitetool" ; \
		$$SITETOOL -v --mode clean || exit 1 ; \
		rm -f site.stamp ; \
	fi

##
## Maintainer related targets
##
URL_SITE = "http://github.com/salvestrini/build-utils/raw/master/site"

SITE_SRCS_EXTERNAL =					\
	$(URL_SITE)/footer.sxml			\
	$(URL_SITE)/header.sxml			\
	$(URL_SITE)/layout.sxml			\
	$(URL_SITE)/site.css

update-local-site: Makefile
	rm -r -f fetch-dir && \
	mkdir fetch-dir && \
	for i in $(SITE_SRCS_EXTERNAL) ; do \
	        URL="$$i" ; \
	        NAME=`echo "$$i" | $(SED) -e 's,^.*/,,'` ; \
	        $(FETCH) $$URL?raw=true fetch-dir/$$NAME && \
	        mv fetch-dir/$$NAME $$NAME || { \
	                rm -f fetch-dir/$$NAME ; \
	                exit 1 ; \
	        } \
	done && \
	rm -r -f fetch-dir

update-local: Makefile update-local-site

maintainer-check-local: Makefile
