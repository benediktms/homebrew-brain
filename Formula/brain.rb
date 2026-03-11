class Brain < Formula
  desc "A local-first personal second brain with token-budgeted retrieval for AI agents"
  homepage "https://github.com/benediktms/brain"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benediktms/brain/releases/download/v0.2.1/brain-aarch64-apple-darwin.tar.xz"
      sha256 "764a3ad1b82f6cc65826bc2cdf17c07b0fd49b89431db078971ca6e1e6b3dc76"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.2.1/brain-x86_64-apple-darwin.tar.xz"
      sha256 "a791926dcd40348783ee9feb86dfc6dd9252cb00996c3a367c4501087aaf2981"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.2.1/brain-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96d3564d6f9db89e1ee52764985a3b96300c57b52325e430439557fa47641469"
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
