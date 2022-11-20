# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Systemtray volume mixer applet from PuppyLinux"
HOMEPAGE="https://wikka.puppylinux.com/Retrovol"
SRC_URI="https://github.com/pizzasgood/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	econf $(use_enable nls)
}

pkg_postinst() {
	echo
	elog "You can find a sample configuration file at"
	elog "   ${EROOT}/usr/share/retrovol/dot.retrovolrc"
	elog "To customize, copy it to ~/.retrovolrc and edit it as you like"
	echo
}
