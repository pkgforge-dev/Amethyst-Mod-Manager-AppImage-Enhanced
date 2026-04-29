#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q amethyst-mod-manager | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/512x512/apps/io.github.Amethyst.ModManager.png
export DESKTOP=/usr/share/applications/io.github.Amethyst.ModManager.desktop
export DEPLOY_PYTHON=1
export ALWAYS_SOFTWARE=1

# Deploy dependencies
quick-sharun \
	/usr/bin/amethyst-mod-manager   \
	/usr/share/amethyst-mod-manager \
	/usr/bin/zenity                 \
	/usr/lib/libgtk-3.so*           \
	/usr/lib/libtcl8.6.so*          \
	/usr/lib/libtk8.6.so            \
	/usr/lib/tcl8.6                 \
	/usr/lib/tk8.6

sed -i -e 's|/usr/share|"$APPDIR"/share|g' ./AppDir/bin/amethyst-mod-manager

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
