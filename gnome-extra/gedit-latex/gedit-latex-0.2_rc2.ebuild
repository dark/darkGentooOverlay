# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils python

DESCRIPTION="LaTeX plugin for gedit"
HOMEPAGE="http://live.gnome.org/Gedit/LaTeXPlugin"
SRC_URI="mirror://sourceforge/${PN}/LaTeXPlugin-${PV/_rc/rc}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

RDEPEND=">=app-editors/gedit-2.15.2[python]
	dev-python/gnome-python
	dev-python/dbus-python
	dev-tex/rubber"

DEPEND=""

S="${WORKDIR}"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	mv GeditLaTeXPlugin ${PN}
	mv GeditLaTeXPlugin.gedit-plugin ${PN}.gedit-plugin
	sed -i -e "s/GeditLaTeXPlugin/${PN}/g" ${PN}.gedit-plugin ${PN}/src/base/resources.py
	rm ${PN}/ChangeLog
	rm ${PN}/INSTALL
	rm ${PN}/COPYING
	insinto /usr/$(get_libdir)/gedit-2/plugins
	doins -r *
	fperms 755 /usr/$(get_libdir)/gedit-2/plugins/${PN}/util/eps2png.pl
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/gedit-2/plugins/${PN}
}
        
pkg_postrm() {
	python_mod_cleanup  /usr/$(get_libdir)/gedit-2/plugins/${PN}
}
