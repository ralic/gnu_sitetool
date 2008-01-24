#####
#
# SYNOPSIS
#
#   AX_PROG_PYTHON([VALUE-IF-NOT-FOUND],[PATH])
#
# DESCRIPTION
#
#   Locates an installed Python binary, placing the result in the
#   precious variable $PYTHON. Accepts a present $PYTHON, then
#   --with-python, and failing that searches for python in the given
#   path (which defaults to the system path). If python is found,
#   $PYTHON is set to the full path of the binary; if it is not found,
#   $PYTHON is set to VALUE-IF-NOT-FOUND, which defaults to 'python'.
#
# NOTE
#   This macro is based upon AX_WITH_PYTHON macro from Dustin J. Mitchell
#   <dustin@cs.uchicago.edu>
#
# LAST MODIFICATION
#
#   2008-01-24
#
# COPYLEFT
#
#  Copyright (c) 2008 Francesco Salvestrini <salvestrini@users.sourceforge.net>
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2 of the
#   License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
#   02111-1307, USA.
#
#   As a special exception, the respective Autoconf Macro's copyright
#   owner gives unlimited permission to copy, distribute and modify the
#   configure scripts that are the output of Autoconf when processing
#   the Macro. You need not follow the terms of the GNU General Public
#   License when using or distributing such scripts, even though
#   portions of the text of the Macro appear in them. The GNU General
#   Public License (GPL) does govern all other use of the material that
#   constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the
#   Autoconf Macro released by the Autoconf Macro Archive. When you
#   make and distribute a modified version of the Autoconf Macro, you
#   may extend this special exception to the GPL to apply to your
#   modified version as well.

AC_DEFUN([AX_PROG_PYTHON],[
    AC_PREREQ([2.61])

    AC_ARG_VAR([PYTHON])

    AS_IF([test -z "$PYTHON"],[
    	AC_MSG_CHECKING([for --with-python])
        AC_ARG_WITH([python],
            [AS_HELP_STRING([--with-python=PYTHON],
                            [absolute path name of Python executable])], [
	    AS_IF([test "$withval" != "yes"],[
	        PYTHON="$withval"
		AC_MSG_RESULT([$PYTHON])
	    ],[
	        AC_MSG_RESULT([no])
	    ])
	],[
	    AC_MSG_RESULT([no])
	])

        AS_IF([test -z "$PYTHON"],[
	    AC_PATH_PROG([PYTHON],[python],m4_ifval([$1],[$1],[python]),$3)
        ])
    ])
])