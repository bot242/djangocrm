# Generated by Django 2.2.4 on 2020-11-30 07:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cases', '0021_notification'),
    ]

    operations = [
        migrations.AlterField(
            model_name='case',
            name='status',
            field=models.CharField(default='new_case', max_length=255),
        ),
    ]