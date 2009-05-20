# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils games versionator

DESCRIPTION="Dominions 3 is an epic turn-based fantasy strategy game"
HOMEPAGE="http://www.shrapnelgames.com/Illwinter/dom3/"

MY_PV=$(get_version_component_range 2)
if [ $MY_PV -lt 10 ]
then
	MY_PV="0"$MY_PV
fi
MY_PV=$(get_major_version)"${MY_PV}"

SRC_URI="http://download.shrapnelgames.com/downloads/dompatch${MY_PV}_linux.zip
	mirror://gentoo/${PN}.png"

SLOT="0"
KEYWORDS="~x86"
IUSE="doc"
#RESTRICT=""

# I am not sure what license applies to Dominions III and I couldn't find
# further information on their homepage or on the game CD :(
LICENSE="as-is"

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl "

dir=${GAMES_PREFIX_OPT}/${PN}
#Ddir=${D}/${dir}

src_unpack() {
	mkdir -p "${S}"/patch
	cd "${S}"/patch
	unpack dompatch${MY_PV}_linux.zip
}

src_install() {
	cdrom_get_cds dom2icon.ico
	einfo "Copying files to harddisk... this may take a while..."

	exeinto "${dir}"
	doexe "${CDROM_ROOT}"/bin_lin/x86/dom3 || die "doexe failed"

	insinto "${dir}"
	doins -r "${CDROM_ROOT}"/Dominions3.app/Contents/Resources/* || \
		die "doins failed"

	# install useless and outdated documentation?
	if use doc; then
		dodoc "${CDROM_ROOT}"/doc/*.pdf || die "dodoc failed"
	fi

	# applying the official patches just means overwriting some important
	# files with their more recent versions:
	einfo "Applying patch for version ${PV}..."
	if use doc;
	then
		dodoc "${S}"/patch/doc/* || die "dodoc failed"
	fi

	# pick the proper executable file from the patch
	mv "${S}"/patch/dom3_x86 "${S}"/patch/dom3
	doexe "${S}"/patch/dom3 || die "doexe failed"
	rm -rf "${S}"/patch/doc/ "${S}"/patch/dom3* || die "rm failed"
	doins -r "${S}"/patch/* || die "doins failed"

	doicon "${DISTDIR}"/${PN}.png

	# update times
	find "${D}" -exec touch '{}' \;

	games_make_wrapper dominions3 ./dom3 "${dir}" "${dir}"
	make_desktop_entry dominions3 "Dominions III" dominions3.png

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play the game run:"
	elog " dominions3"
	if use doc; then
		elog ""
		elog "Documentation has been installed into '/usr/share/doc/${P}'"
	fi

	echo
}
