class Rec < Formula
  desc "Practice release engineering"
  homepage "https://github.com/cyfrin/rec"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/rec/releases/download/rec-v0.1.4/rec-aarch64-apple-darwin.tar.xz"
      sha256 "76959373782d0b224712a102cf5c4c7db81bfca1636a3631edb8b580bcfd9467"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/rec/releases/download/rec-v0.1.4/rec-x86_64-apple-darwin.tar.xz"
      sha256 "0b02dda166d35f66576bef517b8500bb2898e9efe07804a665e64908c87d9ae3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/rec/releases/download/rec-v0.1.4/rec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41e022b49468e7f87c0af3e3541b44033e03dee19ab00612bde0385c97303322"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/rec/releases/download/rec-v0.1.4/rec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d36a46e87ca232fcbcb9ac8ac7a4b504e4643ceb885e4fe01f4bb65194b16d07"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rec" if OS.mac? && Hardware::CPU.arm?
    bin.install "rec" if OS.mac? && Hardware::CPU.intel?
    bin.install "rec" if OS.linux? && Hardware::CPU.arm?
    bin.install "rec" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
