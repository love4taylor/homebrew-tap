class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.36-reF1nd/sing-box-1.14.0-alpha.36-reF1nd-darwin-arm64.tar.gz"
      sha256 "fd003a39ec075679923b44ed3aec94b0631d63e81254a5fa5681e6f1b82c7bb7"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.36-reF1nd/sing-box-1.14.0-alpha.36-reF1nd-darwin-amd64.tar.gz"
      sha256 "5ffde404996aa3cf8305dcaf7372b5579460a48cc1e0e59bcd2428e950a3aa48"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.36-reF1nd/sing-box-1.14.0-alpha.36-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "475d0f24e17bed8f1659701faffa8d9ce40006de623f589aaf3ed68f7b9d2856"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.36-reF1nd/sing-box-1.14.0-alpha.36-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "164eec16ce68aa731c5491f9c2ca059df6b831c364741d3658696f57672d088f"
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
