# Generated by Django 2.2.10 on 2020-06-05 06:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cases', '0011_case_parent_description'),
    ]

    operations = [
        migrations.AlterField(
            model_name='case',
            name='parent_description',
            field=models.TextField(blank=True, default='', max_length=255, null=True),
        ),
    ]
