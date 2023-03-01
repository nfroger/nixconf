{ lib, rustPlatform, openssl, perl, pkg-config, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = pname;
    rev = version;
    sha256 = "sha256-GqhaTxPdJH0kvsqxvRAzS/Yt3wmJ3ahzJOIiuE9VJxE=";
  };

  cargoPatches = [
    # a patch file to add/update Cargo.lock in the source code
    ./add-Cargo.lock.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ perl openssl openssl.dev ];

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  OPENSSL_NO_VENDOR = 1;

  cargoSha256 = "sha256-JaSaIOUt3Dx6x2RCyG2WpKDp3h7zm6IWfowyrdYpkvs=";
}
