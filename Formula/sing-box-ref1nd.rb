class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.14.0"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-reF1nd.1/sing-box-1.14.0-reF1nd.1-darwin-arm64.tar.gz"
      sha256 "8af47014c21cc0ec565c1c5a7511ca9c3938a23e1de0d7e8229bcb2bf16a5a8a"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-reF1nd.1/sing-box-1.14.0-reF1nd.1-darwin-amd64.tar.gz"
      sha256 "12389a7e5db543cc8dc6be25582ed689af1e5353cdc6f65baded2365d557bb42"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-reF1nd.1/sing-box-1.14.0-reF1nd.1-linux-arm64-musl.tar.gz"
      sha256 "052391a9e94a0bd00e4d2531920dc87f65436500d581918c07b1c4e2406338fc"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-reF1nd.1/sing-box-1.14.0-reF1nd.1-linux-amd64-musl.tar.gz"
      sha256 "6831a8fe8faf0e030715773e4daee75a8a0261a4047bc6cc68e09b9e7f7e0136"
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
