import arrow
from django.db import models
from django.utils.translation import pgettext_lazy
from django.utils.translation import ugettext_lazy as _
from django.contrib.contenttypes.models import ContentType
from accounts.models import Account
from contacts.models import Contact
from common.models import User
from common.utils import CASE_TYPE, PRIORITY_CHOICE, STATUS_CHOICE
from planner.models import Event
from teams.models import Teams
import datetime
from django.core.validators import RegexValidator


class SlaVoice(models.Model):
    status = models.CharField(choices=STATUS_CHOICE, max_length=64)
    respond_within= models.TimeField(blank=True, null=True,default="00:00")
    escalate_to = models.ForeignKey(User, related_name='case_user',on_delete=models.SET_NULL, null=True)
    escalate_mail = models.CharField(max_length=255,default="")

    class Meta:
        db_table = "slavoice"

class SlaEmail(models.Model):
    status = models.CharField(choices=STATUS_CHOICE, max_length=64)
    respond_within= models.TimeField(blank=True, null=True,default="00:00")
    escalate_to = models.ForeignKey(User, related_name='user',on_delete=models.SET_NULL, null=True)
    escalate_email = models.CharField(max_length=255,default="")
    class Meta:
            db_table = "slaemail"

class Sla(models.Model):

    voiceopen_status = models.CharField(choices=STATUS_CHOICE, max_length=64)
    voiceopen_respond_within= models.TimeField(blank=True, null=True,default="00:00")
    voiceopen_escalate_mail = models.CharField(max_length=255,default="")
    voiceprogress_status = models.CharField(choices=STATUS_CHOICE, max_length=64)
    voiceprogress_respond_within= models.TimeField(blank=True, null=True,default="00:00")
    voiceprogress_escalate_mail = models.CharField(max_length=255,default="")
    # v_escalate_to = models.ForeignKey(User, related_name='case_user',on_delete=models.SET_NULL, null=True)


    emailopen_status = models.CharField(choices=STATUS_CHOICE, max_length=64)
    emailopen_respond_within= models.TimeField(blank=True, null=True,default="00:00")
    emailopen_escalate_mail =  models.CharField(max_length=255,default="")
    emailprogress_status = models.CharField(choices=STATUS_CHOICE, max_length=64)
    emailprogress_respond_within = models.CharField(max_length=255,default="0")
    emailprogress_escalate_mail =  models.CharField(max_length=255,default="")

    # escalate_to = models.ForeignKey(User, related_name='case_user',on_delete=models.SET_NULL, null=True)

 
    class Meta:
        db_table = "sla"

    

class Case(models.Model):
    name = models.CharField(
        pgettext_lazy("Name of the case", "Name"),
        max_length=64,default="")
    status = models.CharField(choices=STATUS_CHOICE, max_length=64, default='Open')
    case_number = models.CharField(max_length=100,blank=True,null=True)
    email = models.EmailField(blank=True,null=True,default="")
    address = models.TextField(max_length=255,blank=True,null=True)
    action_items = models.TextField(max_length=255,blank=True,null=True)
    creation_date = models.DateTimeField(blank=True,null=True)
    assigned_date = models.DateTimeField(blank=True,null=True)
    
    priority = models.CharField(choices=PRIORITY_CHOICE, max_length=64,default="Not Critical")
    case_type = models.CharField(
        choices=CASE_TYPE, max_length=255, blank=True, null=True,default="Enquiry")
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, blank=True, null=True)
    contacts = models.ManyToManyField(Contact)
    # closed_on = models.DateTimeField()
    closed_on = models.DateField(null=True,blank=True)
    
    phone1=models.CharField(max_length=11,blank=True,null=True)
    description = models.TextField(blank=True, null=True)
    assigned_to = models.ManyToManyField(
        User, related_name='case_assigned_users',blank=True)
    created_by = models.ForeignKey(
        User, related_name='case_created_by',
        on_delete=models.SET_NULL, null=True)
    created_on = models.DateTimeField(_("Created on"), auto_now_add=True)
    sla = models.DateTimeField(null=True,blank=True)
    is_active = models.BooleanField(default=False)
    teams = models.ManyToManyField(Teams, related_name='cases_teams')
    remark=models.TextField(blank=True, null=True)
    parent_case = models.CharField(max_length=255,null=True,blank=True,default="")
    parent_description = models.TextField(max_length=255,null=True,blank=True,default="")
    assignedcase_status = models.CharField(max_length=255,default="new_case")
    colorcode=models.CharField(max_length=255,default="#CCC")
    class Meta:
        ordering = ['-created_on']

    def __str__(self):
        return self.name

    @property
    def get_team_users(self):
        team_user_ids = list(self.teams.values_list('users__id', flat=True))
        return User.objects.filter(id__in=team_user_ids)

    @property
    def get_team_and_assigned_users(self):
        team_user_ids = list(self.teams.values_list('users__id', flat=True))
        assigned_user_ids = list(self.assigned_to.values_list('id', flat=True))
        user_ids = team_user_ids + assigned_user_ids
        return User.objects.filter(id__in=user_ids)

    @property
    def get_assigned_users_not_in_teams(self):
        team_user_ids = list(self.teams.values_list('users__id', flat=True))
        assigned_user_ids = list(self.assigned_to.values_list('id', flat=True))
        user_ids = set(assigned_user_ids) - set(team_user_ids)
        return User.objects.filter(id__in=list(user_ids))

    def get_meetings(self):
        content_type = ContentType.objects.get(app_label="cases", model="case")
        return Event.objects.filter(
            content_type=content_type,
            object_id=self.id,
            event_type="Meeting",
            status="Planned")

    def get_completed_meetings(self):
        content_type = ContentType.objects.get(app_label="cases", model="case")
        return Event.objects.filter(
            content_type=content_type,
            object_id=self.id,
            event_type="Meeting").exclude(status="Planned")

    def get_tasks(self):
        content_type = ContentType.objects.get(app_label="cases", model="case")
        return Event.objects.filter(content_type=content_type,
                                    object_id=self.id,
                                    event_type="Task",
                                    status="Planned")

    def get_completed_tasks(self):
        content_type = ContentType.objects.get(app_label="cases", model="case")
        return Event.objects.filter(
            content_type=content_type,
            object_id=self.id,
            event_type="Task").exclude(status="Planned")

    def get_calls(self):
        content_type = ContentType.objects.get(app_label="cases", model="case")
        return Event.objects.filter(content_type=content_type,
                                    object_id=self.id, event_type="Call",
                                    status="Planned")

    def get_completed_calls(self):
        content_type = ContentType.objects.get(app_label="cases", model="case")
        return Event.objects.filter(
            content_type=content_type,
            object_id=self.id,
            event_type="Call").exclude(status="Planned")

    def get_assigned_user(self):
        return User.objects.get(id=self.assigned_to.id)

    @property
    def created_on_arrow(self):
        return arrow.get(self.created_on).humanize()


class UpdatedCase(models.Model):
    field=models.CharField(max_length=100)
    oldvalue = models.CharField(max_length=100)
    newvalue = models.CharField(max_length=100)
    changedate=models.DateTimeField(auto_now_add=True)
    changedby = models.CharField(max_length=100,default="null")
    case = models.ForeignKey(Case,on_delete=models.CASCADE)

    class Meta:
        db_table = 'updatecase'

class Notification(models.Model):
    caseid=models.CharField(max_length=100)
    userid = models.CharField(max_length=100)
    notifi_status = models.CharField(max_length=20,default='unread')
    # changedate=models.DateTimeField(auto_now_add=True)
    # changedby = models.CharField(max_length=100,default="null")
    # case = models.ForeignKey(Case,on_delete=models.CASCADE)

    class Meta:
        db_table = 'notification'
