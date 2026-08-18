class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.19"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.19-reF1nd/sing-box-1.13.19-reF1nd-darwin-arm64.tar.gz"
      sha256 "23c2dc12fb1e5719c466772527b5c8e764f36bfdfe1c5947d1a4ba4bc72b30f0"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.19-reF1nd/sing-box-1.13.19-reF1nd-darwin-amd64.tar.gz"
      sha256 "b05fb0413843dac89ad48ae0c7229c8ed88d4c0b626891c28c2106e99d76d6b5"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.19-reF1nd/sing-box-1.13.19-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "563507be2b5dc03abee4db6ad7ffc560fd7536a8171e21a434f3332c97896fdc"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.19-reF1nd/sing-box-1.13.19-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "57237bfc96df1f9b822e09c26e9322560eb092c1e89f4d50741cf3517203cb0f"
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
