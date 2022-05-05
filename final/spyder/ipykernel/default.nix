{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pythonOlder
, argcomplete
, debugpy
, ipython
, jupyter-client
, tornado
, traitlets
, psutil
, packaging
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DignPikIWDk+huFSsQTlUGp5wT0luVGsbsoiAFG0vmA=";
  };

  propagatedBuildInputs = [
    debugpy
    ipython
    jupyter-client
    tornado
    traitlets
    psutil
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    argcomplete
  ];

  # check in passthru.tests.pytest to escape infinite recursion with ipyparallel
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
