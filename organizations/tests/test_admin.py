"""
Organizations Admin Module Test Cases
"""

from unittest.mock import Mock, patch

from django import forms
from django.contrib import admin
from django.contrib.admin.sites import AdminSite
from django.contrib.admin.widgets import AutocompleteSelectMultiple
from django.contrib.messages.storage.fallback import FallbackStorage
from django.test import RequestFactory

from organizations.tests import utils
from organizations.admin import (
    EducationLevelFilter,
    GovernanceTypeFilter,
    OrganizationAdmin,
    OrganizationAdminForm,
    OrganizationCourseAdmin,
    OrganizationTypeFilter,
)
from organizations.models import Organization, OrganizationCourse
from organizations.tests.factories import OrganizationFactory, UserFactory


def create_organization(index, active=True):
    """
    Create an organization.
    """
    Organization.objects.create(
        short_name=f'test_org_{index}',
        name=f'test organization {index}',
        description='test organization description',
        organization_type=Organization.OrganizationType.UNKNOWN,
        education_level=Organization.EducationLevel.UNKNOWN,
        governance_type=Organization.GovernanceType.UNKNOWN,
        active=active
    )


class OrganizationsAdminTestCase(utils.OrganizationsTestCaseBase):
    """
    Test Case module for Organizations Admin
    """

    def setUp(self):
        super().setUp()
        self.org_admin = OrganizationAdmin(Organization, AdminSite())
        self.request = RequestFactory().get('/admin')
        self.admin_user = UserFactory(is_staff=True)
        self.request.session = 'session'
        self.request.user = self.admin_user
        self.request._messages = FallbackStorage(self.request)  # pylint: disable=protected-access

    def test_default_fields(self):
        """
        Test: organization admin should expose all editable organization fields.
        """
        self.assertEqual(
            list(self.org_admin.get_form(self.request).base_fields),
            [
                'name',
                'short_name',
                'description',
                'website_url',
                'logo',
                'city',
                'state',
                'zipcode',
                'organization_type',
                'education_level',
                'governance_type',
                'parent_organization',
                'child_organizations',
                'sites',
                'active',
            ]
        )

    def test_organization_actions(self):
        """
        Test: organization should have its custom actions.
        """
        actions = self.org_admin.get_actions(self.request)
        self.assertIn('activate_selected', actions.keys())
        self.assertIn('deactivate_selected', actions.keys())
        self.assertNotIn('delete_selected', actions.keys())

    def test_classification_fields_are_displayed_and_searchable(self):
        """Organization classifications should be visible and searchable in the changelist."""
        classification_fields = {'organization_type', 'education_level', 'governance_type'}

        self.assertTrue(classification_fields.issubset(self.org_admin.list_display))
        self.assertTrue(classification_fields.issubset(self.org_admin.search_fields))

    def test_parent_organization_is_displayed_and_searchable(self):
        """Parent organizations should be easy to find and assign in the admin."""
        self.assertIn('parent_organization_link', self.org_admin.list_display)
        self.assertEqual(self.org_admin.autocomplete_fields, ('parent_organization',))
        self.assertIn(
            'parent-organization-autocomplete',
            self.org_admin.get_form(self.request).base_fields['parent_organization'].widget.attrs['class'],
        )
        self.assertEqual(
            self.org_admin.get_form(self.request).base_fields['parent_organization'].widget.attrs['style'],
            'width: 50em; max-width: 100%;',
        )
        self.assertEqual(
            self.org_admin.get_form(self.request).base_fields['parent_organization'].widget.attrs['data-width'],
            '50em',
        )
        self.assertIn('parent_organization__name', self.org_admin.search_fields)
        self.assertIn('parent_organization__short_name', self.org_admin.search_fields)
        self.assertNotIn(
            ('parent_organization', admin.RelatedOnlyFieldListFilter),
            self.org_admin.list_filter,
        )

    def test_parent_organization_link_opens_full_change_page(self):
        """The changelist should link a parent to its full Organization change page."""
        parent = OrganizationFactory.create()
        child = OrganizationFactory.create(parent_organization=parent)
        parent_url = f'/admin/organizations/organization/{parent.pk}/change/'

        with patch('organizations.admin.reverse', return_value=parent_url):
            rendered_link = str(self.org_admin.parent_organization_link(child))

        self.assertIn(parent_url, rendered_link)
        self.assertIn(str(parent), rendered_link)
        self.assertEqual(
            str(self.org_admin.parent_organization_link.short_description),
            'District / Parent Organization',
        )
        self.assertEqual(
            self.org_admin.parent_organization_link.admin_order_field,
            'parent_organization__name',
        )

    def test_child_organizations_use_multi_select_autocomplete(self):
        """A parent should assign multiple existing children without inline child forms."""
        parent = OrganizationFactory.create(name='Greenville County Schools', short_name='GreenvilleCS')
        child = OrganizationFactory.create(
            name='Beck Academy',
            short_name='GCSBeckAcademy',
            parent_organization=parent,
        )

        form_class = self.org_admin.get_form(self.request, parent, change=True)
        form = form_class(instance=parent)

        self.assertIs(self.org_admin.form, OrganizationAdminForm)
        self.assertIsInstance(form.fields['child_organizations'].widget, AutocompleteSelectMultiple)
        self.assertIn(
            'child-organizations-autocomplete',
            form.fields['child_organizations'].widget.attrs['class'],
        )
        self.assertEqual(list(form.fields['child_organizations'].initial), [child])
        self.assertIn('child_organization_links', self.org_admin.readonly_fields)

    def test_child_organization_assignments_are_saved(self):
        """Saving the reverse selector should assign and remove child parent IDs."""
        parent = OrganizationFactory.create()
        selected_child = OrganizationFactory.create()
        removed_child = OrganizationFactory.create(parent_organization=parent)
        selected_children = Organization.objects.filter(pk=selected_child.pk)
        form = Mock(
            instance=parent,
            cleaned_data={'child_organizations': selected_children},
        )

        self.org_admin.save_related(self.request, form, (), change=True)

        selected_child.refresh_from_db()
        removed_child.refresh_from_db()
        self.assertEqual(selected_child.parent_organization, parent)
        self.assertIsNone(removed_child.parent_organization)

    def test_child_organization_cannot_select_children(self):
        """The reverse selector should reject children on an organization that has a parent."""
        parent = OrganizationFactory.create()
        child = OrganizationFactory.create(parent_organization=parent)
        proposed_grandchild = OrganizationFactory.create()
        form = OrganizationAdminForm(instance=child)
        self.assertTrue(form.fields['child_organizations'].disabled)
        self.assertIn(
            'already has a parent',
            str(form.fields['child_organizations'].help_text),
        )
        form.cleaned_data = {
            'parent_organization': parent,
            'child_organizations': Organization.objects.filter(pk=proposed_grandchild.pk),
        }

        with self.assertRaises(forms.ValidationError):
            form.clean_child_organizations()

    def test_organizations_with_children_are_excluded_from_child_selector(self):
        """An existing parent should not be available for assignment as a child."""
        existing_parent = OrganizationFactory.create()
        OrganizationFactory.create(parent_organization=existing_parent)
        available_child = OrganizationFactory.create()

        form = OrganizationAdminForm(instance=existing_parent)

        self.assertNotIn(existing_parent, form.fields['child_organizations'].queryset)
        self.assertIn(available_child, form.fields['child_organizations'].queryset)
        self.assertTrue(form.fields['parent_organization'].disabled)
        self.assertIn(
            'already has children',
            str(form.fields['parent_organization'].help_text),
        )

    def test_child_organization_links_open_full_change_pages(self):
        """The form and changelist should link children to their full change pages."""
        parent = OrganizationFactory.create()
        child = OrganizationFactory.create(parent_organization=parent)
        child_url = f'/admin/organizations/organization/{child.pk}/change/'

        with patch('organizations.admin.reverse', return_value=child_url):
            rendered_links = str(self.org_admin.child_organization_links(parent))

        self.assertIn(child_url, rendered_links)
        self.assertIn(str(child), rendered_links)
        self.assertIn('child_organization_links', self.org_admin.list_display)
        self.assertEqual(
            str(self.org_admin.child_organization_links.short_description),
            'Child Organizations',
        )

    def test_changelist_queryset_prefetches_child_organizations(self):
        """The child link column should not cause one query per organization row."""
        queryset = self.org_admin.get_queryset(self.request)

        self.assertIn('child_organizations', queryset._prefetch_related_lookups)  # pylint: disable=protected-access

    def test_classification_fields_are_required_and_allow_unknown(self):
        """Classification fields should be required and offer Unknown as a choice."""
        form = self.org_admin.get_form(self.request)

        for field_name in ('organization_type', 'education_level', 'governance_type'):
            field = form.base_fields[field_name]
            grouped_choices = list(field.choices)
            choices = [
                choice
                for _, group_choices in grouped_choices[1:]
                for choice in group_choices
            ]
            self.assertTrue(field.required)
            self.assertEqual(grouped_choices[0], ('', '---------'))
            self.assertIn(('unknown', 'Unknown'), choices)

    def test_classification_fields_use_model_defined_choice_groups(self):
        """Classification dropdowns should use the ordered groups defined by the model."""
        form = self.org_admin.get_form(self.request)
        expected_groups = {
            'organization_type': Organization.ORGANIZATION_TYPE_GROUPS,
            'education_level': Organization.EDUCATION_LEVEL_GROUPS,
            'governance_type': Organization.GOVERNANCE_TYPE_GROUPS,
        }

        for field_name, groups in expected_groups.items():
            actual_group_labels = [
                str(label)
                for label, _ in list(form.base_fields[field_name].choices)[1:]
            ]
            expected_group_labels = [str(label) for label, _ in groups]
            self.assertEqual(actual_group_labels, expected_group_labels)

    def test_classification_filters_use_model_defined_choice_groups(self):
        """Changelist filters should follow the same groups and ordering as the form."""
        expected_filters = (
            (OrganizationTypeFilter, Organization.ORGANIZATION_TYPE_GROUPS),
            (EducationLevelFilter, Organization.EDUCATION_LEVEL_GROUPS),
            (GovernanceTypeFilter, Organization.GOVERNANCE_TYPE_GROUPS),
        )

        self.assertEqual(self.org_admin.list_filter[1:4], tuple(item[0] for item in expected_filters))

        for filter_class, groups in expected_filters:
            list_filter = filter_class(self.request, {}, Organization, self.org_admin)
            expected_values = [value for _, values in groups for value in values]
            actual_values = [value for value, _ in list_filter.lookup_choices]
            self.assertEqual(actual_values, expected_values)
            self.assertEqual(list_filter.template, 'admin/grouped_choices_filter.html')

    def test_classification_filter_limits_queryset(self):
        """Selecting a grouped filter choice should limit the organization queryset."""
        employer = Organization.objects.create(
            name='Test employer',
            short_name='test_employer',
            organization_type=Organization.OrganizationType.EMPLOYER,
            education_level=Organization.EducationLevel.UNKNOWN,
            governance_type=Organization.GovernanceType.UNKNOWN,
        )
        Organization.objects.create(
            name='Test school',
            short_name='test_school',
            organization_type=Organization.OrganizationType.K12_SCHOOL,
            education_level=Organization.EducationLevel.UNKNOWN,
            governance_type=Organization.GovernanceType.UNKNOWN,
        )
        list_filter = OrganizationTypeFilter(
            self.request,
            {'organization_type': [Organization.OrganizationType.EMPLOYER]},
            Organization,
            self.org_admin,
        )

        results = list_filter.queryset(self.request, Organization.objects.all())

        self.assertEqual(list(results), [employer])

    def test_classification_display_labels_are_searchable(self):
        """Search should recognize the human-readable classification labels shown in admin."""
        organization = Organization.objects.create(
            name='Test technical center',
            short_name='test_technical_center',
            organization_type=Organization.OrganizationType.CAREER_TECHNICAL_CENTER,
            education_level=Organization.EducationLevel.SECONDARY_ADULT,
            governance_type=Organization.GovernanceType.PUBLIC,
        )

        results, _ = self.org_admin.get_search_results(
            self.request,
            Organization.objects.all(),
            str(Organization.OrganizationType.CAREER_TECHNICAL_CENTER.label),
        )

        self.assertEqual(list(results), [organization])

    def test_deactivate_selected_should_deactivate_active_organizations(self):
        """
        Test: action deactivate_selected should deactivate an activated organization.
        """
        create_organization(1, active=True)
        queryset = Organization.objects.filter(pk=1)
        self.org_admin.deactivate_selected(self.request, queryset)
        self.assertFalse(Organization.objects.get(pk=1).active)

    def test_deactivate_selected_should_deactivate_multiple_active_organizations(self):
        """
        Test: action deactivate_selected should deactivate the multiple activated organization.
        """
        for i in range(2):
            create_organization(i, active=True)
        queryset = Organization.objects.all()
        self.org_admin.deactivate_selected(self.request, queryset)
        self.assertFalse(Organization.objects.get(pk=1).active)
        self.assertFalse(Organization.objects.get(pk=2).active)

    def test_activate_selected_should_activate_deactivated_organizations(self):
        """
        Test: action activate_selected should activate an deactivated organization.
        """
        create_organization(1, active=False)
        queryset = Organization.objects.filter(pk=1)
        self.org_admin.activate_selected(self.request, queryset)
        self.assertTrue(Organization.objects.get(pk=1).active)

    def test_activate_selected_should_activate_multiple_deactivated_organizations(self):
        """
        Test: action activate_selected should activate the multiple deactivated organization.
        """
        for i in range(2):
            create_organization(i, active=True)
        queryset = Organization.objects.all()
        self.org_admin.activate_selected(self.request, queryset)
        self.assertTrue(Organization.objects.get(pk=1).active)
        self.assertTrue(Organization.objects.get(pk=2).active)


class OrganizationCourseAdminTestCase(utils.OrganizationsTestCaseBase):
    """
    Test Case module for Organization Course Admin
    """

    def setUp(self):
        super().setUp()
        self.request = RequestFactory().get('')
        self.org_course_admin = OrganizationCourseAdmin(OrganizationCourse, AdminSite())

    def test_foreign_key_field_active_choices(self):
        """
        Test: organization course foreignkey widget has active organization choices.
        """
        create_organization(1, active=True)
        self.assertEqual(
            list(self.org_course_admin.get_form(self.request).base_fields['organization'].widget.choices),
            [('', '---------'), (1, 'test organization 1 (test_org_1)')]
        )

    def test_foreign_key_field_inactive_choices(self):
        """
        Test: organization course foreignkey widget has not inactive organization choices.
        """
        create_organization(1, active=False)
        self.assertEqual(
            list(self.org_course_admin.get_form(self.request).base_fields['organization'].widget.choices),
            [('', '---------')]
        )
