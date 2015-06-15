#!/bin/bash

save_param()
{
	eval "$1=\"$f4\""
	echo "$1=\"$f4\"" | tee -a $out
}

CURL='curl -s -u fsd-tc-tagger:natGajkeswiasOv http://fsd-tc.paragon-software.com/TeamCity/app/rest'

EMBEDDED_CONFIG="$(${CURL}/buildTypes?locator=project:EmbeddedBuildUfsdHead | \
	awk -F'"' 'BEGIN{RS=">"}($4=="'${EMBEDDED_CONFIG}'" || $2=="'${EMBEDDED_CONFIG}'"){print $2;exit}')"
echo "Using $EMBEDDED_CONFIG configuration"

out='tc_parameters.sh'
rm -f $out

echo '--- IMPORTED PARAMETERS ---'

while IFS='"' read f1 f2 f3 f4 f5; do
	if [ "$f1" = '<property name=' ]; then
		case "$f2" in
		TOOLCHAIN_DRIVER_HOST)     save_param TC_TOOLCHAIN_TRIPLET;;
		TOOLCHAIN_DRIVER_PATH)     save_param TC_TOOLCHAIN_PATH;;
		TOOLCHAIN_ARCH)            save_param C_TOOLCHAIN_ARCH;;
		TOOLCHAIN_UTILITES_HOST)   save_param C_TOOLCHAIN_UTILITES_HOST;;
		TOOLCHAIN_UTILITES_PATH)   save_param C_TOOLCHAIN_UTILITES_PATH;;
		TOOLCHAIN_DRIVER_NO_LIBC)  save_param C_TOOLCHAIN_DRIVER_NO_LIBC;;
		env.C_TOOLCHAIN_DIR)       save_param C_TOOLCHAIN_DIR;;
		env.C_TOOLCHAIN_ARCH_FULL) save_param C_TOOLCHAIN_ARCH_FULL;;
		env.SAMBA_PREFIX)          save_param SAMBA_PREFIX;;
		env.STAGING_DIR)           save_param 'export STAGING_DIR';;
		esac
	fi
done < <(${CURL}/buildTypes/${EMBEDDED_CONFIG}/parameters | sed 's/></>\n</g')

if [ ! -s $out ]; then
	echo "FAILED TO CREATE PARAMETERS FILE" >&2
	exit 1
fi

echo '------ REDEFINITIONS ------'

if [ -n "${C_TOOLCHAIN_DRIVER_NO_LIBC}" ]; then
	if [ -n "${C_TOOLCHAIN_UTILITES_PATH}" ]; then
		echo "TC_TOOLCHAIN_PATH=\"${C_TOOLCHAIN_UTILITES_PATH}\"" | tee -a $out
		echo "TC_TOOLCHAIN_TRIPLET=\"${C_TOOLCHAIN_UTILITES_HOST}\"" | tee -a $out
	else
		echo "[ERROR] TOOLCHAIN DOESN'T SUPPORT BUILDING UTILITIES!" >&2
		exit 1
	fi
fi

if [ -z "${C_TOOLCHAIN_ARCH_FULL}" ]; then
	echo "C_TOOLCHAIN_ARCH_FULL=\"${TC_TOOLCHAIN_TRIPLET%-*}\"" | tee -a $out
fi

if [ -z "${C_TOOLCHAIN_DIR}" ]; then
	echo "C_TOOLCHAIN_DIR=\"${TC_TOOLCHAIN_PATH%/bin}\"" | tee -a $out
fi

echo 'PATH="${TC_TOOLCHAIN_PATH}:${PATH}"' | tee -a $out

