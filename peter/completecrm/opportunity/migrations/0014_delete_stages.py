# Generated by Django 2.2.4 on 2020-08-24 08:28

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('opportunity', '0013_stages'),
    ]

    operations = [
        migrations.DeleteModel(
            name='Stages',
        ),
    ]