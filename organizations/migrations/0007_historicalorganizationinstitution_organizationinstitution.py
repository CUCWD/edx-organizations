# Generated by Django 3.2.13 on 2022-10-05 19:44

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import model_utils.fields
import simple_history.models


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('organizations', '0006_userorganizationmapping_is_amc_admin'),
    ]

    operations = [
        migrations.CreateModel(
            name='OrganizationInstitution',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created', model_utils.fields.AutoCreatedField(default=django.utils.timezone.now, editable=False, verbose_name='created')),
                ('modified', model_utils.fields.AutoLastModifiedField(default=django.utils.timezone.now, editable=False, verbose_name='modified')),
                ('name', models.CharField(db_index=True, max_length=255)),
                ('short_name', models.CharField(help_text='Unique, short string identifier for organization institution. Please do not use spaces or special characters. Only allowed special characters are period (.), hyphen (-) and underscore (_).', max_length=255, unique=True, verbose_name='Short Name')),
                ('description', models.TextField(blank=True, null=True)),
                ('logo', models.ImageField(blank=True, help_text='Please add only .PNG files for logo images. This logo will be used on certificates.', max_length=255, null=True, upload_to='organization_institution_logos')),
                ('active', models.BooleanField(default=True)),
                ('organizations', models.ManyToManyField(related_name='organizations', to='organizations.Organization')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='HistoricalOrganizationInstitution',
            fields=[
                ('id', models.IntegerField(auto_created=True, blank=True, db_index=True, verbose_name='ID')),
                ('created', model_utils.fields.AutoCreatedField(default=django.utils.timezone.now, editable=False, verbose_name='created')),
                ('modified', model_utils.fields.AutoLastModifiedField(default=django.utils.timezone.now, editable=False, verbose_name='modified')),
                ('name', models.CharField(db_index=True, max_length=255)),
                ('short_name', models.CharField(db_index=True, help_text='Unique, short string identifier for organization institution. Please do not use spaces or special characters. Only allowed special characters are period (.), hyphen (-) and underscore (_).', max_length=255, verbose_name='Short Name')),
                ('description', models.TextField(blank=True, null=True)),
                ('logo', models.TextField(blank=True, help_text='Please add only .PNG files for logo images. This logo will be used on certificates.', max_length=255, null=True)),
                ('active', models.BooleanField(default=True)),
                ('history_id', models.AutoField(primary_key=True, serialize=False)),
                ('history_date', models.DateTimeField()),
                ('history_change_reason', models.CharField(max_length=100, null=True)),
                ('history_type', models.CharField(choices=[('+', 'Created'), ('~', 'Changed'), ('-', 'Deleted')], max_length=1)),
                ('history_user', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name': 'historical organization institution',
                'ordering': ('-history_date', '-history_id'),
                'get_latest_by': 'history_date',
            },
            bases=(simple_history.models.HistoricalChanges, models.Model),
        ),
    ]
