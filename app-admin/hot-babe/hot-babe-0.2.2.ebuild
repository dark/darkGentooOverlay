# Copyright 1999-2004 Gentoo Foundation
# Copyright 2004 Paul Thompson <set@pobox.com>
# Distributed under the terms of the GNU General Public License v2
# $Header: /archive/cvsdir/portage/app-admin/hot-babe/hot-babe-0.2.0.ebuild,v 1.1 2004/12/02 22:32:45 set Exp $
# moficato da me per adattarsi alla 0.2.2

DESCRIPTION="A System load monitor"

HOMEPAGE="http://dindinx.net/hotbabe/"

SRC_URI="http://dindinx.net/hotbabe/downloads/${P}.tar.bz2"

LICENSE="Artistic"

SLOT="0"

KEYWORDS="x86"

IUSE=""

# A space delimited list of portage features to restrict. man 5 ebuild
# for details.  Usually not needed.
RESTRICT="mirror"

DEPEND=">=x11-libs/gtk+-2.0"

#RDEPEND=""

S=${WORKDIR}/${P}

src_compile() {
	sed -iorig -e "s:-O2 -Wall -g:${CFLAGS}:" Makefile || die "sed failed"
	emake PREFIX="/usr" || die "emake failed"
}

src_install() {
	make PREFIX="${D}/usr" install || die "Failed to install"
	doman hot-babe.1
}
