class Brain < Formula
  desc "A local-first personal second brain with token-budgeted retrieval for AI agents"
  homepage "https://github.com/benediktms/brain"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benediktms/brain/releases/download/v0.3.4/brain-aarch64-apple-darwin.tar.xz"
      sha256 "a158c6ee42282b06270e35bbd2a3e79a5a8dd902a2fdd53e0466a90da1dba8f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.3.4/brain-x86_64-apple-darwin.tar.xz"
      sha256 "3c4af8bfbecbf3ae4d2af2ccd98682dd137deec8de67e42998b5929b2e1fb3b0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benediktms/brain/releases/download/v0.3.4/brain-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "cdfc8ba24ed0280907d5ae2d9519192215a6b4251cd6a3a34e0eafca26b5f0f1"
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
