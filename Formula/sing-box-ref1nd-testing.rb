class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.10-reF1nd/sing-box-1.14.0-beta.10-reF1nd-darwin-arm64.tar.gz"
      sha256 "fc5cc037efc0c9a4fdaabce2e0f6b52b13715faa3794f92631de9cdc6ee4a965"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.10-reF1nd/sing-box-1.14.0-beta.10-reF1nd-darwin-amd64.tar.gz"
      sha256 "3fe12443cb9ad803b441f3fc8733fa9131f1e8042a5dc947d48465be221047c7"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.10-reF1nd/sing-box-1.14.0-beta.10-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "42e404e21b932b321d346d0707028e0c701cda96a782698f9732acb4950dbb09"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.10-reF1nd/sing-box-1.14.0-beta.10-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "94a51fc2e51e0c4fe51b9582f1b754595696c0f5067e89f3c23fffb333a5a293"
    end
  end

  conflicts_with "sing-box-ref1nd", because: "both install sing-box-ref1nd binary"

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
