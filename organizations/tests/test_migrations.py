"""
Tests for migrations, especially potentially risky data migrations.
"""
import importlib
from io import StringIO

from django.apps import apps
from django.core.management import call_command
from django.test.testcases import TestCase
from django.test.utils import override_settings

from organizations.models import Organization
from organizations.tests.factories import OrganizationFactory


class MigrationTests(TestCase):
    """
    Runs migration tests using Django Command interface.
    """

    @override_settings(MIGRATION_MODULES={})
    def test_migrations_are_in_sync(self):
        out = StringIO()
        call_command("makemigrations", dry_run=True, verbosity=3, stdout=out)
        output = out.getvalue()
        self.assertIn("No changes detected", output)

    def test_career_technical_organization_type_data_migration(self):
        """The renamed type should migrate both current and historical rows reversibly."""
        migration = importlib.import_module(
            "organizations.migrations.0020_rename_career_technical_education"
        )
        organization = OrganizationFactory.create(
            organization_type=migration.OLD_ORGANIZATION_TYPE,
        )
        historical_organization = apps.get_model("organizations", "HistoricalOrganization")

        self.assertTrue(
            historical_organization.objects.filter(
                id=organization.id,
                organization_type=migration.OLD_ORGANIZATION_TYPE,
            ).exists()
        )

        migration.rename_career_technical_organization_type(apps, None)

        organization.refresh_from_db()
        self.assertEqual(organization.organization_type, migration.NEW_ORGANIZATION_TYPE)
        self.assertFalse(
            historical_organization.objects.filter(
                id=organization.id,
                organization_type=migration.OLD_ORGANIZATION_TYPE,
            ).exists()
        )
        self.assertTrue(
            historical_organization.objects.filter(
                id=organization.id,
                organization_type=migration.NEW_ORGANIZATION_TYPE,
            ).exists()
        )

        migration.restore_career_technical_organization_type(apps, None)

        organization.refresh_from_db()
        self.assertEqual(organization.organization_type, migration.OLD_ORGANIZATION_TYPE)
        self.assertTrue(
            historical_organization.objects.filter(
                id=organization.id,
                organization_type=migration.OLD_ORGANIZATION_TYPE,
            ).exists()
        )
