class Owncast < Formula
  desc "Free and open source live video and web chat server"
  homepage "https://owncast.online"
  url "https://github.com/owncast/owncast/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ca4d5792e26da6f1b048b3a8d043563b79b7e3008f138cad6f581234fb624a3a"
  license "MIT"
  head "https://github.com/owncast/owncast.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build
  depends_on "ffmpeg"

  def install
    system "go", "build", "-o", "owncast", "main.go"
    bin.install "owncast"
  end

  test do
    port = free_port
    fork do
      system "#{bin}/owncast", "-webserverport", port.to_s
    end
    sleep 2

    assert_match "\"New Owncast Server\"",
      shell_output("curl -s http://127.0.0.1:#{port}/api/config")
  end
end
