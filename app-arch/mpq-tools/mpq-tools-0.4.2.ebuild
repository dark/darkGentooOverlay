# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit libtool

DESCRIPTION="Tool for retrieving information and extracting data from mpq archives"
HOMEPAGE="https://libmpq.org/wiki/MpqTools"
SRC_URI="https://libmpq.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-libs/zlib-1.1.3
	>=app-arch/bzip2-1.0.4
	dev-libs/libmpq"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	elibtoolize
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	doman doc/man1/*.1 || die "doman failed"
	dodoc AUTHORS ChangeLog COPYING FAQ NEWS README THANKS TODO || die "dodoc failed"
}
