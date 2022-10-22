class PoketeBuilder < AppImage::Builder
  # For brew appimage-build
  def apprun; <<~EOS
    #!/bin/sh
    #export APPDIR="/tmp/.mount-poketeXXXXXX"
    if [ "x${APPDIR}" = "x" ]; then
      export APPDIR="$(dirname "$(readlink -f "${0}")")"
    fi

    export TCL_LIBRARY="${APPDIR}/usr/libexec/squashfs-root/usr/share/tcltk/tcl8.5"
    export TK_LIBRARY="${APPDIR}/usr/libexec/squashfs-root/usr/share/tcltk/tk8.5"
    export TKPATH="${TK_LIBRARY}"
    export SSL_CERT_FILE="${APPDIR}/usr/libexec/squashfs-root/opt/_internal/certs.pem"

    if [ "x${HOMEBREW_PREFIX}" = "x" ]; then
      export LD_LIBRARY_PATH="${APPDIR}/usr/libexec/squashfs-root/usr/lib:${HOMEBREW_PREFIX}/lib:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      export PATH="${APPDIR}/usr/libexec/squashfs-root/usr/bin:${APPDIR}/usr/bin:${HOMEBREW_PREFIX}/bin:${PATH:+:$PATH}"
      export XDG_DATA_DIRS="${APPDIR}/usr/share/:${HOMEBREW_PREFIX}/share/:${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
    else
      export LD_LIBRARY_PATH="${APPDIR}/usr/libexec/squashfs-root/usr/lib:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      export PATH="${APPDIR}/usr/libexec/squashfs-root/usr/bin:${APPDIR}/usr/bin:${PATH:+:$PATH}"
      export XDG_DATA_DIRS="${APPDIR}/usr/share/:${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
    fi

    if [ "x${POKETEDIR}" = "x" ] || [ ! -d "${POKETEDIR}" ]; then
      export POKETEDIR="${HOME}/.config/pokete"
    fi

    if [ ! -d "${POKETEDIR}/mods" ]; then
      ${APPDIR}/usr/libexec/squashfs-root/usr/bin/python3.9 \
        -c "import shutil; shutil.copytree('${APPDIR}/usr/libexec/pokete/mods', '${POKETEDIR}/mods')"
    fi

    unset ARGV0
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export PYTHON_HOME="${APPDIR}/usr/libexec/squashfs-root/usr"

    exec ${APPDIR}/usr/libexec/squashfs-root/opt/python3.9/bin/python3.9 ${APPDIR}/usr/libexec/pokete/pokete.py "$@"
    EOS
  end

  def exec_path_list
    return []
  end

  def desktop(exec_path); <<~EOS
    [Desktop Entry]
    Type=Application
    Name=Pokete
    Exec=pokete
    Comment=#{desc}
    Icon=pokete
    Categories=Game;
    Terminal=true
    EOS
  end

  def pre_build_appimage(appdir, verbose)
    unless (opt_libexec/"squashfs-root").directory? then
      raise "Can't found directory #{opt_libexec}/squashfs-root"
    end

    ohai "Install pokete.desktop" if verbose
    (appdir/"pokete.desktop").write(desktop(opt_bin/"pokete"))

    ohai "Install pokete.png" if verbose
    system("cp -pRv #{opt_libexec}/pokete/assets/pokete-256x256.png #{appdir.icons_256x256}/pokete.png")
    system("rm -rfv #{appdir}/appimage.png")
    system("cd #{appdir} && ln -sfv ./#{appdir.icons_256x256.relative_path_from(appdir.realpath)}/pokete.png ./pokete.png")

    ohai "Reinstall AppRun" if verbose
    system("mv #{appdir}/AppRun #{appdir}/usr/bin/pokete")
    system("cd #{appdir} && ln -sfv ./usr/bin/pokete ./AppRun")

    ohai "Install #{appdir}/libexec" if verbose
    system("cp -pRv #{opt_libexec} #{appdir}/usr")
  end
end
