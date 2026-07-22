"""
Tests for Organization Model.
"""

import ddt
from django.core.exceptions import ValidationError
from django.test import TestCase
from organizations.models import Organization
from organizations.tests.factories import OrganizationFactory


@ddt.ddt
class TestOrganizationModel(TestCase):
    """ OrganizationModel tests. """
    def setUp(self):
        super().setUp()
        self.organization = OrganizationFactory.create()

    @ddt.data(
        [" ", ",", "@", "(", "!", "#", "$", "%", "^", "&", "*", "+", "=", "{", "[", "ó"]
    )
    def test_clean_error(self, invalid_char_list):
        """
        Verify that the clean method raises validation error if org short name
        consists of special characters or spaces.
        """
        for char in invalid_char_list:
            self.organization.short_name = f'shortname{char}'
            self.assertRaises(ValidationError, self.organization.clean)

    @ddt.data(
        ["shortnamewithoutspace", "shortName123", "short_name", "short-name", "short.name"]
    )
    def test_clean_success(self, valid_short_name_list):
        """
        Verify that the clean method returns None if org short name is valid
        """
        for valid_short_name in valid_short_name_list:
            self.organization.short_name = valid_short_name
            self.assertEqual(self.organization.clean(), None)

    def test_classifications_are_required_without_defaults(self):
        """Classification fields should require an explicit value and have no model default."""
        for field_name in ('organization_type', 'education_level', 'governance_type'):
            field = Organization._meta.get_field(field_name)  # pylint: disable=protected-access
            self.assertFalse(field.null)
            self.assertFalse(field.blank)
            self.assertFalse(field.has_default())

    def test_parent_organization_relationship(self):
        """An organization can reference another organization as its parent."""
        parent = OrganizationFactory.create(
            name='Greenville County Schools',
            short_name='GreenvilleCS',
            organization_type=Organization.OrganizationType.SCHOOL_DISTRICT,
            education_level=Organization.EducationLevel.K12,
            governance_type=Organization.GovernanceType.PUBLIC,
        )
        child = OrganizationFactory.create(parent_organization=parent)

        self.assertEqual(child.parent_organization, parent)
        self.assertEqual(list(parent.child_organizations.all()), [child])

    def test_organization_cannot_be_its_own_parent(self):
        """An organization cannot directly reference itself as its parent."""
        self.organization.parent_organization = self.organization

        with self.assertRaises(ValidationError) as exception:
            self.organization.clean()

        self.assertIn('parent_organization', exception.exception.message_dict)

    def test_child_organization_cannot_be_a_parent(self):
        """An organization hierarchy cannot extend beyond parent and child."""
        parent = OrganizationFactory.create()
        child = OrganizationFactory.create(parent_organization=parent)
        grandchild = OrganizationFactory.build(parent_organization=child)

        with self.assertRaises(ValidationError) as exception:
            grandchild.clean()

        self.assertIn('parent_organization', exception.exception.message_dict)

    def test_parent_with_children_cannot_become_a_child(self):
        """An existing parent cannot itself be assigned beneath another organization."""
        new_parent = OrganizationFactory.create()
        existing_parent = OrganizationFactory.create()
        OrganizationFactory.create(parent_organization=existing_parent)
        existing_parent.parent_organization = new_parent

        with self.assertRaises(ValidationError) as exception:
            existing_parent.clean()

        self.assertIn('parent_organization', exception.exception.message_dict)

    def test_organization_website_url_field(self):
        """Organizations use a dedicated validated URL field."""
        field = Organization._meta.get_field('website_url')  # pylint: disable=protected-access
        self.assertEqual(field.max_length, 500)
        self.assertTrue(field.blank)
        self.assertEqual(field.default, '')

    def test_classification_choices_cover_common_us_organizations(self):
        """Taxonomies should cover common U.S. education and workforce organizations."""
        organization_types = set(Organization.OrganizationType.values)
        education_levels = set(Organization.EducationLevel.values)
        governance_types = set(Organization.GovernanceType.values)

        self.assertEqual(organization_types, {
            'k12_school',
            'school_district',
            'career_technical_center',
            'homeschool',
            'college_university',
            'training_provider',
            'workforce_agency',
            'education_nonprofit',
            'education_technology',
            'employer',
            'government_agency',
            'internal_program',
            'other',
            'unknown',
        })
        self.assertTrue({
            'early_childhood',
            'elementary_school',
            'middle_school',
            'high_school',
            'elementary_middle',
            'secondary',
            'k12',
            'secondary_adult',
            'postsecondary_nondegree',
            'postsecondary',
            'adult_workforce',
            'continuing_education',
            'all_levels',
            'not_applicable',
            'unknown',
        }.issubset(education_levels))
        self.assertTrue({
            'public',
            'public_charter',
            'private_nonprofit',
            'private_for_profit',
            'federal_government',
            'state_government',
            'local_government',
            'tribal_government',
            'cooperative',
            'labor_management',
            'unknown',
        }.issubset(governance_types))

    def test_classification_groups_follow_model_choice_order(self):
        """Each choice should appear once in the same order used by its groups."""
        classifications = (
            (Organization.OrganizationType, Organization.ORGANIZATION_TYPE_GROUPS),
            (Organization.EducationLevel, Organization.EDUCATION_LEVEL_GROUPS),
            (Organization.GovernanceType, Organization.GOVERNANCE_TYPE_GROUPS),
        )

        for choice_class, groups in classifications:
            grouped_values = [value for _, values in groups for value in values]
            self.assertEqual(grouped_values, list(choice_class.values))
