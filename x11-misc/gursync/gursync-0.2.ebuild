# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"

inherit eutils 

MY_PN="gursync"

DESCRIPTION="A GUI frontend for rsync"
HOMEPAGE="http://code.google.com/p/gursync/"
SRC_URI="http://gursync.googlecode.com/files/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-misc/rsync
	x11-libs/vte"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_configure() {
	if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
		econf || die "Configuration failed"
	fi
}

src_compile() {
	if [ -e Makefile ] ; then
		emake  || die "Compilation failed"
	fi
}

src_install() {
	einstall  || die "Installation failed"
}

