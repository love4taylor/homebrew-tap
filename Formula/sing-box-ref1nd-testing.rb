class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.5-reF1nd/sing-box-1.14.0-beta.5-reF1nd-darwin-arm64.tar.gz"
      sha256 "e8ce7633524980bbc00afc392e21b8fbcdf0142dbbe2b415aa06923f20176bd7"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.5-reF1nd/sing-box-1.14.0-beta.5-reF1nd-darwin-amd64.tar.gz"
      sha256 "06bed4e5e39404c05a02f71e584da460697449c1f70ec7122deb3fe8e6eaaf25"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.5-reF1nd/sing-box-1.14.0-beta.5-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "c00726f9ec36659e945d5883d14ea787e2b785658477ab6a9a0a0d852bcc0dda"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.5-reF1nd/sing-box-1.14.0-beta.5-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "9bdf8c3d41a4af71f41b497f5feab8113f84f652aefb4049110727fe29327d45"
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
