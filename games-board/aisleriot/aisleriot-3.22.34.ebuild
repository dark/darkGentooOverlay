# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME2_EAUTORECONF="yes"

inherit gnome.org gnome2-utils meson readme.gentoo-r1  xdg

DESCRIPTION="A collection of solitaire card games for GNOME"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Aisleriot"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc gnome qt5"

# FIXME: quartz support?
# Lookup guile modules grep "use-modules" *.scm
COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-scheme/guile-2.2:2.2
	>=gnome-base/librsvg-2.32:2
	|| (
		media-libs/libcanberra-gtk3
		media-libs/libcanberra[gtk3(-)]
	)
	>=x11-libs/cairo-1.10
	>=x11-libs/gtk+-3.4:3
	gnome? ( >=gnome-base/gconf-2.0:2 )
	qt5? ( >=dev-qt/qtsvg-5:5 )
"
DEPEND="${COMMON_DEPEND}
	app-arch/gzip
	app-text/yelp-tools
	dev-libs/libxml2:2
	dev-util/glib-utils
	dev-build/autoconf-archive
	>=sys-devel/gettext-0.12
	virtual/pkgconfig
	gnome? ( app-text/docbook-xml-dtd:4.3 )
"

src_prepare() {
	eapply_user
}

src_configure() {
	local emesonargs=(
		-Dtheme_kde=false
		-Dtheme_svg_qtsvg=true
		-Ddocs=false
	)

	if use doc; then
		emesonargs+=(
			-Dhelp_method=library
		)
	fi
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
