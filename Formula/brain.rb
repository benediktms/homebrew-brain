# frozen_string_literal: true

class Brain < Formula
  desc "Your thinking surface — tasks, records, wiki, and semantic search in one place"
  homepage "https://github.com/benediktms/brain"
  license "MIT"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benediktms/brain/releases/download/v0.4.2/brain-aarch64-apple-darwin.tar.xz"
      sha256 "e1d0189419f95ed844af313c4db828d9ff8010c22ce5120cbd57e99450e2fe36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benediktms/brain/releases/download/v0.4.2/brain-x86_64-apple-darwin.tar.xz"
      sha256 "2da95bc7d287f92e2e7385a2247857dccdaced0570d46589473d17b17c3df80a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benediktms/brain/releases/download/v0.4.2/brain-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b77078be0d7dee27b7ecc51544de60f303dde1922c16450e10d32ea3d3c474b7"
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
    bin.install "brain", "brain-daemon", "brain-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "brain", "brain-daemon", "brain-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "brain", "brain-daemon", "brain-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  # `brew upgrade` automatically calls `brew services restart brain` when this
  # service block is present — launchd/systemd picks up the new binary on restart.
  service do
    run [
      opt_bin/"brain-daemon",
      "--socket-path", "#{ENV["HOME"]}/.brain/brain-rpc.sock",
      "--pid-file", "#{ENV["HOME"]}/.brain/brain.pid",
      "--sqlite-db", "#{ENV["HOME"]}/.brain/brain.db",
      "--lance-db", "#{ENV["HOME"]}/.brain/lancedb",
    ]
    keep_alive true
    restart_delay 5
    run_at_load true
    log_path "#{ENV["HOME"]}/.brain/logs/brain.log"
    error_log_path "#{ENV["HOME"]}/.brain/logs/brain.err.log"
    environment_variables PATH: "#{ENV["HOME"]}/bin:#{std_service_path_env}"
  end

  def caveats
    <<~EOS
      The brain daemon is installed. Start it with: brew services start brain

      To stop the daemon:       brew services stop brain
      To restart the daemon:    brew services restart brain
      To view logs:             tail -f ~/.brain/logs/brain.log
    EOS
  end
end
