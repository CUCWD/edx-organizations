"""
Tests for Organizations API serializers.
"""


from django.test import TestCase
from rest_framework.settings import api_settings

from organizations.models import Organization
from organizations.serializers import OrganizationSerializer, deserialize_organization
from organizations.tests.factories import OrganizationFactory


class TestOrganizationSerializer(TestCase):
    """ OrganizationSerializer tests."""
    def setUp(self):
        super().setUp()
        self.organization = OrganizationFactory.create()

    def test_data(self):
        """ Verify that OrganizationSerializer serialize data correctly."""
        serialize_data = OrganizationSerializer(self.organization)
        expected = {
            "id": self.organization.id,
            "name": self.organization.name,
            "short_name": self.organization.short_name,
            "description": self.organization.description,
            "website_url": self.organization.website_url,
            "logo": None,
            "city": self.organization.city,
            "state": self.organization.state,
            "zipcode": self.organization.zipcode,
            "organization_type": self.organization.organization_type,
            "education_level": self.organization.education_level,
            "governance_type": self.organization.governance_type,
            "parent_organizations": [],
            "active": self.organization.active,
            "created": self.organization.created.strftime(api_settings.DATETIME_FORMAT),
            "modified": self.organization.modified.strftime(api_settings.DATETIME_FORMAT)
        }
        self.assertEqual(serialize_data.data, expected)

    def test_deserialize_missing_classifications_defaults_to_unknown(self):
        """Deserialization should never create null classification values."""
        organization = deserialize_organization({
            'name': 'New organization',
            'short_name': 'new_organization',
        })

        self.assertEqual(organization.organization_type, Organization.OrganizationType.UNKNOWN)
        self.assertEqual(organization.education_level, Organization.EducationLevel.UNKNOWN)
        self.assertEqual(organization.governance_type, Organization.GovernanceType.UNKNOWN)

    def test_website_url_is_deserialized(self):
        """The data-layer serializer should retain the dedicated website URL."""
        organization = deserialize_organization({
            'name': 'New organization',
            'short_name': 'new_organization',
            'website_url': 'https://example.org/',
        })

        self.assertEqual(organization.website_url, 'https://example.org/')

    def test_parent_organizations_are_serialized_as_ids(self):
        """The API should use each parent organization's stable database identifier."""
        parents = OrganizationFactory.create_batch(2)
        child = OrganizationFactory.create(parent_organizations=parents)

        self.assertEqual(
            set(OrganizationSerializer(child).data['parent_organizations']),
            {parent.id for parent in parents},
        )

        deserialized = deserialize_organization({
            'name': 'Child organization',
            'short_name': 'child_organization',
            'parent_organizations': [parent.id for parent in parents],
        })
        self.assertEqual(
            deserialized._parent_organization_ids,  # pylint: disable=protected-access
            [parent.id for parent in parents],
        )
