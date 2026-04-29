class Brain < Formula
  desc "A local-first personal second brain with token-budgeted retrieval for AI agents"
  homepage "https://github.com/benediktms/brain"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benediktms/brain/releases/download/v0.3.7/brain-aarch64-apple-darwin.tar.xz"
      sha256 "319fa30b5dd4dfd04fa2d9d1204cbb16b6bd1506e384cf0b68389e637e2379eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.3.7/brain-x86_64-apple-darwin.tar.xz"
      sha256 "967b3c40b4b2148f737a14502b90a57e7447cf8e35c28992aadffb01430d6e3d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benediktms/brain/releases/download/v0.3.7/brain-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0ec953397490614b08737848344bada0bb9abe200da85dea92a21958a08d573c"
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
