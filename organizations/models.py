"""
Database ORM models managed by this Django app
Please do not integrate directly with these models!!!  This app currently
offers one programmatic API -- api.py for direct Python integration.
"""

import re
from django.core.exceptions import ValidationError
from django.db import models
from django.core.validators import RegexValidator
from django.utils.translation import gettext_lazy as _
from model_utils.models import TimeStampedModel
from simple_history.models import HistoricalRecords


US_STATE_CHOICES = (
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

ZIPCODE_VALIDATOR = RegexValidator(
    regex=r'^(\d{5}([\-]\d{4})?)$',
    message='Must be a valid zipcode',
)


class Organization(TimeStampedModel):
    """
    An Organization is a representation of an entity which publishes/provides
    one or more courses delivered by the LMS. Organizations have a base set of
    metadata describing the organization, including id, name, and description.
    """

    class OrganizationType(models.TextChoices):
        """
        Broad classification of organizations using the platform.

        This application taxonomy is adapted from organization categories used by:

        * The U.S. Department of Education's NCES Common Core of Data (CCD),
          including schools, districts, education service agencies, vocational
          schools, special education schools, and alternative schools:
          https://nces.ed.gov/statprog/handbook/ccd_keyconcepts.asp
        * The U.S. Department of Labor's Apprenticeship.gov Partner Finder,
          including employers, educators, workforce development boards,
          intermediaries, associations, labor-management organizations, and
          community-based organizations:
          https://www.apprenticeship.gov/partner-finder

        These choices intentionally consolidate specialized federal categories into
        broader application categories and are not verbatim federal codes.
        """

        # Schools and education agencies
        K12_SCHOOL = 'k12_school', _('K-12 School')
        SCHOOL_DISTRICT = 'school_district', _('School District or Education Agency')
        CAREER_TECHNICAL_EDUCATION = 'career_technical_education', _('Career & Technical Education Center')
        HOMESCHOOL = 'homeschool', _('Homeschool')

        # Postsecondary, training, and workforce
        COLLEGE_UNIVERSITY = 'college_university', _('College or University')
        TRAINING_PROVIDER = 'training_provider', _('Training or Adult Education Provider')
        WORKFORCE_AGENCY = 'workforce_agency', _('Workforce Development Organization')

        # Organizations and institutions
        EDUCATION_NONPROFIT = 'education_nonprofit', _('Education or Community Organization')
        EDUCATION_TECHNOLOGY = 'education_technology', _('Education Technology Provider')
        EMPLOYER = 'employer', _('Employer or Industry Organization')
        GOVERNMENT_AGENCY = 'government_agency', _('Government Agency')

        # Administrative and fallback
        INTERNAL_PROGRAM = 'internal_program', _('Internal Program')
        OTHER = 'other', _('Other')
        UNKNOWN = 'unknown', _('Unknown')

    class EducationLevel(models.TextChoices):
        """
        Learner level served by an educational organization.

        Grade-level categories are adapted from the U.S. Department of Education's
        NCES classifications for elementary, secondary, combined, and postsecondary
        instruction:

        * https://nces.ed.gov/pubs2015/fin_acct/chapter6_8.asp
        * https://nces.ed.gov/statprog/handbook/pss_keyconcepts.asp
        * https://nces.ed.gov/ipeds/use-the-data/institutional-groupings-in-ipeds

        Workforce, continuing-education, all-level, and not-applicable values extend
        those categories for the organizations represented by this application.
        """

        # Early and elementary education
        EARLY_CHILDHOOD = 'early_childhood', _('Early Childhood')
        ELEMENTARY_SCHOOL = 'elementary_school', _('Elementary School')
        ELEMENTARY_MIDDLE = 'elementary_middle', _('Elementary and Middle School')
        MIDDLE_SCHOOL = 'middle_school', _('Middle School')

        # Secondary and combined education
        HIGH_SCHOOL = 'high_school', _('High School')
        SECONDARY = 'secondary', _('Secondary School')
        K12 = 'k12', _('K-12')
        SECONDARY_ADULT = 'secondary_adult', _('Secondary and Adult Workforce')

        # Postsecondary and workforce education
        POSTSECONDARY_NONDEGREE = 'postsecondary_nondegree', _('Postsecondary Non-Degree')
        POSTSECONDARY = 'postsecondary', _('Postsecondary')
        ADULT_WORKFORCE = 'adult_workforce', _('Adult Workforce')
        CONTINUING_EDUCATION = 'continuing_education', _('Continuing Education')

        # Broad applicability and fallback
        ALL_LEVELS = 'all_levels', _('Multiple or All Education Levels')
        NOT_APPLICABLE = 'not_applicable', _('Not Applicable')
        UNKNOWN = 'unknown', _('Unknown')

    class GovernanceType(models.TextChoices):
        """
        Ownership or governance classification for an organization.

        The public, private nonprofit, and private for-profit distinctions follow
        the U.S. Department of Education's NCES IPEDS institutional-control model:
        https://nces.ed.gov/ipeds/use-the-data/institutional-groupings-in-ipeds

        Government-level, tribal, cooperative, labor-management, and internal
        choices extend that model for non-postsecondary organizations represented
        by this application. Existing general values are retained for compatibility.
        """

        # Public and government control
        PUBLIC = 'public', _('Public')
        PUBLIC_CHARTER = 'public_charter', _('Public Charter')
        FEDERAL_GOVERNMENT = 'federal_government', _('Federal Government')
        STATE_GOVERNMENT = 'state_government', _('State Government')
        LOCAL_GOVERNMENT = 'local_government', _('Local Government')
        TRIBAL_GOVERNMENT = 'tribal_government', _('Tribal Government')
        GOVERNMENT = 'government', _('Government Agency')

        # Private control
        PRIVATE_NONPROFIT = 'private_nonprofit', _('Private Nonprofit')
        PRIVATE_FOR_PROFIT = 'private_for_profit', _('Private For-Profit')
        PRIVATE = 'private', _('Private')

        # Other organization models
        NONPROFIT = 'nonprofit', _('Nonprofit')
        COOPERATIVE = 'cooperative', _('Cooperative')
        LABOR_MANAGEMENT = 'labor_management', _('Labor-Management Partnership')

        # Administrative and fallback
        INTERNAL = 'internal', _('Internal')
        UNKNOWN = 'unknown', _('Unknown')

    ORGANIZATION_TYPE_GROUPS = (
        (_('Schools and education agencies'), (
            OrganizationType.K12_SCHOOL,
            OrganizationType.SCHOOL_DISTRICT,
            OrganizationType.CAREER_TECHNICAL_EDUCATION,
            OrganizationType.HOMESCHOOL,
        )),
        (_('Postsecondary, training, and workforce'), (
            OrganizationType.COLLEGE_UNIVERSITY,
            OrganizationType.TRAINING_PROVIDER,
            OrganizationType.WORKFORCE_AGENCY,
        )),
        (_('Organizations and institutions'), (
            OrganizationType.EDUCATION_NONPROFIT,
            OrganizationType.EDUCATION_TECHNOLOGY,
            OrganizationType.EMPLOYER,
            OrganizationType.GOVERNMENT_AGENCY,
        )),
        (_('Administrative and fallback'), (
            OrganizationType.INTERNAL_PROGRAM,
            OrganizationType.OTHER,
            OrganizationType.UNKNOWN,
        )),
    )

    EDUCATION_LEVEL_GROUPS = (
        (_('Early and elementary education'), (
            EducationLevel.EARLY_CHILDHOOD,
            EducationLevel.ELEMENTARY_SCHOOL,
            EducationLevel.ELEMENTARY_MIDDLE,
            EducationLevel.MIDDLE_SCHOOL,
        )),
        (_('Secondary and combined education'), (
            EducationLevel.HIGH_SCHOOL,
            EducationLevel.SECONDARY,
            EducationLevel.K12,
            EducationLevel.SECONDARY_ADULT,
        )),
        (_('Postsecondary and workforce education'), (
            EducationLevel.POSTSECONDARY_NONDEGREE,
            EducationLevel.POSTSECONDARY,
            EducationLevel.ADULT_WORKFORCE,
            EducationLevel.CONTINUING_EDUCATION,
        )),
        (_('Broad applicability and fallback'), (
            EducationLevel.ALL_LEVELS,
            EducationLevel.NOT_APPLICABLE,
            EducationLevel.UNKNOWN,
        )),
    )

    GOVERNANCE_TYPE_GROUPS = (
        (_('Public and government control'), (
            GovernanceType.PUBLIC,
            GovernanceType.PUBLIC_CHARTER,
            GovernanceType.FEDERAL_GOVERNMENT,
            GovernanceType.STATE_GOVERNMENT,
            GovernanceType.LOCAL_GOVERNMENT,
            GovernanceType.TRIBAL_GOVERNMENT,
            GovernanceType.GOVERNMENT,
        )),
        (_('Private control'), (
            GovernanceType.PRIVATE_NONPROFIT,
            GovernanceType.PRIVATE_FOR_PROFIT,
            GovernanceType.PRIVATE,
        )),
        (_('Other organization models'), (
            GovernanceType.NONPROFIT,
            GovernanceType.COOPERATIVE,
            GovernanceType.LABOR_MANAGEMENT,
        )),
        (_('Administrative and fallback'), (
            GovernanceType.INTERNAL,
            GovernanceType.UNKNOWN,
        )),
    )

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
    website_url = models.URLField(max_length=500, blank=True, default='', verbose_name='Website URL')
    logo = models.ImageField(
        upload_to='organization_logos',
        help_text=_('Please add only .PNG files for logo images. This logo will be used on certificates.'),
        null=True, blank=True, max_length=255
    )

    STATE_CHOICES = US_STATE_CHOICES

    city = models.CharField(max_length=255, null=True, blank=False)
    state = models.CharField(
        verbose_name="State",
        blank=False, null=True, max_length=2, db_index=True,
        choices=STATE_CHOICES
    )

    zipcode = models.CharField(
        verbose_name="Zip Code",
        max_length=10,
        null=True,
        blank=False,
        validators=[ZIPCODE_VALIDATOR]
    )

    organization_type = models.CharField(
        verbose_name='Organization Type',
        max_length=32,
        choices=OrganizationType.choices,
        db_index=True,
    )
    education_level = models.CharField(
        verbose_name='Education Level',
        max_length=32,
        choices=EducationLevel.choices,
        db_index=True,
    )
    governance_type = models.CharField(
        verbose_name='Governance Type',
        max_length=32,
        choices=GovernanceType.choices,
        db_index=True,
    )

    parent_organizations = models.ManyToManyField(
        'self',
        verbose_name='District / Parent Organizations',
        related_name='child_organizations',
        symmetrical=False,
        blank=True,
        help_text=_(
            'Optional districts or parent organizations. Create them as organizations before assigning them.'
        ),
    )

    active = models.BooleanField(default=True)

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
        if self.pk is not None:
            if self.parent_organizations.filter(pk=self.pk).exists():  # pylint: disable=no-member
                raise ValidationError({'parent_organizations': _('An organization cannot be its own parent.')})
            if (  # pylint: disable=no-member
                self.parent_organizations.exists() and self.child_organizations.exists()
            ):
                raise ValidationError({
                    'parent_organizations': _('An organization with child organizations cannot have parents.')
                })
            if self.parent_organizations.filter(  # pylint: disable=no-member
                parent_organizations__isnull=False
            ).exists():
                raise ValidationError({
                    'parent_organizations': _('A child organization cannot be selected as a parent organization.')
                })


class OrganizationCourse(TimeStampedModel):
    """
    An OrganizationCourse represents the link between an Organization and a
    Course (via course key). Because Courses are not true Open edX entities
    (in the Django/ORM sense) the modeling and integrity is limited to that
    of specifying course identifier strings in this model.
    """
    course_id = models.CharField(max_length=255, db_index=True, verbose_name='Course ID')
    organization = models.ForeignKey(Organization, db_index=True, on_delete=models.CASCADE)
    active = models.BooleanField(default=True)

    history = HistoricalRecords()

    class Meta:
        """ Meta class for this Django model """
        unique_together = (('course_id', 'organization'),)
        verbose_name = _('Link Course')
        verbose_name_plural = _('Link Courses')
