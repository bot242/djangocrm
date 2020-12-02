# Generated by Django 2.1.7 on 2019-03-07 12:20

from django.conf import settings
import django.core.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('marketing', '0002_auto_20190307_1227'),
    ]

    operations = [
        migrations.CreateModel(
            name='FailedContact',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_on', models.DateTimeField(auto_now_add=True)),
                ('name', models.CharField(blank=True, max_length=500, null=True)),
                ('email', models.EmailField(blank=True, max_length=254, null=True)),
                ('contact_number', models.CharField(blank=True, max_length=20, null=True, validators=[django.core.validators.RegexValidator(message="Phone number must be entered in the format: '+999999999'. Up to 20 digits allowed.", regex='^\\+?1?\\d{9,15}$')])),
                ('company_name', models.CharField(blank=True, max_length=500, null=True)),
                ('last_name', models.CharField(blank=True, max_length=500, null=True)),
                ('city', models.CharField(blank=True, max_length=500, null=True)),
                ('state', models.CharField(blank=True, max_length=500, null=True)),
                ('contry', models.CharField(blank=True, max_length=500, null=True)),
                ('contact_list', models.ManyToManyField(related_name='failed_contacts', to='marketing.ContactList')),
                ('created_by', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='marketing_failed_contacts_created_by', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
