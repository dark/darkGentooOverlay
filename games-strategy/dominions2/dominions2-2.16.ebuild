# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/dominions2/dominions2-2.16.ebuild,v 1.7 2007/03/12 18:02:33 genone Exp $

inherit eutils games

DESCRIPTION="Dominions 2: The Ascension Wars is an epic turn-based fantasy strategy game"
HOMEPAGE="http://www.shrapnelgames.com/Illwinter/d2/"
SRC_URI="x86? (
		http://www.shrapnelgames.com/downloads/dompatch${PV/\./}_linux_x86.tgz )
	doc? ( http://www.shrapnelgames.com/downloads/DOM2_Walkthrough.pdf
		http://www.shrapnelgames.com/downloads/manual_addenda.pdf )
	mirror://gentoo/${PN}.png"

SLOT="0"
KEYWORDS="x86"
IUSE="doc originalcdkey"
RESTRICT="strip"

# I am not sure what license applies to Dominions II and I couldn't find
# further information on their homepage or on the game CD :(
LICENSE="as-is"

DEPEND="virtual/opengl
	virtual/glu
	x86? ( media-libs/libsdl )
	ppc? ( media-libs/libsdl )
	amd64? ( app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-sdl )"

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	mkdir -p "${S}"/patch
	cd "${S}"/patch
	if use x86 || use amd64
	then
		unpack dompatch${PV/\./}_linux_x86.tgz
	elif use ppc
	then
		unpack dompatch${PV/\./}_linux_ppc.tgz
	fi
}

src_install() {
	cdrom_get_cds dom2icon.ico
	einfo "Copying files to harddisk... this may take a while..."

	exeinto "${dir}"
	if use amd64 || use x86
	then
		doexe "${CDROM_ROOT}"/bin_lin/x86/dom2* || die "doexe failed"
	elif use ppc
	then
		doexe "${CDROM_ROOT}"/bin_lin/ppc/dom2* || die "doexe failed"
	fi
	insinto "${dir}"
	doins -r "${CDROM_ROOT}"/dominions2.app/Contents/Resources/* || \
		die "doins failed"
	dodoc "${CDROM_ROOT}"/doc/* || die "dodoc failed"

	# applying the official patches just means overwriting some important
	# files with their more recent versions:
	einfo "Applying patch for version ${PV}..."
	dodoc "${S}"/patch/doc/* || die "dodoc failed"

	# pretty self-explanatory
	if use originalcdkey
	then
		doexe "${S}"/patch/dom2 || die "doexe failed"
	else
		einfo "Not patching executable file because you do not own a valid cd key"
	fi

	rm -rf "${S}"/patch/doc/ "${S}"/patch/dom2 || die "rm failed"
	doins -r "${S}"/patch/* || die "doins failed"

	if use doc; then
		elog ""
		elog "Installing extra documentation to '/usr/share/doc/${P}'"
		elog ""
		elog "You may want to study 'DOM2_Walkthrough.pdf' carefully if"
		elog "you are new to Dominions II."
		elog ""
		dodoc "${DISTDIR}"/{DOM2_Walkthrough,manual_addenda}.pdf
	fi

	doicon "${DISTDIR}"/${PN}.png

	# update times
	find "${D}" -exec touch '{}' \;

	games_make_wrapper dominions2 ./dom2 "${dir}" "${dir}"
	make_desktop_entry dominions2 "Dominions II" dominions2.png

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play the game run:"
	elog " dominions2"
	echo
}
