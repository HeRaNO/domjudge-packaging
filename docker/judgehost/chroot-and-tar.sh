#!/bin/bash

set -euo pipefail

# Usage: https://github.com/DOMjudge/domjudge/blob/main/misc-tools/dj_make_chroot.in#L58-L87
/opt/domjudge/judgehost/bin/dj_make_chroot

KOTLIN_VERSION="1.9.24"

# Add kotlin into image
echo "[..] Downloading Kotlin v${KOTLIN_VERSION} compiler"
wget -q "https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip" -P /
echo "[..] Extracting Kotlin compiler"
unzip -qq -d "/chroot/domjudge/usr/local/lib/" "/kotlin-compiler-${KOTLIN_VERSION}.zip"
echo "[..] Making symlink for Kotlin"
chroot "/chroot/domjudge" ln -s "/usr/local/lib/kotlinc/bin/kapt" "/usr/local/bin/kapt"
chroot "/chroot/domjudge" ln -s "/usr/local/lib/kotlinc/bin/kotlin" "/usr/local/bin/kotlin"
chroot "/chroot/domjudge" ln -s "/usr/local/lib/kotlinc/bin/kotlin-dce-js" "/usr/local/bin/kotlin-dce-js"
chroot "/chroot/domjudge" ln -s "/usr/local/lib/kotlinc/bin/kotlinc" "/usr/local/bin/kotlinc"
chroot "/chroot/domjudge" ln -s "/usr/local/lib/kotlinc/bin/kotlinc-js" "/usr/local/bin/kotlinc-js"
chroot "/chroot/domjudge" ln -s "/usr/local/lib/kotlinc/bin/kotlinc-jvm" "/usr/local/bin/kotlinc-jvm"
echo "[..] Cleaning"
rm "/kotlin-compiler-${KOTLIN_VERSION}.zip"
echo "[..] Done setting up Kotlin"

cd /
echo "[..] Compressing chroot"
tar -czpf /chroot.tar.gz --exclude=/chroot/tmp --exclude=/chroot/proc --exclude=/chroot/sys --exclude=/chroot/mnt --exclude=/chroot/media --exclude=/chroot/dev --one-file-system /chroot
echo "[..] Compressing judge"
tar -czpf /judgehost.tar.gz /opt/domjudge/judgehost
