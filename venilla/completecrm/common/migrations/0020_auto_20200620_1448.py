# Generated by Django 2.2.10 on 2020-06-20 09:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('common', '0019_user_currency_settings'),
    ]

    operations = [
        migrations.CreateModel(
            name='Currency',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('currency_settings', models.CharField(blank=True, max_length=150)),
            ],
        ),
        migrations.RemoveField(
            model_name='user',
            name='currency_settings',
        ),
    ]