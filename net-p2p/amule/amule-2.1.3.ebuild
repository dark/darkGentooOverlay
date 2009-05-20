# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

#SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
#http://amule-adunanza.marleylandia.com/fedora/patch/amule-adu/amule-adunanza-3.10-1.patch.gz
#"

inherit eutils flag-o-matic wxwidgets

MY_P=${P/m/M}
S=${WORKDIR}/${MY_P}

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
http://dark.asengard.net/mirror/gentoo/portage/net-p2p/amule-adunanza/amuleadunanza3.11b1.patch.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="amuled debug gtk gtk2 nls remote stats unicode"

RESTRICT="nomirror"
DEPEND=">=x11-libs/wxGTK-2.6.2
      >=sys-libs/zlib-1.2.1
      stats? ( >=media-libs/gd-2.0.26 )
      remote? ( >=media-libs/libpng-1.2.0 )
      !net-p2p/xmule"

pkg_setup() {
      export WX_GTK_VER="2.6"

      if ( ! use gtk || ! use gtk2 )  && ! use remote && ! use amuled; then
            eerror ""
            eerror "You have to specify at least one of X, remote or amuled"
            eerror "USE flag to build amule."
            eerror ""
            die "Invalid USE flag set"
      fi

      if use unicode && use gtk2; then
            einfo "wxGTK with gtk2 and unicode support will be used"
            need-wxwidgets unicode
      elif use gtk2; then
            einfo "wxGTK with gtk2 support will be used"
            need-wxwidgets gtk2
      elif use unicode && use gtk; then
            einfo "wxGTK with gtk2 support will be used"
            need-wxwidgets gtk
      elif use gtk; then
            einfo "wxGTK with gtk1 support will be used"
            need-wxwidgets gtk
      elif use unicode && built_with_use x11-libs/wxGTK -X unicode; then
            einfo "wxGTK with unicode and without X support will be used"
            einfo "(wxbase unicode)"
            need-wxwidgets base-unicode
      else
            einfo "wxGTK without X support will be used"
            einfo "(wxbase)"
            need-wxwidgets base
      fi

      if use stats && ( ! use gtk || ! use gtk2 ); then
            einfo "Note: You would need both the gtk and stats USE flags"
            einfo "to compile aMule Statistics GUI."
            einfo "I will now compile console versions only."
      fi

      if use stats && ! built_with_use media-libs/gd jpeg; then
            die "media-libs/gd should be compiled with the jpeg use flag when you have the stats use flag set"
      fi
}

src_unpack () {
   unpack ${A}
         cd ${S}
      #epatch ${S}/../amule-adunanza-3.10-1.patch
	patch -p0 <${S}/../amuleadunanza3.11b1.patch
}
src_compile() {
      local myconf=""

      if use gtk || use gtk2; then
            use stats && myconf="${myconf}
               --enable-wxcas
               --enable-alc"
            use remote && myconf="${myconf}
               --enable-amule-gui"
      else
            myconf="
               --disable-monolithic
               --disable-amule-gui
               --disable-wxcas
               --disable-alc"
      fi

      econf \
            --with-wx-config=${WX_CONFIG} \
            --with-wxbase-config=${WX_CONFIG} \
            --enable-amulecmd \
            `use_enable debug` \
            `use_enable !debug optimize` \
            `use_enable amuled amule-daemon` \
            `use_enable nls` \
            `use_enable remote webserver` \
            `use_enable stats cas` \
            `use_enable stats alcc` \
            ${myconf} || die

      # we filter ssp until bug #74457 is closed to build on hardened
      if has_hardened; then
            filter-flags -fstack-protector -fstack-protector-all
      fi
      emake -j1 || die
}

src_install() {
      make DESTDIR=${D} install || die

      if use amuled || use remote; then
         if ! id p2p >/dev/null; then
               enewgroup p2p
               enewuser p2p -1 -1 /home/p2p p2p
         fi
      fi

      if use amuled; then
            insinto /etc/conf.d; newins ${FILESDIR}/amuled.confd amuled
            exeinto /etc/init.d; newexe ${FILESDIR}/amuled.initd amuled
      fi

      if use remote; then
            insinto /etc/conf.d; newins ${FILESDIR}/amuleweb.confd amuleweb
            exeinto /etc/init.d; newexe ${FILESDIR}/amuleweb.initd amuleweb
      fi
} 
