class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.1-reF1nd/sing-box-1.14.0-beta.1-reF1nd-darwin-arm64.tar.gz"
      sha256 "729e42cc084e37812e5b0da362a897d48fb0b719e47459b3040dbcd09dfe2b57"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.1-reF1nd/sing-box-1.14.0-beta.1-reF1nd-darwin-amd64.tar.gz"
      sha256 "23115943e5713e01aa6c5f100bd068f1200482ccc754a081d75f6c931d9c6ad6"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.1-reF1nd/sing-box-1.14.0-beta.1-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "236694820a1ab9131268162e4ac56583db639c3366c561b614c857e5c16ffe73"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.1-reF1nd/sing-box-1.14.0-beta.1-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "671e5aed3d21d4c9cf757033afacb80fa8306db223a5676d0a4ebee33629f444"
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
