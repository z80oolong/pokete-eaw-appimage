$:.unshift((Pathname.new(__FILE__).dirname/"..").realpath.to_s)

require "lib/config"

class PoketeAT100Next < Formula
  desc "A terminal based Pokemon like game"
  homepage "https://lxgr-linux.github.io/pokete"
  license "GPL-3.0"
  revision 1

  stable do
    pokete_version = "HEAD-#{Config::commit}"
    url "https://github.com/lxgr-linux/pokete/archive/#{Config::commit_long}.tar.gz"
    sha256 Config::commit_sha256
    version pokete_version

    patch :p1, Formula["z80oolong/game/pokete"].diff_data
  end

  keg_only :versioned_formula
 
  depends_on "imagemagick" => :build
  depends_on "python@3.9" => :recommended

  resource("appimage-python3.9") do
    url "https://github.com/niess/python-appimage/releases/download/python3.9/python3.9.12-cp39-cp39-manylinux2014_x86_64.AppImage"
    sha256 "318b380d944e30ff7dda62c1baa92307ed08f1aa160ebcdd68a4e7c428e68416"
  end if build.without?("python@3.9")

  resource("scrap_engine") do
    url "https://github.com/lxgr-linux/scrap_engine/releases/download/1.2.0/scrap_engine-1.2.0.tar.gz"
    sha256 "767ffdc312b550777771cdc9a350a9f6dca73855259dd1fe7197c8736e38cac1"
  end

  def pokete_sh(python_home); <<~EOS
    #!/bin/sh
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export PYTHON_HOME="#{python_home}"
    exec #{python_home}/bin/python3.9 #{libexec}/pokete/pokete.py "$@"
    EOS
  end

  def install
    libexec.mkdir; bin.mkdir

    if build.without?("python@3.9") then
      resource("appimage-python3.9").stage do
        (Pathname.pwd/"python3.9.12-cp39-cp39-manylinux2014_x86_64.AppImage").chmod(0755)
        system "./python3.9.12-cp39-cp39-manylinux2014_x86_64.AppImage", "--appimage-extract"
        libexec.install "./squashfs-root"
      end

      resource("scrap_engine").stage do
        system "env", "PYTHON_HOME='#{libexec}/squashfs-root/usr'", \
          libexec/"squashfs-root/usr/bin/pip", "install", "-v", "--no-binary", ":all:", "--ignore-installed", "."
      end
      (buildpath/"pokete").write(pokete_sh(libexec/"squashfs-root/usr"))
    else
      venv = virtualenv_create(libexec, "python3")

      resource("scrap_engine").stage do
        system "env", "PYTHON_HOME='#{libexec}'", \
          libexec/"bin/pip", "install", "-v", "--no-binary", ":all:", "--ignore-installed", "."
      end
      (buildpath/"pokete").write(pokete_sh(libexec))
    end

    system "#{Formula["imagemagick"].opt_bin}/convert", \
      "#{buildpath}/assets/pokete.png", "-resize", "256x256!", "#{buildpath}/assets/pokete-256x256.png"

    bin.install buildpath/"pokete"
    (libexec/"pokete").mkpath
    (libexec/"pokete").install Dir["*"]
    (bin/"pokete").chmod(0755)
  end

  test do
    system "false"
  end
end
