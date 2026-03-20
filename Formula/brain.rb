class Brain < Formula
  desc "A local-first personal second brain with token-budgeted retrieval for AI agents"
  homepage "https://github.com/benediktms/brain"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benediktms/brain/releases/download/v0.3.2/brain-aarch64-apple-darwin.tar.xz"
      sha256 "2eb081502beea5079ca31b9bac389f4b7a5a1011f778882fea541100e750400e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.3.2/brain-x86_64-apple-darwin.tar.xz"
      sha256 "bc08f90f89295a0311de9ca8b43b65281bab0684a7a5526e00e6b80f48c1f41e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.3.2/brain-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4cfffde081bb3816d60bf813a831d8fd6d58d743c80e327d8e3a0906d25a6f4f"
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
