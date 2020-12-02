from django.db import models

from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from django_countries.fields import CountryField
import os
from django.core.files.storage import FileSystemStorage

# Create your models here.
class Inbox(models.Model):
	subject_inbox = models.TextField()
	description = models.TextField()
	username = models.CharField(max_length = 50,null=True)
	from_address = models.EmailField(max_length = 50)
	to_address = models.EmailField(max_length = 50)
	status = models.CharField(max_length=10,default=0,null=True)
	created_datetime = models.DateTimeField(default=timezone.now)
	read_status = models.CharField(max_length=20,default='unread')
	


	class Meta:
		db_table = "inbox"



class Subjectmatch(models.Model):
	subject = models.TextField()
	description = models.TextField()
	search_fields = ['subject']

	class Meta:
		db_table="subjectmatch"