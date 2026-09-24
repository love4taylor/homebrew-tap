class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.8-reF1nd/sing-box-1.15.0-alpha.8-reF1nd-darwin-arm64.tar.gz"
      sha256 "6165e921d338b2bac76640239abdf8c31159e0c8e9853547c87c8248d184cef6"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.8-reF1nd/sing-box-1.15.0-alpha.8-reF1nd-darwin-amd64.tar.gz"
      sha256 "a950b5ef15fd0912a27edecaf2ad8259bab523e42935d1328098ae597ea87d21"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.8-reF1nd/sing-box-1.15.0-alpha.8-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "9cfb9ce1fe857525d355bdb2d01d1b2e590e28cb39f4afdf3a35d30e9dbc698d"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.8-reF1nd/sing-box-1.15.0-alpha.8-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "db351e69d23a989c97b0874c5ee7188c261f932777c5ba36e880f794cdbefde5"
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
