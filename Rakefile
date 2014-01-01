task :default => :update

task :setup => ["setup:setup"]

verbose(false)

namespace :setup do
  task :setup => [:osx, :homebrew, :local, :dotfiles]

  task :osx do
    if RUBY_PLATFORM.include? "darwin"
      script = File.join(root_path(), "osx.bash")
      sh script
    end
  end

  task :homebrew do
    if which("brew").empty?
      info("installing homebrew")
      sh 'ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"'
    end

    unless `brew tap`.split().include?('phinze/cask')
      info("installing homebrew cask support")
      sh 'brew tap phinze/homebrew-cask'
    end
  end

  task :local do
    root = root_path()
    localFiles = ["Brewfile.local", "gitconfig.local", "slate.js.local", "vimrc.local", "zshrc.local"]
    localFiles.each {|f|
      path = File.join(root, f)
      unless File.exists?(path)
        info("created empty local file #{path}")
        FileUtils.touch(path)
      end
    }
  end

  task :dotfiles do
    excludes = ["LICENSE", "README.md", "Rakefile", "osx.bash"]
    root = root_path()

    Dir.foreach(root) {|f|
      unless f.start_with?(".") or excludes.include?(f)
        symlink_path(File.join(root, f), File.join(Dir.home, ".#{File.basename(f)}"))
      end
    }

    Dir.foreach(File.join(root, "zprezto", "runcoms")) {|f|
      if f.start_with?("z")
        symlink_path(File.join(Dir.home, ".zprezto", "runcoms", f), File.join(Dir.home, ".#{f}"))
      end
    }
  end
end

task :update do
  sh 'git pull'
  sh 'git submodule update --recursive'
end

#### Helper Classes and Functions

class String
  def colorize(colorCode)
    "\e[#{colorCode}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end
end

def which(binary)
  paths = ENV['PATH'].split(File::PATH_SEPARATOR)
  paths.map {|path| File.join(path, binary)}.find {|p| File.exists?(p) and File.executable?(p)}
end

def symlink_path(source, dest)
  if not File.exists?(dest) and File.symlink?(dest)
    info("deleting broken symlink #{dest} to #{File.readlink(dest)}")
    File.delete(dest)
  end
  if File.exists?(dest)
    if File.symlink?(dest)
      if File.realpath(source) == File.realpath(dest)
        return
      else
        warning("deleting unknown symlink #{dest} to #{File.realpath(dest)}")
        File.delete(dest)
      end
    else
      backup = "#{dest}.#{Time.now.strftime("%Y%m%d%H%M%S")}"
      warning("target #{dest} already exists, backing up to #{backup}")
      File.rename(dest, backup)
    end
  end
  File.symlink(source, dest)
  info("symlinked #{source} to #{dest}")
end

def root_path()
  File.expand_path(File.dirname(__FILE__))
end

def info(msg, *args)
  puts "#{"info".green}: #{msg % args}"
end

def warning(msg, *args)
  puts "#{"warning".yellow}: #{msg % args}"
end

def error(msg, *args)
  puts "#{"error".red}: #{msg % args}"
end

