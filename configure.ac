dnl Copyright © 2021 Roel Janssen <roel@gnu.org>
dnl
dnl This program is free software: you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation, either version 3 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program. If not, see <http://www.gnu.org/licenses/>.
dnl -*- Autoconf -*-

AC_INIT(sc-dna-pipeline, 1.0.0)
AC_CONFIG_MACRO_DIR([m4])

AC_CONFIG_FILES([sc-dna-pipeline], [chmod +x sc-dna-pipeline])

dnl Check for the availability of R.
dnl ---------------------------------------------------------------------------
AC_PATH_PROG(RSCRIPT, Rscript, Rscript)

dnl Check for the availability of R packages.
dnl ---------------------------------------------------------------------------
AX_R_PACKAGE([ggplot2])
AX_R_PACKAGE([AneuFinder])
AX_R_PACKAGE([USCDtools])

dnl Check for presence of 'pdflatex', 'bibtex', and 'htlatex'.
dnl ---------------------------------------------------------------------------
AC_CHECK_PROG(PDFLATEX, pdflatex, pdflatex)
AC_CHECK_PROG(BIBTEX, bibtex, bibtex)
AC_CHECK_PROG(HTLATEX, htlatex, htlatex)

if test "x$BIBTEX" = "x"; then
  AC_MSG_WARN([Unable to create the user manual.])
else
  if test "x$PDFLATEX" = "x"; then
    AC_MSG_WARN([Unable to create PDF version of the user manual.])
  fi
  if test "x$HTLATEX" = "x"; then
    AC_MSG_WARN([Unable to create HTML version of the user manual.])
  fi
fi

AC_OUTPUT
