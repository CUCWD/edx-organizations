"""
Data layer serialization operations.  Converts querysets to simple
python containers (mainly arrays and dicts).
"""
import requests

from django.core.files.base import ContentFile
from rest_framework import serializers

from organizations import models


class OrganizationSerializer(serializers.ModelSerializer):
    """ Serializes the Organization object."""
    logo_url = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = models.Organization
        fields = ('id', 'created', 'modified', 'name', 'short_name', 'description', 'website_url', 'logo',
                  'city', 'state', 'zipcode', 'organization_type', 'education_level',
                  'governance_type', 'parent_organizations', 'active', 'logo_url',)
        extra_kwargs = {
            'organization_type': {'required': False},
            'education_level': {'required': False},
            'governance_type': {'required': False},
        }

    def update_logo(self, obj, logo_url):
        if logo_url:  # pragma: no cover
            logo = requests.get(logo_url)  # pylint: disable=missing-timeout
            obj.logo.save(logo_url.split('/')[-1], ContentFile(logo.content))

    def create(self, validated_data):
        logo_url = validated_data.pop('logo_url', None)
        validated_data.setdefault('organization_type', models.Organization.OrganizationType.UNKNOWN)
        validated_data.setdefault('education_level', models.Organization.EducationLevel.UNKNOWN)
        validated_data.setdefault('governance_type', models.Organization.GovernanceType.UNKNOWN)
        obj = super().create(validated_data)
        self.update_logo(obj, logo_url)
        return obj

    def update(self, instance, validated_data):
        logo_url = validated_data.pop('logo_url', None)
        super().update(instance, validated_data)
        self.update_logo(instance, logo_url)
        return instance


def serialize_organization(organization):
    """
    Organization object-to-dict serialization
    """
    return {
        'id': organization.id,
        'name': organization.name,
        'short_name': organization.short_name,
        'description': organization.description,
        'website_url': organization.website_url,
        'logo': organization.logo,
        'city': organization.city,
        'state': organization.state,
        'zipcode': organization.zipcode,
        'organization_type': organization.organization_type,
        'education_level': organization.education_level,
        'governance_type': organization.governance_type,
        'parent_organizations': _parent_organization_ids(organization),
        'active': organization.active
    }


def serialize_organization_with_course(organization_course):
    """
    OrganizationCourse serialization (composite object)
    """
    return {
        'id': organization_course.organization.id,
        'name': organization_course.organization.name,
        'short_name': organization_course.organization.short_name,
        'description': organization_course.organization.description,
        'website_url': organization_course.organization.website_url,
        'logo': organization_course.organization.logo,
        'city': organization_course.organization.city,
        'state': organization_course.organization.state,
        'zipcode': organization_course.organization.zipcode,
        'organization_type': organization_course.organization.organization_type,
        'education_level': organization_course.organization.education_level,
        'governance_type': organization_course.organization.governance_type,
        'parent_organizations': _parent_organization_ids(organization_course.organization),
        'active': organization_course.organization.active,
        'course_id': organization_course.course_id
    }


def serialize_organizations(organizations):
    """
    Organization serialization
    Converts list of objects to list of dicts
    """
    return [serialize_organization(organization) for organization in organizations]


def deserialize_organization(organization_dict):
    """
    Organization dict-to-object serialization
    """
    organization = models.Organization(
        id=organization_dict.get('id'),
        name=organization_dict.get('name', ''),
        short_name=organization_dict.get('short_name', ''),
        description=organization_dict.get('description', ''),
        website_url=organization_dict.get('website_url', ''),
        logo=organization_dict.get('logo', ''),
        city=organization_dict.get('city', ''),
        state=organization_dict.get('state', ''),
        zipcode=organization_dict.get('zipcode', ''),
        organization_type=(
            organization_dict.get('organization_type') or models.Organization.OrganizationType.UNKNOWN
        ),
        education_level=(
            organization_dict.get('education_level') or models.Organization.EducationLevel.UNKNOWN
        ),
        governance_type=(
            organization_dict.get('governance_type') or models.Organization.GovernanceType.UNKNOWN
        ),
        active=organization_dict.get('active', True)
    )
    parent_organization_ids = organization_dict.get('parent_organizations')
    if parent_organization_ids is None:
        legacy_parent_id = organization_dict.get('parent_organization_id') or organization_dict.get(
            'parent_organization'
        )
        parent_organization_ids = [legacy_parent_id] if legacy_parent_id else []
    organization._parent_organization_ids = list(parent_organization_ids)  # pylint: disable=protected-access
    return organization


def _parent_organization_ids(organization):
    """Return persisted or pending parent IDs for data-layer serialization."""
    pending_ids = getattr(organization, '_parent_organization_ids', None)
    if pending_ids is not None:
        return pending_ids
    if organization.pk is None:
        return []
    prefetched_parents = getattr(organization, '_prefetched_objects_cache', {}).get('parent_organizations')
    if prefetched_parents is not None:
        return [parent.id for parent in prefetched_parents]
    return list(organization.parent_organizations.values_list('id', flat=True))
