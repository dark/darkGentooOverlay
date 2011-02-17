# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/i8kutils/i8kutils-1.25-r1.ebuild,v 1.3 2010/01/01 21:09:43 ssuominen Exp $

EAPI="3"
inherit toolchain-funcs

DESCRIPTION="Dell Inspiron and Latitude utilities"
HOMEPAGE="http://packages.debian.org/i8kutils"
SRC_URI="mirror://debian/pool/main/i/${PN}/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="tk"

DEPEND="tk? ( >=dev-lang/tk-8.3.3 )"

src_prepare() {
	sed -i -e 's/\$(CC) -g \$(CFLAGS)/& \$(LDFLAGS)/g' ${S}/Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" all || die
}

src_install() {
	dobin i8kbuttons i8kctl
	doman i8kbuttons.1 i8kctl.1
	dosym /usr/bin/i8kctl /usr/bin/i8kfan
	dodoc README.i8kutils
	docinto examples/
	dodoc examples/*

	newinitd "${FILESDIR}"/i8k.init-r1 i8k
	newconfd "${FILESDIR}"/i8k.conf i8k

	if use tk
	then
		dobin i8kmon
		doman i8kmon.1
		docinto /
		dodoc i8kmon.conf
	else
		echo >> ${D}/etc/conf.d/i8k
		echo '# i8kmon disabled because the package was installed without USE=tk' >> ${D}/etc/conf.d/i8k
		echo 'NOMON=1' >> ${D}/etc/conf.d/i8k
	fi

}
