""" Django admin pages for organization models """
from django import forms
from django.contrib import admin, messages
from django.contrib.admin.widgets import AutocompleteSelectMultiple
from django.db.models import Q
from django.urls import reverse
from django.utils.html import format_html_join
from django.utils.translation import gettext_lazy as _

from organizations.models import Organization, OrganizationCourse


class OrganizationAdminForm(forms.ModelForm):
    """Organization form with a reverse-relationship child selector."""

    child_organizations = forms.ModelMultipleChoiceField(
        label=_('Child Organizations'),
        queryset=Organization.objects.all(),
        required=False,
        help_text=_(
            'Select unassigned organizations to make them children of this organization. '
            'Use the links below to edit each child in its full Organization page.'
        ),
    )

    class Meta:
        model = Organization
        fields = '__all__'

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        available_children = Organization.objects.filter(child_organizations__isnull=True)

        if self.instance.pk:
            has_children = self.instance.child_organizations.exists()
            has_parents = self.instance.parent_organizations.exists()
            available_children = available_children.exclude(pk=self.instance.pk)
            self.fields['child_organizations'].initial = self.instance.child_organizations.all()

            if has_children and 'parent_organizations' in self.fields:
                self.fields['parent_organizations'].disabled = True
                self.fields['parent_organizations'].help_text = _(
                    'Parent organizations cannot be assigned because this organization already has children.'
                )

            if has_parents:
                self.fields['child_organizations'].disabled = True
                self.fields['child_organizations'].help_text = _(
                    'Child organizations cannot be assigned because this organization already has parents.'
                )

        if 'parent_organizations' in self.fields:
            available_parents = Organization.objects.filter(parent_organizations__isnull=True)
            if self.instance.pk:
                available_parents = available_parents.exclude(pk=self.instance.pk)
            self.fields['parent_organizations'].queryset = available_parents.distinct().order_by('name', 'short_name')

        self.fields['child_organizations'].queryset = available_children.distinct().order_by('name', 'short_name')

    def clean_parent_organizations(self):
        """Prevent self-reference and selecting child organizations as parents."""
        parent_organizations = self.cleaned_data['parent_organizations']

        if self.instance.pk and parent_organizations.filter(pk=self.instance.pk).exists():
            raise forms.ValidationError(_('An organization cannot be its own parent.'))

        if parent_organizations.filter(parent_organizations__isnull=False).exists():
            raise forms.ValidationError(_('A child organization cannot be selected as a parent organization.'))

        if self.instance.pk and self.instance.child_organizations.exists() and parent_organizations.exists():
            raise forms.ValidationError(_('An organization with child organizations cannot have parents.'))

        return parent_organizations

    def clean_child_organizations(self):
        """Prevent cycles and organization hierarchies deeper than one level."""
        child_organizations = self.cleaned_data['child_organizations']
        parent_organizations = self.cleaned_data.get('parent_organizations')

        if parent_organizations is not None and parent_organizations.exists() and child_organizations.exists():
            raise forms.ValidationError(_(
                'A child organization cannot have its own child organizations.'
            ))

        if child_organizations.filter(child_organizations__isnull=False).exists():
            raise forms.ValidationError(_(
                'An organization that already has children cannot be selected as a child organization.'
            ))

        return child_organizations


class ActivateDeactivateAdminMixin:
    """
    Provides the activate_selected and deactivate_select bulk actions.

    Hides the delete_selected actions; we'd much rows are deactivated than
    deleted.
    """

    HISTORY_DISCLAIMER = _(
        "Please note: as a bulk action, this will not be reflected in the model's history table."
    )

    def get_actions(self, request):
        """ Return set of Django admin actions, removing the delete action """
        actions = super().get_actions(request)

        # Remove the delete action.
        if 'delete_selected' in actions:  # pragma: no cover
            del actions['delete_selected']

        return actions

    @admin.action(
        description=_('Activate selected entries')
    )
    def activate_selected(self, request, queryset):
        """ Activate the selected entries. """
        count = queryset.count()
        queryset.update(active=True)
        model_name = self.__class__.__name__

        if count == 1:
            message = _('1 {model_name} entry was successfully activated.')
        else:
            message = _('{count} {model_name} entries were successfully activated.')
        message = message.format(count=count, model_name=model_name)  # pylint: disable=no-member
        self.message_user(request, message)
        self.message_user(request, self.HISTORY_DISCLAIMER, level=messages.WARNING)

    @admin.action(
        description=_('Deactivate selected entries')
    )
    def deactivate_selected(self, request, queryset):
        """ Deactivate the selected entries. """
        count = queryset.count()
        queryset.update(active=False)
        model_name = self.__class__.__name__

        if count == 1:
            message = _('1 {model_name} entry was successfully deactivated.')
        else:
            message = _('{count} {model_name} entries were successfully deactivated.')
        message = message.format(count=count, model_name=model_name)  # pylint: disable=no-member
        self.message_user(request, message)
        self.message_user(request, self.HISTORY_DISCLAIMER, level=messages.WARNING)


class GroupedClassificationFilter(admin.SimpleListFilter):
    """Base admin filter that renders model-defined classification groups."""

    template = 'admin/grouped_choices_filter.html'
    choice_class = Organization.OrganizationType
    groups = ()

    def selected_value(self):
        """Return one selected value across Django parameter container formats."""
        selected_value = self.value()
        if isinstance(selected_value, (list, tuple)):
            return selected_value[-1]
        return selected_value

    def lookups(self, request, model_admin):
        """Return every choice in model-defined group order."""
        return (
            (value, self.choice_class(value).label)
            for _, values in self.groups
            for value in values
        )

    def queryset(self, request, queryset):
        """Filter by the selected stored choice value."""
        selected_value = self.selected_value()
        if selected_value is None:
            return queryset

        return queryset.filter(**{self.parameter_name: selected_value})

    def choices(self, changelist):
        """Add non-selectable group headings around the standard filter links."""
        yield {
            'selected': self.selected_value() is None,
            'query_string': changelist.get_query_string(remove=[self.parameter_name]),
            'display': _('All'),
        }

        for group_label, values in self.groups:
            yield {
                'is_group': True,
                'display': group_label,
            }
            for value in values:
                yield {
                    'selected': self.selected_value() == value,
                    'query_string': changelist.get_query_string({self.parameter_name: value}),
                    'display': self.choice_class(value).label,
                }


class OrganizationTypeFilter(GroupedClassificationFilter):
    """Grouped organization-type changelist filter."""

    title = _('organization type')
    parameter_name = 'organization_type'
    choice_class = Organization.OrganizationType
    groups = Organization.ORGANIZATION_TYPE_GROUPS


class EducationLevelFilter(GroupedClassificationFilter):
    """Grouped education-level changelist filter."""

    title = _('education level')
    parameter_name = 'education_level'
    choice_class = Organization.EducationLevel
    groups = Organization.EDUCATION_LEVEL_GROUPS


class GovernanceTypeFilter(GroupedClassificationFilter):
    """Grouped governance-type changelist filter."""

    title = _('governance type')
    parameter_name = 'governance_type'
    choice_class = Organization.GovernanceType
    groups = Organization.GOVERNANCE_TYPE_GROUPS


@admin.register(Organization)
class OrganizationAdmin(ActivateDeactivateAdminMixin, admin.ModelAdmin):
    """ Admin for the Organization model. """

    class Media:
        css = {'all': ('organizations/css/admin.css',)}

    actions = ['activate_selected', 'deactivate_selected']
    form = OrganizationAdminForm
    fields = (
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
        'parent_organizations',
        'child_organizations',
        'child_organization_links',
        'sites',
        'active',
        'created',
    )
    list_display = (
        'name',
        'short_name',
        'organization_type',
        'education_level',
        'governance_type',
        'parent_organization_links',
        'child_organization_links',
        'logo',
        'active',
    )
    list_filter = (
        'active',
        OrganizationTypeFilter,
        EducationLevelFilter,
        GovernanceTypeFilter,
    )
    ordering = ('name', 'short_name',)
    autocomplete_fields = ('parent_organizations',)
    readonly_fields = ('child_organization_links', 'created')
    search_fields = (
        'name',
        'short_name',
        'organization_type',
        'education_level',
        'governance_type',
        'parent_organizations__name',
        'parent_organizations__short_name',
    )

    def get_form(self, request, obj=None, change=False, **kwargs):
        """Configure the parent and reverse-child organization autocomplete widgets."""
        form = super().get_form(request, obj, change, **kwargs)
        if 'parent_organizations' in form.base_fields:
            parent_widget = form.base_fields['parent_organizations'].widget
            parent_widget.attrs['class'] = ' '.join(filter(None, (
                parent_widget.attrs.get('class'),
                'parent-organization-autocomplete',
            )))
            # Select2 derives its rendered width from the original select's inline width.
            parent_widget.attrs['style'] = 'width: 50em; max-width: 100%;'
            # Explicitly pass the width to Select2 so opening the dropdown cannot
            # recalculate it from Django's narrow related-widget wrapper.
            parent_widget.attrs['data-width'] = '50em'
        if 'child_organizations' in form.base_fields:
            form.base_fields['child_organizations'].widget = AutocompleteSelectMultiple(
                Organization._meta.get_field('parent_organizations'),  # pylint: disable=protected-access
                self.admin_site,
                attrs={'class': 'child-organizations-autocomplete'},
            )
        return form

    @admin.display(description=_('District / Parent Organizations'))
    def parent_organization_links(self, organization):
        """Link each parent organization to its full Organization change page."""
        parents = sorted(
            organization.parent_organizations.all(),
            key=lambda parent: (parent.name, parent.short_name),
        )
        if not parents:
            return _('None')

        return format_html_join(
            '',
            '<div><a href="{}">{}</a></div>',
            (
                (reverse('admin:organizations_organization_change', args=(parent.pk,)), parent)
                for parent in parents
            ),
        )

    @admin.display(description=_('Child Organizations'))
    def child_organization_links(self, organization):
        """Link to each child's full Organization change page."""
        if organization is None or organization.pk is None:
            return _('None')

        children = sorted(
            organization.child_organizations.all(),
            key=lambda child: (child.name, child.short_name),
        )
        if not children:
            return _('None')

        return format_html_join(
            '',
            '<div><a href="{}">{}</a></div>',
            (
                (reverse('admin:organizations_organization_change', args=(child.pk,)), child)
                for child in children
            ),
        )

    def get_queryset(self, request):
        """Load child organizations efficiently for the changelist link column."""
        return super().get_queryset(request).prefetch_related('parent_organizations', 'child_organizations')

    def save_related(self, request, form, formsets, change):
        """Persist assignments made through the reverse child selector."""
        super().save_related(request, form, formsets, change)
        if 'child_organizations' not in form.cleaned_data:
            return

        organization = form.instance
        selected_ids = set(form.cleaned_data['child_organizations'].values_list('id', flat=True))

        for child in organization.child_organizations.exclude(pk__in=selected_ids):
            child.parent_organizations.remove(organization)

        for child in Organization.objects.filter(pk__in=selected_ids).exclude(parent_organizations=organization):
            child.parent_organizations.add(organization)
            child.clean()

    def formfield_for_choice_field(self, db_field, request, **kwargs):
        """Render classification choices in the ordered groups defined by the model."""
        formfield = super().formfield_for_choice_field(db_field, request, **kwargs)
        grouped_fields = {
            'organization_type': (Organization.OrganizationType, Organization.ORGANIZATION_TYPE_GROUPS),
            'education_level': (Organization.EducationLevel, Organization.EDUCATION_LEVEL_GROUPS),
            'governance_type': (Organization.GovernanceType, Organization.GOVERNANCE_TYPE_GROUPS),
        }

        if db_field.name in grouped_fields:
            choice_class, groups = grouped_fields[db_field.name]
            grouped_choices = tuple(
                (
                    group_label,
                    tuple((value, choice_class(value).label) for value in values),
                )
                for group_label, values in groups
            )
            formfield.choices = (('', _('---------')),) + grouped_choices

        return formfield

    def get_search_results(self, request, queryset, search_term):
        """Search classification fields by both stored values and displayed labels."""
        search_results, may_have_duplicates = super().get_search_results(request, queryset, search_term)
        classification_query = Q()
        normalized_search_term = search_term.casefold()

        for field_name, choices in (
            ('organization_type', Organization.OrganizationType.choices),
            ('education_level', Organization.EducationLevel.choices),
            ('governance_type', Organization.GovernanceType.choices),
        ):
            matching_values = [
                value for value, label in choices
                if normalized_search_term in str(label).casefold()
            ]
            if matching_values:
                classification_query |= Q(**{f'{field_name}__in': matching_values})

        if classification_query:
            search_results |= queryset.filter(classification_query)

        return search_results, may_have_duplicates


@admin.register(OrganizationCourse)
class OrganizationCourseAdmin(ActivateDeactivateAdminMixin, admin.ModelAdmin):
    """ Admin for the OrganizationCourse model. """
    actions = ['activate_selected', 'deactivate_selected']
    list_display = ('course_id', 'organization', 'active')
    list_filter = ('active',)
    ordering = ('course_id', 'organization__name',)
    search_fields = ('course_id', 'organization__name', 'organization__short_name',)

    def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
        # Only display active Organizations.
        if db_field.name == 'organization':  # pragma: no branch
            kwargs['queryset'] = Organization.objects.filter(active=True).order_by('name')

        return super().formfield_for_foreignkey(db_field, request, **kwargs)
