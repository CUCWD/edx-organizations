Change Log
----------

..
   All enhancements and patches to edx-organizations will be documented
   in this file.  It adheres to the structure of https://keepachangelog.com/ ,
   but in reStructuredText instead of Markdown (for ease of incorporation into
   Sphinx documentation and the PyPI description).

   This project adheres to Semantic Versioning (https://semver.org/).
.. There should always be an "Unreleased" section for changes pending release.


Unreleased
~~~~~~~~~~

[v7.3.0.0+skilredi] - 2026-11-05
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Identify the SkilRedi distribution with a distinct local version.
* Defer runtime dependency versions to the host Open edX platform and align
  development and Django 5.2 test dependencies with Ulmo constraints.
* Update CI to test Python 3.11 and 3.12 on ubuntu-latest, retaining Django 4.2
  compatibility checks alongside Ulmo tests.
* Return an empty course list for unsaved organizations to avoid invalid related
  queries under Django 5.2.


[v6.14.4] - 2026-11-02
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Defer shared runtime dependency versions to the host Ulmo edx-platform
  environment and preserve unpinned runtime requirements during regeneration.
* Keep legacy development constraints and setuptools out of runtime
  requirements; retain setuptools only where needed for testing.
* Document installation into a provisioned platform environment without
  changing its shared dependencies.
* Run CI and publishing on ``ubuntu-latest`` with Python 3.12.
* Test Django 4.2 compatibility and Ulmo Django 5.2 using separate dependency
  environments, with a test-only snapshot of Ulmo's shared dependency versions.
* Upload coverage from the Django 5.2 job and add documentation and package
  validation alongside quality checks.
* Update tox defaults, publishing actions, and local testing instructions.
* Return no course links for unsaved organizations instead of passing an unsaved
  model instance to a related filter, which Django 5.2 rejects.
* Set explicit UTC timezone settings for consistent serializer tests across
  Django versions.
* Exclude build artifacts from test discovery to avoid duplicate collection.
* Remove an unused import from migration tests.


[v7.3.0] - 2025-08-28
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Updated django-simple-history to 3.10.1


[v7.2.1] - 2025-05-27
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Added
_____

* Updated django-simple-history to 3.8.0


[v7.2.0] - 2025-05-13
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Added
_____

* Added support for django 5.2


[v7.0.0] - 2024-09-23
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Added
_____

* Added the changelog file

Removed
_____

* Dropped support for python 3.8


[v6.13.0] - 2024-04-02
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Previous history can be found in github https://github.com/openedx/edx-organizations/tags
