# Generated by Django 2.2.10 on 2020-06-22 10:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('opportunity', '0007_updated_viewlog_ud_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='opportunity',
            name='update_date',
            field=models.DateTimeField(blank=True, null=True),
        ),
    ]
