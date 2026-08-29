class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.20"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.20-reF1nd/sing-box-1.13.20-reF1nd-darwin-arm64.tar.gz"
      sha256 "04d03dee034b8bc31e84cd8144e16a3a0c402d42bbc00c80851e9419abcdeb15"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.20-reF1nd/sing-box-1.13.20-reF1nd-darwin-amd64.tar.gz"
      sha256 "3b9fc9799b101a973207ef1f98712c54bade3f551dce2daad2d8aebfc1e159c6"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.20-reF1nd/sing-box-1.13.20-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "ff842e08f757fb4547a8094f7beed9ee33e115784032fa3b71bef843a3e388ab"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.20-reF1nd/sing-box-1.13.20-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "9ebbb5b245f7af40179125823c2e191e44d6acb805e15a1cd6b9d71d9ea91143"
    end
  end

  conflicts_with "sing-box-ref1nd-testing", because: "both install sing-box-ref1nd binary"

  def install
    # The tarball extracts directly into buildpath.
    # The binary is named `sing-box` — rename to avoid conflict with original sing-box.
    bin.install "sing-box" => "sing-box-ref1nd"
  end

  post_install_steps do
    mkdir_p "sing-box-ref1nd", base: :etc
  end

  def caveats
    <<~EOS
      No default configuration is provided. Place your JSON config files under:
        #{etc}/sing-box-ref1nd/
    EOS
  end

  service do
    run [opt_bin/"sing-box-ref1nd", "run",
         "--config-directory", etc/"sing-box-ref1nd",
         "--directory", var/"lib/sing-box-ref1nd"]
    run_type :immediate
    keep_alive true
    require_root true
    process_type :background
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box-ref1nd version")
  end
end
