# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="2"

inherit libtool

DESCRIPTION="The Common Open Research Emulator (CORE) is a tool for emulating networks on one or more machines"
HOMEPAGE="http://code.google.com/p/coreemu/"
SRC_URI="http://downloads.pf.itd.nrl.navy.mil/core/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

QA_FLAGS_IGNORED="/usr/lib64/python2.7/site-packages/netns.so
/usr/lib64/python2.7/site-packages/vcmd.so"

DEPEND="net-firewall/ebtables
	 dev-libs/libev
	 dev-lang/tk
	 dev-tcltk/tkimg
	 x11-terms/xterm
	 media-gfx/imagemagick"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
