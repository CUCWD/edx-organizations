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
        fields = ('id', 'created', 'modified', 'name', 'short_name', 'description', 'logo',
                  'city', 'state', 'zipcode', 'active', 'logo_url',)

    def update_logo(self, obj, logo_url):
        if logo_url:  # pragma: no cover
            logo = requests.get(logo_url)  # pylint: disable=missing-timeout
            obj.logo.save(logo_url.split('/')[-1], ContentFile(logo.content))

    def create(self, validated_data):
        logo_url = validated_data.pop('logo_url', None)
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
        'logo': organization.logo,
        'city': organization.city,
        'state': organization.state,
        'zipcode': organization.zipcode,
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
        'logo': organization_course.organization.logo,
        'city': organization_course.organization.city,
        'state': organization_course.organization.state,
        'zipcode': organization_course.organization.zipcode,
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
    return models.Organization(
        id=organization_dict.get('id'),
        name=organization_dict.get('name', ''),
        short_name=organization_dict.get('short_name', ''),
        description=organization_dict.get('description', ''),
        logo=organization_dict.get('logo', ''),
        city=organization_dict.get('city', ''),
        state=organization_dict.get('state', ''),
        zipcode=organization_dict.get('zipcode', ''),
        active=organization_dict.get('active', True)
    )
