class Brain < Formula
  desc "A local-first personal second brain with token-budgeted retrieval for AI agents"
  homepage "https://github.com/benediktms/brain"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benediktms/brain/releases/download/v0.3.0/brain-aarch64-apple-darwin.tar.xz"
      sha256 "49e79cd8497b594c67597a94a5efb07260c388d92f910a0b5bff6eac058aa84a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.3.0/brain-x86_64-apple-darwin.tar.xz"
      sha256 "723a2618cc9317dded298e1b939c2ef5af77a8cacdbdaf458e63fedb7a9e59cb"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.3.0/brain-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "300b391cac80e409f7482ad9759ff470a8ab5270186e221e7faebce776ca99c4"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "brain" if OS.mac? && Hardware::CPU.arm?
    bin.install "brain" if OS.mac? && Hardware::CPU.intel?
    bin.install "brain" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
