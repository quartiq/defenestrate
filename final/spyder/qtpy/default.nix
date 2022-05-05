{ lib, buildPythonPackage, fetchPypi, pyside, pytest, packaging }:

buildPythonPackage rec {
  pname = "QtPy";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yozUIXF1GGNEKZ7kwPfnrc82LHCFK6NbJVpTQHcCXAY=";
  };

  propagatedBuildInputs = [ packaging ];

  # no concrete propagatedBuildInputs as multiple backends are supposed
  checkInputs = [ pyside pytest ];

  doCheck = false; # require X
  checkPhase = ''
    py.test qtpy/tests
  '';

  meta = with lib; {
    description = "Abstraction layer for PyQt5/PyQt4/PySide2/PySide";
    homepage = "https://github.com/spyder-ide/qtpy";
    license = licenses.mit;
  };
}
