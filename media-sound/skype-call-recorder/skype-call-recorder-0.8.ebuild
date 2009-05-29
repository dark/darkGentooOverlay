# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Records Skype calls to MP3/Ogg/WAV files"
HOMEPAGE="http://atdot.ch/scr/"
SRC_URI="http://atdot.ch/scr/files/${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RESTRICT="strip"

DEPEND="
	media-sound/lame
	media-libs/id3lib
	>=media-libs/libvorbis-1.2.0
	>=x11-libs/qt-gui-4.4:4[dbus]
	>=x11-libs/qt-dbus-4.4:4
"
RDEPEND="${DEPEND}"
