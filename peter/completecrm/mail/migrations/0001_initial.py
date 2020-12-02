# Generated by Django 2.2.2 on 2020-08-06 07:17

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Inbox',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('subject_inbox', models.TextField()),
                ('description', models.TextField()),
                ('username', models.CharField(max_length=50, null=True)),
                ('from_address', models.EmailField(max_length=50)),
                ('to_address', models.EmailField(max_length=50)),
                ('status', models.CharField(default=0, max_length=10, null=True)),
                ('created_datetime', models.DateTimeField(default=django.utils.timezone.now)),
            ],
            options={
                'db_table': 'inbox',
            },
        ),
        migrations.CreateModel(
            name='Subjectmatch',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('subject', models.TextField()),
                ('description', models.TextField()),
            ],
            options={
                'db_table': 'subjectmatch',
            },
        ),
    ]