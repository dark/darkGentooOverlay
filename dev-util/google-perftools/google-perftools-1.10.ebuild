# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/google-perftools/google-perftools-1.10.ebuild,v 1.1 2012/07/06 00:57:34 flameeyes Exp $

EAPI=4

inherit toolchain-funcs eutils flag-o-matic

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/gperftools/"
SRC_URI="http://gperftools.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="largepages +debug minimal test 64bitworkaround"

DEPEND="!64bitworkaround? ( sys-libs/libunwind )"
RDEPEND="${DEPEND}"

pkg_setup() {
	# set up the make options in here so that we can actually make use
	# of them on both compile and install.

	# Avoid building the unit testing if we're not going to execute
	# tests; this trick here allows us to ignore the tests without
	# touching the build system (and thus without rebuilding
	# autotools). Keep commented as long as it's restricted.
	use test || \
		makeopts="${makeopts} noinst_PROGRAMS= "

	# don't install _anything_ from the documentation, since it would
	# install it in non-standard locations, and would just waste time.
	makeopts="${makeopts} dist_doc_DATA= "
}

src_configure() {
	use largepages && append-cppflags -DTCMALLOC_LARGE_PAGES

	append-flags -fno-strict-aliasing

	econf \
		--disable-static \
		--disable-dependency-tracking \
		--enable-fast-install \
		$(use_enable 64bitworkaround frame-pointers) \
		$(use_enable debug debugalloc) \
		$(use_enable minimal)
}

src_compile() {
	emake ${makeopts}
}

src_test() {
	case "${LD_PRELOAD}" in
		*libsandbox*)
			ewarn "Unable to run tests when sanbox is enabled."
			ewarn "See http://bugs.gentoo.org/290249"
			return 0
			;;
	esac

	emake check
}

src_install() {
	emake DESTDIR="${D}" install ${makeopts}

	# Remove libtool files since we dropped the static libraries
	find "${D}" -name '*.la' -delete

	dodoc README AUTHORS ChangeLog TODO NEWS
	pushd doc
	dohtml -r *
	popd
}
