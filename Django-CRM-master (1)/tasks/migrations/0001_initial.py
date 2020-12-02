# Generated by Django 2.1.7 on 2019-05-07 10:38

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('accounts', '0007_email'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('contacts', '0003_merge_20190214_1427'),
    ]

    operations = [
        migrations.CreateModel(
            name='Task',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=200, verbose_name='title')),
                ('status', models.CharField(choices=[('New', 'New'), ('In Progress', 'In Progress'), ('Completed', 'Completed')], max_length=50, verbose_name='status')),
                ('priority', models.CharField(choices=[('Low', 'Low'), ('Medium', 'Medium'), ('High', 'High')], max_length=50, verbose_name='priority')),
                ('due_date', models.DateField(blank=True, null=True)),
                ('account', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='accounts_tasks', to='accounts.Account')),
                ('assigned_to', models.ManyToManyField(related_name='users_tasks', to=settings.AUTH_USER_MODEL)),
                ('contacts', models.ManyToManyField(related_name='contacts_tasks', to='contacts.Contact')),
            ],
            options={
                'ordering': ['-due_date'],
            },
        ),
    ]
