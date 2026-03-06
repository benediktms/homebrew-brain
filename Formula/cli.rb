class Cli < Formula
  desc "A local-first personal second brain with token-budgeted retrieval for AI agents"
  homepage "https://github.com/benediktms/brain"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benediktms/brain/releases/download/v0.1.1/cli-aarch64-apple-darwin.tar.xz"
      sha256 "c8fc4e626796da8ee5b568eee68d14bbb5d07428b09d9d6c0a95c1f5dfe6b5b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.1.1/cli-x86_64-apple-darwin.tar.xz"
      sha256 "a5e52b7ef4a8d0afd252a3489f1e9b60436f93e29b65d9d6d8f5f5d4d8ebd567"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.1.1/cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "64360fae4b6c70a1e7287121891c0902796666adb007710918b99767931e388c"
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
