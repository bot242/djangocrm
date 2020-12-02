# Generated by Django 2.2.10 on 2020-04-25 14:15

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('planner', '0005_auto_20200425_1436'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='content_type',
            field=models.ForeignKey(blank=True, choices=[(10, 'Account'), (13, 'Lead'), (14, 'Opportunity'), (11, 'Case')], limit_choices_to=models.Q(models.Q(('app_label', 'account'), ('id', 10), ('model', 'Account')), models.Q(('app_label', 'leads'), ('id', 13), ('model', 'Lead')), models.Q(('app_label', 'opportunity'), ('id', 14), ('model', 'Opportunity')), models.Q(('app_label', 'cases'), ('id', 11), ('model', 'Case')), _connector='OR'), null=True, on_delete=django.db.models.deletion.CASCADE, to='contenttypes.ContentType'),
        ),
    ]
