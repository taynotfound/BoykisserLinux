#!/usr/bin/env bash
# Run me:  ./README.sh

p=$'\033[38;2;255;95;162m'   # pink
s=$'\033[38;2;255;142;200m'  # soft pink
w=$'\033[1;97m'              # white
d=$'\033[2;37m'              # dim
r=$'\033[0m'                 # reset

cat <<EOF

${p}        /\\                 /\\
${p}       /  \\_______________/  \\
${p}      /                       \\
${p}     |   ${s}o   ${p}         ${s}o   ${p}  |     ${w}Boykisser Linux ${p}:3${r}
${p}     |        ${s}>  w  <${p}       |     ${d}gay XFCE for every kitty${r}
${p}      \\                     /
${p}       \\___________________/${r}

  ${w}A gay, gimmicky, actually daily-drivable Debian distro.${r}

  ${s}What's inside${r}
    • Debian 13 (trixie), XFCE, full Boykisser theme (light + dark)
    • Flatpak + Flathub out of the box, GNOME Software, Flatseal, Gear Lever
    • Steam, Heroic, GameMode, MangoHud, OBS (with virtual camera)
    • Firefox, VS Code Insiders, VLC
    • Calamares installer, UEFI + BIOS, old & new hardware

  ${s}Build it${r}
    ${w}./build.sh${r}            ${d}# builds the ISO in a container${r}
    ${w}./test-vm.sh${r}          ${d}# boots the result in QEMU${r}

  ${s}Links${r}
    Site     ${w}https://boykisser.taymaerz.de${r}
    Source   ${w}https://github.com/taynotfound/BoykisserLinux${r}
    Discord  ${w}https://discord.gg/3ZpwE9PPfP${r}

  ${d}Disclaimer: AI tooling helped build this OS. Everything here is${r}
  ${d}reviewed and tested by a human, but be your own kitty and check${r}
  ${d}the code before you run it. :3${r}

EOF
