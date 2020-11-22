# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for Steam games: Antichamber"
HOMEPAGE="https://steampowered.com"
LICENSE="metapackage"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	media-libs/libvorbis[abi_x86_32]
	media-libs/libogg[abi_x86_32]
	media-sound/apulse[abi_x86_32]
	media-libs/alsa-lib[abi_x86_32]
	"
