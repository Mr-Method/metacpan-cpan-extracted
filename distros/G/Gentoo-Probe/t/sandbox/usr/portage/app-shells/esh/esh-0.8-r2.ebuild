# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/perl/Gentoo-Probe/t/sandbox/usr/portage/app-shells/esh/esh-0.8-r2.ebuild,v 1.1 2004/06/20 09:09:34 linguist Exp $

S=${WORKDIR}/esh
DESCRIPTION="A UNIX Shell with a simplified Scheme syntax"
SRC_URI="http://esh.netpedia.net/${P}.tar.gz"
HOMEPAGE="http://esh.netpedia.net/"
KEYWORDS="x86 sparc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc
		>=sys-libs/ncurses-5.1
		>=sys-libs/readline-4.1"

src_compile() {

	cp Makefile Makefile.orig
	sed -e "s:^CFLAGS=:CFLAGS=${CFLAGS/-fomit-frame-pointer/} :" \
		-e "s:^LIB=:LIB=-lncurses :" Makefile.orig > Makefile
	make || die
}

src_install() {

	dobin esh
	into /usr
	doinfo doc/esh.info
	dodoc CHANGELOG CREDITS GC_README HEADER LICENSE READLNE-HACKS TODO
	docinto html
	dodoc doc/*.html
	docinto examples
	dodoc examples/*
	insinto /usr/share/emacs/site-lisp/
	doins emacs/esh-mode.el
}
