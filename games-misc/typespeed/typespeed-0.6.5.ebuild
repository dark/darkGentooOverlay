# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/typespeed/typespeed-0.6.4.ebuild,v 1.4 2009/05/31 18:20:51 ranger Exp $

inherit autotools eutils toolchain-funcs games

DESCRIPTION="Test your typing speed, and get your fingers CPS"
HOMEPAGE="http://tobias.eyedacor.org/typespeed/"
SRC_URI="http://tobias.eyedacor.org/typespeed/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 x86"
IUSE="nls"

RDEPEND="sys-libs/ncurses
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/datadir/d' \
		doc/Makefile.am \
		|| die "sed failed"
	sed -i \
		-e '/^highdir/d' \
		-e 's/^high_/localstate_/' \
		-e 's/highdir/localstatedir/g' \
		src/Makefile.am \
		|| die "sed failed"
	eautoreconf
}

src_compile() {
	egamesconf \
		--localedir=/usr/share/locale \
		--docdir=/usr/share/doc/${PF} \
		--disable-dependency-tracking \
		$(use_enable nls) || die
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS TODO
	prepalldocs
	prepgamesdirs
}
