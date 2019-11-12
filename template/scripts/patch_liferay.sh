#!/bin/bash

function install_patch {
	cp ${LIFERAY_PATCHING_DIR}/liferay-*.zip /opt/liferay/patching-tool/patches

	/opt/liferay/patching-tool/patching-tool.sh setup

	if ( /opt/liferay/patching-tool/patching-tool.sh install )
	then
		patch_installed
	fi
}

function main {
	if [[ $(ls -A ${LIFERAY_PATCHING_DIR}/patching-tool-*.zip 2>/dev/null) ]]
	then
		echo ""
		echo "[LIFERAY] Updating Patching Tool."

		mv /opt/liferay/patching-tool/patches /opt/liferay/patching-tool-upgrade-patches

		rm -fr /opt/liferay/patching-tool

		unzip -d /opt/liferay -q ${LIFERAY_PATCHING_DIR}/patching-tool-*

		/opt/liferay/patching-tool/patching-tool.sh auto-discovery

		rm -fr /opt/liferay/patching-tool/patches

		mv /opt/liferay/patching-tool-upgrade-patches /opt/liferay/patching-tool/patches

		echo ""
		echo "[LIFERAY] Patching Tool updated successfully."
	fi

	if [[ $(ls -A ${LIFERAY_PATCHING_DIR}/liferay-*.zip 2>/dev/null) ]]
	then
		if [ `ls ${LIFERAY_PATCHING_DIR}/liferay-*.zip | wc -l` == 1 ]
		then
			if ( /opt/liferay/patching-tool/patching-tool.sh apply ${LIFERAY_PATCHING_DIR}/liferay-*.zip )
			then
				patch_installed
			else
				install_patch
			fi
		else
			install_patch
		fi
	fi
}

function patch_installed {
	rm -fr /opt/liferay/osgi/state/*

	echo ""
	echo "[LIFERAY] Patch applied successfully."
}

main