# Generated by Django 2.2.4 on 2020-08-24 07:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('opportunity', '0012_auto_20200818_1459'),
    ]

    operations = [
        migrations.CreateModel(
            name='Stages',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('stages', models.CharField(blank=True, max_length=255, null=True)),
                ('probability', models.CharField(blank=True, max_length=255, null=True)),
            ],
        ),
    ]
