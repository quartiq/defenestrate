{ lib
, fetchPypi
, buildPythonPackage
, helpdev
, qtpy
}:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "3.0.3";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    sha256 = "sha256-k20tNbVS9CmAOphdvBf8h5ovlm+qn7+Jg4lsz6M+aPY=";
  };

  # No tests available
  doCheck = false;

  propagatedBuildInputs = [ helpdev qtpy ];

  meta = with lib; {
    description = "A dark stylesheet for Python and Qt applications";
    homepage = "https://github.com/ColinDuquesnoy/QDarkStyleSheet";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
