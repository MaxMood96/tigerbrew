class ArgpStandalone < Formula
  desc "Standalone version of arguments parsing functions from GLIBC"
  homepage "https://www.lysator.liu.se/~nisse/misc/"
  url "https://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz"
  sha256 "dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be"

  bottle do
    sha256 "a63e3f795b21628e8cd1374000b1958c5efe99ed0c371108403229f48809aa33" => :tiger_altivec
  end

  # This patch fixes compilation with Clang.
  patch :p0 do
    url "https://trac.macports.org/export/86556/trunk/dports/devel/argp-standalone/files/patch-argp-fmtstream.h"
    sha256 "5656273f622fdb7ca7cf1f98c0c9529bed461d23718bc2a6a85986e4f8ed1cb8"
  end

  conflicts_with "gpgme", :because => "gpgme picks it up during compile & fails to build"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    lib.install "libargp.a"
    include.install "argp.h"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <argp.h>

      int main(int argc, char ** argv)
      {
        return argp_parse(0, argc, argv, 0, 0, 0);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-largp", "-o", "test"
    system "./test"
  end
end
