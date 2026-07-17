class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.46-reF1nd.1/sing-box-1.14.0-alpha.46-reF1nd.1-darwin-arm64.tar.gz"
      sha256 "5ec3c942acb6fbc1eec32a57156203f6d1140d33dc70db7e50736b2610f9d684"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.46-reF1nd.1/sing-box-1.14.0-alpha.46-reF1nd.1-darwin-amd64.tar.gz"
      sha256 "d5424e9d26f00cd7a04da24fbe2841a8561157cc90341175fd25eb9451e2baaf"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.46-reF1nd.1/sing-box-1.14.0-alpha.46-reF1nd.1-linux-arm64-musl.tar.gz"
      sha256 "8db08c5f443db823a61c830482e0c13c7ef679a61695817079a934187eb95f47"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.46-reF1nd.1/sing-box-1.14.0-alpha.46-reF1nd.1-linux-amd64-musl.tar.gz"
      sha256 "bbedcf27e9fb943eb2bf15062846e62c319c26f7aaeb8fc63bf5de1438776d2b"
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
