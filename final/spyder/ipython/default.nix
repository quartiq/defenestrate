{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
# Build dependencies
, glibcLocales
# Test dependencies
, nose
, pygments
# Runtime dependencies
, jedi
, decorator
, matplotlib-inline
, pickleshare
, traitlets
, prompt-toolkit
, pexpect
, appnope
, backcall
, pytest
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "7.33.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vP+4Zag7CBYgMBug7E2VCERU8muR1tZrR1v/PfsCGNQ=";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = [
    jedi
    decorator
    matplotlib-inline
    pickleshare
    traitlets
    prompt-toolkit
    pygments
    pexpect
    backcall
  ] ++ lib.optionals stdenv.isDarwin [appnope];

  LC_ALL="en_US.UTF-8";

  # full tests normally disabled due to a circular dependency with
  # ipykernel, but we want to test the CVE-2022-21699 fix in this
  # branch
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest IPython/tests/cve.py
  '';

  pythonImportsCheck = [
    "IPython"
  ];

  meta = with lib; {
    description = "IPython: Productive Interactive Computing";
    homepage = "http://ipython.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor fridh ];
  };
}
