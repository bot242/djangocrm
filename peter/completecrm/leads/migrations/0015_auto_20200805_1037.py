# Generated by Django 2.2.10 on 2020-08-05 05:07

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('leads', '0014_auto_20200805_1036'),
    ]

    operations = [
        migrations.AlterField(
            model_name='lead',
            name='account_name',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]
