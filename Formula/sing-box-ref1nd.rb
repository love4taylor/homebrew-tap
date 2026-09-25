class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.14.2"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.2-reF1nd/sing-box-1.14.2-reF1nd-darwin-arm64.tar.gz"
      sha256 "b721d8858885caa74ff790f68445fb21dd50baddb4f85b36f539c710b7b229cf"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.2-reF1nd/sing-box-1.14.2-reF1nd-darwin-amd64.tar.gz"
      sha256 "c2112f53f9d1c063061ef5651079fcd95be0dee1c133236c798d2203fec18b3d"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.2-reF1nd/sing-box-1.14.2-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "c38febec4cdd96b69065dbb000edd2575d29f39da457ffc659c514ec7700369b"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.2-reF1nd/sing-box-1.14.2-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "7b059e26e0d6af88932470272877ca0f60b078d70342a513fd9f4fb8805935f3"
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
