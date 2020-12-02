# Generated by Django 2.1.7 on 2019-03-15 09:13

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('marketing', '0003_failedcontact'),
    ]

    operations = [
        migrations.AlterField(
            model_name='contact',
            name='contact_number',
            field=models.CharField(blank=True, max_length=20, null=True, validators=[django.core.validators.RegexValidator(message="Phone number must be entered in the format: '+999999999'.         Up to 20 digits allowed.", regex='^\\+?1?\\d{9,15}$')]),
        ),
        migrations.AlterField(
            model_name='failedcontact',
            name='contact_number',
            field=models.CharField(blank=True, max_length=20, null=True, validators=[django.core.validators.RegexValidator(message="Phone number must be entered in the format: '+999999999'.        Up to 20 digits allowed.", regex='^\\+?1?\\d{9,15}$')]),
        ),
    ]
