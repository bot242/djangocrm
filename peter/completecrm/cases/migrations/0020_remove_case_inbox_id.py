# Generated by Django 2.2.10 on 2020-08-12 12:57

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('cases', '0019_case_inbox_id'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='case',
            name='inbox_id',
        ),
    ]
