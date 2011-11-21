# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"

inherit eutils

DESCRIPTION="Synkron is a simple Qt application for synchronising folders."
HOMEPAGE="http://synkron.sourceforge.net/"
SRC_URI="http://netcologne.dl.sourceforge.net/project/${PN}/${PN}/${PV}/Synkron-1.6.2-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-shells/squirrelsh
	>=x11-libs/qt-gui-4.3"

RDEPEND="${DEPEND}"

S="${WORKDIR}/Synkron-1.6.2-src"

src_configure() {
	lrelease ${S}/Synkron.pro || die "Creating of translations failed"
	qmake -config release || die "Configuration failed"

}

src_compile() {
	if [ -e Makefile ] ; then
		emake  || die "Compilation failed"
	fi
}

src_install() {
	dodir /usr/bin
	cp ${S}/synkron ${D}/usr/bin || die "Copiing error"
}

