# Generated by Django 2.2.10 on 2020-06-27 12:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contacts', '0010_auto_20200627_1615'),
    ]

    operations = [
        migrations.AlterField(
            model_name='contact',
            name='phone2',
            field=models.CharField(max_length=11, null=True, unique=True),
        ),
    ]
