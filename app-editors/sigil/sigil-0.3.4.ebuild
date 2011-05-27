# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils cmake-utils

DESCRIPTION="Sigil is a multi-platform WYSIWYG ebook editor. It is designed to edit books in ePub format."
HOMEPAGE="http://code.google.com/p/sigil/"
SRC_URI="http://sigil.googlecode.com/files/Sigil-${PV}-Code.zip"

ICON_PATH="src/Sigil/Resource_Files/icon/"
ICON="sigil_icon_32.png"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-util/cmake-2.8.0
		>=x11-libs/qt-xmlpatterns-4.7.0
		>=x11-libs/qt-webkit-4.7.0
		>=x11-libs/qt-svg-4.7.0
		>=x11-libs/qt-gui-4.7.0"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv "Sigil-${PV}-Code" "${P}"
}

src_configure() {
	local mycmakeargs="-DCMAKE_BUILD_TYPE=Release"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	pushd "${P}"
	mv "${ICON_PATH}app_icon_32.png" "${ICON_PATH}${ICON}"
	popd
	doicon "${ICON_PATH}${ICON}"
	make_desktop_entry ${PN} Sigil "/usr/share/pixmaps/${ICON}" "Office;Publishing" || die "failed creating desktop entry"
}
