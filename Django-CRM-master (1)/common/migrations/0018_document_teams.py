# Generated by Django 2.2.4 on 2019-09-17 05:46

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('teams', '0003_auto_20190909_1621'),
        ('common', '0017_auto_20190722_1443'),
    ]

    operations = [
        migrations.AddField(
            model_name='document',
            name='teams',
            field=models.ManyToManyField(related_name='document_teams', to='teams.Teams'),
        ),
    ]
