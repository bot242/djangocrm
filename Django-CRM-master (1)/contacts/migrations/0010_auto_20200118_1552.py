# Generated by Django 2.2.4 on 2020-01-18 10:22

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contacts', '0009_contact_alternate_phone'),
    ]

    operations = [
        migrations.RenameField(
            model_name='contact',
            old_name='alternate_phone',
            new_name='phone1',
        ),
        migrations.RenameField(
            model_name='contact',
            old_name='phone',
            new_name='phone2',
        ),
    ]
