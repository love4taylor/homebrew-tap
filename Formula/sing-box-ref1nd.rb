class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.15"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.15-reF1nd/sing-box-1.13.15-reF1nd-darwin-arm64.tar.gz"
      sha256 "7ec53075b39333ba035db218282e8b7447801e95a44f57062b15fb62792f7326"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.15-reF1nd/sing-box-1.13.15-reF1nd-darwin-amd64.tar.gz"
      sha256 "d74216a42100ffb738ff40291f95292fae9c6685207ee25352e9f24b9f058422"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.15-reF1nd/sing-box-1.13.15-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "6e4e08d28e35e79a96abdec3b3646897948df1bbae4d87906ab425566fe8b750"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.15-reF1nd/sing-box-1.13.15-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "acf3be81a419abb3fc07c6e85098305bd7411ab9e5b0355858dfb477da0e5b23"
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
