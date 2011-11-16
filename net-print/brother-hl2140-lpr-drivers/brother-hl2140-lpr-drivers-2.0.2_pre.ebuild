# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit rpm multilib

DESCRIPTION="Brother HL-2140 LPR drivers"
HOMEPAGE="http://solutions.brother.com/linux/en_us/index.html"
SRC_URI="http://pub.brother.com/pub/com/bsc/linux/dlf/brhl2140lpr-2.0.2-1.i386.rpm"

LICENSE="Brother-EULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="strip"

DEPEND="app-arch/rpm"

RDEPEND="${DEPEND}"


S="${WORKDIR}"

src_unpack() {
	rpm_unpack ${A} || die "Error unpacking ${A}."
}


src_install() {
	has_multilib_profile && ABI=x86
	INSTDIR="/opt/Brother"

	dosym ${INSTDIR} /usr/local/Brother

	dobin usr/bin/brprintconfiglpr2 usr/bin/brprintconflsr2
	dolib usr/lib/libbrcomplpr2.so
	dodir ${INSTDIR}/inf
	dodir ${INSTDIR}/lpd

	mv usr/local/Brother/inf/{braddprinter,brHL2140func,brHL2140rc,paperinf,setupPrintcap} ${D}${INSTDIR}/inf
	mv usr/local/Brother/lpd/{filterHL2140,psconvert2,rawtobr2} ${D}${INSTDIR}/lpd
	chmod a+w ${D}${INSTDIR}/inf/br*rc
	chmod a+w ${D}${INSTDIR}/inf

	echo "HL2140" >> ${INSTDIR}/inf/brPrintList

	dodir /var/spool/lpd/HL2140
}
