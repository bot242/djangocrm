# Generated by Django 2.2.10 on 2020-04-25 14:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cases', '0007_auto_20200424_1725'),
    ]

    operations = [
        migrations.AlterField(
            model_name='case',
            name='case_type',
            field=models.CharField(blank=True, choices=[('Ambulance Service', 'Ambulance Service'), ('Teleconsult doctor', 'Teleconsult doctor'), ('Pharmacy Service', 'Pharmacy Service'), ('Enquiry', 'Enquiry'), ('Feedback', 'Feedback'), ('Compliments', 'Compliments'), ('Complaints', 'Complaints'), ('Sales', 'Sales'), ('Support', 'Support'), ('Others', 'Others')], default='Ambulance Service', max_length=255, null=True),
        ),
        migrations.AlterField(
            model_name='case',
            name='status',
            field=models.CharField(choices=[('Open', 'Open'), ('In Progress', 'In Progress'), ('Closed', 'Closed')], default='Open', max_length=64),
        ),
        migrations.AlterField(
            model_name='sla',
            name='emailopen_status',
            field=models.CharField(choices=[('Open', 'Open'), ('In Progress', 'In Progress'), ('Closed', 'Closed')], max_length=64),
        ),
        migrations.AlterField(
            model_name='sla',
            name='emailprogress_status',
            field=models.CharField(choices=[('Open', 'Open'), ('In Progress', 'In Progress'), ('Closed', 'Closed')], max_length=64),
        ),
        migrations.AlterField(
            model_name='sla',
            name='voiceopen_status',
            field=models.CharField(choices=[('Open', 'Open'), ('In Progress', 'In Progress'), ('Closed', 'Closed')], max_length=64),
        ),
        migrations.AlterField(
            model_name='sla',
            name='voiceprogress_status',
            field=models.CharField(choices=[('Open', 'Open'), ('In Progress', 'In Progress'), ('Closed', 'Closed')], max_length=64),
        ),
        migrations.AlterField(
            model_name='slaemail',
            name='status',
            field=models.CharField(choices=[('Open', 'Open'), ('In Progress', 'In Progress'), ('Closed', 'Closed')], max_length=64),
        ),
        migrations.AlterField(
            model_name='slavoice',
            name='status',
            field=models.CharField(choices=[('Open', 'Open'), ('In Progress', 'In Progress'), ('Closed', 'Closed')], max_length=64),
        ),
    ]
