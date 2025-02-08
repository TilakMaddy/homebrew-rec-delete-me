class Rec < Formula
  desc "Practice release engineering"
  homepage "https://github.com/cyfrin/rec"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/rec/releases/download/rec-v0.1.5/rec-aarch64-apple-darwin.tar.xz"
      sha256 "4e06837c77d777ab3fdcb4c1f5b143942873649df0f610d0333504a0eda9d98a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/rec/releases/download/rec-v0.1.5/rec-x86_64-apple-darwin.tar.xz"
      sha256 "1ee261707a95da774de45393e1863258984abdb362efb7052b63e7595119b51a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/rec/releases/download/rec-v0.1.5/rec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61aacdb531eb690aeef3f69c11f6c3e8f6d112e4dddfe4a5c09001c598bd1732"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/rec/releases/download/rec-v0.1.5/rec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01b1d7cbfa778bf89771611e597919b10748e09ea9f95581c28efb20f8e9767d"
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
