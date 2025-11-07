{ lib
, buildPythonPackage
, fetchPypi
, click
, pillow
, ephem
, pyshp
, requests
,
}:

buildPythonPackage rec {
  pname = "termtrack";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-d9Y3wFppaOLhKtLiXEwbjIx8eIKdHYTTPnttqPUlfV8=";
  };

  propagatedBuildInputs = [
    click
    pillow
    ephem
    pyshp
    requests
  ];

  preBuild = ''
    substituteInPlace setup.py --replace pyephem ephem

  '';

  meta = with lib; {
    homepage = "https://github.com/trehn/termtrack";
    description = "Track satellites in your terminal";
    license = licenses.gpl3;
  };
}
