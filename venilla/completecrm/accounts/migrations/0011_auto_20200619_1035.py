# Generated by Django 2.2.10 on 2020-06-19 05:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0010_account_teams'),
    ]

    operations = [
        migrations.AlterField(
            model_name='account',
            name='phone',
            field=models.CharField(max_length=10, null=True, unique=True),
        ),
    ]
