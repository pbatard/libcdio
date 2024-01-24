#!/bin/sh
#   Copyright (C) 2024 Pete Batard <pete@akeo.ie>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Tests El Torito (via iso-info and iso-read). 

if test -z "$srcdir" ; then
  srcdir=`pwd`
fi

if test "X$top_builddir" = "X" ; then
  top_builddir=`pwd`/..
fi

. ${top_builddir}/test/check_common_fn

if test ! -x ../src/iso-info ; then
  exit 77
fi

if test ! -x ../src/iso-read ; then
  exit 77
fi

BASE=`basename $0 .sh`

# File listing with and without El Torito enabled
iso_image="${srcdir}/data/eltorito.iso"
opts="--no-header --quiet -l ${iso_image}"
test_iso_info "$opts" eltorito.dump ${srcdir}/eltorito.right
RC=$?
check_result $RC "$aspect"' eltorito listing test' "$ISO_INFO $opts"

opts="--no-header --no-el-torito --quiet -l ${iso_image}"
test_iso_info "$opts" eltorito.dump ${srcdir}/no_eltorito.right
RC=$?
check_result $RC "$aspect"' eltorito listing test' "$ISO_INFO $opts"

# File dump and comparison
opts="--ignore --image ${iso_image} --extract [BOOT]/0-Boot-NoEmul.img"
test_iso_read "$opts" eltorito ${srcdir}/data/eltorito_file
RC=$?
check_result $RC "$aspect"' eltorito read test' "$ISO_READ $opts"

exit $RC
