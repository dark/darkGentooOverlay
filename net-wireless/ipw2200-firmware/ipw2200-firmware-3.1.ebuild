# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ipw2200-firmware/ipw2200-firmware-3.0.ebuild,v 1.5 2008/02/25 23:34:53 wolf31o2 Exp $

MY_P=${P/firmware/fw}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Firmware for the Intel PRO/Wireless 2200BG/2915ABG miniPCI and 2225BG PCI adapters"

HOMEPAGE="http://ipw2200.sourceforge.net/"
SRC_URI="http://dark.asengard.net/mirror/gentoo/distfiles/${MY_P}.tgz"
RESTRICT="mirror"

LICENSE="ipw2200-fw"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
DEPEND=""
# dark: dunno if this is enought, I hope I have a fairly recent one
RDEPEND="|| ( >=sys-fs/udev-096 >=sys-apps/hotplug-20040923 )"

src_install() {
	insinto /lib/firmware
	doins *.fw

	doins LICENSE.ipw2200-fw
}
