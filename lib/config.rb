module Config
  module_function

  def stable_version_list
    return %w(0.6.0)
  end

  def stable_version
    return stable_version_list[-1]
  end

  def devel_version_list
    return []
  end

  def devel_version
    return ""
  end

  def commit_long
    return "9013f66b2550ed237045c31e1cfc7babe753d909"
  end

  def commit
    return commit_long[0..7]
  end

  def commit_sha256
    @@curl ||= %x{which curl}.chomp!
    @@sha256sum ||= %x{which sha256sum}.chomp!
    @@archive_url ||= "https://github.com/lxgr-linux/pokete/archive"
    @@commit_sha256 ||= %x{#{@@curl} -s -L -o - #{@@archive_url}/#{commit_long}.tar.gz | #{@@sha256sum} -}.chomp.gsub(/^([0-9a-f]*).*/) { $1 }
    return @@commit_sha256
  end

  def head_version
    return "1.0.0-next"
  end

  def appimage_version
    return "v#{stable_version}-eaw-appimage-0.0.1"
  end

  def appimage_revision
    return 35
  end

  def release_dir
    return "/vagrant/opt/releases"
  end

  def formula_dir
    return "/vagrant/opt/formula"
  end

  def lib_dir
    return "/vagrant/lib"
  end

  def appimage_builder_rb
    return "pokete-builder.rb"
  end

  def appimage_name
    return "pokete-eaw"
  end

  def appimage_command
    return "pokete"
  end

  def appimage_arch
    return "x86_64"
  end

  def formula_tap
    return "z80oolong/game"
  end

  def formula_name
    return "pokete"
  end

  def formula_fullname
    return "#{formula_tap}/#{formula_name}"
  end

  def formula_desc
    return "AppImage package of a terminal based Pokemon like game."
  end

  def formula_homepage
    return "https://lxgr-linux.github.io/pokete"
  end

  def formula_download_url
    return "https://github.com/z80oolong/pokete-eaw-appimage/releases/download"
  end
end
