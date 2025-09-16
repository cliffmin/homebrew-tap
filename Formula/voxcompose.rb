class Voxcompose < Formula
  desc "Markdown refiner for speech transcripts (CLI)"
  homepage "https://github.com/cliffmin/voxcompose"
  url "https://github.com/cliffmin/voxcompose/releases/download/v0.1.0/voxcompose-0.1.0-all.jar"
  sha256 "5f819615f309c23c248420bf77257b63291d00085c0747ef9879b78f7b3393b9"
  license "MIT"

  depends_on "openjdk@21"

  def install
    libexec.install "voxcompose-0.1.0-all.jar"
    (bin/"voxcompose").write <<~EOS
      #!/usr/bin/env bash
      exec "#{Formula["openjdk@21"].opt_bin}/java" -jar "#{libexec}/voxcompose-0.1.0-all.jar" "$@"
    EOS
    chmod 0555, (bin/"voxcompose")
  end

  test do
    output = shell_output("#{bin}/voxcompose --help 2>&1", 2)
    assert_match "model", output
  end
end

