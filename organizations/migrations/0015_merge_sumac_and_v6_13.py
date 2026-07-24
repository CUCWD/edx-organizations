from django.db import migrations


class Migration(migrations.Migration):
    """Join the deployed CUCWD Sumac history with the upstream v6.13 history."""

    dependencies = [
        (
            "organizations",
            "0014_remove_historicalorganizationinstitutioncourse_history_user_and_more",
        ),
        ("organizations", "0004_auto_20230727_2054"),
    ]

    operations = []
