# Generated by Django 2.2.10 on 2020-06-23 10:17

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('opportunity', '0009_auto_20200622_1706'),
    ]

    operations = [
        migrations.AddField(
            model_name='updated_viewlog',
            name='up_date',
            field=models.DateTimeField(auto_now_add=True, null=True),
        ),
    ]
