class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.14"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.14-reF1nd.1/sing-box-1.13.14-reF1nd.1-darwin-arm64.tar.gz"
      sha256 "34eba9a1cc46677439ed12dc42e56e6aacafb67aa0e169b60b0ef4cb925a85e6"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.14-reF1nd.1/sing-box-1.13.14-reF1nd.1-darwin-amd64.tar.gz"
      sha256 "7b9c6356883fa11af96fa06243fae4e70f6e85ff3ac7e32f472cd21d0d88a4a8"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.14-reF1nd.1/sing-box-1.13.14-reF1nd.1-linux-arm64-musl.tar.gz"
      sha256 "f071868a62136345fe5e7d9ca667317d4417a58a5f1527ebcfd51e4126073e64"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.14-reF1nd.1/sing-box-1.13.14-reF1nd.1-linux-amd64-musl.tar.gz"
      sha256 "564d3b5caf560cd50b15a917a54c5e5d07edcf189cc8ef568c46984e43c1dff4"
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
