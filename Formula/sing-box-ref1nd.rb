class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.13"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.13-reF1nd/sing-box-1.13.13-reF1nd-darwin-arm64.tar.gz"
      sha256 "1b925f0f7858ec5e65b41e44661db15f0bff8c2b88ad44e7db8ae4fdd49e5fcd"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.13-reF1nd/sing-box-1.13.13-reF1nd-darwin-amd64.tar.gz"
      sha256 "3974cad0cb88ed4a19a074cde2ac47e6d0981b1069c3e0ffe38e64a39ef3f60d"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.13-reF1nd/sing-box-1.13.13-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "b3d6a86b119a1b6dc71dda7dbc90db858ef52aa76440f365d363818e4e1b945b"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.13-reF1nd/sing-box-1.13.13-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "701224a942fcca1bd53eeb8e87ea8a7b4a00869acc96d188fc44dfec44849891"
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
