# Generated by Django 2.1.5 on 2019-01-29 08:02

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('cases', '0002_auto_20190128_1237'),
        ('common', '0003_document'),
    ]

    operations = [
        migrations.AddField(
            model_name='attachments',
            name='case',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='case_attachment', to='cases.Case'),
        ),
    ]
