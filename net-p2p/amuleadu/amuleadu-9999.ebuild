# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools eutils flag-o-matic wxwidgets

ESVN_REPO_URI="https://amule-adunanza.svn.sourceforge.net/svnroot/amule-adunanza/branches/mrhyde_test"
ESVN_PROJECT="amule-adunanza"
S="${WORKDIR}/amule-adunanza"

DESCRIPTION="aMule AdunanzA, software p2p per la comunita' fastweb"
HOMEPAGE="http://www.adunanza.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="daemon debug geoip gtk nls remote stats unicode upnp"

DEPEND="!net-p2p/amule
	=x11-libs/wxGTK-2.8*
	>=dev-libs/crypto++-5.5.2
	>=sys-libs/zlib-1.2.1
	stats? ( >=media-libs/gd-2.0.26 )
	geoip? ( dev-libs/geoip )
	upnp? ( >=net-libs/libupnp-1.6.6 )
	remote? ( >=media-libs/libpng-1.2.0
		unicode? ( >=media-libs/gd-2.0.26 )
	)"


src_unpack() {
	subversion_src_unpack
        AT_M4DIR="m4" eautoreconf
	elibtoolize
}

pkg_preinst() {
	if use amuled || use remote; then
		enewgroup p2p
		enewuser p2p -1 -1 /home/p2p p2p
	fi
}

src_compile() {
	local myconf
	WX_GTK_VER="2.8"

	if use gtk; then
		einfo "wxGTK with gtk support will be used"
		need-wxwidgets unicode
	else
		einfo "wxGTK without X support will be used"
		need-wxwidgets base
	fi

	if use gtk ; then
		myconf="--enable-monolithic
			--enable-alc"
		use stats && myconf="${myconf} --enable-wxcas"
		use remote && myconf="${myconf} --enable-amule-gui"
	else
		myconf="--disable-monolithic
			--disable-amule-gui
			--disable-wxcas
			--disable-alc"
	fi

        econf \
		--disable-dependency-tracking \
		--with-wx-config=${WX_CONFIG} \
		--with-wxbase-config=${WX_CONFIG} \
		--enable-amulecmd \
		--enable-alcc \
		--enable-ed2k \
		$(use_enable daemon amule-daemon) \
		$(use_enable debug) \
		$(use_enable !debug optimize) \
		$(use_enable geoip) \
		$(use_enable nls) \
		$(use_enable remote webserver) \
		$(use_enable stats cas) \
		$(use_enable upnp) \
		${myconf} || die

	emake || die
}


src_install() {
	make DESTDIR=${D} install || die

	if use amuled; then
		newconfd ${FILESDIR}/amuled.confd amuled
		newinitd ${FILESDIR}/amuled.initd amuled
	fi

	if use remote; then
		newconfd ${FILESDIR}/amuleweb.confd amuleweb
		newinitd ${FILESDIR}/amuleweb.initd amuleweb
	fi
}
