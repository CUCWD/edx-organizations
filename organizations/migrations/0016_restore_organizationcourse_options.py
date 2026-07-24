from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("organizations", "0015_merge_sumac_and_v6_13"),
    ]

    operations = [
        migrations.AlterModelOptions(
            name="organizationcourse",
            options={
                "verbose_name": "Link Course",
                "verbose_name_plural": "Link Courses",
            },
        ),
    ]
