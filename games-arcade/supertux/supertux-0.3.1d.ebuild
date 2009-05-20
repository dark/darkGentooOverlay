# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit base games
inherit cmake-utils

DESCRIPTION="Classic 2D jump'n run sidescroller game similar to SuperMario: Milestone 2"
HOMEPAGE="http://supertux.lethargik.org/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 x86"

DEPEND="virtual/opengl
	media-libs/libsdl
	media-libs/sdl-image
	dev-games/physfs
	media-libs/openal"

S="${WORKDIR}/${PN}-${PV%[a-z]}"
RESTRICT="mirror"

PATCHES=( "${FILESDIR}/0.3.1-fixes.patch"
	"${FILESDIR}/0.3.1-fs-layout.patch"
	"${FILESDIR}/desktop.patch" )

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
