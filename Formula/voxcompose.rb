class Voxcompose < Formula
  desc "Markdown refiner for speech transcripts (CLI)"
  homepage "https://github.com/cliffmin/voxcompose"
  url "https://github.com/cliffmin/voxcompose/releases/download/v0.4.0-rc.4/voxcompose-cli-0.1.0-all.jar"
  sha256 "1cb36998635957fef7c21a8ff343c817ab275d5b9c5107a30a14ce65d030ee55"
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

