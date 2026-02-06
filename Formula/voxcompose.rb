class Voxcompose < Formula
  desc "Markdown refiner for speech transcripts (CLI)"
  homepage "https://github.com/cliffmin/voxcompose"
  url "https://github.com/cliffmin/voxcompose/releases/download/v1.0.0/voxcompose-1.0.0-all.jar"
  sha256 "5d3789b54b31c64155f1d0b1f01049065d20935999e7eadd100e918ec2fd3c87"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "openjdk@21"

  def install
    libexec.install "voxcompose-1.0.0-all.jar"
    (bin/"voxcompose").write <<~EOS
      #!/usr/bin/env bash
      exec "#{Formula["openjdk@21"].opt_bin}/java" -jar "#{libexec}/voxcompose-1.0.0-all.jar" "$@"
    EOS
    chmod 0555, (bin/"voxcompose")
  end

  def caveats
    <<~EOS
      VoxCompose requires Ollama for LLM refinement:

        brew install ollama
        ollama serve &
        ollama pull llama3.1

      Test: echo "pushto github" | voxcompose

      For VoxCore integration, edit ~/.hammerspoon/ptt_config.lua:
        LLM_REFINER = { ENABLED = true, CMD = { "#{opt_bin}/voxcompose" }, ... }
    EOS
  end

  test do
    output = shell_output("#{bin}/voxcompose --version 2>&1")
    assert_match "1.0.0", output
  end
end

