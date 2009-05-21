# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

DESCRIPTION="LaTeX plugin for gedit"
HOMEPAGE="http://live.gnome.org/Gedit/LaTeXPlugin"
SRC_URI="mirror://sourceforge/gedit-latex/LaTeXPlugin-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-editors/gedit-2.13.0
	dev-python/pygobject
	dev-python/pygtk
	dev-python/pygtksourceview
	dev-python/gnome-python
	dev-tex/rubber"

S="${WORKDIR}"

pkg_setup() {
	if ! built_with_use app-editors/gedit python; then
		eerror "app-editors/gedit was built without support for python."
		eerror "Please re-emerge app-editors/gedit with USE='python'."
		die "app-editors/gedit was built without support for python."
	fi
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dodoc LaTeXPlugin/ChangeLog
	rm LaTeXPlugin/ChangeLog
	rm LaTeXPlugin/INSTALL
	insinto /usr/$(get_libdir)/gedit-2/plugins
	doins -r *
	fperms 755 /usr/$(get_libdir)/gedit-2/plugins/LaTeXPlugin/util/eps2png
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/gedit-2/plugins/LaTeXPlugin
}
        
pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/gedit-2/plugins/LaTeXPlugin
}