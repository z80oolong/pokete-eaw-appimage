module Config
  module_function

  def stable_version?
    return true
  end

  def appimage_tap_name
    return "z80oolong/appimage"
  end

  def current_tap_name
    return "z80oolong/game"
  end

  def current_formula_name
    return "pokete"
  end

  def current_builder_name
    return "pokete-builder"
  end

  def current_appimage_name
    return "#{current_formula_name}-eaw"
  end

  def current_version
    if stable_version? then
      return "0.6.0"
    else
      return "HEAD-#{commit}"
    end
  end

  def all_stable_version
    return %w[0.6.0 0.7.0 0.7.1 0.7.2 0.7.3 0.8.0 0.8.1 0.8.2 0.9.0]
  end

  def current_head_formula_version
    return "1.0.0-next"
  end

  def all_stable_formulae
    return all_stable_version.map do |v|
      "#{Config::current_tap_name}/#{Config::current_formula_name}@#{v}"
    end
  end

  def current_head_formula
    return "#{lib_dir}/#{current_formula_name}@#{current_head_formula_version}.rb"
  end

  def commit_long
    return "9bfbdc5a141a68e56eec4d500c3915e331354132"
  end

  def commit
    return commit_long[0..7]
  end

  def current_appimage_revision
    return 50
  end

  def release_dir
    return "/vagrant/opt/releases"
  end

  def lib_dir
    return "/vagrant/lib"
  end

  def appimage_arch
    return "x86_64"
  end
end
