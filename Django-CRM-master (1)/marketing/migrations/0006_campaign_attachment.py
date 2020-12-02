# Generated by Django 2.1.7 on 2019-03-19 10:29

from django.db import migrations, models
import marketing.models


class Migration(migrations.Migration):

    dependencies = [
        ('marketing', '0005_campaign_timezone'),
    ]

    operations = [
        migrations.AddField(
            model_name='campaign',
            name='attachment',
            field=models.FileField(blank=True, max_length=1000, null=True, upload_to=marketing.models.get_campaign_attachment_path),
        ),
    ]
