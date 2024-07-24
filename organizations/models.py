"""
Database ORM models managed by this Django app
Please do not integrate directly with these models!!!  This app currently
offers one programmatic API -- api.py for direct Python integration.
"""

import re
from django.core.exceptions import ValidationError
from django.db import models
from django.conf import settings
from django.core.validators import RegexValidator
from django.utils.translation import ugettext_lazy as _
from model_utils.models import TimeStampedModel
from simple_history.models import HistoricalRecords


class Organization(TimeStampedModel):
    """
    An Organization is a representation of an entity which publishes/provides
    one or more courses delivered by the LMS. Organizations have a base set of
    metadata describing the organization, including id, name, and description.
    """
    name = models.CharField(max_length=255, db_index=True)
    short_name = models.CharField(
        max_length=255,
        unique=True,
        verbose_name='Short Name',
        help_text=_(
            'Unique, short string identifier for organization. '
            'Please do not use spaces or special characters. '
            'Only allowed special characters are period (.), hyphen (-) and underscore (_).'
        ),
    )
    description = models.TextField(null=True, blank=True)
    logo = models.ImageField(
        upload_to='organization_logos',
        help_text=_('Please add only .PNG files for logo images. This logo will be used on certificates.'),
        null=True, blank=True, max_length=255
    )
    active = models.BooleanField(default=True)
    users = models.ManyToManyField(
        settings.AUTH_USER_MODEL,
        through='UserOrganizationMapping',
        related_name="organizations"
    )
    sites = models.ManyToManyField(
        'sites.Site',
        related_name='organizations',
    )

    history = HistoricalRecords()

    def __str__(self):
        return f"{self.name} ({self.short_name})"

    def clean(self):
        if not re.match("^[a-zA-Z0-9._-]*$", self.short_name):
            raise ValidationError(_('Please do not use spaces or special characters in the short name '
                                    'field. Only allowed special characters are period (.), hyphen (-) '
                                    'and underscore (_).'))


class OrganizationInstitution(TimeStampedModel):
    """
    An OrganizationInstitution represents linking of an organization to a school or academy.
    Some organizations may be schools, however, this represents a further breakdown of schools
    underneath a larger umbrella (e.g. Choose Aerospace).
    """
    name = models.CharField(max_length=255, db_index=True)
    short_name = models.CharField(
        max_length=255,
        unique=True,
        verbose_name='Short Name',
        help_text=_(
            'Unique, short string identifier for organization institution. '
            'Please do not use spaces or special characters. '
            'Only allowed special characters are period (.), hyphen (-) and underscore (_).'
        ),
    )
    description = models.TextField(null=True, blank=True)
    logo = models.ImageField(
        upload_to='organization_institution_logos',
        help_text=_('Please add only .PNG files for logo images. This logo will be used on certificates.'),
        null=True, blank=True, max_length=255
    )


    zipcode = models.CharField(
        verbose_name="Zip Code",
        max_length=10,
        null=True,
        blank=True,
        validators=[RegexValidator(
            regex=r'^(\d{5}([\-]\d{4})?)$',
            message=u'Must be a valid zipcode'
        )]
    )

    STATE_CHOICES = (
        ('AL', 'Alabama'),
        ('AK', 'Alaska'),
        ('AZ', 'Arizona'),
        ('AR', 'Arkansas'),
        ('AA', 'Armed Forces Americas'),
        ('AE', 'Armed Forces Europe'),
        ('AP', 'Armed Forces Pacific'),
        ('CA', 'California'),
        ('CO', 'Colorado'),
        ('CT', 'Connecticut'),
        ('DE', 'Delaware'),
        ('DC', 'District Of Columbia'),
        ('FL', 'Florida'),
        ('GA', 'Georgia'),
        ('HI', 'Hawaii'),
        ('ID', 'Idaho'),
        ('IL', 'Illinois'),
        ('IN', 'Indiana'),
        ('IA', 'Iowa'),
        ('KS', 'Kansas'),
        ('KY', 'Kentucky'),
        ('LA', 'Louisiana'),
        ('ME', 'Maine'),
        ('MD', 'Maryland'),
        ('MA', 'Massachusetts'),
        ('MI', 'Michigan'),
        ('MN', 'Minnesota'),
        ('MS', 'Mississippi'),
        ('MO', 'Missouri'),
        ('MT', 'Montana'),
        ('NE', 'Nebraska'),
        ('NV', 'Nevada'),
        ('NH', 'New Hampshire'),
        ('NJ', 'New Jersey'),
        ('NM', 'New Mexico'),
        ('NY', 'New York'),
        ('NC', 'North Carolina'),
        ('ND', 'North Dakota'),
        ('OH', 'Ohio'),
        ('OK', 'Oklahoma'),
        ('OR', 'Oregon'),
        ('PA', 'Pennsylvania'),
        ('RI', 'Rhode Island'),
        ('SC', 'South Carolina'),
        ('SD', 'South Dakota'),
        ('TN', 'Tennessee'),
        ('TX', 'Texas'),
        ('UT', 'Utah'),
        ('VT', 'Vermont'),
        ('VA', 'Virginia'),
        ('WA', 'Washington'),
        ('WV', 'West Virginia'),
        ('WI', 'Wisconsin'),
        ('WY', 'Wyoming'),
    )

    city = models.CharField(max_length=255, null=True, blank=True)
    state = models.CharField(
        verbose_name="State",
        blank=True, null=True, max_length=2, db_index=True,
        choices=STATE_CHOICES
    )


    active = models.BooleanField(default=True)
    organizations = models.ManyToManyField(
        'organizations.Organization',
        related_name='organizations',
    )

    history = HistoricalRecords()

    def __str__(self):
        return f"{self.name} ({self.short_name})"

    def clean(self):
        if not re.match("^[a-zA-Z0-9._-]*$", self.short_name):
            raise ValidationError(_('Please do not use spaces or special characters in the short name '
                                    'field. Only allowed special characters are period (.), hyphen (-) '
                                    'and underscore (_).'))


class OrganizationCourse(TimeStampedModel):
    """
    An OrganizationCourse represents the link between an Organization and a
    Course (via course key). Because Courses are not true Open edX entities
    (in the Django/ORM sense) the modeling and integrity is limited to that
    of specifying course identifier strings in this model.
    """
    course_id = models.CharField(max_length=255, db_index=True, verbose_name='Course ID')
    organization = models.ForeignKey(Organization, db_index=True, on_delete=models.CASCADE)
    # organization_institution = models.ForeignKey(OrganizationInstitution, db_index=True, on_delete=models.CASCADE)
    active = models.BooleanField(default=True)

    history = HistoricalRecords()

    class Meta:
        """ Meta class for this Django model """
        unique_together = (('course_id', 'organization'),)
        verbose_name = _('Link Course')
        verbose_name_plural = _('Link Courses')


class OrganizationInstitutionCourse(TimeStampedModel):
    """
    An OrganizationInstitutionCourse represents the link between an OrganizationInstitution and a
    Course (via course key). Because Courses are not true Open edX entities
    (in the Django/ORM sense) the modeling and integrity is limited to that
    of specifying course identifier strings in this model.
    """
    course_id = models.CharField(max_length=255, db_index=True, verbose_name='Course ID')
    organization = models.ForeignKey(Organization, db_index=True, on_delete=models.CASCADE)
    # organization_institution = models.ForeignKey(OrganizationInstitution, db_index=True, on_delete=models.CASCADE)
    active = models.BooleanField(default=True)

    history = HistoricalRecords()

    class Meta:
        """ Meta class for this Django model """
        unique_together = (('course_id', 'organization'),)
        verbose_name = _('Link Course')
        verbose_name_plural = _('Link Courses')


class UserOrganizationMapping(models.Model):
    """
    Map a user to an organization. This is more about access control for the Figures frontend site.
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL, db_index=True, on_delete=models.CASCADE)
    organization = models.ForeignKey(Organization, db_index=True, on_delete=models.CASCADE)
    is_active = models.BooleanField(default=False)
    is_amc_admin = models.BooleanField(default=False)
    


