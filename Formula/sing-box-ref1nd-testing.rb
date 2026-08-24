class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-rc.1-reF1nd/sing-box-1.14.0-rc.1-reF1nd-darwin-arm64.tar.gz"
      sha256 "e622d096f72b1c35a91e5e6c190b4d5d84b496dcc10d9487b527738a682a412b"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-rc.1-reF1nd/sing-box-1.14.0-rc.1-reF1nd-darwin-amd64.tar.gz"
      sha256 "33e600a1812df453fd9ba2469fa6feb71ffda2e1962cf0c62fd704c79cd1a218"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-rc.1-reF1nd/sing-box-1.14.0-rc.1-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "40a6f9bc37404ae644a60c2896186334aff8ebb60b4ccf964de00753238c7db9"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-rc.1-reF1nd/sing-box-1.14.0-rc.1-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "a049c6815fcae4c37f7d209d14a7a44ae7449c7d919285bbae938f6b79d1fcb7"
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
