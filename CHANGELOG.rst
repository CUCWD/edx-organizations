Change Log
##########

Unreleased
**********

6.14.4 - 2026-11-02
*******************

Changed
========

* Defer shared runtime dependency versions to the host Ulmo edx-platform environment and preserve unpinned runtime requirements during regeneration.
* Keep legacy development constraints and setuptools out of runtime requirements; retain setuptools only where needed for testing.
* Document installation into a provisioned platform environment without changing its shared dependencies.
* Run CI and publishing on ``ubuntu-latest`` with Python 3.12.
* Test Django 4.2 compatibility and Ulmo Django 5.2 using separate dependency environments, with a test-only snapshot of Ulmo's shared dependency versions.
* Upload coverage from the Django 5.2 job and add documentation and package validation alongside quality checks.
* Update tox defaults, publishing actions, and local testing instructions.

Fixed
=====

* Return no course links for unsaved organizations instead of passing an unsaved model instance to a related filter, which Django 5.2 rejects.
* Set explicit UTC timezone settings for consistent serializer tests across Django versions.
* Exclude build artifacts from test discovery to avoid duplicate collection.
* Remove an unused import from migration tests.
