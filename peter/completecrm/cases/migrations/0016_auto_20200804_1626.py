# Generated by Django 2.2.10 on 2020-08-04 10:56

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cases', '0015_auto_20200714_1049'),
    ]

    operations = [
        migrations.AlterField(
            model_name='case',
            name='case_type',
            field=models.CharField(blank=True, choices=[('Enquiry', 'Enquiry'), ('Feedback', 'Feedback'), ('Compliments', 'Compliments'), ('Complaints', 'Complaints'), ('Sales', 'Sales'), ('Support', 'Support'), ('Others', 'Others')], default='Enquiry', max_length=255, null=True),
        ),
    ]
