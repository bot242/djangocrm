# Generated by Django 2.2 on 2020-01-13 11:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contacts', '0005_auto_20200113_0956'),
    ]

    operations = [
        migrations.AlterField(
            model_name='contact',
            name='created_on',
            field=models.DateField(auto_now_add=True, verbose_name='Created on'),
        ),
    ]
