# Generated by Django 2.2.10 on 2020-06-22 11:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('opportunity', '0008_auto_20200622_1610'),
    ]

    operations = [
        migrations.AlterField(
            model_name='opportunity',
            name='update_date',
            field=models.DateTimeField(auto_now_add=True, null=True),
        ),
    ]