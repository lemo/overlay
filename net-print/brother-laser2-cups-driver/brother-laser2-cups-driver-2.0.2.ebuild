# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="CUPS-Drivers for Brother Laser Printers"
HOMEPAGE="http://www.brother.com/index.htm"
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/brother-laser2-cups-driver-2.0.2-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE_DCP="DCP7030 DCP7040 DCP7045N"
IUSE_HL="HL2140 HL2150N HL2170W"
# IUSE_MFC="mfc7320 mfc7340 mfc7440n mfc7450 mfc7840n mfc7840w"

IUSE="${IUSE_DCP} ${IUSE_HL} " 	#${IUSE_MFC}"
RDEPEND="net-print/cups
	DCP7030? ( net-print/brother-dcp7030-lpr-drivers )
	DCP7040? ( net-print/brother-dcp7040-lpr-drivers )
	DCP7045N? ( net-print/brother-dcp7045n-lpr-drivers )
	HL2140? ( net-print/brother-hl2140-lpr-drivers )
        HL2150N? ( net-print/brother-hl2150n-lpr-drivers )
        HL2170W? ( net-print/brother-hl2170w-lpr-drivers )"

DEPEND="${RDEPEND} sys-apps/sed"


S=${WORKDIR}/${P}-1


src_compile() {
	mkdir -p ${S}/model
	mkdir -p ${S}/filter
	function ppd_generate() {
		sed -n '/cat <<ENDOFPPDFILE >$ppd_file_name/,/ENDOFPPDFILE/p' ${S}/scripts/cupswrapper$1-2.0.2 | sed '$d'| sed '1,1d' > ${S}/model/$1.ppd
		chmod 755 ${S}/model/$1.ppd
	}

	function filter_generate() {
		sed -n '/cat <<!ENDOFWFILTER! >$brotherlpdwrapper/,/!ENDOFWFILTER!/p' ${S}/scripts/cupswrapper$1-2.0.2 |sed '$d' | sed '1,1d' > ${S}/filter/brotherlpdwrapper$1
		chmod 755 ${S}/filter/brotherlpdwrapper$1
	}
	function cmpuse () {
	until [ -z "$1" ]
	do
		if use $1 ; then
        		ppd_generate $1
        		filter_generate $1
			ln -s /opt/Brother/lpd/filter$1 ${S}/filter/brlpdwrapper$1
		fi
		shift
	done
	}

	cmpuse DCP7030 DCP7040 DCP7045N HL2140 HL2150N HL2170W
}


src_install() {
	has_multilib_profile && ABI=x86
	INSTDIR="/opt/Brother"

	dodir ${INSTDIR}/cupswrapper/
	dodir /usr/lib/cups/filter/
	dodir /usr/share/cups/model/
	dodir /usr/libexec/cups/filter/

	if [ -e '/usr/share/ppd' ]; then
		dodir /usr/share/ppd
		cp  ${S}/model/.ppd ${D}usr/share/ppd
	fi

	mv ${S}/brcupsconfig3/{brcups_commands.h,brcupsconfig.c} ${D}${INSTDIR}/cupswrapper/
	mv ${S}/model/*.ppd ${D}usr/share/cups/model/
	mv ${S}/filter/brotherlpdwrapper* ${D}usr/lib/cups/filter/
	mv ${S}/filter/brlpdwrapper* ${D}usr/libexec/cups/filter

}

pkg_postinst() {
	/etc/init.d/cupsd restart
	sleep 2s
	port2=`lpinfo -v | grep -i 'usb://Brother/DCP-7030' | head -1`
	if [ "$port2" = '' ];then
        	port2=`lpinfo -v | grep 'usb://' | head -1`
	fi
	port=`echo $port2| sed s/direct//g`
	if [ "$port" = '' ];then
        	port=usb:/dev/usb/lp0
	fi
	lpadmin -p DCP7030 -E -v $port -P /usr/share/cups/model/DCP7030.ppd


	ewarn 'Deinstallation Notice:'
	elog  'To remove the driver, please run'
	elog  '    lpadmin -x $1'
	elog  'with $1 as your driver name (eg. DCP7030),'
	elog  'after unmerging the cups-driver package.'
}
