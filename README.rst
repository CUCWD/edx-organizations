edx-organizations |Build Status| |Coverage Status|
==================================================

edx-organizations (``organizations``) is a Django application
responsible for managing the concept of Organizations in the Open edX
platform. Organizations represent the entities responsible for creating
and publishing Courses. In the future the scope and responsibilty of the
Organization may evolve to include other aspects, such as related
learners.

.. |Build Status| image:: https://github.com/openedx/edx-organizations/workflows/Python%20CI/badge.svg?branch=master
   :target: https://github.com/openedx/edx-organizations/actions?query=workflow%3A%22Python+CI%22
.. |Coverage Status| image:: https://coveralls.io/repos/github/edx/edx-organizations/badge.svg?branch=master
   :target: https://coveralls.io/github/edx/edx-organizations?branch=master

Usage
-----
Organizations is designed to centralize metadata about course publishers, such as their title, logo URL,
and information included in certificates.

Local Development
-----------------

.. code-block:: bash

    $ make requirements
    $ make test
    $ make quality

CI runs on ``ubuntu-latest`` with Python 3.12, Django 4.2 compatibility tests,
Ulmo Django 5.2 tests, quality checks, and documentation/package validation.
Run the same checks locally in an isolated Python 3.12 environment::

    python -m pip install "tox>=4,<5"
    tox

``requirements/ulmo-test.in`` uses the test-only ``ulmo-constraints.txt``
snapshot of shared runtime dependencies from the platform. Refresh that snapshot
when the target platform requirements change. These constraints are never used
in the plugin's runtime package metadata.

Run only the Ulmo suite with ``tox -e py312-django52``, or only legacy
compatibility tests with ``tox -e py312-django42``.

Open edX Platform Integration
-----------------------------

Ulmo owns the versions of shared dependencies. Both ``requirements/base.in``
and ``requirements/base.txt`` declare runtime dependencies without exact pins;
the package metadata reads ``base.in`` without development constraints.
Setuptools is a build dependency, not a runtime dependency of this application.

Provision the environment using the target platform's requirements first. To
install this fork into that environment without changing shared dependencies,
run from this repository::

    python -m pip install --no-deps .

Use ``--no-deps -e .`` instead for editable development in a provisioned platform
environment. This assumes all runtime dependencies are already installed.

The fork's package version is managed separately from Ulmo's upstream
``edx-organizations`` pin. Account for that replacement in deployment
configuration; do not install both versions.

``requirements/constraints.txt``, ``requirements/common_constraints.txt``,
``test-requirements.txt``, and ``make requirements`` are for isolated development
and testing. They contain legacy pins and must not be installed into the platform
environment. ``make upgrade`` preserves the unpinned runtime requirements.

How to Contribute
-----------------
Contributions are very welcome, but please note that edx-organizations is currently an early stage
work-in-progress and is changing frequently at this time.

See our `CONTRIBUTING`_ file for more information – it also contains guidelines for how to
maintain high code quality, which will make your contribution more likely to be accepted.

.. _CONTRIBUTING: https://github.com/openedx/.github/blob/master/CONTRIBUTING.md

Reporting Security Issues
-------------------------
Please do not report security issues in public. Please email security@openedx.org.

Mailing List and IRC Channel
----------------------------

You can discuss this code on the `edx-code Google Group`_ or in the
``edx-code`` IRC channel on Freenode.

.. _edx-code Google Group: https://groups.google.com/forum/#!forum/edx-code
