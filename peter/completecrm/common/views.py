import datetime
import json
import os
import boto3
import botocore
import requests
import pandas as pd
from django.db import connection
from datetime import datetime as ddatetime
from datetime import datetime, timedelta
from datetime import timedelta
import time
import calendar
import datetime, calendar
from datetime import date
from dateutil.rrule import rrule, DAILY

import time
import calendar
import datetime, calendar
from django.db.models import Count, Q
from datetime import datetime
import re

from django.core.cache import cache
from django.conf import settings
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.hashers import check_password
from django.contrib.auth.mixins import AccessMixin, LoginRequiredMixin
from django.contrib.auth.views import PasswordResetView
from django.contrib.sites.shortcuts import get_current_site
from django.core.exceptions import PermissionDenied
from django.core.mail import EmailMessage
from django.db.models import Q
from django.http import (Http404, HttpResponse, HttpResponseRedirect,
    JsonResponse)
from django.shortcuts import get_object_or_404, redirect, render
from django.template.loader import render_to_string
from django.urls import reverse, reverse_lazy
from django.utils import timezone
from django.utils.encoding import force_bytes, force_text
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from django.views.generic import (CreateView, DeleteView, DetailView,
    TemplateView, UpdateView, View)

from accounts.models import Account, Tags
from cases.models import Case,Notification
from common.access_decorators_mixins import (MarketingAccessRequiredMixin,
    SalesAccessRequiredMixin, marketing_access_required, sales_access_required,
    admin_login_required)
from common.forms import (APISettingsForm, ChangePasswordForm, DocumentForm,
    LoginForm, PasswordResetEmailForm, UserCommentForm, UserForm)
from common.models import (APISettings, Attachments, Comment, Document, Google,
    Profile, User, Currency)
from common.tasks import (resend_activation_link_to_user,
    send_email_to_new_user, send_email_user_delete, send_email_user_status)
from common.token_generator import account_activation_token
from common.utils import ROLES
from contacts.models import Contact
from leads.models import Lead,LeadNotification
from opportunity.models import Opportunity
from teams.models import Teams
from marketing.models import ContactEmailCampaign, BlockedDomain, BlockedEmail,Campaign
from django.db.models import Count, Q
from datetime import date,datetime
import plotly.offline as opy
from plotly import graph_objs as go
import plotly.express as px
from django.db.models import Sum

from common.utils import CURRENCY_CODES
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer

def handler404(request, exception):
    return render(request, '404.html', status=404)


def handler500(request):
    return render(request, '500.html', status=500)



class DashboardView(SalesAccessRequiredMixin,LoginRequiredMixin,TemplateView):

    template_name = "sales/dashboard.html"

    def get_context_data(self, **kwargs):
        dataset = Case.objects \
        .values('status') \
        .annotate(assigned_count=Count('status', filter=Q(status="Assigned")),
                  pending_count=Count('status', filter=Q(status="Pending")), 
                  closed_count=Count('status', filter=Q(status="Closed")),
                  rejected=Count('status',filter=Q(status="Rejected"))) 
        # print("dataset",dataset)
        d1 = datetime.now().strftime("%Y-%m-%d")
    
        d = self.request.GET.get('status')
        print("Start date:",d)
        # fd = datetime.strptime(d,"%d-%m-%Y").strftime("%Y-%m-%d")
        tod = self.request.GET.get('tostatus')
        print('End date:',tod)

        if  Notification.objects.filter(userid=self.request.user.id).exists():
            if Notification.objects.filter(userid=self.request.user.id,notifi_status='unread').exists():
                casenoti=Notification.objects.filter(userid=self.request.user.id,notifi_status='unread').count()
                print('***************&&&&&&&&&****************',casenoti)
                channel_layer = get_channel_layer()
                async_to_sync(channel_layer.group_send)("assignuser", 
                {"type": "user.assignuser",
                "event": "assignuser",
                "username": casenoti,
                "userid":self.request.user.id
                })
            else:
                print('testing')
        if  LeadNotification.objects.filter(userid=self.request.user.id).exists():
            if LeadNotification.objects.filter(userid=self.request.user.id,notifi_status='unread').exists():
                leadnoti=LeadNotification.objects.filter(userid=self.request.user.id,notifi_status='unread').count()
                print('***************&&&&&&&&&****************',leadnoti)
                channel_layer = get_channel_layer()
                async_to_sync(channel_layer.group_send)("assignuser", 
                {"type": "user.assignuser",
                "event": "assignuser",
                "leadid": leadnoti,
                "userid":self.request.user.id
                })
            else:
                print('testing')
        else:
            print(User.objects.values_list('username',flat=True).get(id='1'),'&&&&&&&&&&&&&&&')
            print('&&&&***********&&&&&**************&&&&')

        if d == None and tod == None:
            print("yes")
            # fd=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%Y-%m-%d")
            # std=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%d-%m-%Y")
            fd = datetime.now().strftime("%Y-%m-%d")
            std = datetime.now().strftime("%d-%m-%Y")
            d = std
            # for to date
            opd = datetime.now().strftime("%Y-%m-%d")
            tod =datetime.now().strftime("%d-%m-%Y")

            date = datetime.strptime(opd, "%Y-%m-%d")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")

            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  

                open = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed = Case.objects.filter(Q(status="Closed")& Q(created_on__range=[fd,td])).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                print("Open:",open)
                print("inprogress:",inprogress)
                print("closed:",closed)
                
                contact = Contact.objects.all().filter(created_on__range=[fd,td]).count()
                print("admin CCOONNTTAACCTTccc:",contact)
                case = Case.objects.all().filter(created_on__range=[fd,td]).count()
                print("case:",case)
                account = Account.objects.all().filter(created_on__range=[fd,td]).count()
                print("account:",account)
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(DashboardView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(status="open")
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(
                    status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Lead:",count_lead)
                count_case = Case.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Case:",count_case)
                count_contact = Contact.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Contact:",count_contact)
                sales_count = count_account+count_opportunities+count_lead+count_contact
                print("No.of Sales:",sales_count)
        ############################## Column Graph values for the sum of amount  ###########################################
                qualification = Opportunity.objects.filter(Q(stage="QUALIFICATION")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if qualification['total_amount']==None:
                    qualification_amount=0
                else:
                    qualification_amount=qualification['total_amount']

                needanalysis = Opportunity.objects.filter(Q(stage="NEEDS ANALYSIS")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if needanalysis['total_amount']==None:
                    needanalysis_amount=0
                else:
                    needanalysis_amount=needanalysis['total_amount']

                valueproposition = Opportunity.objects.filter(Q(stage="VALUE PROPOSITION")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if valueproposition['total_amount']==None:
                    valueproposition_amount=0
                else:
                    valueproposition_amount=valueproposition['total_amount']
                # print(valueproposition_amount,"vpa")
                decisionmakers = Opportunity.objects.filter(Q(stage="ID.DECISION MAKERS")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if decisionmakers['total_amount']==None:
                    decisionmakers_amount=0
                else:
                    decisionmakers_amount=decisionmakers['total_amount']

                perception = Opportunity.objects.filter(Q(stage="PERCEPTION ANALYSIS")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if perception['total_amount']==None:
                    perception_amount=0
                else:
                    perception_amount=perception['total_amount']
                
                proposalquote = Opportunity.objects.filter(Q(stage="PROPOSAL/PRICE QUOTE")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if proposalquote['total_amount']==None:
                    proposalquote_amount=0
                else:
                    proposalquote_amount=proposalquote['total_amount']

                negotiation = Opportunity.objects.filter(Q(stage="NEGOTIATION/REVIEW")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if negotiation['total_amount']==None:
                    negotiation_amount=0
                else:
                    negotiation_amount=negotiation['total_amount']

                closedwon = Opportunity.objects.filter(Q(stage="CLOSED LOST")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if closedwon['total_amount']==None:
                    closedwon_amount=0
                else:
                    closedwon_amount=closedwon['total_amount']



        ############################################################################################
                q = Opportunity.objects.filter(Q(stage="QUALIFICATION")& Q(created_on__range=[fd,td])).count()
                # print("Q:",q)

                na = Opportunity.objects.filter(Q(stage="NEEDS ANALYSIS")& Q(created_on__range=[fd,td])).count()
                # print("NA:",na)

                vp = Opportunity.objects.filter(Q(stage="VALUE PROPOSITION")& Q(created_on__range=[fd,td])).count()
                # print("VP:",vp)

                im = Opportunity.objects.filter(Q(stage="ID.DECISION MAKERS")& Q(created_on__range=[fd,td])).count()
                # print("IM:",im)

                pa = Opportunity.objects.filter(Q(stage="PERCEPTION ANALYSIS")& Q(created_on__range=[fd,td])).count()
                # print("PA:",pa)

                pq = Opportunity.objects.filter(Q(stage="PROPOSAL/PRICE QUOTE")& Q(created_on__range=[fd,td])).count()
                # print("PQ:",pq)

                nr = Opportunity.objects.filter(Q(stage="NEGOTIATION/REVIEW")& Q(created_on__range=[fd,td])).count()
                # print("NR:",nr)

                cw = Opportunity.objects.filter(Q(stage="CLOSED WON")& Q(created_on__range=[fd,td])).count()
                # print("CW:",cw)

                cl = Opportunity.objects.filter(Q(stage="CLOSED LOST")& Q(created_on__range=[fd,td])).count()
                # print("CL:",cl)



                funnel_qualification = q+na+vp+im+pa+pq+nr+cw+cl
                # print("Qualification",funnel_qualification)
                funnel_needanalysis = na+vp+im+pa+pq+nr+cw+cl
                # print("Need Analysis",funnel_needanalysis)
                funnel_value_proposition = vp+im+pa+pq+nr+cw+cl
                # print("Value Proposit/ion",funnel_value_proposition)
                funnel_decision_makers = im+pa+pq+nr+cw+cl
                # print("Decision makers",funnel_decision_makers)
                funnel_perception_analysis = pa+pq+nr+cw+cl
                # print("Perception analysis",funnel_perception_analysis)
                funnel_proposal = pq+nr+cw+cl
                # print("Proposal",funnel_proposal)
                funnel_negotiation = nr+cw+cl
                # print("Negotiation",funnel_negotiation)
                funnel_closed_won = cw
                funnel_closed_lost = cl

                trace1 = go.Funnel(
                y = [ "Qualification","Need Analysis","Value Proposition","Decision Makers","Perception Analysis","Proposal/Price Quote","Negotiation","Closed Won"],
                x = [funnel_qualification,funnel_needanalysis,funnel_value_proposition,funnel_decision_makers,funnel_perception_analysis,funnel_proposal,funnel_negotiation,funnel_closed_won],
                text = [qualification_amount,needanalysis_amount,valueproposition_amount,decisionmakers_amount,perception_amount,proposalquote_amount,negotiation_amount,closedwon_amount],
                hoverinfo = 'text')

                config={"displayModeBar": False}
                layout = go.Layout(
                    plot_bgcolor='rgba(0,0,0,0)',
                    # title = "Annual Sales",
                    margin = {"l": 5, "r": 5})
                

                div  = opy.plot(go.Figure([trace1],layout),config=config,output_type='div')
                #######################################################################################

                ################################ Bar Graph values for Lead by Source #########################################################
                call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(created_on__range=[fd,td])).count()
                e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(created_on__range=[fd,td])).count()
                existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(created_on__range=[fd,td])).count()
                partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(created_on__range=[fd,td])).count()
                public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(created_on__range=[fd,td])).count()
                campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(created_on__range=[fd,td])).count()
                website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(created_on__range=[fd,td])).count()
                other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(created_on__range=[fd,td])).count()
                none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(created_on__range=[fd,td])).count()

                count_marketing = Campaign.objects.filter(created_on__range=[fd,td]).count()




            
                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                #context['cassigned'] = cassigned
                context['count_marketing'] = count_marketing
                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities
                context["open"] = open
                context["inprogress"] = inprogress
                context["closed"] = closed
                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div
                context['qualification'] = qualification_amount
                context['needanalysis'] = needanalysis_amount
                context['valueproposition'] = valueproposition_amount
                context['decisionmakers'] = decisionmakers_amount
                context['perception'] = perception_amount
                context['proposalquote'] = proposalquote_amount
                context['negotiation'] = negotiation_amount
                context['closedwon'] = closedwon_amount
                context['call'] = call
                context['email'] = e_mail
                context['existing_customer'] = existing_customer
                context['partner'] = partner
                context['public_relations'] = public_relations
                context['campaign'] = campaign
                context['website'] = website
                context['other'] = other
                context['none'] = none
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['countcase'] = count_case
                context['countcontact'] = count_contact
                context['countsales'] = sales_count
                context['date']=d
                context['tod']=tod
                
                return context

            else:

                open = Case.objects.filter(Q(status="Open",created_on__range=[fd,td],created_by_id=self.request.user.id)| Q(status="Open",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                inprogress = Case.objects.filter(Q(status="In Progress",created_on__range=[fd,td],created_by_id=self.request.user.id)| Q(status="In Progress",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                closed = Case.objects.filter(Q(status="Closed",created_on__range=[fd,td],created_by_id=self.request.user.id)| Q(status="Closed",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                print("Open:",open)
                print("inprogress:",inprogress)
                print("closed:",closed)
                
                contact = Contact.objects.all().filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("user CCOONNTTAACCTTccc:",contact)
                case = Case.objects.all().filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("case:",case)
                account = Account.objects.all().filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("account:",account)
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(DashboardView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(status="open")
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(
                    status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td],created_by_id=self.request.user.id)
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("No.of Lead:",count_lead)
                count_case = Case.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id)| Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                print("No.of Case:",count_case)
                count_contact = Contact.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("No.of Contact:",count_contact)
                sales_count = count_account+count_opportunities+count_lead+count_contact
                print("No.of Sales:",sales_count)
        ############################## Column Graph values for the sum of amount  ###########################################
                qualification = Opportunity.objects.filter(Q(stage="QUALIFICATION",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="QUALIFICATION",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if qualification['total_amount']==None:
                    qualification_amount=0
                else:
                    print("QA amount:",qualification['total_amount'])
                    qualification_amount=qualification['total_amount']

                needanalysis = Opportunity.objects.filter(Q(stage="NEEDS ANALYSIS",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="NEEDS ANALYSIS",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if needanalysis['total_amount']==None:
                    needanalysis_amount=0
                else:
                    needanalysis_amount=needanalysis['total_amount']

                valueproposition = Opportunity.objects.filter(Q(stage="VALUE PROPOSITION",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="VALUE PROPOSITION",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if valueproposition['total_amount']==None:
                    valueproposition_amount=0
                else:
                    valueproposition_amount=valueproposition['total_amount']
                # print(valueproposition_amount,"vpa")
                decisionmakers = Opportunity.objects.filter(Q(stage="ID.DECISION MAKERS",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="ID.DECISION MAKERS",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if decisionmakers['total_amount']==None:
                    decisionmakers_amount=0
                else:
                    decisionmakers_amount=decisionmakers['total_amount']

                perception = Opportunity.objects.filter(Q(stage="PERCEPTION ANALYSIS",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="PERCEPTION ANALYSIS",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if perception['total_amount']==None:
                    perception_amount=0
                else:
                    perception_amount=perception['total_amount']
                
                proposalquote = Opportunity.objects.filter(Q(stage="PROPOSAL/PRICE QUOTE",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="PROPOSAL/PRICE QUOTE",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if proposalquote['total_amount']==None:
                    proposalquote_amount=0
                else:
                    proposalquote_amount=proposalquote['total_amount']

                negotiation = Opportunity.objects.filter(Q(stage="NEGOTIATION/REVIEW",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="NEGOTIATION/REVIEW",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if negotiation['total_amount']==None:
                    negotiation_amount=0
                else:
                    negotiation_amount=negotiation['total_amount']

                closedwon = Opportunity.objects.filter(Q(stage="CLOSED LOST",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="CLOSED LOST",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if closedwon['total_amount']==None:
                    closedwon_amount=0
                else:
                    closedwon_amount=closedwon['total_amount']



        ############################################################################################
                q = Opportunity.objects.filter(Q(stage="QUALIFICATION",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="QUALIFICATION",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("Q:",q)

                na = Opportunity.objects.filter(Q(stage="NEEDS ANALYSIS",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="NEEDS ANALYSIS",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("NA:",na)

                vp = Opportunity.objects.filter(Q(stage="VALUE PROPOSITION",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="VALUE PROPOSITION",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("VP:",vp)

                im = Opportunity.objects.filter(Q(stage="ID.DECISION MAKERS",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="ID.DECISION MAKERS",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("IM:",im)

                pa = Opportunity.objects.filter(Q(stage="PERCEPTION ANALYSIS",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="PERCEPTION ANALYSIS",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("PA:",pa)

                pq = Opportunity.objects.filter(Q(stage="PROPOSAL/PRICE QUOTE",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="PROPOSAL/PRICE QUOTE",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("PQ:",pq)

                nr = Opportunity.objects.filter(Q(stage="NEGOTIATION/REVIEW",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="NEGOTIATION/REVIEW",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("NR:",nr)

                cw = Opportunity.objects.filter(Q(stage="CLOSED WON",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="CLOSED WON",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("CW:",cw)

                cl = Opportunity.objects.filter(Q(stage="CLOSED LOST",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="CLOSED LOST",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("CL:",cl)



                funnel_qualification = q+na+vp+im+pa+pq+nr+cw+cl
                # print("Qualification",funnel_qualification)
                funnel_needanalysis = na+vp+im+pa+pq+nr+cw+cl
                # print("Need Analysis",funnel_needanalysis)
                funnel_value_proposition = vp+im+pa+pq+nr+cw+cl
                # print("Value Proposit/ion",funnel_value_proposition)
                funnel_decision_makers = im+pa+pq+nr+cw+cl
                # print("Decision makers",funnel_decision_makers)
                funnel_perception_analysis = pa+pq+nr+cw+cl
                # print("Perception analysis",funnel_perception_analysis)
                funnel_proposal = pq+nr+cw+cl
                # print("Proposal",funnel_proposal)
                funnel_negotiation = nr+cw+cl
                # print("Negotiation",funnel_negotiation)
                funnel_closed_won = cw
                funnel_closed_lost = cl

                trace1 = go.Funnel(
                y = [ "Qualification","Need Analysis","Value Proposition","Decision Makers","Perception Analysis","Proposal/Price Quote","Negotiation","Closed Won"],
                x = [funnel_qualification,funnel_needanalysis,funnel_value_proposition,funnel_decision_makers,funnel_perception_analysis,funnel_proposal,funnel_negotiation,funnel_closed_won],
                text = [qualification_amount,needanalysis_amount,valueproposition_amount,decisionmakers_amount,perception_amount,proposalquote_amount,negotiation_amount,closedwon_amount],
                hoverinfo = 'text')

                config={"displayModeBar": False}
                layout = go.Layout(
                    plot_bgcolor='rgba(0,0,0,0)',
                    # title = "Annual Sales",
                    margin = {"l": 5, "r": 5})
                

                div  = opy.plot(go.Figure([trace1],layout),config=config,output_type='div')
                #######################################################################################

                ################################ Bar Graph values for Lead by Source #########################################################
                call = Opportunity.objects.filter(Q(lead_source="CALL",created_on__range=[fd,td],created_by_id=self.request.user.id)).count()
                e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()

                count_marketing = Campaign.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()




            
                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
            
                context['count_marketing'] = count_marketing
                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities
                context["open"] = open
                context["inprogress"] = inprogress
                context["closed"] = closed
                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div
                context['qualification'] = qualification_amount
                context['needanalysis'] = needanalysis_amount
                context['valueproposition'] = valueproposition_amount
                context['decisionmakers'] = decisionmakers_amount
                context['perception'] = perception_amount
                context['proposalquote'] = proposalquote_amount
                context['negotiation'] = negotiation_amount
                context['closedwon'] = closedwon_amount
                context['call'] = call
                context['email'] = e_mail
                context['existing_customer'] = existing_customer
                context['partner'] = partner
                context['public_relations'] = public_relations
                context['campaign'] = campaign
                context['website'] = website
                context['other'] = other
                context['none'] = none
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['countcase'] = count_case
                context['countcontact'] = count_contact
                context['countsales'] = sales_count
                context['date']=d
                context['tod']=tod
                
                return context
        

        else:
        # if d != None and tod != None:
            fd = datetime.strptime(d,"%d-%m-%Y").strftime("%Y-%m-%d")
            print(fd, "from date")
            opd =datetime.strptime(tod,"%d-%m-%Y").strftime("%Y-%m-%d")
            print(opd, "to date")

            date = datetime.strptime(opd, "%Y-%m-%d")
            print(date, "date")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")
            print(td, '++++++++++')

            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  

                open = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed = Case.objects.filter(Q(status="Closed")& Q(created_on__range=[fd,td])).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                print("Open:",open)
                print("inprogress:",inprogress)
                print("closed:",closed)
                
                contact = Contact.objects.all().filter(created_on__range=[fd,td]).count()
                print("admin CCOONNTTAACCTTccc:",contact)
                case = Case.objects.all().filter(created_on__range=[fd,td]).count()
                print("case:",case)
                account = Account.objects.all().filter(created_on__range=[fd,td]).count()
                print("account:",account)
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(DashboardView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(status="open")
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(
                    status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Lead:",count_lead)
                count_case = Case.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Case:",count_case)
                count_contact = Contact.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Contact:",count_contact)
                sales_count = count_account+count_opportunities+count_lead+count_contact
                print("No.of Sales:",sales_count)
        ############################## Column Graph values for the sum of amount  ###########################################
                qualification = Opportunity.objects.filter(Q(stage="QUALIFICATION")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if qualification['total_amount']==None:
                    qualification_amount=0
                else:
                    qualification_amount=qualification['total_amount']

                needanalysis = Opportunity.objects.filter(Q(stage="NEEDS ANALYSIS")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if needanalysis['total_amount']==None:
                    needanalysis_amount=0
                else:
                    needanalysis_amount=needanalysis['total_amount']

                valueproposition = Opportunity.objects.filter(Q(stage="VALUE PROPOSITION")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if valueproposition['total_amount']==None:
                    valueproposition_amount=0
                else:
                    valueproposition_amount=valueproposition['total_amount']
                # print(valueproposition_amount,"vpa")
                decisionmakers = Opportunity.objects.filter(Q(stage="ID.DECISION MAKERS")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if decisionmakers['total_amount']==None:
                    decisionmakers_amount=0
                else:
                    decisionmakers_amount=decisionmakers['total_amount']

                perception = Opportunity.objects.filter(Q(stage="PERCEPTION ANALYSIS")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if perception['total_amount']==None:
                    perception_amount=0
                else:
                    perception_amount=perception['total_amount']
                
                proposalquote = Opportunity.objects.filter(Q(stage="PROPOSAL/PRICE QUOTE")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if proposalquote['total_amount']==None:
                    proposalquote_amount=0
                else:
                    proposalquote_amount=proposalquote['total_amount']

                negotiation = Opportunity.objects.filter(Q(stage="NEGOTIATION/REVIEW")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if negotiation['total_amount']==None:
                    negotiation_amount=0
                else:
                    negotiation_amount=negotiation['total_amount']

                closedwon = Opportunity.objects.filter(Q(stage="CLOSED LOST")& Q(update_date__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if closedwon['total_amount']==None:
                    closedwon_amount=0
                else:
                    closedwon_amount=closedwon['total_amount']



        ############################################################################################
                q = Opportunity.objects.filter(Q(stage="QUALIFICATION")& Q(created_on__range=[fd,td])).count()
                # print("Q:",q)

                na = Opportunity.objects.filter(Q(stage="NEEDS ANALYSIS")& Q(created_on__range=[fd,td])).count()
                # print("NA:",na)

                vp = Opportunity.objects.filter(Q(stage="VALUE PROPOSITION")& Q(created_on__range=[fd,td])).count()
                # print("VP:",vp)

                im = Opportunity.objects.filter(Q(stage="ID.DECISION MAKERS")& Q(created_on__range=[fd,td])).count()
                # print("IM:",im)

                pa = Opportunity.objects.filter(Q(stage="PERCEPTION ANALYSIS")& Q(created_on__range=[fd,td])).count()
                # print("PA:",pa)

                pq = Opportunity.objects.filter(Q(stage="PROPOSAL/PRICE QUOTE")& Q(created_on__range=[fd,td])).count()
                # print("PQ:",pq)

                nr = Opportunity.objects.filter(Q(stage="NEGOTIATION/REVIEW")& Q(created_on__range=[fd,td])).count()
                # print("NR:",nr)

                cw = Opportunity.objects.filter(Q(stage="CLOSED WON")& Q(created_on__range=[fd,td])).count()
                # print("CW:",cw)

                cl = Opportunity.objects.filter(Q(stage="CLOSED LOST")& Q(created_on__range=[fd,td])).count()
                # print("CL:",cl)



                funnel_qualification = q+na+vp+im+pa+pq+nr+cw+cl
                # print("Qualification",funnel_qualification)
                funnel_needanalysis = na+vp+im+pa+pq+nr+cw+cl
                # print("Need Analysis",funnel_needanalysis)
                funnel_value_proposition = vp+im+pa+pq+nr+cw+cl
                # print("Value Proposit/ion",funnel_value_proposition)
                funnel_decision_makers = im+pa+pq+nr+cw+cl
                # print("Decision makers",funnel_decision_makers)
                funnel_perception_analysis = pa+pq+nr+cw+cl
                # print("Perception analysis",funnel_perception_analysis)
                funnel_proposal = pq+nr+cw+cl
                # print("Proposal",funnel_proposal)
                funnel_negotiation = nr+cw+cl
                # print("Negotiation",funnel_negotiation)
                funnel_closed_won = cw
                funnel_closed_lost = cl

                trace1 = go.Funnel(
                y = [ "Qualification","Need Analysis","Value Proposition","Decision Makers","Perception Analysis","Proposal/Price Quote","Negotiation","Closed Won"],
                x = [funnel_qualification,funnel_needanalysis,funnel_value_proposition,funnel_decision_makers,funnel_perception_analysis,funnel_proposal,funnel_negotiation,funnel_closed_won],
                text = [qualification_amount,needanalysis_amount,valueproposition_amount,decisionmakers_amount,perception_amount,proposalquote_amount,negotiation_amount,closedwon_amount],
                hoverinfo = 'text')

                config={"displayModeBar": False}
                layout = go.Layout(
                    plot_bgcolor='rgba(0,0,0,0)',
                    # title = "Annual Sales",
                    margin = {"l": 5, "r": 5})
                

                div  = opy.plot(go.Figure([trace1],layout),config=config,output_type='div')
                #######################################################################################

                ################################ Bar Graph values for Lead by Source #########################################################
                call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(created_on__range=[fd,td])).count()
                e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(created_on__range=[fd,td])).count()
                existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(created_on__range=[fd,td])).count()
                partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(created_on__range=[fd,td])).count()
                public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(created_on__range=[fd,td])).count()
                campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(created_on__range=[fd,td])).count()
                website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(created_on__range=[fd,td])).count()
                other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(created_on__range=[fd,td])).count()
                none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(created_on__range=[fd,td])).count()

                count_marketing = Campaign.objects.filter(created_on__range=[fd,td]).count()




            
                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
            
                context['count_marketing'] = count_marketing
                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities
                context["open"] = open
                context["inprogress"] = inprogress
                context["closed"] = closed
                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div
                context['qualification'] = qualification_amount
                context['needanalysis'] = needanalysis_amount
                context['valueproposition'] = valueproposition_amount
                context['decisionmakers'] = decisionmakers_amount
                context['perception'] = perception_amount
                context['proposalquote'] = proposalquote_amount
                context['negotiation'] = negotiation_amount
                context['closedwon'] = closedwon_amount
                context['call'] = call
                context['email'] = e_mail
                context['existing_customer'] = existing_customer
                context['partner'] = partner
                context['public_relations'] = public_relations
                context['campaign'] = campaign
                context['website'] = website
                context['other'] = other
                context['none'] = none
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['countcase'] = count_case
                context['countcontact'] = count_contact
                context['countsales'] = sales_count
                context['date']=d
                context['tod']=tod
                
                return context

            else:
                open = Case.objects.filter(Q(status="Open",created_on__range=[fd,td],created_by_id=self.request.user.id)| Q(status="Open",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                inprogress = Case.objects.filter(Q(status="In Progress",created_on__range=[fd,td],created_by_id=self.request.user.id)| Q(status="In Progress",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                closed = Case.objects.filter(Q(status="Closed",created_on__range=[fd,td],created_by_id=self.request.user.id)| Q(status="Closed",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                print("Open:",open)
                print("inprogress:",inprogress)
                print("closed:",closed)
                
                contact = Contact.objects.all().filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("user CCOONNTTAACCTTccc:",contact)
                case = Case.objects.all().filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("case:",case)
                account = Account.objects.all().filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("account:",account)
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(DashboardView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(status="open")
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(
                    status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td],created_by_id=self.request.user.id)
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("No.of Lead:",count_lead)
                count_case = Case.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id)| Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                print("No.of Case:",count_case)
                count_contact = Contact.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()
                print("No.of Contact:",count_contact)
                sales_count = count_account+count_opportunities+count_lead+count_contact
                print("No.of Sales:",sales_count)
        ############################## Column Graph values for the sum of amount  ###########################################
                qualification = Opportunity.objects.filter(Q(stage="QUALIFICATION",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="QUALIFICATION",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if qualification['total_amount']==None:
                    qualification_amount=0
                else:
                    print("QA amount:",qualification['total_amount'])
                    qualification_amount=qualification['total_amount']

                needanalysis = Opportunity.objects.filter(Q(stage="NEEDS ANALYSIS",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="NEEDS ANALYSIS",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if needanalysis['total_amount']==None:
                    needanalysis_amount=0
                else:
                    needanalysis_amount=needanalysis['total_amount']

                valueproposition = Opportunity.objects.filter(Q(stage="VALUE PROPOSITION",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="VALUE PROPOSITION",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if valueproposition['total_amount']==None:
                    valueproposition_amount=0
                else:
                    valueproposition_amount=valueproposition['total_amount']
                # print(valueproposition_amount,"vpa")
                decisionmakers = Opportunity.objects.filter(Q(stage="ID.DECISION MAKERS",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="ID.DECISION MAKERS",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if decisionmakers['total_amount']==None:
                    decisionmakers_amount=0
                else:
                    decisionmakers_amount=decisionmakers['total_amount']

                perception = Opportunity.objects.filter(Q(stage="PERCEPTION ANALYSIS",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="PERCEPTION ANALYSIS",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if perception['total_amount']==None:
                    perception_amount=0
                else:
                    perception_amount=perception['total_amount']
                
                proposalquote = Opportunity.objects.filter(Q(stage="PROPOSAL/PRICE QUOTE",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="PROPOSAL/PRICE QUOTE",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if proposalquote['total_amount']==None:
                    proposalquote_amount=0
                else:
                    proposalquote_amount=proposalquote['total_amount']

                negotiation = Opportunity.objects.filter(Q(stage="NEGOTIATION/REVIEW",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="NEGOTIATION/REVIEW",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if negotiation['total_amount']==None:
                    negotiation_amount=0
                else:
                    negotiation_amount=negotiation['total_amount']

                closedwon = Opportunity.objects.filter(Q(stage="CLOSED LOST",update_date__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="CLOSED LOST",update_date__range=[fd,td],assigned_to=self.request.user.id)).aggregate(total_amount=Sum('amount'))
                if closedwon['total_amount']==None:
                    closedwon_amount=0
                else:
                    closedwon_amount=closedwon['total_amount']



        ############################################################################################
                q = Opportunity.objects.filter(Q(stage="QUALIFICATION",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="QUALIFICATION",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("Q:",q)

                na = Opportunity.objects.filter(Q(stage="NEEDS ANALYSIS",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="NEEDS ANALYSIS",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("NA:",na)

                vp = Opportunity.objects.filter(Q(stage="VALUE PROPOSITION",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="VALUE PROPOSITION",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("VP:",vp)

                im = Opportunity.objects.filter(Q(stage="ID.DECISION MAKERS",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="ID.DECISION MAKERS",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("IM:",im)

                pa = Opportunity.objects.filter(Q(stage="PERCEPTION ANALYSIS",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="PERCEPTION ANALYSIS",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("PA:",pa)

                pq = Opportunity.objects.filter(Q(stage="PROPOSAL/PRICE QUOTE",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="PROPOSAL/PRICE QUOTE",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("PQ:",pq)

                nr = Opportunity.objects.filter(Q(stage="NEGOTIATION/REVIEW",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="NEGOTIATION/REVIEW",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("NR:",nr)

                cw = Opportunity.objects.filter(Q(stage="CLOSED WON",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="CLOSED WON",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("CW:",cw)

                cl = Opportunity.objects.filter(Q(stage="CLOSED LOST",created_on__range=[fd,td],created_by_id=self.request.user.id)|Q(stage="CLOSED LOST",created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("CL:",cl)






                funnel_qualification = q+na+vp+im+pa+pq+nr+cw+cl
                # print("Qualification",funnel_qualification)
                funnel_needanalysis = na+vp+im+pa+pq+nr+cw+cl
                # print("Need Analysis",funnel_needanalysis)
                funnel_value_proposition = vp+im+pa+pq+nr+cw+cl
                # print("Value Proposit/ion",funnel_value_proposition)
                funnel_decision_makers = im+pa+pq+nr+cw+cl
                # print("Decision makers",funnel_decision_makers)
                funnel_perception_analysis = pa+pq+nr+cw+cl
                # print("Perception analysis",funnel_perception_analysis)
                funnel_proposal = pq+nr+cw+cl
                # print("Proposal",funnel_proposal)
                funnel_negotiation = nr+cw+cl
                # print("Negotiation",funnel_negotiation)
                funnel_closed_won = cw
                funnel_closed_lost = cl

                trace1 = go.Funnel(
                y = [ "Qualification","Need Analysis","Value Proposition","Decision Makers","Perception Analysis","Proposal/Price Quote","Negotiation","Closed Won"],
                x = [funnel_qualification,funnel_needanalysis,funnel_value_proposition,funnel_decision_makers,funnel_perception_analysis,funnel_proposal,funnel_negotiation,funnel_closed_won],
                text = [qualification_amount,needanalysis_amount,valueproposition_amount,decisionmakers_amount,perception_amount,proposalquote_amount,negotiation_amount,closedwon_amount],
                hoverinfo = 'text')

                config={"displayModeBar": False}
                layout = go.Layout(
                    plot_bgcolor='rgba(0,0,0,0)',
                    # title = "Annual Sales",
                    margin = {"l": 5, "r": 5})
                

                div  = opy.plot(go.Figure([trace1],layout),config=config,output_type='div')
                #######################################################################################

                ################################ Bar Graph values for Lead by Source #########################################################
                call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()
                none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(created_on__range=[fd,td]) & Q(created_by_id=self.request.user.id)).count()

                count_marketing = Campaign.objects.filter(created_on__range=[fd,td],created_by_id=self.request.user.id).count()




            
                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
            
                context['count_marketing'] = count_marketing
                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities
                context["open"] = open
                context["inprogress"] = inprogress
                context["closed"] = closed
                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div
                context['qualification'] = qualification_amount
                context['needanalysis'] = needanalysis_amount
                context['valueproposition'] = valueproposition_amount
                context['decisionmakers'] = decisionmakers_amount
                context['perception'] = perception_amount
                context['proposalquote'] = proposalquote_amount
                context['negotiation'] = negotiation_amount
                context['closedwon'] = closedwon_amount
                context['call'] = call
                context['email'] = e_mail
                context['existing_customer'] = existing_customer
                context['partner'] = partner
                context['public_relations'] = public_relations
                context['campaign'] = campaign
                context['website'] = website
                context['other'] = other
                context['none'] = none
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['countcase'] = count_case
                context['countcontact'] = count_contact
                context['countsales'] = sales_count
                context['date']=d
                context['tod']=tod
                
                return context


            


class CaseDashboardView(SalesAccessRequiredMixin,LoginRequiredMixin,TemplateView):
    template_name = "sales/index.html"
        
    def get_context_data(self, **kwargs):
        dataset = Case.objects \
        .values('status') \
        .annotate(assigned_count=Count('status', filter=Q(status="Assigned")),
                  pending_count=Count('status', filter=Q(status="Pending")), 
                  closed_count=Count('status', filter=Q(status="Closed")),
                  rejected=Count('status',filter=Q(status="Rejected"))) 
        # print("dataset",dataset)
        
        d = self.request.GET.get('status')
        print("Start date for case: ",d)
        # fd = datetime.strptime(d,"%d-%m-%Y").strftime("%Y-%m-%d")
        tod = self.request.GET.get('tostatus')
        print('End date: for case',tod)
        # Case.objects.values('case_type').annotate(type=Count('case_type')).order_by('case_type')
        c = Case.objects.all().annotate(type_count=Count('case_type')).order_by('-type_count')
        print("C:",c)
        for dsd in c:
            print(dsd.case_type)
            print('id',dsd.id)
        d1 = datetime.now().strftime("%Y-%m-%d")
        if d == None and tod == None:
            print("yes")
            # fd=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%Y-%m-%d")
            # std=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%d-%m-%Y")

            fd = datetime.now().strftime("%Y-%m-%d")
            std = datetime.now().strftime("%d-%m-%Y")
            d = std

            year,month,date = fd.split('-')

            y1 = int(year)
            m1 = int(month)
            d1 = int(date)
            
            # for to date
            opd = datetime.now().strftime("%Y-%m-%d")
            tod = datetime.now().strftime("%d-%m-%Y")
            
            date = datetime.strptime(opd, "%Y-%m-%d")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")
            print(td, '++++++++++')

            year,month,date = td.split('-')
            y2 = int(year)
            m2 = int(month)
            d2 = int(date)

            
            print(fd, '----------')

            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  

                open_case = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                
                inprogress_case = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed_case = Case.objects.filter(Q(status="Closed")& Q(created_on__range=[fd,td])).count()
                total_case = Case.objects.filter(created_on__range=[fd,td]).count()   

                cases_opened=[]
                cases_close=[]
                cases_progress=[]

                date_field = []
                # cod = connection.queries.pop()
                # print(cod,"___________")      

                a = datetime(y1, m1, d1)
                # print('------',a)
                b = datetime(y2, m2, d2)
                # print('////////',b)



                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    # print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")

                    # print(bn)
                    
                    
                    if td == bn:
                        print('yeah yes')
                    else:
                        date_field.append(um)
                    # print(date_field, '-----------------------------')

                        op_case = Case.objects.filter(Q(status="Open")& Q(created_on__icontains=bn)).count()
                        cases_opened.append(op_case)
                        

                        op_progress = Case.objects.filter(Q(status="In Progress")& Q(created_on__icontains=bn)).count()
                        # print('-------------------', op_progress)
                        cases_progress.append(op_progress)

                        op_close = Case.objects.filter(Q(status="Closed")& Q(created_on__icontains=bn)).count()
                        # print('-------------------', op_close)
                        cases_close.append(op_close)

                        
                    
                    


                    # case_open = Case.objects.extra(select={'day': 'date( created_on )'}).values('day').annotate(status_count=Count('created_on')).order_by('day')

                    
                print('---------Cases opened------', cases_opened)
                cases_user = Case.objects.all().prefetch_related("assigned_to").filter(created_on__range=[fd,td]).order_by('id')
                # print('------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',cases_user)


                cous=Case.objects.all().prefetch_related("assigned_to").filter(created_on__range=[fd,td]).count()

                contacts = Contact.objects.all()
                cases = Case.objects.all()
                contact = Contact.objects.filter(created_on__range=[fd,td]).count()

                case = Case.objects.filter(created_on__range=[fd,td]).count()



                context = super(CaseDashboardView, self).get_context_data(**kwargs)
                if (Case.objects.all().exists()):
                    category = Case.objects.values('case_type').order_by().annotate(case_type_count=Count('case_type'))
                    # print('category:',category)
                    t_category = max(category,key = lambda x:x['case_type_count'])
                    # print('TOP CATEGORY:',t_category)
                    top_category = t_category['case_type']
                    top_category_count = t_category['case_type_count']
                else:
                    top_category = ""
                    top_category_count = "0"
                slatimer=Case.objects.values('sla','name').filter(Q(status="Open")| Q(status="In Progress"))
                print(slatimer,"Slatimer")
                current=datetime.now(timezone.utc)
                dt=[]
                temps={}
                ds=[]
                for sl in slatimer:
                    print('*************************************',sl)
                    t={}
                    slatime=sl['sla']
                    print(slatime,"sltime")
                    dt.append(sl)
                    if slatime >= current:
                        
                        sla_case_name=sl['name']
                        t['name']=sla_case_name
                        print("888888888",t)
                        ds.append(t)
                        temps['alsla']=len(dt)                 
                    else:
                        print('no')
                sms=temps.get('alsla')
                if sms==None:
                    sms=0
                else:
                    cal = sms/total_case
                    percentage = 100 * cal
                    sms=percentage
                # print('*****',temps.get('alsla'))
                #################### FOR INDIVIDUAL ########################################
                idd = User.objects.values('id','username').all()
                data=[]
                for i in idd:
                    temp={}
                    id = i['id']
                    user = i['username']
                    # print("USER:",user)
                    i_open = Case.objects.filter(Q(status="Open")& Q(created_by=id)).count()
                    # print("oc:",i_open)
                    i_inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_by=id)).count()
                    # print()
                    i_closed = Case.objects.filter(Q(status="Closed")& Q(created_by=id)).count()
                    i_totalcases = Case.objects.filter(Q(created_by=id)).count()
                    temp['username'] = user
                    temp['open'] = i_open
                    temp['progress']=i_inprogress
                    temp['closed'] = i_closed
                    temp['totalcases'] = i_totalcases
                    data.append(temp)
                ############################################################################
                print('s',data)
                # print("SD",ds)
                context["contacts_count"] = contacts.count()
                # context["open"] = open
                # context["inprogress"] = inprogress
                # context["closed"] = closed
                context["contact"] = contacts
                context["cases"] = cases.count()
                # context['totalcases'] = totalcases
                context['cases_user'] = cases_user
                context['data'] = data
                context['sla']=sms
                context['scn']=ds
                context['countcase']=cous
                context['category'] = top_category_count
                context['category_name'] = top_category
                context['date']=d
                context['tod']=tod

                # context['myopen_case']=myopen_case
                context['op_case']=cases_opened
                context['op_progress']=cases_progress
                context['op_close']=cases_close


                context["open_case"] = open_case
                context["inprogress_case"] = inprogress_case
                context["closed_case"] = closed_case
                context['total_case']=total_case

                context['case_open']=date_field
                # context['cases_opened']=cases_opened
                # context['cases_close']=cases_close
                # context['cases_progress']=cases_progress
                

                            
                return context

######################################################################################################################
            else:
                name = self.request.user.username
                print("NAME:",name)
                name_id = User.objects.values_list('id',flat=True).get(username=name)
                print("NAME:",name_id)
                # d = date.today()
                # print("DATE:",d)
                

                date_field = []

                a = datetime(y1, m1, d1)
                # print('------',a)
                b = datetime(y2, m2, d2)
                # print('////////',b)
                cases_opened=[]
                cases_close=[]
                cases_progress=[]


                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    # print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    print(bn)
                    # date_field.append(um)
                    # print(date_field, '-----------------------------')

                    if td == bn:
                        print('yeah yes')
                    else:
                        date_field.append(um)

                    # case_open = Case.objects.extra(select={'day': 'date( created_on )'}).values('day').annotate(status_count=Count('created_on')).order_by('day')

                        op_case = Case.objects.filter(Q(status="Open",created_on__icontains=bn,created_by_id=name_id)| Q(status="Open",created_on__icontains=bn,assigned_to=name_id)).count()
                        print('---------opcase----------', op_case)
                        cases_opened.append(op_case)

                        op_progress =  Case.objects.filter(Q(status="In Progress",created_on__icontains=bn,created_by_id=name_id)| Q(status="In Progress",created_on__icontains=bn,assigned_to=name_id)).count()
                        print('-------------------', op_progress)
                        cases_progress.append(op_progress)

                        op_close = Case.objects.filter(Q(status="Closed",created_on__icontains=bn,created_by_id=name_id)| Q(status="Closed",created_on__icontains=bn,assigned_to=name_id)).count()
                        # print('-------------------', op_close)
                        cases_close.append(op_close)

                    print('-------------------', cases_opened)
                    print('-------------------', cases_progress)
                    print('-------------------', cases_close)
      

                open_case =Case.objects.filter(Q(status="Open",created_on__range=[fd,td],created_by_id=name_id)| Q(status="Open",created_on__range=[fd,td],assigned_to=name_id)).count()
                print("PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP:",open_case)
                inprogress_case = Case.objects.filter(Q(status="In Progress",created_on__range=[fd,td],created_by_id=name_id)| Q(status="In Progress",created_on__range=[fd,td],assigned_to=name_id)).count()
                print("IIIIIIIIIIIIIIIIIIIIIII",inprogress_case)
                closed_case = Case.objects.filter(Q(status="Closed",created_on__range=[fd,td],created_by_id=name_id)| Q(status="Closed",created_on__range=[fd,td],assigned_to=name_id)).count()
                total_case = Case.objects.filter(Q(created_on__range=[fd,td],created_by_id=name_id)| Q(created_on__range=[fd,td],assigned_to=name_id)).count()
                print("TOTALCASES:",total_case)

                # assigned = Case.objects.all().filter(assigned_to=name_id)
                # print("ASSIGNED TO:",assigned)
                context = super(CaseDashboardView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(status="open")

                cases_user = Case.objects.all().filter(Q(created_on__range=[fd,td])& Q(created_by_id=name_id,created_on__range=[fd,td])| Q(assigned_to=name_id,created_on__range=[fd,td])).order_by('id')
                # cases_user = Case.objects.all().filter(Q(assigned_to=name_id,created_on__range=[fd,td])|Q(created_by=name_id,created_on__range=[fd,td]))
                print("CASES:",cases_user)
                
                cous=Case.objects.all().filter(Q(created_by=name_id,created_on__range=[fd,td])).count()
                print("+++++",cous)
                if (Case.objects.all().exists()):
                    category = Case.objects.values('case_type').filter(Q(created_on__range=[fd,td],created_by_id=name_id)| Q(created_on__range=[fd,td],assigned_to=name_id)).order_by().annotate(case_type_count=Count('case_type'))
                    print('category:',category)
                    if category.exists():
                        t_category = max(category,key = lambda x:x['case_type_count'])
                        print('TOP CATEGORY:',t_category)
                        top_category = t_category['case_type']
                        top_category_count = t_category['case_type_count']
                       
                    else:
                        top_category = ""
                        top_category_count = "0"
                else:
                    top_category = ""
                    top_category_count = "0"
                slatimer=Case.objects.values('sla','name').filter(Q(status="Open")| Q(status="In Progress"))
                current=datetime.now(timezone.utc)
                dt=[]
                temps={}
                ds=[]
                for sl in slatimer:
                    t={}
                    slatime=sl['sla']
                    dt.append(sl)
                    if slatime >= current:
                        sla_case_name=sl['name']
                        t['name']=sla_case_name
                        ds.append(t)
                        temps['alsla']=len(dt)                 
                    else:
                        print('no')
                sms=temps.get('alsla')
                if sms==None:
                    sms=0
                else:
                    sms=sms

                context["open_case"] = open_case
                context["inprogress_case"] = inprogress_case
                context["closed_case"] = closed_case
                context['cases_user'] = cases_user
                context['total_case'] = total_case
                context['category'] = top_category_count
                context['category_name'] = top_category
                context['sla']=sms
                context['scn']=ds
                context['countcase']=cous
                context['date']=d
                context['tod']=tod
                context['case_open']=date_field
                context['op_case']=cases_opened
                context['op_progress']=cases_progress
                context['op_close']=cases_close
                # context['assigned'] = assigned

                return context

        else:
        # if d != None and tod != None:
            print('test')
            
            fd = datetime.strptime(d,"%d-%m-%Y").strftime("%Y-%m-%d")
            # fd = '2020-05-01'
            print('date from', fd)
            year,month,date = fd.split('-')

            y1 = int(year)
            # print('year',y1)
            m1 = int(month)
            # print('month',m1)
            d1 = int(date)
            # print('date',d1)

            # print("date to",tod)

            opd =datetime.strptime(tod,"%d-%m-%Y").strftime("%Y-%m-%d")

            date = datetime.strptime(opd, "%Y-%m-%d")
            print(date, "date")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")
            print(td, '++++++++++')
            
            year,month,date = td.split('-')
            y2 = int(year)
            # print('year',y2)
            m2 = int(month)
            # print('month',m2)
            d2 = int(date)
            # print('date',d2)

###################### CASES BY USER #####################################################################   
            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  

                open_case = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                
                inprogress_case = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed_case = Case.objects.filter(Q(status="Closed")& Q(created_on__range=[fd,td])).count()
                total_case = Case.objects.filter(created_on__range=[fd,td]).count()   

                cases_opened=[]
                cases_close=[]
                cases_progress=[]

                date_field = []
                # cod = connection.queries.pop()
                # print(cod,"___________")      

                a = datetime(y1, m1, d1)
                # print('------',a)
                b = datetime(y2, m2, d2)
                # print('////////',b)



                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    # print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)


                    if td == bn:
                        print('yeah yes')
                    else:
                        date_field.append(um)

                        # case_open = Case.objects.extra(select={'day': 'date( created_on )'}).values('day').annotate(status_count=Count('created_on')).order_by('day')

                        op_case = Case.objects.filter(Q(status="Open")& Q(created_on__icontains=bn)).count()
                        print('-------------------', op_case)
                        cases_opened.append(op_case)

                        op_progress = Case.objects.filter(Q(status="In Progress")& Q(created_on__icontains=bn)).count()
                        print('-------------------', op_progress)
                        cases_progress.append(op_progress)

                        op_close = Case.objects.filter(Q(status="Closed")& Q(created_on__icontains=bn)).count()
                        # print('-------------------', op_close)
                        cases_close.append(op_close)


                cases_user = Case.objects.all().prefetch_related("assigned_to").filter(created_on__range=[fd,td]).order_by('id')
                cous=Case.objects.all().prefetch_related("assigned_to").filter(created_on__range=[fd,td]).count()

                contacts = Contact.objects.all()
                cases = Case.objects.all()
                contact = Contact.objects.filter(created_on__range=[fd,td]).count()

                case = Case.objects.filter(created_on__range=[fd,td]).count()



                context = super(CaseDashboardView, self).get_context_data(**kwargs)
                if (Case.objects.all().exists()):
                    category = Case.objects.values('case_type').order_by().annotate(case_type_count=Count('case_type'))
                    # print('category:',category)
                    t_category = max(category,key = lambda x:x['case_type_count'])
                    # print('TOP CATEGORY:',t_category)
                    top_category = t_category['case_type']
                    top_category_count = t_category['case_type_count']
                else:
                    top_category = ""
                    top_category_count = "0"
                slatimer=Case.objects.values('sla','name').filter(Q(status="Open")| Q(status="In Progress"))
                current=datetime.now(timezone.utc)
                dt=[]
                temps={}
                ds=[]
                for sl in slatimer:
                    # print('*************************************',sl)
                    t={}
                    slatime=sl['sla']
                    dt.append(sl)
                    if slatime >= current:
                        
                        sla_case_name=sl['name']
                        t['name']=sla_case_name
                        ds.append(t)
                        temps['alsla']=len(dt)                 
                    else:
                        print('no')
                sms=temps.get('alsla')
                if sms==None:
                    sms=0
                else:
                    sms=sms
                # print('*****',temps.get('alsla'))
                #################### FOR INDIVIDUAL ########################################
                idd = User.objects.values('id','username').all()
                data=[]
                for i in idd:
                    temp={}
                    id = i['id']
                    user = i['username']
                    # print("USER:",user)
                    i_open = Case.objects.filter(Q(status="Open")& Q(created_by=id)).count()
                    # print("oc:",i_open)
                    i_inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_by=id)).count()
                    # print()
                    i_closed = Case.objects.filter(Q(status="Closed")& Q(created_by=id)).count()
                    i_totalcases = Case.objects.filter(Q(created_by=id)).count()
                    temp['username'] = user
                    temp['open'] = i_open
                    temp['progress']=i_inprogress
                    temp['closed'] = i_closed
                    temp['totalcases'] = i_totalcases
                    data.append(temp)
                ############################################################################
                print('s',data)
                # print("SD",ds)
                context["contacts_count"] = contacts.count()
                # context["open"] = open
                # context["inprogress"] = inprogress
                # context["closed"] = closed
                context["contact"] = contacts
                context["cases"] = cases.count()
                # context['totalcases'] = totalcases
                context['cases_user'] = cases_user
                context['data'] = data
                context['sla']=sms
                context['scn']=ds
                context['countcase']=cous
                context['category'] = top_category_count
                context['category_name'] = top_category
                context['date']=d
                context['tod']=tod

                # context['myopen_case']=myopen_case
                context['op_case']=cases_opened
                context['op_progress']=cases_progress
                context['op_close']=cases_close


                context["open_case"] = open_case
                context["inprogress_case"] = inprogress_case
                context["closed_case"] = closed_case
                context['total_case']=total_case

                context['case_open']=date_field
                # context['cases_opened']=cases_opened
                # context['cases_close']=cases_close
                # context['cases_progress']=cases_progress
                

                            
                return context

######################################################################################################################
            else:

                name = self.request.user.username
                print("NAME:",name)
                name_id = User.objects.values_list('id',flat=True).get(username=name)
                print("NAME:",name_id)
                # d = date.today()
                # print("DATE:",d)
                cases_opened=[]
                cases_close=[]
                cases_progress=[]

                date_field = []

                a = datetime(y1, m1, d1)
                # print('------',a)
                b = datetime(y2, m2, d2)
                # print('////////',b)

                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    # print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)
                    
                    if td == bn:
                        print('yeah yes')
                    else:
                        date_field.append(um)

                        # case_open = Case.objects.extra(select={'day': 'date( created_on )'}).values('day').annotate(status_count=Count('created_on')).order_by('day')

                        op_case = Case.objects.filter(Q(status="Open",created_on__icontains=bn,created_by_id=name_id)| Q(status="Open",created_on__icontains=bn,assigned_to=name_id)).count()
                        print('-------------------', op_case)
                        cases_opened.append(op_case)

                        op_progress =  Case.objects.filter(Q(status="In Progress",created_on__icontains=bn,created_by_id=name_id)| Q(status="In Progress",created_on__icontains=bn,assigned_to=name_id)).count()
                        # print('-------------------', op_progress)
                        cases_progress.append(op_progress)

                        op_close = Case.objects.filter(Q(status="Closed",created_on__icontains=bn,created_by_id=name_id)| Q(status="Closed",created_on__icontains=bn,assigned_to=name_id)).count()
                        # print('-------------------', op_close)
                        cases_close.append(op_close)


                open_case =Case.objects.filter(Q(status="Open",created_on__range=[fd,td],created_by_id=name_id)| Q(status="Open",created_on__range=[fd,td],assigned_to=name_id)).count()
                print("PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP:",open_case)
                inprogress_case = Case.objects.filter(Q(status="In Progress",created_on__range=[fd,td],created_by_id=name_id)| Q(status="In Progress",created_on__range=[fd,td],assigned_to=name_id)).count()
                print("IIIIIIIIIIIIIIIIIIIIIII",inprogress_case)
                closed_case = Case.objects.filter(Q(status="Closed",created_on__range=[fd,td],created_by_id=name_id)| Q(status="Closed",created_on__range=[fd,td],assigned_to=name_id)).count()
                total_case = Case.objects.filter(Q(created_on__range=[fd,td],created_by_id=name_id)| Q(created_on__range=[fd,td],assigned_to=name_id)).count()
                print("TOTALCASES:",total_case)

                # assigned = Case.objects.all().filter(assigned_to=name_id)
                # print("ASSIGNED TO:",assigned)
                context = super(CaseDashboardView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(status="open")

                cases_user = Case.objects.all().filter(Q(created_on__range=[fd,td])& Q(created_by=name_id,created_on__range=[fd,td])| Q(assigned_to=name_id,created_on__range=[fd,td])).order_by('id')
                print("CASES:",cases_user)
                
                
                cous=Case.objects.all().filter(Q(created_by=name_id,created_on__range=[fd,td])).count()
                print("+++++",cous)
                if (Case.objects.all().exists()):
                    category = Case.objects.values('case_type').filter(Q(created_on__range=[fd,td],created_by_id=name_id)| Q(created_on__range=[fd,td],assigned_to=name_id)).order_by().annotate(case_type_count=Count('case_type'))
                    print('category:',category)
                    if category.exists():
                        t_category = max(category,key = lambda x:x['case_type_count'])
                        print('TOP CATEGORY:',t_category)
                        top_category = t_category['case_type']
                        top_category_count = t_category['case_type_count']                       
                    else:
                        top_category = ""
                        top_category_count = "0"
                else:
                    top_category = ""
                    top_category_count = "0"
                slatimer=Case.objects.values('sla','name').filter(Q(status="Open")| Q(status="In Progress"))
                current=datetime.now(timezone.utc) 
                dt=[]
                temps={}
                ds=[]
                for sl in slatimer:
                    t={}
                    slatime=sl['sla']
                    dt.append(sl)
                    if slatime >= current:
                        sla_case_name=sl['name']
                        t['name']=sla_case_name
                        ds.append(t)
                        temps['alsla']=len(dt)                 
                    else:
                        print('no')
                sms=temps.get('alsla')
                if sms==None:
                    sms=0
                else:
                    sms=sms

                
                context['cases_user'] = cases_user
                context['category'] = top_category_count
                context['category_name'] = top_category
                context['sla']=sms
                context['scn']=ds
                context['countcase']=cous

                context['date']=d
                context['tod']=tod
                context['case_open']=date_field
                context['op_case']=cases_opened
                context['op_progress']=cases_progress
                context['op_close']=cases_close

                context["total_case"] = total_case
                context["open_case"] = open_case
                context["inprogress_case"] = inprogress_case
                context["closed_case"] = closed_case
                # context['assigned'] = assigned

                return context


class IndvCaseDashboardView(SalesAccessRequiredMixin,LoginRequiredMixin,TemplateView):
    template_name = "sales/case_ind.html"
        
    def get_context_data(self, **kwargs):
        dataset = Case.objects \
        .values('status') \
        .annotate(assigned_count=Count('status', filter=Q(status="Assigned")),
                  pending_count=Count('status', filter=Q(status="Pending")), 
                  closed_count=Count('status', filter=Q(status="Closed")),
                  rejected=Count('status',filter=Q(status="Rejected"))) 
        # print("dataset",dataset)
        
        d = self.request.GET.get('status')
        print("Start date for case: ",d)
        # fd = datetime.strptime(d,"%d-%m-%Y").strftime("%Y-%m-%d")
        tod = self.request.GET.get('tostatus')
        print('End date: for case',tod)

        d1 = datetime.now().strftime("%Y-%m-%d")
        if d == None and tod == None:
            print("yes")
            # fd=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%Y-%m-%d")
            # std=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%d-%m-%Y")
            fd = datetime.now().strftime("%Y-%m-%d")
            std = datetime.now().strftime("%d-%m-%Y")
            d = std
            # for to date
            opd = datetime.now().strftime("%Y-%m-%d")
            tod = datetime.now().strftime("%d-%m-%Y")


            year,month,date = fd.split('-')

            y1 = int(year)
            m1 = int(month)
            d1 = int(date)

            year,month,date = opd.split('-')
            y2 = int(year)
            # print('year',y2)
            m2 = int(month)
            # print('month',m2)
            d2 = int(date)
            # print('date',d2)

            date = datetime.strptime(opd, "%Y-%m-%d")
            # print(date, "date")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")
            # print(td, '++++++++++')

            bnmm = self.request.user.username
            name_id = User.objects.values_list('id',flat=True).get(username=bnmm)
            print(name_id, '===========================')
            user_list = User.objects.all()
            print(user_list, "----------------------------")

            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  

                open_case = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                
                inprogress_case = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed_case = Case.objects.filter(Q(status="Closed")& Q(created_on__range=[fd,td])).count()
                total_case = Case.objects.filter(created_on__range=[fd,td]).count()   

                cases_user = Case.objects.all().prefetch_related("assigned_to").filter(created_on__range=[fd,td])
                # print('------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',cases_user)

                context = super(IndvCaseDashboardView, self).get_context_data(**kwargs)
                if (Case.objects.all().exists()):
                    category = Case.objects.values('case_type').order_by().annotate(case_type_count=Count('case_type'))
                    # print('category:',category)
                    t_category = max(category,key = lambda x:x['case_type_count'])
                    # print('TOP CATEGORY:',t_category)
                    top_category = t_category['case_type']
                    top_category_count = t_category['case_type_count']
                else:
                    top_category = ""
                    top_category_count = "0"
                slatimer=Case.objects.values('sla','name').filter(Q(status="Open")| Q(status="In Progress"))
                current=datetime.now(timezone.utc)
                dt=[]
                temps={}
                ds=[]
                for sl in slatimer:
                    # print('*************************************',sl)
                    t={}
                    slatime=sl['sla']
                    dt.append(sl)
                    if slatime >= current:
                        
                        sla_case_name=sl['name']
                        t['name']=sla_case_name
                        ds.append(t)
                        temps['alsla']=len(dt)                 
                    else:
                        print('no')
                sms=temps.get('alsla')
                if sms==None:
                    sms=0
                else:
                    cal = sms/total_case
                    percentage = 100 * cal
                    sms=percentage
                # print('*****',temps.get('alsla'))
                #################### FOR INDIVIDUAL ########################################
                idd = User.objects.values('id','username').all()
                data=[]
                for i in idd:
                    temp={}
                    id = i['id']
                    user = i['username']
                    # print("USER:",user)
                    i_open = Case.objects.filter(Q(status="Open",created_by=id,created_on__range=[fd,td])|Q(status="Open",assigned_to=id,created_on__range=[fd,td])).count()

                    # open_open = Case.objects.filter(Q(status="Open")& Q(created_by=id)& Q(created_on__range=[fd,td]))
                    print(i_open, '------------------')



                    # print("oc:",i_open)
                    i_inprogress = Case.objects.filter(Q(status="In Progress",created_by=id,created_on__range=[fd,td])|Q(status="In Progress",assigned_to=id,created_on__range=[fd,td])).count()
                    print(i_inprogress)
                    i_closed = Case.objects.filter(Q(status="Closed",created_by=id,created_on__range=[fd,td])|Q(status="Closed",assigned_to=id,created_on__range=[fd,td])).count()
                    print(i_closed)
                    i_totalcases = Case.objects.filter(Q(created_by=id,created_on__range=[fd,td])|Q(assigned_to=id,created_on__range=[fd,td])).count()
                    print(i_totalcases)
                    temp['username'] = user
                    temp['open'] = i_open
                    temp['progress']=i_inprogress
                    temp['closed'] = i_closed
                    temp['totalcases'] = i_totalcases
                    data.append(temp)
                ############################################################################
                print('s',data)
                # print("SD",ds)
                # context["contacts_count"] = contacts.count()
                # context["open"] = open
                # context["inprogress"] = inprogress
                # context["closed"] = closed
                # context["contact"] = contacts
                # context["cases"] = cases.count()
                # context['totalcases'] = totalcases
                context['cases_user'] = cases_user
                context['data'] = data
                context['sla']=sms
                context['scn']=ds
                # context['countcase']=cous
                context['category'] = top_category_count
                context['category_name'] = top_category
                context['date']=d
                context['tod']=tod

                # context['myopen_case']=myopen_case
                

                context["open_case"] = open_case
                context["inprogress_case"] = inprogress_case
                context["closed_case"] = closed_case
                context['total_case']=total_case

                
                # context['cases_opened']=cases_opened
                # context['cases_close']=cases_close
                # context['cases_progress']=cases_progress
                

                            
                return context

######################################################################################################################
            else:
                name = self.request.user.username
                print("NAME:",name)
                name_id = User.objects.values_list('id',flat=True).get(username=name)
                print("NAME:",name_id)
                # d = date.today()
                # print("DATE:",d)
                cases_user = Case.objects.all().prefetch_related("assigned_to").filter(Q(created_on__range=[fd,td]))
                print('----------------',cases_user)

                open_case = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])& Q(created_by_id=name_id)| Q(assigned_to=name_id)).count()
                inprogress_case = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])& Q(created_by_id=name_id)| Q(assigned_to=name_id)).count()
                closed_case = Case.objects.filter(Q(status="Closed")& Q(created_on__range=[fd,td])& Q(created_by_id=name_id)| Q(assigned_to=name_id)).count()
                total_case = Case.objects.filter(Q(created_by_id=name_id), Q(created_on__range=[fd,td])& Q(assigned_to=name_id)).count()

                # cases_user = Case.objects.all().filter(Q(assigned_to=name_id,created_on__range=[fd,td])|Q(created_by=name_id,created_on__range=[fd,td]))

                
                # assigned = Case.objects.all().filter(assigned_to=name_id)
                # print("ASSIGNED TO:",assigned)
                context = super(IndvCaseDashboardView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(status="open")
                
                if (Case.objects.all().exists()):
                    category = Case.objects.values('case_type').order_by().annotate(case_type_count=Count('case_type'))
                    print('category:',category)
                    t_category = max(category,key = lambda x:x['case_type_count'])
                    print('TOP CATEGORY:',t_category)
                    top_category = t_category['case_type']
                    top_category_count = t_category['case_type_count']
                else:
                    top_category = ""
                    top_category_count = "0"
                slatimer=Case.objects.values('sla','name').filter(Q(status="Open")| Q(status="In Progress"))
                current=datetime.now(timezone.utc)
                dt=[]
                temps={}
                ds=[]
                for sl in slatimer:
                    t={}
                    slatime=sl['sla']
                    dt.append(sl)
                    if slatime >= current:
                        sla_case_name=sl['name']
                        t['name']=sla_case_name
                        ds.append(t)
                        temps['alsla']=len(dt)                 
                    else:
                        print('no')
                sms=temps.get('alsla')
                if sms==None:
                    sms=0
                else:
                    sms=sms

                context["open_case"] = open_case
                context["inprogress_case"] = inprogress_case
                context["closed_case"] = closed_case
                context['cases_user'] = cases_user
                context['total_case'] = total_case
                context['category'] = top_category_count
                context['category_name'] = top_category
                context['sla']=sms
                context['scn']=ds
                # context['countcase']=cous
                context['date']=d
                context['tod']=tod
                # context['assigned'] = assigned

                return context

        else:
        # if d != None and tod != None:
            print('test')
            
            fd = datetime.strptime(d,"%d-%m-%Y").strftime("%Y-%m-%d")
            # fd = '2020-05-01'
            print('date from', fd)
            year,month,date = fd.split('-')

            y1 = int(year)
            # print('year',y1)
            m1 = int(month)
            # print('month',m1)
            d1 = int(date)
            # print('date',d1)

            # print("date to",tod)

            opd =datetime.strptime(tod,"%d-%m-%Y").strftime("%Y-%m-%d")

            date = datetime.strptime(opd, "%Y-%m-%d")
            print(date, "date")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")
            print(td, '++++++++++')
            
            year,month,date = td.split('-')
            y2 = int(year)
            # print('year',y2)
            m2 = int(month)
            # print('month',m2)
            d2 = int(date)
            # print('date',d2)
            
            bnmm = self.request.user.username
            name_id = User.objects.values_list('id',flat=True).get(username=bnmm)
            
###################### CASES BY USER #####################################################################   
            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  

                open_case = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                
                inprogress_case = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed_case = Case.objects.filter(Q(status="Closed")& Q(created_on__range=[fd,td])).count()
                total_case = Case.objects.filter(Q(created_on__range=[fd,td])).count()   
                print('total cases', total_case)

                cases_user = Case.objects.all().filter(Q(assigned_to=name_id,created_on__range=[fd,td])|Q(created_by=name_id,created_on__range=[fd,td]))
                print("CASES:",cases_user)

                context = super(IndvCaseDashboardView, self).get_context_data(**kwargs)
                if (Case.objects.all().exists()):
                    category = Case.objects.values('case_type').order_by().annotate(case_type_count=Count('case_type'))
                    # print('category:',category)
                    t_category = max(category,key = lambda x:x['case_type_count'])
                    # print('TOP CATEGORY:',t_category)
                    top_category = t_category['case_type']
                    top_category_count = t_category['case_type_count']
                else:
                    top_category = ""
                    top_category_count = "0"
                slatimer=Case.objects.values('sla','name').filter(Q(status="Open")| Q(status="In Progress"))
                current=datetime.now(timezone.utc)
                dt=[]
                temps={}
                ds=[]
                for sl in slatimer:
                    # print('*************************************',sl)
                    t={}
                    slatime=sl['sla']
                    dt.append(sl)
                    if slatime >= current:
                        
                        sla_case_name=sl['name']
                        t['name']=sla_case_name
                        ds.append(t)
                        temps['alsla']=len(dt)                 
                    else:
                        print('no')
                sms=temps.get('alsla')
                if sms==None:
                    sms=0
                else:
                    sms=sms
                # print('*****',temps.get('alsla'))
                #################### FOR INDIVIDUAL ########################################
                idd = User.objects.values('id','username').all()
                data=[]
                for i in idd:
                    temp={}
                    id = i['id']
                    user = i['username']
                    # print("USER:",user)
                    i_open = Case.objects.filter(Q(status="Open",created_by=id,created_on__range=[fd,td])|Q(status="Open",assigned_to=id,created_on__range=[fd,td])).count()
                    print("oc:",i_open)
                    i_inprogress = Case.objects.filter(Q(status="In Progress",created_by=id,created_on__range=[fd,td])|Q(status="In Progress",assigned_to=id,created_on__range=[fd,td])).count()
                    # print()
                    i_closed = Case.objects.filter(Q(status="Closed",created_by=id,created_on__range=[fd,td])|Q(status="Closed",assigned_to=id,created_on__range=[fd,td])).count()
                    i_totalcases = Case.objects.filter(Q(created_by=id,created_on__range=[fd,td])|Q(assigned_to=id,created_on__range=[fd,td])).count()
                    temp['username'] = user
                    temp['open'] = i_open
                    temp['progress']=i_inprogress
                    temp['closed'] = i_closed
                    temp['totalcases'] = i_totalcases
                    data.append(temp)
                ############################################################################
                print('s',data)
                # print("SD",ds)
                # context["contacts_count"] = contacts.count()

                context["cases_user"] = cases_user
                # context["contact"] = contacts
                # context["cases"] = cases.count()
                context['data'] = data
                context['sla']=sms
                context['scn']=ds
                # context['countcase']=cous
                context['category'] = top_category_count
                context['category_name'] = top_category
                context['date']=d
                context['tod']=tod

                # context['myopen_case']=myopen_case



                context["open_case"] = open_case
                context["inprogress_case"] = inprogress_case
                context["closed_case"] = closed_case
                context['total_case']=total_case

                # context['case_open']=date_field
                # context['cases_opened']=cases_opened
                # context['cases_close']=cases_close
                # context['cases_progress']=cases_progress
                

                            
                return context

######################################################################################################################
            else:

                name = self.request.user.username
                print("NAME:",name)
                name_id = User.objects.values_list('id',flat=True).get(username=name)
                print("NAME:",name_id)
                # d = date.today()
                # print("DATE:",d)

                open_case = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])& Q(created_by_id=name_id)| Q(assigned_to=name_id)).count()
                inprogress_case = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])& Q(created_by_id=name_id)| Q(assigned_to=name_id)).count()
                closed_case = Case.objects.filter(Q(status="Closed")& Q(created_on__range=[fd,td])& Q(created_by_id=name_id)| Q(assigned_to=name_id)).count()
                total_case = Case.objects.filter(created_by_id=name_id,created_on__range=[fd,td]| Q(assigned_to=name_id)).count()
                # print("TOTALCASES:",totalcases)
                # assigned = Case.objects.all().filter(assigned_to=name_id)
                # print("ASSIGNED TO:",assigned)
                context = super(IndvCaseDashboardView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(status="open")

                cases_user = Case.objects.all().prefetch_related("assigned_to").filter(created_on__range=[fd,td])

               
                if (Case.objects.all().exists()):
                    category = Case.objects.values('case_type').order_by().annotate(case_type_count=Count('case_type'))
                    print('category:',category)
                    t_category = max(category,key = lambda x:x['case_type_count'])
                    print('TOP CATEGORY:',t_category)
                    top_category = t_category['case_type']
                    top_category_count = t_category['case_type_count']
                else:
                    top_category = ""
                    top_category_count = "0"
                slatimer=Case.objects.values('sla','name').filter(Q(status="Open")| Q(status="In Progress"))
                current=datetime.now(timezone.utc)
                dt=[]
                temps={}
                ds=[]
                for sl in slatimer:
                    t={}
                    slatime=sl['sla']
                    dt.append(sl)
                    if slatime >= current:
                        sla_case_name=sl['name']
                        t['name']=sla_case_name
                        ds.append(t)
                        temps['alsla']=len(dt)                 
                    else:
                        print('no')
                sms=temps.get('alsla')
                if sms==None:
                    sms=0
                else:
                    sms=sms

                
                context['cases_user'] = cases_user
                context['category'] = top_category_count
                context['category_name'] = top_category
                context['sla']=sms
                context['scn']=ds
                # context['countcase']=cous

                context['date']=d
                context['tod']=tod
                # context['case_open']=date_field
                # context['op_case']=cases_opened
                # context['op_progress']=cases_progress
                # context['op_close']=cases_close

                context["open_case"] = open_case
                context["inprogress_case"] = inprogress_case
                context["closed_case"] = closed_case
                # context['assigned'] = assigned

                return context


class AdminRequiredMixin(AccessMixin):

    def dispatch(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            return self.handle_no_permission()
        self.raise_exception = True
        if not request.user.role == "ADMIN":
            if not request.user.is_superuser:
                return self.handle_no_permission()
        return super(AdminRequiredMixin, self).dispatch(
            request, *args, **kwargs)


class HomeView(SalesAccessRequiredMixin, LoginRequiredMixin, TemplateView):
    template_name = "sales/sales_dash.html"

    def get_context_data(self, **kwargs):
        dataset = Case.objects \
        .values('status') \
        .annotate(assigned_count=Count('status', filter=Q(status="Assigned")),
                  pending_count=Count('status', filter=Q(status="Pending")), 
                  closed_count=Count('status', filter=Q(status="Closed")),
                  rejected=Count('status',filter=Q(status="Rejected"))) 
        # print("dataset",dataset)

        # d1 = datetime.now().strftime("%Y-%m-%d")

        d = self.request.GET.get('fromstatus')
        print("Start date:",d)

        tod = self.request.GET.get('toostatus')
        print('End date:',tod)

        if d == None and tod == None:
            # print("yes")
            # fd=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%Y-%m-%d")
            # std=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%d-%m-%Y")
            fd = datetime.now().strftime("%Y-%m-%d")
            std = datetime.now().strftime("%d-%m-%Y")
            d = std

            year,month,date = fd.split('-')

            y1 = int(year)
            m1 = int(month)
            d1 = int(date)


            # for to date
            opd = datetime.now().strftime("%Y-%m-%d")
            tod =datetime.now().strftime("%d-%m-%Y")

            date = datetime.strptime(opd, "%Y-%m-%d")
            print(date, "date")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")

            year,month,date = td.split('-')
            y2 = int(year)
            m2 = int(month)
            d2 = int(date)

            print(fd, '----------')
            print(td, '++++++++++')
            

    
            date_field=[]
            prospect_dts = []
            interest_dts=[]
            trial_poc_dts=[]
            proposal_quote_sent_dts=[]
            closed_won_dts=[]
            aborted_closed_lost_dts=[]


            call_dts = []
            email_dts = []
            existing_customer_dts=[]
            partner_dts=[]
            public_relations_dts=[]
            campaign_dts =[]
            website_dts=[]
            other_dts=[]
            none_dts=[]

            a = datetime(y1, m1, d1)
            b = datetime(y2, m2, d2)

            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  


                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)

                    if td == bn:
                        print('yes')
                    else:
                        date_field.append(um)
                        print(date_field, '-----------------------------')

                        op_prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(update_date__icontains=bn)).count()
                        prospect_dts.append(op_prospect)

                        op_interest = Opportunity.objects.filter(Q(stage="Interest")& Q(update_date__icontains=bn)).count()
                        interest_dts.append(op_interest)

                        op_trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(update_date__icontains=bn)).count()
                        trial_poc_dts.append(op_trial_poc)

                        op_proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(update_date__icontains=bn)).count()
                        proposal_quote_sent_dts.append(op_proposal_quote_sent)
                        
                        op_closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(update_date__icontains=bn)).count()
                        closed_won_dts.append(op_closed_won)

                        op_aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(update_date__icontains=bn)).count()
                        aborted_closed_lost_dts.append(op_aborted_closed_lost)

                       
        # ################################ Lead by source  graph ##############################3
                        call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(update_date__icontains=bn)).count()
                        call_dts.append(call)
                        print(call_dts)

                        e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(update_date__icontains=bn)).count()
                        email_dts.append(e_mail)

                        existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(update_date__icontains=bn)).count()
                        existing_customer_dts.append(existing_customer)

                        partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(update_date__icontains=bn)).count()
                        partner_dts.append(partner)

                        public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(update_date__icontains=bn)).count()
                        public_relations_dts.append(public_relations)

                        campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(update_date__icontains=bn)).count()
                        campaign_dts.append(campaign)

                        website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(update_date__icontains=bn)).count()
                        website_dts.append(website)

                        other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(update_date__icontains=bn)).count()
                        other_dts.append(other)

                        none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(update_date__icontains=bn)).count()
                        none_dts.append(none)







                # open = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                # inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                # closed = Case.objects.filter(Q(status="Close")& Q(created_on__range=[fd,td])).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                            
                contact = Contact.objects.filter(created_on__range=[fd,td]).count()
                # print("CCOONNTTAACCTT:",contact)
                case = Case.objects.filter(created_on__range=[fd,td]).count()
                # print("case:",case)
                account = Account.objects.filter(created_on__range=[fd,td]).count()
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(HomeView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(Q(status="open")& Q(created_on__range=[fd,td]))
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(created_on__range=[fd,td]).exclude(status='converted').exclude(status='closed').count()
                print("No.of Lead:",count_lead)
                count_contact = Contact.objects.all().filter(created_on__range=[fd,td]).count()
                print("No.of contact:",count_contact)



        ##################################### Column Graph values for the sum of amount  ###########################################
                prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if prospect['total_amount']==None:
                    prospect_amount=0
                else:
                    prospect_amount=prospect['total_amount']

                interest = Opportunity.objects.filter(Q(stage="Interest")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if interest['total_amount']==None:
                    interest_amount=0
                else:
                    interest_amount=interest['total_amount']

                trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if trial_poc['total_amount']==None:
                   trial_poc_amount=0
                else:
                    trial_poc_amount=trial_poc['total_amount']
                # print(valueproposition_amount,"vpa")
                proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if proposal_quote_sent['total_amount']==None:
                    proposal_quote_sent_amount=0
                else:
                    proposal_quote_sent_amount=proposal_quote_sent['total_amount']

                closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if closed_won['total_amount']==None:
                    closed_won_amount=0
                else:
                    closed_won_amount=closed_won['total_amount']
                
                aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if aborted_closed_lost['total_amount']==None:
                    aborted_closed_lost_amount=0
                else:
                    aborted_closed_lost_amount=aborted_closed_lost['total_amount']

       


                p = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_on__range=[fd,td])).count()
                # print("P:",p)

                i = Opportunity.objects.filter(Q(stage="Interest")& Q(created_on__range=[fd,td])).count()
                # print("I:",i)

                tp = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_on__range=[fd,td])).count()
                # print("TP:",tp)

                pcs = Opportunity.objects.filter(Q(stage="Proposal / Closed sent")& Q(created_on__range=[fd,td])).count()
                # print("PCS:",pcs)

                cw = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_on__range=[fd,td])).count()
                # print("CW:",cw)

                acl = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_on__range=[fd,td])).count()
                # print("ACL:",acl)

#############################
               



                funnel_prospect = p+i+tp+pcs+cw+acl
                # print("Prospect",funnel_prospect)
                funnel_interest = i+tp+pcs+cw+acl
                # print("Interest",funnel_interest)
                funnel_trial_poc = tp+pcs+cw+acl
                # print("Trial/poc",funnel_trial_poc)
                funnel_proposal_quote_sent = pcs+cw+acl
                # print("Proposal Quote sent",funnel_proposal_quote_sent)
                funnel_closed_won = cw
                funnel_aborted_closed_lost = acl

                trace1 = go.Funnel(
                y = [ "Prospect","Interest","Trial/POC","Proposal/Quote Sent","Closed/Won","Aborted/Closed Lost"],
                x = [funnel_prospect,funnel_interest,funnel_trial_poc,funnel_proposal_quote_sent,funnel_closed_won,funnel_aborted_closed_lost],
                text = [prospect_amount,interest_amount,trial_poc_amount,proposal_quote_sent_amount,closed_won_amount,aborted_closed_lost_amount],
                marker = {"color": ["#162252", "#27408B", "#386BD8", "#758FDC", "#99B2FF","#E5ECFF"]},
                hoverinfo = 'text')

                config={"displayModeBar": False}
                layout = go.Layout(
                    plot_bgcolor='rgba(0,0,0,0)',
                    # title = "Annual Sales",
                    margin = {"l": 5, "r": 5})
                

                div  = opy.plot(go.Figure([trace1],layout),config=config,output_type='div')


        ################################ Bar Graph values for Lead by Source #########################################################
                # call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(created_on__range=[fd,td])).count()
                # e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(created_on__range=[fd,td])).count()
                # existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(created_on__range=[fd,td])).count()
                # partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(created_on__range=[fd,td])).count()
                # public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(created_on__range=[fd,td])).count()
                # campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(created_on__range=[fd,td])).count()
                # website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(created_on__range=[fd,td])).count()
                # other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(created_on__range=[fd,td])).count()
                # none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(created_on__range=[fd,td])).count()


                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                
                context["sales_amount"] = date_field

                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities

                # context["open"] = open
                # context["inprogress"] = inprogress
                # context["closed"] = closed

                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div

                context['prospect'] = prospect_amount
                context['interest'] = interest_amount
                context['trial_poc'] = trial_poc_amount
                context['proposal_quote_sent'] = proposal_quote_sent_amount
                context['closed_won'] = closed_won_amount
                context['aborted_closed_lost'] = aborted_closed_lost_amount
              


                context['prospect_dts'] = prospect_dts
                context['interest_dts'] = interest_dts
                context['trial_poc_dts'] = trial_poc_dts
                context['proposal_quote_sent_dts'] = proposal_quote_sent_dts
                context['closed_won_dts'] = closed_won_dts
                context['aborted_closed_lost_dts'] = aborted_closed_lost_dts
            


                context['call_dts'] = call_dts
                context['email_dts'] = email_dts
                context['existing_customer_dts'] = existing_customer_dts
                context['partner_dts'] = partner_dts
                context['public_relations_dts'] = public_relations_dts
                context['campaign_dts'] = campaign_dts
                context['website_dts'] = website_dts
                context['other_dts'] = other_dts
                context['none_dts'] = none_dts

                
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['date']=d
                context['tod']=tod

                return context
            
            else:

                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)

                    if td == bn:
                        print('yes')
                    else:
                        date_field.append(um)
                        print(date_field, '-----------------------------')

                        op_prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(update_date__icontains=bn)).count()
                        prospect_dts.append(op_prospect)

                        op_interest = Opportunity.objects.filter(Q(stage="Interest")& Q(update_date__icontains=bn)).count()
                        interest_dts.append(op_interest)

                        op_trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(update_date__icontains=bn)).count()
                        trial_poc_dts.append(op_trial_poc)

                        op_proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(update_date__icontains=bn)).count()
                        proposal_quote_sent_dts.append(op_proposal_quote_sent)
                        
                        op_closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(update_date__icontains=bn)).count()
                        closed_won_dts.append(op_closed_won)

                        op_aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(update_date__icontains=bn)).count()
                        aborted_closed_lost_dts.append(op_aborted_closed_lost)
        # ################################ Lead by source  graph ##############################3
                        call = Opportunity.objects.filter(Q(lead_source="CALL",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="CALL",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        call_dts.append(call)
                        print(call_dts)

                        e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="EMAIL",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        email_dts.append(e_mail)

                        existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="EXISTING CUSTOMER",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        existing_customer_dts.append(existing_customer)

                        partner = Opportunity.objects.filter(Q(lead_source="PARTNER",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="PARTNER",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        partner_dts.append(partner)

                        public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="PUBLIC RELATIONS",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        public_relations_dts.append(public_relations)

                        campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="CAMPAIGN",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        campaign_dts.append(campaign)

                        website = Opportunity.objects.filter(Q(lead_source="WEBSITE",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="WEBSITE",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        website_dts.append(website)

                        other = Opportunity.objects.filter(Q(lead_source="OTHER",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="OTHER",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        other_dts.append(other)

                        none = Opportunity.objects.filter(Q(lead_source="NONE",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="NONE",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        none_dts.append(none)







                open = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed = Case.objects.filter(Q(status="Close")& Q(created_on__range=[fd,td])).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                            
                contact = Contact.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("CCOONNTTAACCTT:",contact)
                case = Case.objects.filter(created_on__range=[fd,td]).count()
                # print("case:",case)
                account = Account.objects.filter(created_on__range=[fd,td]).count()
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(HomeView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(Q(status="open")& Q(created_on__range=[fd,td]))
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).exclude(status='converted').exclude(status='closed').count()
                # print("No.of Lead:",count_lead)


        ##################################### Column Graph values for the sum of amount  ###########################################
                prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if prospect['total_amount']==None:
                    prospect_amount=0
                else:
                    prospect_amount=prospect['total_amount']

                interest = Opportunity.objects.filter(Q(stage="Interest")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if interest['total_amount']==None:
                    interest_amount=0
                else:
                    interest_amount=interest['total_amount']

                trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if trial_poc['total_amount']==None:
                   trial_poc_amount=0
                else:
                    trial_poc_amount=trial_poc['total_amount']
                # print(valueproposition_amount,"vpa")
                proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if proposal_quote_sent['total_amount']==None:
                    proposal_quote_sent_amount=0
                else:
                    proposal_quote_sent_amount=proposal_quote_sent['total_amount']

                closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if closed_won['total_amount']==None:
                    closed_won_amount=0
                else:
                    closed_won_amount=closed_won['total_amount']
                
                aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if aborted_closed_lost['total_amount']==None:
                    aborted_closed_lost_amount=0
                else:
                    aborted_closed_lost_amount=aborted_closed_lost['total_amount']

       


                p = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_on__range=[fd,td])).count()
                # print("P:",p)

                i = Opportunity.objects.filter(Q(stage="Interest")& Q(created_on__range=[fd,td])).count()
                # print("I:",i)

                tp = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_on__range=[fd,td])).count()
                # print("TP:",tp)

                pcs = Opportunity.objects.filter(Q(stage="Proposal / Closed sent")& Q(created_on__range=[fd,td])).count()
                # print("PCS:",pcs)

                cw = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_on__range=[fd,td])).count()
                # print("CW:",cw)

                acl = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_on__range=[fd,td])).count()
                # print("ACL:",acl)

#############################
               



                funnel_prospect = p+i+tp+pcs+cw+acl
                # print("Prospect",funnel_prospect)
                funnel_interest = i+tp+pcs+cw+acl
                # print("Interest",funnel_interest)
                funnel_trial_poc = tp+pcs+cw+acl
                # print("Trial/poc",funnel_trial_poc)
                funnel_proposal_quote_sent = pcs+cw+acl
                # print("Proposal Quote sent",funnel_proposal_quote_sent)
                funnel_closed_won = cw
                funnel_aborted_closed_lost = acl

                trace1 = go.Funnel(
                y = [ "Prospect","Interest","Trial/POC","Proposal/Quote Sent","Closed/Won","Aborted/Closed Lost"],
                x = [funnel_prospect,funnel_interest,funnel_trial_poc,funnel_proposal_quote_sent,funnel_closed_won,funnel_aborted_closed_lost],
                text = [prospect_amount,interest_amount,trial_poc_amount,proposal_quote_sent_amount,closed_won_amount,aborted_closed_lost_amount],
                marker = {"color": ["#162252", "#27408B", "#386BD8", "#758FDC", "#99B2FF","#E5ECFF"]},
                hoverinfo = 'text')

                config={"displayModeBar": False}
                layout = go.Layout(
                    plot_bgcolor='rgba(0,0,0,0)',
                    # title = "Annual Sales",
                    margin = {"l": 5, "r": 5})
                

                div  = opy.plot(go.Figure([trace1],layout),config=config,output_type='div')




        ################################ Bar Graph values for Lead by Source #########################################################
                # call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(created_on__range=[fd,td])).count()
                # e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(created_on__range=[fd,td])).count()
                # existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(created_on__range=[fd,td])).count()
                # partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(created_on__range=[fd,td])).count()
                # public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(created_on__range=[fd,td])).count()
                # campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(created_on__range=[fd,td])).count()
                # website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(created_on__range=[fd,td])).count()
                # other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(created_on__range=[fd,td])).count()
                # none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(created_on__range=[fd,td])).count()


                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                
                context["sales_amount"] = date_field

                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities

                context["open"] = open
                context["inprogress"] = inprogress
                context["closed"] = closed

                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div

                context['prospect'] = prospect_amount
                context['interest'] = interest_amount
                context['trial_poc'] = trial_poc_amount
                context['proposal_quote_sent'] = proposal_quote_sent_amount
                context['closed_won'] = closed_won_amount
                context['aborted_closed_lost'] = aborted_closed_lost_amount
              


                context['prospect_dts'] = prospect_dts
                context['interest_dts'] = interest_dts
                context['trial_poc_dts'] = trial_poc_dts
                context['proposal_quote_sent_dts'] = proposal_quote_sent_dts
                context['closed_won_dts'] = closed_won_dts
                context['aborted_closed_lost_dts'] = aborted_closed_lost_dts


                context['call_dts'] = call_dts
                context['email_dts'] = email_dts
                context['existing_customer_dts'] = existing_customer_dts
                context['partner_dts'] = partner_dts
                context['public_relations_dts'] = public_relations_dts
                context['campaign_dts'] = campaign_dts
                context['website_dts'] = website_dts
                context['other_dts'] = other_dts
                context['none_dts'] = none_dts

                
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['date']=d
                context['tod']=tod

                return context
        else:
            print('yes')
            fd = datetime.strptime(d,"%d-%m-%Y").strftime("%Y-%m-%d")
            print(fd, "from date")
            opd =datetime.strptime(tod,"%d-%m-%Y").strftime("%Y-%m-%d")
            # print(td, "from date")

            date = datetime.strptime(opd, "%Y-%m-%d")
            print(date, "to date")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")
            print(td, '++++++++++')

            year,month,date = fd.split('-')

            y1 = int(year)
            print('year',y1)
            m1 = int(month)
            print('month',m1)
            d1 = int(date)
            print('date',d1)

            year,month,date = td.split('-')
            y2 = int(year)
            print('year',y2)
            m2 = int(month)
            print('month',m2)
            d2 = int(date)
            print('date',d2)

            date_field=[]
            prospect_dts = []
            interest_dts=[]
            trial_poc_dts=[]
            proposal_quote_sent_dts=[]
            closed_won_dts=[]
            aborted_closed_lost_dts=[]

            call_dts = []
            email_dts = []
            existing_customer_dts=[]
            partner_dts=[]
            public_relations_dts=[]
            campaign_dts =[]
            website_dts=[]
            other_dts=[]
            none_dts=[]

            a = datetime(y1, m1, d1)
            print('------',a)
            b = datetime(y2, m2, d2)
            print('////////',b)


            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  


                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)

                    if td == bn:
                        print('yes')
                    else:
                        date_field.append(um)
                        print(date_field, '-----------------------------')

                        op_prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(update_date__icontains=bn)).count()
                        prospect_dts.append(op_prospect)

                        op_interest = Opportunity.objects.filter(Q(stage="Interest")& Q(update_date__icontains=bn)).count()
                        interest_dts.append(op_interest)

                        op_trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(update_date__icontains=bn)).count()
                        trial_poc_dts.append(op_trial_poc)

                        op_proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(update_date__icontains=bn)).count()
                        proposal_quote_sent_dts.append(op_proposal_quote_sent)
                        
                        op_closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(update_date__icontains=bn)).count()
                        closed_won_dts.append(op_closed_won)

                        op_aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(update_date__icontains=bn)).count()
                        aborted_closed_lost_dts.append(op_aborted_closed_lost)

        # ################################ Lead by source  graph ##############################3
                        call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(update_date__icontains=bn)).count()
                        call_dts.append(call)
                        print(call_dts)

                        e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(update_date__icontains=bn)).count()
                        email_dts.append(e_mail)

                        existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(update_date__icontains=bn)).count()
                        existing_customer_dts.append(existing_customer)

                        partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(update_date__icontains=bn)).count()
                        partner_dts.append(partner)

                        public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(update_date__icontains=bn)).count()
                        public_relations_dts.append(public_relations)

                        campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(update_date__icontains=bn)).count()
                        campaign_dts.append(campaign)

                        website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(update_date__icontains=bn)).count()
                        website_dts.append(website)

                        other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(update_date__icontains=bn)).count()
                        other_dts.append(other)

                        none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(update_date__icontains=bn)).count()
                        none_dts.append(none)







                # open = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                # inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                # closed = Case.objects.filter(Q(status="Close")& Q(created_on__range=[fd,td])).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                            
                contact = Contact.objects.filter(created_on__range=[fd,td]).count()
                # print("CCOONNTTAACCTT:",contact)
                case = Case.objects.filter(created_on__range=[fd,td]).count()
                # print("case:",case)
                account = Account.objects.filter(created_on__range=[fd,td]).count()
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(HomeView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(Q(status="open")& Q(created_on__range=[fd,td]))
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(created_on__range=[fd,td]).exclude(status='converted').exclude(status='closed').count()
                print("No.of Lead:",count_lead)
                count_contact = Contact.objects.all().filter(created_on__range=[fd,td]).count()
                print("No.of contact:",count_contact)



        ##################################### Column Graph values for the sum of amount  ###########################################
                prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if prospect['total_amount']==None:
                    prospect_amount=0
                else:
                    prospect_amount=prospect['total_amount']

                interest = Opportunity.objects.filter(Q(stage="Interest")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if interest['total_amount']==None:
                    interest_amount=0
                else:
                    interest_amount=interest['total_amount']

                trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if trial_poc['total_amount']==None:
                   trial_poc_amount=0
                else:
                    trial_poc_amount=trial_poc['total_amount']
                # print(valueproposition_amount,"vpa")
                proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if proposal_quote_sent['total_amount']==None:
                    proposal_quote_sent_amount=0
                else:
                    proposal_quote_sent_amount=proposal_quote_sent['total_amount']

                closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if closed_won['total_amount']==None:
                    closed_won_amount=0
                else:
                    closed_won_amount=closed_won['total_amount']
                
                aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if aborted_closed_lost['total_amount']==None:
                    aborted_closed_lost_amount=0
                else:
                    aborted_closed_lost_amount=aborted_closed_lost['total_amount']

       


                p = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_on__range=[fd,td])).count()
                # print("P:",p)

                i = Opportunity.objects.filter(Q(stage="Interest")& Q(created_on__range=[fd,td])).count()
                # print("I:",i)

                tp = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_on__range=[fd,td])).count()
                # print("TP:",tp)

                pcs = Opportunity.objects.filter(Q(stage="Proposal / Closed sent")& Q(created_on__range=[fd,td])).count()
                # print("PCS:",pcs)

                cw = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_on__range=[fd,td])).count()
                # print("CW:",cw)

                acl = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_on__range=[fd,td])).count()
                # print("ACL:",acl)

#############################
               



                funnel_prospect = p+i+tp+pcs+cw+acl
                # print("Prospect",funnel_prospect)
                funnel_interest = i+tp+pcs+cw+acl
                # print("Interest",funnel_interest)
                funnel_trial_poc = tp+pcs+cw+acl
                # print("Trial/poc",funnel_trial_poc)
                funnel_proposal_quote_sent = pcs+cw+acl
                # print("Proposal Quote sent",funnel_proposal_quote_sent)
                funnel_closed_won = cw
                funnel_aborted_closed_lost = acl

                trace1 = go.Funnel(
                y = [ "Prospect","Interest","Trial/POC","Proposal/Quote Sent","Closed/Won","Aborted/Closed Lost"],
                x = [funnel_prospect,funnel_interest,funnel_trial_poc,funnel_proposal_quote_sent,funnel_closed_won,funnel_aborted_closed_lost],
                text = [prospect_amount,interest_amount,trial_poc_amount,proposal_quote_sent_amount,closed_won_amount,aborted_closed_lost_amount],
                marker = {"color": ["#162252", "#27408B", "#386BD8", "#758FDC", "#99B2FF","#E5ECFF"]},
                hoverinfo = 'text')

                config={"displayModeBar": False}
                layout = go.Layout(
                    plot_bgcolor='rgba(0,0,0,0)',
                    # title = "Annual Sales",
                    margin = {"l": 5, "r": 5})
                

                div  = opy.plot(go.Figure([trace1],layout),config=config,output_type='div')



        ################################ Bar Graph values for Lead by Source #########################################################
                # call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(created_on__range=[fd,td])).count()
                # e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(created_on__range=[fd,td])).count()
                # existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(created_on__range=[fd,td])).count()
                # partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(created_on__range=[fd,td])).count()
                # public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(created_on__range=[fd,td])).count()
                # campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(created_on__range=[fd,td])).count()
                # website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(created_on__range=[fd,td])).count()
                # other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(created_on__range=[fd,td])).count()
                # none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(created_on__range=[fd,td])).count()


                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                
                context["sales_amount"] = date_field

                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities

                # context["open"] = open
                # context["inprogress"] = inprogress
                # context["closed"] = closed

                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div

                context['prospect'] = prospect_amount
                context['interest'] = interest_amount
                context['trial_poc'] = trial_poc_amount
                context['proposal_quote_sent'] = proposal_quote_sent_amount
                context['closed_won'] = closed_won_amount
                context['aborted_closed_lost'] = aborted_closed_lost_amount
              


                context['prospect_dts'] = prospect_dts
                context['interest_dts'] = interest_dts
                context['trial_poc_dts'] = trial_poc_dts
                context['proposal_quote_sent_dts'] = proposal_quote_sent_dts
                context['closed_won_dts'] = closed_won_dts
                context['aborted_closed_lost_dts'] = aborted_closed_lost_dts


                context['call_dts'] = call_dts
                context['email_dts'] = email_dts
                context['existing_customer_dts'] = existing_customer_dts
                context['partner_dts'] = partner_dts
                context['public_relations_dts'] = public_relations_dts
                context['campaign_dts'] = campaign_dts
                context['website_dts'] = website_dts
                context['other_dts'] = other_dts
                context['none_dts'] = none_dts

                
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['date']=d
                context['tod']=tod

                return context
            
            else:

                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)

                    if td == bn:
                        print('yes')
                    else:
                        date_field.append(um)
                        print(date_field, '-----------------------------')

                        op_prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(update_date__icontains=bn)).count()
                        prospect_dts.append(op_prospect)

                        op_interest = Opportunity.objects.filter(Q(stage="Interest")& Q(update_date__icontains=bn)).count()
                        interest_dts.append(op_interest)

                        op_trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(update_date__icontains=bn)).count()
                        trial_poc_dts.append(op_trial_poc)

                        op_proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(update_date__icontains=bn)).count()
                        proposal_quote_sent_dts.append(op_proposal_quote_sent)
                        
                        op_closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(update_date__icontains=bn)).count()
                        closed_won_dts.append(op_closed_won)

                        op_aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(update_date__icontains=bn)).count()
                        aborted_closed_lost_dts.append(op_aborted_closed_lost)

        # ################################ Lead by source  graph ##############################3
                        call = Opportunity.objects.filter(Q(lead_source="CALL",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="CALL",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        call_dts.append(call)
                        print(call_dts)

                        e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="EMAIL",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        email_dts.append(e_mail)

                        existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="EXISTING CUSTOMER",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        existing_customer_dts.append(existing_customer)

                        partner = Opportunity.objects.filter(Q(lead_source="PARTNER",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="PARTNER",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        partner_dts.append(partner)

                        public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="PUBLIC RELATIONS",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        public_relations_dts.append(public_relations)

                        campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="CAMPAIGN",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        campaign_dts.append(campaign)

                        website = Opportunity.objects.filter(Q(lead_source="WEBSITE",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="WEBSITE",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        website_dts.append(website)

                        other = Opportunity.objects.filter(Q(lead_source="OTHER",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="OTHER",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        other_dts.append(other)

                        none = Opportunity.objects.filter(Q(lead_source="NONE",update_date__icontains=bn,created_by_id=self.request.user.id)|Q(lead_source="NONE",update_date__icontains=bn,assigned_to=self.request.user.id)).count()
                        none_dts.append(none)







                open = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed = Case.objects.filter(Q(status="Close")& Q(created_on__range=[fd,td])).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                            
                contact = Contact.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("CCOONNTTAACCTT:",contact)
                case = Case.objects.filter(created_on__range=[fd,td]).count()
                # print("case:",case)
                account = Account.objects.filter(created_on__range=[fd,td]).count()
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(HomeView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(Q(status="open")& Q(created_on__range=[fd,td]))
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).exclude(status='converted').exclude(status='closed').count()
                # print("No.of Lead:",count_lead)


        ##################################### Column Graph values for the sum of amount  ###########################################
                prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if prospect['total_amount']==None:
                    prospect_amount=0
                else:
                    prospect_amount=prospect['total_amount']

                interest = Opportunity.objects.filter(Q(stage="Interest")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if interest['total_amount']==None:
                    interest_amount=0
                else:
                    interest_amount=interest['total_amount']

                trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if trial_poc['total_amount']==None:
                   trial_poc_amount=0
                else:
                    trial_poc_amount=trial_poc['total_amount']
                # print(valueproposition_amount,"vpa")
                proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if proposal_quote_sent['total_amount']==None:
                    proposal_quote_sent_amount=0
                else:
                    proposal_quote_sent_amount=proposal_quote_sent['total_amount']

                closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if closed_won['total_amount']==None:
                    closed_won_amount=0
                else:
                    closed_won_amount=closed_won['total_amount']
                
                aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                if aborted_closed_lost['total_amount']==None:
                    aborted_closed_lost_amount=0
                else:
                    aborted_closed_lost_amount=aborted_closed_lost['total_amount']

       


                p = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_on__range=[fd,td])).count()
                # print("P:",p)

                i = Opportunity.objects.filter(Q(stage="Interest")& Q(created_on__range=[fd,td])).count()
                # print("I:",i)

                tp = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_on__range=[fd,td])).count()
                # print("TP:",tp)

                pcs = Opportunity.objects.filter(Q(stage="Proposal / Closed sent")& Q(created_on__range=[fd,td])).count()
                # print("PCS:",pcs)

                cw = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_on__range=[fd,td])).count()
                # print("CW:",cw)

                acl = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_on__range=[fd,td])).count()
                # print("ACL:",acl)

#############################
               



                funnel_prospect = p+i+tp+pcs+cw+acl
                # print("Prospect",funnel_prospect)
                funnel_interest = i+tp+pcs+cw+acl
                # print("Interest",funnel_interest)
                funnel_trial_poc = tp+pcs+cw+acl
                # print("Trial/poc",funnel_trial_poc)
                funnel_proposal_quote_sent = pcs+cw+acl
                # print("Proposal Quote sent",funnel_proposal_quote_sent)
                funnel_closed_won = cw
                funnel_aborted_closed_lost = acl

                trace1 = go.Funnel(
                y = [ "Prospect","Interest","Trial/POC","Proposal/Quote Sent","Closed/Won","Aborted/Closed Lost"],
                x = [funnel_prospect,funnel_interest,funnel_trial_poc,funnel_proposal_quote_sent,funnel_closed_won,funnel_aborted_closed_lost],
                text = [prospect_amount,interest_amount,trial_poc_amount,proposal_quote_sent_amount,closed_won_amount,aborted_closed_lost_amount],
                marker = {"color": ["#162252", "#27408B", "#386BD8", "#758FDC", "#99B2FF","#E5ECFF"]},
                hoverinfo = 'text')

                config={"displayModeBar": False}
                layout = go.Layout(
                    plot_bgcolor='rgba(0,0,0,0)',
                    # title = "Annual Sales",
                    margin = {"l": 5, "r": 5})
                

                div  = opy.plot(go.Figure([trace1],layout),config=config,output_type='div')


        ################################ Bar Graph values for Lead by Source #########################################################
                # call = Opportunity.objects.filter(Q(lead_source="CALL")& Q(created_on__range=[fd,td])).count()
                # e_mail = Opportunity.objects.filter(Q(lead_source="EMAIL")& Q(created_on__range=[fd,td])).count()
                # existing_customer = Opportunity.objects.filter(Q(lead_source="EXISTING CUSTOMER")& Q(created_on__range=[fd,td])).count()
                # partner = Opportunity.objects.filter(Q(lead_source="PARTNER")& Q(created_on__range=[fd,td])).count()
                # public_relations = Opportunity.objects.filter(Q(lead_source="PUBLIC RELATIONS")& Q(created_on__range=[fd,td])).count()
                # campaign = Opportunity.objects.filter(Q(lead_source="CAMPAIGN")& Q(created_on__range=[fd,td])).count()
                # website = Opportunity.objects.filter(Q(lead_source="WEBSITE")& Q(created_on__range=[fd,td])).count()
                # other = Opportunity.objects.filter(Q(lead_source="OTHER")& Q(created_on__range=[fd,td])).count()
                # none = Opportunity.objects.filter(Q(lead_source="NONE")& Q(created_on__range=[fd,td])).count()


                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                
                context["sales_amount"] = date_field

                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities

                context["open"] = open
                context["inprogress"] = inprogress
                context["closed"] = closed

                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div

                context['prospect'] = prospect_amount
                context['interest'] = interest_amount
                context['trial_poc'] = trial_poc_amount
                context['proposal_quote_sent'] = proposal_quote_sent_amount
                context['closed_won'] = closed_won_amount
                context['aborted_closed_lost'] = aborted_closed_lost_amount
              


                context['prospect_dts'] = prospect_dts
                context['interest_dts'] = interest_dts
                context['trial_poc_dts'] = trial_poc_dts
                context['proposal_quote_sent_dts'] = proposal_quote_sent_dts
                context['closed_won_dts'] = closed_won_dts
                context['aborted_closed_lost_dts'] = aborted_closed_lost_dts

                context['call_dts'] = call_dts
                context['email_dts'] = email_dts
                context['existing_customer_dts'] = existing_customer_dts
                context['partner_dts'] = partner_dts
                context['public_relations_dts'] = public_relations_dts
                context['campaign_dts'] = campaign_dts
                context['website_dts'] = website_dts
                context['other_dts'] = other_dts
                context['none_dts'] = none_dts

                
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['date']=d
                context['tod']=tod

                return context

class SalesIndividual(SalesAccessRequiredMixin, LoginRequiredMixin, TemplateView):
    template_name = "sales/sales_ind.html"

    def get_context_data(self, **kwargs):
        dataset = Case.objects \
        .values('status') \
        .annotate(assigned_count=Count('status', filter=Q(status="Assigned")),
                  pending_count=Count('status', filter=Q(status="Pending")), 
                  closed_count=Count('status', filter=Q(status="Closed")),
                  rejected=Count('status',filter=Q(status="Rejected"))) 
        # print("dataset",dataset)

        # d1 = datetime.now().strftime("%Y-%m-%d")

        d = self.request.GET.get('fromstatus')
        print("Start date:",d)

        tod = self.request.GET.get('toostatus')
        print('End date:',tod)

        if d == None and tod == None:
            # print("yes")
            # fd=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%Y-%m-%d")
            # std=datetime.today().replace(day=1, hour=0, minute=0, second=0, microsecond=0).strftime("%d-%m-%Y")
            fd = datetime.now().strftime("%Y-%m-%d")
            std = datetime.now().strftime("%d-%m-%Y")
            d = std

            year,month,date = fd.split('-')

            y1 = int(year)
            m1 = int(month)
            d1 = int(date)


            # for to date
            opd = datetime.now().strftime("%Y-%m-%d")
            tod =datetime.now().strftime("%d-%m-%Y")

            date = datetime.strptime(opd, "%Y-%m-%d")
            print(date, "date")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")

            year,month,date = td.split('-')
            y2 = int(year)
            m2 = int(month)
            d2 = int(date)

            print(fd, '----------')
            print(td, '++++++++++')
            

    
            date_field=[]
            
            a = datetime(y1, m1, d1)
            b = datetime(y2, m2, d2)

            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  


                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)

                    if td == bn:
                        print('yes')
                    else:
                        date_field.append(um)
                        print(date_field, '-----------------------------')

                contact = Contact.objects.filter(created_on__range=[fd,td]).count()
                # print("CCOONNTTAACCTT:",contact)
                case = Case.objects.filter(created_on__range=[fd,td]).count()
                # print("case:",case)
                account = Account.objects.filter(created_on__range=[fd,td]).count()
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(SalesIndividual, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(Q(status="open")& Q(created_on__range=[fd,td]))
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(created_on__range=[fd,td]).exclude(status='converted').exclude(status='closed').count()
                print("No.of Lead:",count_lead)
                count_contact = Contact.objects.all().filter(created_on__range=[fd,td]).count()
                print("No.of contact:",count_contact)

                idd = User.objects.values('id','username').all()
                print(idd)
                stage_data=[]
                for i in idd:
                    temp={}
                    id = i['id']
                    user = i['username']
                    print(user)
                    prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("PROSPECT:",prospect)
                    if prospect['total_amount']==None:
                       prospect_amount = 0
                    else:
                        prospect_amount = float(prospect['total_amount'])
         
                    interest = Opportunity.objects.filter(Q(stage="Interest")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("INTEREST:",interest)
                    if interest['total_amount']==None:
                       interest_amount = 0
                    else:
                        interest_amount = float(interest['total_amount'])

                    trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("Trial POC:",trial_poc)
                    if trial_poc['total_amount']==None:
                       trial_poc_amount =0
                    else:
                        trial_poc_amount = float(trial_poc['total_amount'])

                    proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("Proposal / Quote sent:",proposal_quote_sent)
                    if proposal_quote_sent['total_amount']==None:
                       proposal_quote_sent_amount = 0
                    else:
                       proposal_quote_sent_amount = float(proposal_quote_sent['total_amount'])

                    closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("Closed/won:",closed_won)
                    if closed_won['total_amount']==None:
                       closed_won_amount = 0
                    else:
                        closed_won_amount = float(closed_won['total_amount'])

                    aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("Aborted / Closed Lost:",aborted_closed_lost)
                    if aborted_closed_lost['total_amount']==None:
                       aborted_closed_lost_amount =0
                    else:
                        aborted_closed_lost_amount = float(aborted_closed_lost['total_amount'])

                               
                    temp['username']=user
                    temp['prospect']=prospect_amount
                    temp['interest']=interest_amount
                    temp['trial_poc']=trial_poc_amount
                    temp['proposal_quote_sent']=proposal_quote_sent_amount
                    temp['closed_won']=closed_won_amount
                    temp['aborted_closed_lost']=aborted_closed_lost_amount
                    stage_data.append(temp)
                print(stage_data)
                    


                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                
                context["sales_amount"] = date_field
                context["sdata"] = stage_data
                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities

               

                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account


               
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['date']=d
                context['tod']=tod

                return context
            
            else:

                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)

                    if td == bn:
                        print('yes')
                    else:
                        date_field.append(um)
                        print(date_field, '-----------------------------')

                open = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                closed = Case.objects.filter(Q(status="Close")& Q(created_on__range=[fd,td])).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                            
                contact = Contact.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("CCOONNTTAACCTT:",contact)
                case = Case.objects.filter(created_on__range=[fd,td]).count()
                # print("case:",case)
                account = Account.objects.filter(created_on__range=[fd,td]).count()
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(HomeView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(Q(status="open")& Q(created_on__range=[fd,td]))
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).exclude(status='converted').exclude(status='closed').count()
                # print("No.of Lead:",count_lead)


                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                
                context["sales_amount"] = date_field

                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities

                

                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['date']=d
                context['tod']=tod

                return context
        else:
            print('yes')
            fd = datetime.strptime(d,"%d-%m-%Y").strftime("%Y-%m-%d")
            print(fd, "fd-from date")
            opd =datetime.strptime(tod,"%d-%m-%Y").strftime("%Y-%m-%d")
            # print(td, "from date")

            date = datetime.strptime(opd, "%Y-%m-%d")
            print(date, "to date")
            modified_date = date + timedelta(days=1)
            td = datetime.strftime(modified_date, "%Y-%m-%d")
            print(td, '++++++++++')

            year,month,date = fd.split('-')

            y1 = int(year)
            print('year',y1)
            m1 = int(month)
            print('month',m1)
            d1 = int(date)
            print('date',d1)

            year,month,date = td.split('-')
            y2 = int(year)
            print('year',y2)
            m2 = int(month)
            print('month',m2)
            d2 = int(date)
            print('date',d2)

            date_field=[]
            
            a = datetime(y1, m1, d1)
            print('------',a)
            b = datetime(y2, m2, d2)
            print('////////',b)


            if self.request.user.role == "ADMIN" or self.request.user.is_superuser:  


                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)

                    if td == bn:
                        print('yes')
                    else:
                        date_field.append(um)
                        print(date_field, '-----------------------------')


                # open = Case.objects.filter(Q(status="Open")& Q(created_on__range=[fd,td])).count()
                # inprogress = Case.objects.filter(Q(status="In Progress")& Q(created_on__range=[fd,td])).count()
                # closed = Case.objects.filter(Q(status="Close")& Q(created_on__range=[fd,td])).count()
                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                            
                contact = Contact.objects.filter(created_on__range=[fd,td]).count()
                # print("CCOONNTTAACCTT:",contact)
                case = Case.objects.filter(created_on__range=[fd,td]).count()
                # print("case:",case)
                account = Account.objects.filter(created_on__range=[fd,td]).count()
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(SalesIndividual, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(Q(status="open")& Q(created_on__range=[fd,td]))
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(created_on__range=[fd,td]).count()
                print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(created_on__range=[fd,td]).exclude(status='converted').exclude(status='closed').count()
                print("No.of Lead:",count_lead)
                count_contact = Contact.objects.all().filter(created_on__range=[fd,td]).count()
                print("No.of contact:",count_contact)
                idd = User.objects.values('id','username').all()
                print(idd)
                stage_data=[]
                for i in idd:
                    temp={}
                    id = i['id']
                    user = i['username']
                    print(user)
                    prospect = Opportunity.objects.filter(Q(stage="Prospect")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("PROSPECT:",prospect)
                    if prospect['total_amount']==None:
                       prospect_amount = 0
                    else:
                        prospect_amount = float(prospect['total_amount'])
         
                    interest = Opportunity.objects.filter(Q(stage="Interest")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("INTEREST:",interest)
                    if interest['total_amount']==None:
                       interest_amount = "0"
                    else:
                        interest_amount = float(interest['total_amount'])

                    trial_poc = Opportunity.objects.filter(Q(stage="Trial / POC")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("Trial POC:",trial_poc)
                    if trial_poc['total_amount']==None:
                       trial_poc_amount = "0"
                    else:
                        trial_poc_amount = float(trial_poc['total_amount'])

                    proposal_quote_sent = Opportunity.objects.filter(Q(stage="Proposal / Quote sent")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("Proposal / Quote sent:",proposal_quote_sent)
                    if proposal_quote_sent['total_amount']==None:
                       proposal_quote_sent_amount = "0"
                    else:
                       proposal_quote_sent_amount = float(proposal_quote_sent['total_amount'])

                    closed_won = Opportunity.objects.filter(Q(stage="Closed / Won")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("Closed/won:",closed_won)
                    if closed_won['total_amount']==None:
                       closed_won_amount = "0"
                    else:
                        closed_won_amount = float(closed_won['total_amount'])

                    aborted_closed_lost = Opportunity.objects.filter(Q(stage="Aborted / Closed Lost")& Q(created_by_id=id)& Q(created_on__range=[fd,td])).aggregate(total_amount=Sum('amount'))
                    print("Aborted / Closed Lost:",aborted_closed_lost)
                    if aborted_closed_lost['total_amount']==None:
                       aborted_closed_lost_amount = "0"
                    else:
                        aborted_closed_lost_amount = float(aborted_closed_lost['total_amount'])

                               
                    temp['username']=user
                    temp['prospect']=prospect_amount
                    temp['interest']=interest_amount
                    temp['trial_poc']=trial_poc_amount
                    temp['proposal_quote_sent']=proposal_quote_sent_amount
                    temp['closed_won']=closed_won_amount
                    temp['aborted_closed_lost']=aborted_closed_lost_amount
                    stage_data.append(temp)
                print(stage_data)
                    
                ############################################################################################
                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                
                context["sales_amount"] = date_field
                context['sdata'] = stage_data
                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities

                # context["open"] = open
                # context["inprogress"] = inprogress
                # context["closed"] = closed

                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                
                
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['date']=d
                context['tod']=tod

                return context
            
            else:

                for dt in rrule(DAILY, dtstart=a, until=b):
                    um = dt.strftime("%d-%m-%Y")
                    print(um, "////////////////////////////////////")
                    bn = dt.strftime("%Y-%m-%d")
                    # print(bn)

                    if td == bn:
                        print('yes')
                    else:
                        date_field.append(um)
                        print(date_field, '-----------------------------')


                # rejected = Case.objects.filter(Q(status="Rejected")& Q(created_on__icontains=d)).count()
                # duplicate = Case.objects.filter(Q(status="Duplicate")& Q(created_on__icontains=d)).count()
                # new = Case.objects.filter(Q(status="New")& Q(created_on__icontains=d)).count()
                            
                contact = Contact.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("CCOONNTTAACCTT:",contact)
                case = Case.objects.filter(created_on__range=[fd,td]).count()
                # print("case:",case)
                account = Account.objects.filter(created_on__range=[fd,td]).count()
            # return render(request, 'sales/index.html', {'dataset': dataset,"as":assigned,"pending":pending,"closed":closed})
                context = super(HomeView, self).get_context_data(**kwargs)
                accounts = Account.objects.filter(Q(status="open")& Q(created_on__range=[fd,td]))
                contacts = Contact.objects.all().filter(created_on__range=[fd,td])
                cases = Case.objects.all().filter(created_on__range=[fd,td])
                leads = Lead.objects.exclude(status='converted').exclude(status='closed')
                opportunities = Opportunity.objects.all().filter(created_on__range=[fd,td])
        ###################################### Number of Accounts, Leads,Opportunities ###########################################################################################
                count_opportunities = Opportunity.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("No.of Opportunities:",count_opportunities)
                count_account = Account.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).count()
                # print("No.of Account:",count_account)
                count_lead = Lead.objects.filter(Q(created_on__range=[fd,td],created_by_id=self.request.user.id) |Q(created_on__range=[fd,td],assigned_to=self.request.user.id)).exclude(status='converted').exclude(status='closed').count()
                # print("No.of Lead:",count_lead)


                if self.request.user.role == "ADMIN" or self.request.user.is_superuser:
                    pass
                else:
                    accounts = accounts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    contacts = contacts.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    leads = leads.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id)).exclude(status='closed')
                    opportunities = opportunities.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    case = cases.filter(
                        Q(assigned_to__id__in=[self.request.user.id]) |
                        Q(created_by=self.request.user.id))
                    
                        
                
                context["sales_amount"] = date_field

                context["accounts"] = accounts
                context["contacts_count"] = contacts.count()
                context["leads_count"] = leads
                context["opportunities"] = opportunities

                

                context["contact"] = contact
                context["cases"] = cases.count()
                context["account"] = account
                context['graph'] = div


                
                context['countopportunities'] = count_opportunities
                context['countaccount'] = count_account
                context['countlead'] = count_lead
                context['date']=d
                context['tod']=tod

                return context




class ChangePasswordView(LoginRequiredMixin, TemplateView):
    template_name = "change_password.html"

    def get_context_data(self, **kwargs):
        context = super(ChangePasswordView, self).get_context_data(**kwargs)
        context["change_password_form"] = ChangePasswordForm()
        return context

    def post(self, request, *args, **kwargs):
        error, errors = "", ""
        form = ChangePasswordForm(request.POST, user=request.user)
        if form.is_valid():
            user = request.user
            # if not check_password(request.POST.get('CurrentPassword'),
            #                       user.password):
            #     error = "Invalid old password"
            # else:
            user.set_password(request.POST.get('Newpassword'))
            user.is_active = True
            user.save()
            return HttpResponseRedirect('/')
        else:
            errors = form.errors
        return render(request, "change_password.html",
                      {'error': error, 'errors': errors,
                       'change_password_form': form})


class ProfileView(LoginRequiredMixin, TemplateView):
    template_name = "profile.html"

    def get_context_data(self, **kwargs):

        context = super(ProfileView, self).get_context_data(**kwargs)
        context["user_obj"] = self.request.user
        return context


class LoginView(TemplateView):
    template_name = "login.html"

    def get_context_data(self, **kwargs):
        context = super(LoginView, self).get_context_data(**kwargs)
        context["ENABLE_GOOGLE_LOGIN"] = settings.ENABLE_GOOGLE_LOGIN
        context["GP_CLIENT_SECRET"] = settings.GP_CLIENT_SECRET
        context["GP_CLIENT_ID"] = settings.GP_CLIENT_ID
        return context

    def dispatch(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return HttpResponseRedirect('/')
        return super(LoginView, self).dispatch(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        form = LoginForm(request.POST, request=request)
        if form.is_valid():

            user = User.objects.filter(email=request.POST.get('email')).first()
            # user = authenticate(username=request.POST.get('email'), password=request.POST.get('password'))
            if user is not None:
                if user.is_active:
                    user = authenticate(username=request.POST.get(
                        'email'), password=request.POST.get('password'))
                    if user is not None:
                        login(request, user)
                        if user.has_sales_access:
                            return HttpResponseRedirect('/')
                        elif user.has_marketing_access:
                            return redirect('marketing:dashboard')
                        else:
                            return HttpResponseRedirect('/')
                    return render(request, "login.html", {
                        "ENABLE_GOOGLE_LOGIN": settings.ENABLE_GOOGLE_LOGIN,
                        "GP_CLIENT_SECRET": settings.GP_CLIENT_SECRET,
                        "GP_CLIENT_ID": settings.GP_CLIENT_ID,
                        "error": True,
                        "message":
                        "Your username and password didn't match. \
                        Please try again."
                    })
                return render(request, "login.html", {
                    "ENABLE_GOOGLE_LOGIN": settings.ENABLE_GOOGLE_LOGIN,
                    "GP_CLIENT_SECRET": settings.GP_CLIENT_SECRET,
                    "GP_CLIENT_ID": settings.GP_CLIENT_ID,
                    "error": True,
                    "message":
                    "Your account is inactive. Please contact administrator"
                })
            return render(request, "login.html", {
                "ENABLE_GOOGLE_LOGIN": settings.ENABLE_GOOGLE_LOGIN,
                "GP_CLIENT_SECRET": settings.GP_CLIENT_SECRET,
                "GP_CLIENT_ID": settings.GP_CLIENT_ID,
                "error": True,
                "message":
                "Your account is not found. Please contact administrator"
            })

        return render(request, "login.html", {
            "ENABLE_GOOGLE_LOGIN": settings.ENABLE_GOOGLE_LOGIN,
            "GP_CLIENT_SECRET": settings.GP_CLIENT_SECRET,
            "GP_CLIENT_ID": settings.GP_CLIENT_ID,
            # "error": True,
            # "message": "Your username and password didn't match. Please try again."
            "form": form
        })


class ForgotPasswordView(TemplateView):
    template_name = "forgot_password.html"


class LogoutView(LoginRequiredMixin, View):

    def get(self, request, *args, **kwargs):
        logout(request)
        request.session.flush()
        return redirect("common:login")


class UsersListView(AdminRequiredMixin, TemplateView):
    model = User
    context_object_name = "users"
    template_name = "list.html"

    def get_queryset(self):
        queryset = self.model.objects.all()

        request_post = self.request.POST
        if request_post:
            if request_post.get('username'):
                queryset = queryset.filter(
                    username__icontains=request_post.get('username'))
            if request_post.get('email'):
                queryset = queryset.filter(
                    email__icontains=request_post.get('email'))
            if request_post.get('role'):
                queryset = queryset.filter(
                    role=request_post.get('role'))
            if request_post.get('status'):
                queryset = queryset.filter(
                    is_active=request_post.get('status'))

        return queryset.order_by('username')

    def get_context_data(self, **kwargs):
        context = super(UsersListView, self).get_context_data(**kwargs)
        active_users = self.get_queryset().filter(is_active=True)
        inactive_users = self.get_queryset().filter(is_active=False)
        context["active_users"] = active_users
        context["inactive_users"] = inactive_users
        context["per_page"] = self.request.POST.get('per_page')
        context['admin_email'] = settings.ADMIN_EMAIL
        context['roles'] = ROLES
        context['status'] = [('True', 'Active'), ('False', 'In Active')]
        return context

    def post(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)


class CreateUserView(AdminRequiredMixin, CreateView):
    model = User
    form_class = UserForm
    template_name = "create.html"
    # success_url = '/users/list/'

    def form_valid(self, form):
        user = form.save(commit=False)
        if form.cleaned_data.get("password"):
            user.set_password(form.cleaned_data.get("password"))
        user.save()

        if self.request.POST.getlist('teams'):
            for team in self.request.POST.getlist('teams'):
                Teams.objects.filter(id=team).first().users.add(user)

        current_site = self.request.get_host()
        protocol = self.request.scheme
        send_email_to_new_user.delay(user.email, self.request.user.email,
                                     domain=current_site, protocol=protocol)
        # mail_subject = 'Created account in CRM'
        # message = render_to_string('new_user.html', {
        #     'user': user,
        #     'created_by': self.request.user

        # })
        # email = EmailMessage(mail_subject, message, to=[user.email])
        # email.content_subtype = "html"
        # email.send()

        if self.request.is_ajax():
            data = {'success_url': reverse_lazy(
                'common:users_list'), 'error': False}
            return JsonResponse(data)
        return super(CreateUserView, self).form_valid(form)

    def form_invalid(self, form):
        response = super(CreateUserView, self).form_invalid(form)
        if self.request.is_ajax():
            return JsonResponse({'error': True, 'errors': form.errors})
        return response

    def get_form_kwargs(self):
        kwargs = super(CreateUserView, self).get_form_kwargs()
        kwargs.update({"request_user": self.request.user})
        return kwargs

    def get_context_data(self, **kwargs):
        context = super(CreateUserView, self).get_context_data(**kwargs)
        context["user_form"] = context["form"]
        context["teams"] = Teams.objects.all()
        if "errors" in kwargs:
            context["errors"] = kwargs["errors"]
        return context


class UserDetailView(AdminRequiredMixin, DetailView):
    model = User
    context_object_name = "users"
    template_name = "user_detail.html"

    def get_context_data(self, **kwargs):
        context = super(UserDetailView, self).get_context_data(**kwargs)
        user_obj = self.object
        users_data = []
        for each in User.objects.all():
            assigned_dict = {}
            assigned_dict['id'] = each.id
            assigned_dict['name'] = each.username
            users_data.append(assigned_dict)
        context.update({
            "user_obj": user_obj,
            "opportunity_list":
            Opportunity.objects.filter(assigned_to=user_obj.id),
            "contacts": Contact.objects.filter(assigned_to=user_obj.id),
            "cases": Case.objects.filter(assigned_to=user_obj.id),
            # "accounts": Account.objects.filter(assigned_to=user_obj.id),
            "assigned_data": json.dumps(users_data),
            "comments": user_obj.user_comments.all(),
        })
        return context


class UpdateUserView(LoginRequiredMixin, UpdateView):
    model = User
    form_class = UserForm
    template_name = "create.html"

    def form_valid(self, form):
        user = form.save(commit=False)
        if self.request.is_ajax():
            if (self.request.user.role != "ADMIN" and not
                    self.request.user.is_superuser):
                if self.request.user.id != self.object.id:
                    data = {'error_403': True, 'error': True}
                    return JsonResponse(data)
        if user.role == "USER":
            user.is_superuser = False
        user.save()

        if self.request.POST.getlist('teams'):
            user_teams = user.user_teams.all()
            # this is for removing the user from previous team
            for user_team in user_teams:
                user_team.users.remove(user)
            # this is for assigning the user to new team
            for team in self.request.POST.getlist('teams'):
                team_obj = Teams.objects.filter(id=team).first()
                team_obj.users.add(user)

        if (self.request.user.role == "ADMIN" and
                self.request.user.is_superuser):
            if self.request.is_ajax():
                data = {'success_url': reverse_lazy(
                    'common:users_list'), 'error': False}
                if self.request.user.id == user.id:
                    data = {'success_url': reverse_lazy(
                        'common:users_list'), 'error': False}
                    return JsonResponse(data)
                return JsonResponse(data)
        if self.request.is_ajax():
            data = {'success_url': reverse_lazy(
                'common:users_list'), 'error': False}
            return JsonResponse(data)
        return super(UpdateUserView, self).form_valid(form)

    def form_invalid(self, form):
        response = super(UpdateUserView, self).form_invalid(form)
        if self.request.is_ajax():
            return JsonResponse({'error': True, 'errors': form.errors})
        return response

    def get_form_kwargs(self):
        kwargs = super(UpdateUserView, self).get_form_kwargs()
        kwargs.update({"request_user": self.request.user})
        return kwargs

    def get_context_data(self, **kwargs):
        context = super(UpdateUserView, self).get_context_data(**kwargs)
        context["user_obj"] = self.object
        user_profile_name = str(context["user_obj"].profile_pic).split("/")
        user_profile_name = user_profile_name[-1]
        context["user_profile_name"] = user_profile_name
        context["user_form"] = context["form"]
        context["teams"] = Teams.objects.all()
        if "errors" in kwargs:
            context["errors"] = kwargs["errors"]
        return context


class UserDeleteView(AdminRequiredMixin, DeleteView):
    model = User

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        current_site = request.get_host()
        deleted_by = self.request.user.email
        send_email_user_delete.delay(
            self.object.email, deleted_by=deleted_by, domain=current_site, protocol=request.scheme)
        self.object.delete()
        lead_users = User.objects.filter(
            is_active=True).order_by('email').values('id', 'email')
        cache.set('lead_form_users', lead_users, 60*60)
        return redirect("common:users_list")


class PasswordResetView(PasswordResetView):
    template_name = 'registration/password_reset_form.html'
    form_class = PasswordResetEmailForm
    email_template_name = 'registration/password_reset_email.html'
    html_email_template_name = 'registration/password_reset_email.html'
    from_email = settings.PASSWORD_RESET_MAIL_FROM_USER


@login_required
@sales_access_required
def document_create(request):
    template_name = "doc_create.html"
    users = []
    if request.user.role == 'ADMIN' or request.user.is_superuser:
        users = User.objects.filter(is_active=True).order_by('email')
    else:
        users = User.objects.filter(role='ADMIN').order_by('email')
    form = DocumentForm(users=users)
    if request.POST:
        form = DocumentForm(request.POST, request.FILES, users=users)
        if form.is_valid():
            doc = form.save(commit=False)
            doc.created_by = request.user
            doc.save()
            if request.POST.getlist('shared_to'):
                doc.shared_to.add(*request.POST.getlist('shared_to'))
            if request.POST.getlist('teams', []):
                user_ids = Teams.objects.filter(id__in=request.POST.getlist(
                    'teams')).values_list('users', flat=True)
                assinged_to_users_ids = doc.shared_to.all().values_list('id', flat=True)
                for user_id in user_ids:
                    if user_id not in assinged_to_users_ids:
                        doc.shared_to.add(user_id)

            if request.POST.getlist('teams', []):
                doc.teams.add(*request.POST.getlist('teams'))

            data = {'success_url': reverse_lazy(
                'common:doc_list'), 'error': False}
            return JsonResponse(data)
        return JsonResponse({'error': True, 'errors': form.errors})
    context = {}
    context["doc_form"] = form
    context["users"] = users
    context["teams"] = Teams.objects.all()
    context["sharedto_list"] = [
        int(i) for i in request.POST.getlist('assigned_to', []) if i]
    context["errors"] = form.errors
    return render(request, template_name, context)


class DocumentListView(SalesAccessRequiredMixin, LoginRequiredMixin, TemplateView):
    model = Document
    context_object_name = "documents"
    template_name = "doc_list_1.html"

    def get_queryset(self):
        queryset = self.model.objects.all()
        if self.request.user.is_superuser or self.request.user.role == "ADMIN":
            queryset = queryset
        else:
            if self.request.user.documents():
                doc_ids = self.request.user.documents().values_list('id',
                                                                    flat=True)
                shared_ids = queryset.filter(
                    Q(status='active') &
                    Q(shared_to__id__in=[self.request.user.id])).values_list(
                    'id', flat=True)
                queryset = queryset.filter(
                    Q(id__in=doc_ids) | Q(id__in=shared_ids))
            else:
                queryset = queryset.filter(Q(status='active') & Q(
                    shared_to__id__in=[self.request.user.id]))

        request_post = self.request.POST
        if request_post:
            if request_post.get('doc_name'):
                queryset = queryset.filter(
                    title__icontains=request_post.get('doc_name'))
            if request_post.get('status'):
                queryset = queryset.filter(status=request_post.get('status'))

            if request_post.getlist('shared_to'):
                queryset = queryset.filter(
                    shared_to__id__in=request_post.getlist('shared_to'))
        return queryset

    def get_context_data(self, **kwargs):
        context = super(DocumentListView, self).get_context_data(**kwargs)
        context["users"] = User.objects.filter(
            is_active=True).order_by('email')
        context["documents"] = self.get_queryset()
        context["status_choices"] = Document.DOCUMENT_STATUS_CHOICE
        context["sharedto_list"] = [
            int(i) for i in self.request.POST.getlist('shared_to', []) if i]
        context["per_page"] = self.request.POST.get('per_page')

        search = False
        if (
            self.request.POST.get('doc_name') or
            self.request.POST.get('status') or
            self.request.POST.get('shared_to')
        ):
            search = True

        context["search"] = search
        return context

    def post(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)


class DocumentDeleteView(LoginRequiredMixin, DeleteView):
    model = Document

    def get(self, request, *args, **kwargs):
        if not request.user.role == 'ADMIN':
            if not request.user == Document.objects.get(id=kwargs['pk']).created_by:
                raise PermissionDenied
        self.object = self.get_object()
        self.object.delete()
        return redirect("common:doc_list")


@login_required
@sales_access_required
def document_update(request, pk):
    template_name = "doc_create.html"
    users = []
    if request.user.role == 'ADMIN' or request.user.is_superuser:
        users = User.objects.filter(is_active=True).order_by('email')
    else:
        users = User.objects.filter(role='ADMIN').order_by('email')
    document = Document.objects.filter(id=pk).first()
    form = DocumentForm(users=users, instance=document)

    if request.POST:
        form = DocumentForm(request.POST, request.FILES,
                            instance=document, users=users)
        if form.is_valid():
            doc = form.save(commit=False)
            doc.save()

            doc.shared_to.clear()
            if request.POST.getlist('shared_to'):
                doc.shared_to.add(*request.POST.getlist('shared_to'))

            if request.POST.getlist('teams', []):
                user_ids = Teams.objects.filter(id__in=request.POST.getlist(
                    'teams')).values_list('users', flat=True)
                assinged_to_users_ids = doc.shared_to.all().values_list('id', flat=True)
                for user_id in user_ids:
                    if user_id not in assinged_to_users_ids:
                        doc.shared_to.add(user_id)

            if request.POST.getlist('teams', []):
                doc.teams.clear()
                doc.teams.add(*request.POST.getlist('teams'))
            else:
                doc.teams.clear()

            data = {'success_url': reverse_lazy(
                'common:doc_list'), 'error': False}
            return JsonResponse(data)
        return JsonResponse({'error': True, 'errors': form.errors})
    context = {}
    context["doc_obj"] = document
    context["doc_form"] = form
    context["doc_file_name"] = context["doc_obj"].document_file.name.split(
        "/")[-1]
    context["users"] = users
    context["teams"] = Teams.objects.all()
    context["sharedto_list"] = [
        int(i) for i in request.POST.getlist('shared_to', []) if i]
    context["errors"] = form.errors
    return render(request, template_name, context)


class DocumentDetailView(SalesAccessRequiredMixin, LoginRequiredMixin, DetailView):
    model = Document
    template_name = "doc_detail.html"

    def dispatch(self, request, *args, **kwargs):
        if not request.user.role == 'ADMIN':
            if (not request.user ==
                    Document.objects.get(id=kwargs['pk']).created_by):
                raise PermissionDenied

        return super(DocumentDetailView, self).dispatch(
            request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super(DocumentDetailView, self).get_context_data(**kwargs)
        # documents = Document.objects.all()
        context.update({
            "file_type_code": self.object.file_type()[1],
            "doc_obj": self.object,
        })
        return context


def download_document(request, pk):
    # doc_obj = Document.objects.filter(id=pk).last()
    doc_obj = Document.objects.get(id=pk)
    if doc_obj:
        if not request.user.role == 'ADMIN':
            if (not request.user == doc_obj.created_by and
                    request.user not in doc_obj.shared_to.all()):
                raise PermissionDenied
        if settings.STORAGE_TYPE == "normal":
            # print('no no no no')
            path = doc_obj.document_file.path
            file_path = os.path.join(settings.MEDIA_ROOT, path)
            if os.path.exists(file_path):
                with open(file_path, 'rb') as fh:
                    response = HttpResponse(
                        fh.read(), content_type="application/vnd.ms-excel")
                    response['Content-Disposition'] = 'inline; filename=' + \
                        os.path.basename(file_path)
                    return response
        else:
            file_path = doc_obj.document_file
            file_name = doc_obj.title
            # print(file_path)
            # print(file_name)
            BUCKET_NAME = "django-crm-demo"
            KEY = str(file_path)
            s3 = boto3.resource('s3')
            try:
                s3.Bucket(BUCKET_NAME).download_file(KEY, file_name)
                # print('got it')
                with open(file_name, 'rb') as fh:
                    response = HttpResponse(
                        fh.read(), content_type="application/vnd.ms-excel")
                    response['Content-Disposition'] = 'inline; filename=' + \
                        os.path.basename(file_name)
                os.remove(file_name)
                return response
            except botocore.exceptions.ClientError as e:
                if e.response['Error']['Code'] == "404":
                    print("The object does not exist.")
                else:
                    raise

            return path
    raise Http404


def download_attachment(request, pk): # pragma: no cover
    attachment_obj = Attachments.objects.filter(id=pk).last()
    if attachment_obj:
        if settings.STORAGE_TYPE == "normal":
            path = attachment_obj.attachment.path
            file_path = os.path.join(settings.MEDIA_ROOT, path)
            if os.path.exists(file_path):
                with open(file_path, 'rb') as fh:
                    response = HttpResponse(
                        fh.read(), content_type="application/vnd.ms-excel")
                    response['Content-Disposition'] = 'inline; filename=' + \
                        os.path.basename(file_path)
                    return response
        else:
            file_path = attachment_obj.attachment
            file_name = attachment_obj.file_name
            # print(file_path)
            # print(file_name)
            BUCKET_NAME = "django-crm-demo"
            KEY = str(file_path)
            s3 = boto3.resource('s3')
            try:
                s3.Bucket(BUCKET_NAME).download_file(KEY, file_name)
                with open(file_name, 'rb') as fh:
                    response = HttpResponse(
                        fh.read(), content_type="application/vnd.ms-excel")
                    response['Content-Disposition'] = 'inline; filename=' + \
                        os.path.basename(file_name)
                os.remove(file_name)
                return response
            except botocore.exceptions.ClientError as e:
                if e.response['Error']['Code'] == "404":
                    print("The object does not exist.")
                else:
                    raise
            # if file_path:
            #     print('yes tus pus')
    raise Http404


def change_user_status(request, pk):
    user = get_object_or_404(User, pk=pk)
    if user.is_active:
        user.is_active = False
    else:
        user.is_active = True
    user.save()
    current_site = request.get_host()
    status_changed_user = request.user.email
    send_email_user_status.delay(
        pk, status_changed_user=status_changed_user, domain=current_site , protocol=request.scheme)
    return HttpResponseRedirect('/users/list/')


def add_comment(request):
    if request.method == "POST":
        user = get_object_or_404(User, id=request.POST.get('userid'))
        form = UserCommentForm(request.POST)
        if form.is_valid():
            comment = form.save(commit=False)
            comment.commented_by = request.user
            comment.user = user
            comment.save()
            return JsonResponse({
                "comment_id": comment.id, "comment": comment.comment,
                "commented_on": comment.commented_on,
                "commented_by": comment.commented_by.email
            })
        return JsonResponse({"error": form.errors})


def edit_comment(request, pk):
    if request.method == "POST":
        comment_obj = get_object_or_404(Comment, id=pk)
        if request.user == comment_obj.commented_by:
            form = UserCommentForm(request.POST, instance=comment_obj)
            if form.is_valid():
                comment_obj.comment = form.cleaned_data.get("comment")
                comment_obj.save(update_fields=["comment"])
                return JsonResponse({
                    "comment_id": comment_obj.id,
                    "comment": comment_obj.comment,
                })
            return JsonResponse({"error": form['comment'].errors})
        data = {'error': "You don't have permission to edit this comment."}
        return JsonResponse(data)


def remove_comment(request):
    if request.method == "POST":
        comment_obj = get_object_or_404(
            Comment, id=request.POST.get('comment_id'))
        if request.user == comment_obj.commented_by:
            comment_obj.delete()
            data = {"cid": request.POST.get("comment_id")}
            return JsonResponse(data)
        data = {'error': "You don't have permission to delete this comment."}
        return JsonResponse(data)

@login_required
@admin_login_required
def currency_settings(request):

    
    cur = Currency.objects.values_list('currency_settings', flat=True).first()
    print(cur, "+++++++++++++++++++++++++++")

    if request.method == "POST":
        
        cur_value = Currency.objects.values_list('id', flat=True).first()
        print(cur_value, "----------------------------------")

    

        if cur_value == None:
            cg = request.POST.get('currency')
            # print(cg, '---------------------')
            currency_create = Currency.objects.create(currency_settings=cg)
            return HttpResponseRedirect("/api/settings/")
            print('yes')
    
        else:
            
            cg = request.POST.get('currency')
            print(cg, '---------------------')
            update = Currency.objects.filter(id=cur_value).update(currency_settings=cg)
            return HttpResponseRedirect("/api/settings/")
            print('yes')

    context = {
        'currencies': CURRENCY_CODES, 
        'cur':cur
    }

    return render(request, 'currency_setting.html', context)

@login_required
@admin_login_required
def api_settings(request):
    # api_settings = APISettings.objects.all()
    blocked_domains = BlockedDomain.objects.all()
    blocked_emails = BlockedEmail.objects.all()
    contacts = ContactEmailCampaign.objects.all()
    created_by_users = User.objects.filter(role='ADMIN')
    assigned_users = User.objects.all()

    context = {
        # 'settings': api_settings,
        'contacts': contacts,
        'created_by_users': created_by_users,
        'assigned_users': assigned_users,
        'blocked_emails': blocked_emails,
        'blocked_domains': blocked_domains,
    }

    if request.method == 'POST':
        # settings = api_settings
        # if request.POST.get('api_settings', None):
        #     if request.POST.get('title', None):
        #         settings = settings.filter(title__icontains=request.POST.get('title', None))
        #     if request.POST.get('created_by', None):
        #         settings = settings.filter(created_by_id=request.POST.get('created_by', None))
        #     if request.POST.get('assigned_to', None):
        #         settings = settings.filter(lead_assigned_to__id__in=request.POST.getlist('assigned_to', None))

        #     context['settings']= settings.distinct()

        if request.POST.get('filter_contacts', None):
            contacts_filter = contacts
            if request.POST.get('contact_name', None):
                contacts_filter = contacts_filter.filter(name__icontains=request.POST.get('contact_name', None))
            if request.POST.get('contact_created_by', None):
                contacts_filter = contacts_filter.filter(created_by_id=request.POST.get('contact_created_by', None))
            if request.POST.get('contact_email', None):
                contacts_filter = contacts_filter.filter(email__icontains=request.POST.get('contact_email', None))

            context['contacts']= contacts_filter.distinct()

        if request.POST.get('filter_blocked_domains', None):
            if request.POST.get('domain', ''):
                blocked_domains = blocked_domains.filter(domain__icontains=request.POST.get('domain', ''))
            if request.POST.get('created_by', ''):
                blocked_domains = blocked_domains.filter(created_by_id=request.POST.get('created_by', ''))

            context['blocked_domains']= blocked_domains

        if request.POST.get('filter_blocked_emails', None):
            if request.POST.get('email', ''):
                blocked_emails = blocked_emails.filter(email__icontains=request.POST.get('email', ''))
            if request.POST.get('created_by', ''):
                blocked_emails = blocked_emails.filter(created_by_id=request.POST.get('created_by', ''))

            context['blocked_emails'] = blocked_emails

    return render(request, 'settings/list.html', context)


def add_api_settings(request):
    users = User.objects.filter(is_active=True).order_by('email')
    form = APISettingsForm(assign_to=users)
    assign_to_list = []
    if request.POST:
        form = APISettingsForm(request.POST, assign_to=users)
        assign_to_list = [
            int(i) for i in request.POST.getlist('lead_assigned_to', []) if i]
        if form.is_valid():
            settings_obj = form.save(commit=False)
            settings_obj.created_by = request.user
            settings_obj.save()
            if request.POST.get('tags', ''):
                tags = request.POST.get("tags")
                splitted_tags = tags.split(",")
                for t in splitted_tags:
                    tag = Tags.objects.filter(name=t)
                    if tag:
                        tag = tag[0]
                    else:
                        tag = Tags.objects.create(name=t)
                    settings_obj.tags.add(tag)
            if assign_to_list:
                settings_obj.lead_assigned_to.add(*assign_to_list)
            success_url = reverse_lazy("common:api_settings")
            if request.POST.get("savenewform"):
                success_url = reverse_lazy("common:add_api_settings")
            data = {'success_url': success_url, 'error': False}
            return JsonResponse(data)
        return JsonResponse({'error': True, 'errors': form.errors})
    data = {'form': form, "setting": api_settings,
            'users': users, 'assign_to_list': assign_to_list}
    return render(request, 'settings/create.html', data)


def view_api_settings(request, pk):
    api_settings = APISettings.objects.filter(pk=pk).first()
    data = {"setting": api_settings}
    return render(request, 'settings/view.html', data)


def update_api_settings(request, pk):
    api_settings = APISettings.objects.filter(pk=pk).first()
    users = User.objects.filter(is_active=True).order_by('email')
    form = APISettingsForm(instance=api_settings, assign_to=users)
    assign_to_list = []
    if request.POST:
        form = APISettingsForm(
            request.POST, instance=api_settings, assign_to=users)
        assign_to_list = [
            int(i) for i in request.POST.getlist('lead_assigned_to', []) if i]
        if form.is_valid():
            settings_obj = form.save(commit=False)
            settings_obj.save()
            if request.POST.get('tags', ''):
                settings_obj.tags.clear()
                tags = request.POST.get("tags")
                splitted_tags = tags.split(",")
                for t in splitted_tags:
                    tag = Tags.objects.filter(name=t)
                    if tag:
                        tag = tag[0]
                    else:
                        tag = Tags.objects.create(name=t)
                    settings_obj.tags.add(tag)
            if assign_to_list:
                settings_obj.lead_assigned_to.clear()
                settings_obj.lead_assigned_to.add(*assign_to_list)
            success_url = reverse_lazy("common:api_settings")
            if request.POST.get("savenewform"):
                success_url = reverse_lazy("common:add_api_settings")
            data = {'success_url': success_url, 'error': False}
            return JsonResponse(data)
        return JsonResponse({'error': True, 'errors': form.errors})
    data = {
        'form': form, "setting": api_settings,
        'users': users, 'assign_to_list': assign_to_list,
        'assigned_to_list':
        json.dumps(
            [setting.id for setting in api_settings.lead_assigned_to.all() if setting])
    }
    return render(request, 'settings/update.html', data)


def delete_api_settings(request, pk):
    api_settings = APISettings.objects.filter(pk=pk).first()
    if api_settings:
        api_settings.delete()
        data = {"error": False, "response": "Successfully Deleted!"}
    else:
        data = {"error": True,
                "response": "Object Not Found!"}
    # return JsonResponse(data)
    return redirect('common:api_settings')


def change_passsword_by_admin(request):
    if request.user.role == "ADMIN" or request.user.is_superuser:
        if request.method == "POST":
            user = get_object_or_404(User, id=request.POST.get("useer_id"))
            user.set_password(request.POST.get("new_passwoord"))
            user.save()
            mail_subject = 'Crm Account Password Changed'
            message = "<h3><b>hello</b> <i>" + user.username +\
                "</i></h3><br><h2><p> <b>Your account password has been changed !\
                 </b></p></h2>" \
                + "<br> <p><b> New Password</b> : <b><i>" + \
                request.POST.get("new_passwoord") + "</i><br></p>"
            email = EmailMessage(mail_subject, message, to=[user.email])
            email.content_subtype = "html"
            email.send()
            return HttpResponseRedirect('/users/list/')
    raise PermissionDenied


def google_login(request): # pragma: no cover
    if 'code' in request.GET:
        params = {
            'grant_type': 'authorization_code',
            'code': request.GET.get('code'),
            'redirect_uri': 'http://' +
            request.META['HTTP_HOST'] + reverse('common:google_login'),
            'client_id': settings.GP_CLIENT_ID,
            'client_secret': settings.GP_CLIENT_SECRET
        }

        info = requests.post(
            "https://accounts.google.com/o/oauth2/token", data=params)
        info = info.json()
        url = 'https://www.googleapis.com/oauth2/v1/userinfo'
        params = {'access_token': info['access_token']}
        kw = dict(params=params, headers={}, timeout=60)
        response = requests.request('GET', url, **kw)
        user_document = response.json()

        link = "https://plus.google.com/" + user_document['id']
        dob = user_document['birthday'] if 'birthday' in user_document.keys(
        ) else ""
        gender = user_document['gender'] if 'gender' in user_document.keys(
        ) else ""
        link = user_document['link'] if 'link' in user_document.keys(
        ) else link

        verified_email = user_document['verified_email'] if 'verified_email' in user_document.keys(
        ) else ''
        name = user_document['name'] if 'name' in user_document.keys(
        ) else 'name'
        first_name = user_document['given_name'] if 'given_name' in user_document.keys(
        ) else 'first_name'
        last_name = user_document['family_name'] if 'family_name' in user_document.keys(
        ) else 'last_name'
        email = user_document['email'] if 'email' in user_document.keys(
        ) else 'email@dummy.com'

        user = User.objects.filter(email=user_document['email'])

        if user:
            user = user[0]
            user.first_name = first_name
            user.last_name = last_name
        else:
            user = User.objects.create(
                username=email,
                email=email,
                first_name=first_name,
                last_name=last_name,
                role="USER",
                has_sales_access=True,
                has_marketing_access=True,
            )

        google, _ = Google.objects.get_or_create(user=user)
        google.user = user
        google.google_url = link
        google.verified_email = verified_email
        google.google_id = user_document['id']
        google.family_name = last_name
        google.name = name
        google.given_name = first_name
        google.dob = dob
        google.email = email
        google.gender = gender
        google.save()

        user.last_login = datetime.datetime.now()
        user.save()

        login(request, user)

        if request.GET.get('state') != '1235dfghjkf123':
            return HttpResponseRedirect(request.GET.get('state'))
        if user.has_sales_access:
            return HttpResponseRedirect('/')
        elif user.has_marketing_access:
            return redirect('marketing:dashboard')
        else:
            return HttpResponseRedirect('/')
    if request.GET.get('next'):
        next_url = request.GET.get('next')
    else:
        next_url = '1235dfghjkf123'
    rty = "https://accounts.google.com/o/oauth2/auth?client_id=" + \
        settings.GP_CLIENT_ID + "&response_type=code"
    rty += "&scope=https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email&redirect_uri=" \
        + 'http://' + request.META['HTTP_HOST'] + \
        reverse('common:google_login') + "&state=" + next_url
    return HttpResponseRedirect(rty)


def create_lead_from_site(request): # pragma: no cover
    allowed_domains = ['micropyramid.com', 'test.microsite.com:8000', ]
    # add origin_domain = request.get_host() in the post body
    if (request.get_host() in ['sales.micropyramid.com', ] and request.POST.get('origin_domain') in allowed_domains):
        if request.method == 'POST':
            if request.POST.get('full_name', None):
                lead = Lead.objects.create(title=request.POST.get('full_name'), email=request.POST.get(
                    'email'), phone=request.POST.get('phone'), description=request.POST.get('message'),
                    created_from_site=True)
                recipients = User.objects.filter(
                    role='ADMIN').values_list('id', flat=True)
                lead.assigned_to.add(*recipients)
                from leads.tasks import send_email_to_assigned_user
                send_email_to_assigned_user(
                    recipients, lead.id, domain='sales.micropyramid.com',
                    source=request.POST.get('origin_domain'))
                return HttpResponse('Lead Created')
    from django.http import HttpResponseBadRequest
    return HttpResponseBadRequest('Bad Request')


def activate_user(request, uidb64, token, activation_key): # pragma: no cover
    profile = get_object_or_404(Profile, activation_key=activation_key)
    if profile.user:
        if timezone.now() > profile.key_expires:
            resend_url = reverse('common:resend_activation_link', args=(profile.user.id,))
            link_content = '<a href="{}">Click Here</a> to resend the activation link.'.format(
                resend_url)
            message_content = 'Your activation link has expired, {}'.format(
                link_content)
            messages.info(request, message_content)
            return render(request, 'login.html')
        else:
            try:
                uid = force_text(urlsafe_base64_decode(uidb64))
                user = User.objects.get(pk=uid)
            except(TypeError, ValueError, OverflowError, User.DoesNotExist):
                user = None
            if user is not None and account_activation_token.check_token(user, token):
                user.is_active = True
                user.save()
                login(request, user)
                if user.has_sales_access:
                    return HttpResponseRedirect('/')
                elif user.has_marketing_access:
                    return redirect('marketing:dashboard')
                else:
                    return HttpResponseRedirect('/')
                # return HttpResponse('Thank you for your email confirmation. Now you can login your account.')
            else:
                return HttpResponse('Activation link is invalid!')


def resend_activation_link(request, userId): # pragma: no cover
    user = get_object_or_404(User, pk=userId)
    kwargs = {'user_email': user.email, 'domain': request.get_host(), 'protocol': request.scheme}
    resend_activation_link_to_user.delay(**kwargs)
    return HttpResponseRedirect('/')
