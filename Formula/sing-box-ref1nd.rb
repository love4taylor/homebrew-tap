class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.12"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.12-reF1nd/sing-box-1.13.12-reF1nd-darwin-arm64.tar.gz"
      sha256 "e2c7e4549c69ba4fd366c697d719c871a80fda55bba8ce3e0b03fe98cc1d885c"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.12-reF1nd/sing-box-1.13.12-reF1nd-darwin-amd64.tar.gz"
      sha256 "123c705cb02198eb56d5376900a79d9e8dda7ac3731b6e6ffe342b80fdc06db4"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.12-reF1nd/sing-box-1.13.12-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "364252793cd4ae6fda5044dacf2b7a987c946e4e1d20201c3a9904765487a17f"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.12-reF1nd/sing-box-1.13.12-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "a87235f3086698ebe2d040f420b0d725ccf0a7030615ae1eb2e82ff8469e0792"
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
