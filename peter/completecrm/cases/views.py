import json
from django.contrib.auth.decorators import login_required
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.sites.shortcuts import get_current_site
from django.core.mail import EmailMessage
from django.db.models import Q,Count
from django.http import JsonResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.template.loader import render_to_string
from django.views.generic import (CreateView, DetailView,
                                  ListView, TemplateView, View)

from cases.models import Case,SlaVoice,SlaEmail,Sla,UpdatedCase,Notification
from cases.forms import CaseForm, CaseCommentForm, CaseAttachmentForm
from common.models import User, Comment, Attachments
from accounts.models import Account
from contacts.models import Contact
from common.utils import PRIORITY_CHOICE, STATUS_CHOICE, CASE_TYPE
from django.urls import reverse
from django.core.exceptions import PermissionDenied
from common.tasks import send_email_user_mentions
from cases.tasks import send_email_to_assigned_user
from common.access_decorators_mixins import (
    sales_access_required, marketing_access_required,service_access_required,ServiceAccessRequiredMixin, SalesAccessRequiredMixin, MarketingAccessRequiredMixin)
from teams.models import Teams
from django.http import HttpResponseRedirect,HttpResponse
from datetime import datetime, timedelta
import datetime
from django.core import serializers

from django.views.decorators.http import require_GET, require_POST
from django.views.decorators.csrf import csrf_exempt
# from webpush import send_user_notification
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from leads.models import LeadNotification
class CasesListView( LoginRequiredMixin, TemplateView):
    model = Case
    context_object_name = "cases"
    template_name = "cases.html"

    def get_queryset(self):
        queryset = self.model.objects.all().select_related("account").order_by('-id')
        if self.request.user.role != "ADMIN" and not self.request.user.is_superuser:
            queryset = queryset.filter(
                Q(assigned_to__in=[self.request.user]) | Q(created_by=self.request.user))

        request_post = self.request.POST
        # print("request_post",request_post)
        if request_post:
            if request_post.get('name'):
                queryset = queryset.filter(
                    name__icontains=request_post.get('name'))
            if request_post.get('account'):
                queryset = queryset.filter(
                    account_id=request_post.get('account'))
            if request_post.get('status'):
                queryset = queryset.filter(status=request_post.get('status'))
            if request_post.get('priority'):
                queryset = queryset.filter(
                    priority=request_post.get('priority'))
            if request_post.get('case_type'):
                queryset = queryset.filter(
                    case_type=request_post.get('case_type'))
            if request_post.get('top_cat'):
                print("topcattttt")
                top = Case.objects.values('case_type').annotate(type_count=Count('case_type')).order_by('-type_count')
                print("Top:",top)
                top_category = []
                for t in top:
                    print("case_type:",t['case_type'])
                    c = Case.objects.all().filter(case_type=t['case_type'])
                    for s in c:
                        print('----test----',s)
                        top_category.append(s)
                queryset=top_category
            if request_post.get('date'):
                print("date",request_post.get('date'))
                queryset = queryset.filter(created_on__icontains=request_post.get('date'))
                print("queryset",queryset)

            # if request_post.get('caseuname'):
            #     print("username............")
            #     print(request_post.get('caseuname'))
            #     user_id = User.objects.values_list('id',flat=True).get(username=request_post.get('caseuname'))
            #     print(user_id)
            #     queryset =  self.model.objects.all().filter(Q(created_by_id=user_id)& Q(assigned_to=user_id))
        return queryset

    def get_context_data(self, **kwargs):
        
        context = super(CasesListView, self).get_context_data(**kwargs)
        print(self.request.user,"**************")

        bnmm = self.request.user.username
        # print(bnmm, '------------------')

        name_id = User.objects.values_list('id',flat=True).get(username=bnmm)
        # print(name_id, '-------- name_id --------')

        njum = Case.objects.all().filter(Q(assigned_to=name_id)|Q(created_by=name_id))
        # print(njum, '----------- njum ------------')
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
        else:
            print('not in id')
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)("assignuser", 
            {"type": "user.assignuser",
            "event": "clearuser",
            "username": None,
            })

        if  LeadNotification.objects.filter(userid=self.request.user.id).exists():
            if LeadNotification.objects.filter(userid=self.request.user.id,notifi_status='unread').exists():
                leadnoti=LeadNotification.objects.filter(userid=self.request.user.id,notifi_status='unread').count()
                # print('***************&&&&&&&&&****************',leadnoti)
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
            # print(User.objects.values_list('username',flat=True).get(id='1'),'&&&&&&&&&&&&&&&')
            print('not in lead id')
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)("assignuser", 
            {"type": "user.assignuser",
            "event": "clearlead",
            "username": None,
            })
            # print('&&&&***********&&&&&**************&&&&')

        c=self.request.POST.get('top_cat')
        print('c----',c)
        if c!=None:
            print('yes')
            d=self.get_queryset()
            print('&^%$%999',d)              
            context["cases"] = d
        else:
            print("no")
            d=self.get_queryset()
            # print('asdf',d)
            context["cases"] = self.get_queryset().order_by('-id')
       
        context['data']=njum       
        context["accounts"] = Account.objects.filter(status="open")
        context["per_page"] = self.request.POST.get('per_page')
        context["acc"] = int(self.request.POST.get("account")) if self.request.POST.get("account") else None
        context["case_priority"] = PRIORITY_CHOICE
        context["case_status"] = STATUS_CHOICE
        context["case_case_type"] = CASE_TYPE
  
        search = False
        if (
            self.request.POST.get('name') or self.request.POST.get('account') or
            self.request.POST.get(
                'status') or self.request.POST.get('priority')  or self.request.POST.get('case_type') or 
                self.request.POST.get('date')
        ):
            search = True

        context["search"] = search
        return context

    def get(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)

    def post(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)


class CasesListInd(LoginRequiredMixin, TemplateView):
    model = Case
    context_object_name = "cases"
    template_name = "ind_cases.html"

    def get_queryset(self):
        bnmm = self.request.user.username
        name_id = User.objects.values_list('id',flat=True).get(username=bnmm)
        queryset = self.model.objects.all().select_related("account").order_by('-id').filter(Q(assigned_to=name_id)|Q(created_by_id=name_id))
        # print("------texting--------", queryset)

        if self.request.user.role != "ADMIN" and not self.request.user.is_superuser:
            queryset = queryset.filter(
                Q(assigned_to__in=[self.request.user]) | Q(created_by=self.request.user))

        request_post = self.request.POST
        if request_post:
            if request_post.get('name'):
                print(request_post.get('name'))
                queryset = queryset.filter(name__icontains=request_post.get('name'))
                print(queryset)

            if request_post.get('account'):
                queryset = queryset.filter(
                    account_id=request_post.get('account'))
            if request_post.get('status'):
                queryset = queryset.filter(status=request_post.get('status'))

                
            if request_post.get('priority'):
                queryset = queryset.filter(
                    priority=request_post.get('priority'))
            if request_post.get('case_type'):
                print("CASE TYPE:",request_post.get('case_type'))
                queryset = queryset.filter(
                    case_type=request_post.get('case_type'))

            if request_post.get('top_cat'):
                top = Case.objects.values('case_type').annotate(type_count=Count('case_type')).order_by('-type_count').filter(Q(assigned_to=name_id)|Q(created_by=name_id))
                print("Top:::::",top)
                top_category = []
                for t in top:
                    print("case_type:",t['case_type'])
                    c = Case.objects.all().filter(case_type=t['case_type'])
                    for s in c:
                        print('----test----',s)
                        top_category.append(s)
                queryset=top_category

            if request_post.get('date'):
                print("date",request_post.get('date'))
                queryset = queryset.filter(created_on__icontains=request_post.get('date'))
                print("queryset",queryset)

            if request_post.get('caseuname'):
                print(request_post.get('caseuname'))
                fd = request_post.get('fdate')
                fdd =datetime.datetime.strptime(fd,"%d-%m-%Y").strftime("%Y-%m-%d")
                print("FDD:",fdd)
                td = request_post.get('tod')
                tdd = datetime.datetime.strptime(td,"%d-%m-%Y").strftime("%Y-%m-%d")
                print("TDD:",tdd)
                da= datetime.datetime.strptime(tdd, "%Y-%m-%d")
                print(da, "to date")
                md = da + datetime.timedelta(days=1)
                print("MD:",md)
                to = datetime.datetime.strftime(md, "%Y-%m-%d")
                print(to, '++++++++++')
                user_id = User.objects.values_list('id',flat=True).get(username=request_post.get('caseuname'))
                print(user_id)
                # queryset=self.model.objects.all().filter(created_on__range=["2020-08-23","2020-08-23"])
                queryset =  self.model.objects.all().filter(Q(created_on__range=[fdd,to],created_by_id=user_id) | Q(created_on__range=[fdd,to],assigned_to=user_id))
                # queryset =  self.model.objects.all().filter(Q(created_by_id=user_id)& Q(assigned_to=user_id))
                # queryset =  self.model.objects.all().filter(Q(created_by_id=user_id)&Q(created_on__range=[fdd,tdd]))
                print(queryset,"QUERYSET")
        return queryset

    def get_context_data(self, **kwargs):
       
        context = super(CasesListInd, self).get_context_data(**kwargs)
        print(self.request.user,"**************")

        bnmm = self.request.user.username
        name_id = User.objects.values_list('id',flat=True).get(username=bnmm)
        text = Case.objects.all().filter(Q(assigned_to=name_id)|Q(created_by=name_id))
        # print(njum, '----------- njum ------------')
        
    
        c=self.request.POST.get('top_cat')
        print('c----c',c)
        u = self.request.POST.get('caseuname')
        print("u----",u)
      
        
        if c!=None:
            print('yes')
            d=self.get_queryset()
            print("QQQQQ")
            print('&^%$%999',d)              
            context["cases"] = d
        elif u!=None:
            print("u exists")
            cu=self.get_queryset()
            # print("CU:",cu)
            context["cases"] = cu
        else:
            print("no")
            d=self.get_queryset()
            # print('&^%$%999',d)
            context["cases"] = self.get_queryset().order_by('-id')



        
        # context['data']=text
        # context['countcase']=cou
        
        context["data"] = Case.objects.all().filter(Q(assigned_to=name_id)|Q(created_by_id=name_id)).order_by('-id')
        context["accounts"] = Account.objects.filter(status="open")
        context["per_page"] = self.request.POST.get('per_page')
        context["acc"] = int(self.request.POST.get(
            "account")) if self.request.POST.get("account") else None
        context["case_priority"] = PRIORITY_CHOICE
        context["case_status"] = STATUS_CHOICE
        context["case_case_type"] = CASE_TYPE
      
        search = False
        if (
            self.request.POST.get('name') or self.request.POST.get('account') or
            self.request.POST.get(
                'status') or self.request.POST.get('priority')  or self.request.POST.get('case_type') or 
                self.request.POST.get('date')
        ):
            search = True

        context["search"] = search
        return context

    def get(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)

    def post(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)

@login_required
@sales_access_required
@service_access_required
def create_case(request):
    users = []
    creation_date = datetime.datetime.now()
    assigned_date = datetime.datetime.now()
    cases = Case.objects.all()
    assigned_case_status = ""
    if request.user.role == 'ADMIN' or request.user.is_superuser:
        users = User.objects.filter(is_active=True).order_by('email')
    elif request.user.google.all():
        users = []
    else:
        users = User.objects.filter(role='ADMIN').order_by('email')
    accounts = Account.objects.filter(status="open")
    contacts = Contact.objects.all()
    if request.user.role != "ADMIN" and not request.user.is_superuser:
        accounts = Account.objects.filter(
            created_by=request.user)
        contacts = Contact.objects.filter(
            Q(assigned_to__in=[request.user]) | Q(created_by=request.user))
    kwargs_data = {
        "assigned_to": users, "account": accounts, "contacts": contacts}
    form = CaseForm(**kwargs_data)
    template_name = "create_cases.html"

    # data2 = {'error':True,'errors': form.errors}
    # dump2 = json.dumps(data2)
    # success_url = reverse('cases:add_case')


    if request.POST:
        form = CaseForm(request.POST, request.FILES, **kwargs_data)
        status = request.POST.get('status')
        print("status_id:",status)
        uid = request.user.id
        print(uid,":uid")
        sla_time = Sla.objects.values('voiceopen_respond_within').filter(voiceopen_status=status)
        print(sla_time,":time")

        if form.is_valid():
            print("form")
            case = form.save(commit=False)
            case.created_by = request.user
            case.creation_date = creation_date
            case.assigned_date = assigned_date
            case.save()
            for s in sla_time:
                print("*****")
                u_sla = s['voiceopen_respond_within']
                print("sla:",u_sla)
                h = u_sla.strftime('%H')
                print('hours:',h)
                m = u_sla.strftime('%M')
                s = u_sla.strftime('%S')
                print("*(()*",s)
                l = Case.objects.values_list('id',flat=True).latest('id')
                print("L:",l)
                cd = Case.objects.values_list('created_on',flat=True).latest('id')
                print("current:",cd.time())
                add = cd + datetime.timedelta(hours=int(h), minutes=int(m), seconds=int(s))
                print("add:",add)
                c = Case.objects.filter(id=l).update(sla=add)
                print("C:",c)

            if request.POST.getlist('assigned_to', []):
                case.assigned_to.add(*request.POST.getlist('assigned_to'))
                assigned_to_list = request.POST.getlist('assigned_to')
                print("ASSIGNED TO CASES:",request.POST.getlist('assigned_to'))
                
                for i in assigned_to_list:
                    print("I:",i)
                    print(User.objects.values_list('username',flat=True).get(id=i))
                    # V_user = get_object_or_404(User,pk=i)
                    v_user=User.objects.values_list('username',flat=True).get(id=i)
                    uname = request.user.id
                    notifi=Notification.objects.create(caseid=l,userid=i)
                    # print(uname,":uid")
                    
                # return JsonResponse(status=200, data={"message": "Web push successful"})

                # current_site = get_current_site(request)
                # recipients = assigned_to_list
                # send_email_to_assigned_user.delay(recipients, case.id, domain=current_site.domain,
                #     protocol=request.scheme)
                # for assigned_to_user in assigned_to_list:
                #     user = get_object_or_404(User, pk=assigned_to_user)
                #     mail_subject = 'Assigned to case.'
                #     message = render_to_string(
                #         'assigned_to/cases_assigned.html', {
                #             'user': user,
                #             'domain': current_site.domain,
                #             'protocol': request.scheme,
                #             'case': case
                #         })
                #     email = EmailMessage(
                #         mail_subject, message, to=[user.email])
                #     email.content_subtype = "html"
                #     email.send()

            if request.POST.getlist('contacts', []):
                case.contacts.add(*request.POST.getlist('contacts'))
            if request.POST.getlist('teams', []):
                user_ids = Teams.objects.filter(id__in=request.POST.getlist('teams')).values_list('users', flat=True)
                assinged_to_users_ids = case.assigned_to.all().values_list('id', flat=True)
                for user_id in user_ids:
                    notification=Notification.objects.create(caseid=l,userid=user_id)
                    if user_id not in assinged_to_users_ids:
                        case.assigned_to.add(user_id)

            if request.POST.getlist('teams', []):
                case.teams.add(*request.POST.getlist('teams'))

            current_site = get_current_site(request)
            recipients = list(case.assigned_to.all().values_list('id', flat=True))
            send_email_to_assigned_user.delay(recipients, case.id, domain=current_site.domain,
                protocol=request.scheme)
            if request.FILES.get('case_attachment'):
                attachment = Attachments()
                attachment.created_by = request.user
                attachment.file_name = request.FILES.get(
                    'case_attachment').name
                attachment.case = case
                attachment.attachment = request.FILES.get('case_attachment')
                attachment.save()
            success_url = reverse('cases:list')
            if request.POST.get("savenewform"):
                success_url = reverse("cases:add_case")
            if request.POST.get('from_account'):
                from_account = request.POST.get('from_account')
                success_url = reverse("accounts:view_account", kwargs={
                                      'pk': from_account})
            return JsonResponse({'error': False, "success_url": success_url})
        return JsonResponse({'error': True, 'errors': form.errors})
    context = {}
    context["case_form"] = form
    context["cases"] = cases
    # context["sla_time"] = sla_time
    context["accounts"] = accounts
    if request.GET.get('view_account'):
        context['account'] = get_object_or_404(
            Account, id=request.GET.get('view_account'))
    context["contacts"] = contacts
    context["users"] = users
    context["case_types"] = CASE_TYPE
    context["case_priority"] = PRIORITY_CHOICE
    context["case_status"] = STATUS_CHOICE
    context["teams"] = Teams.objects.all()
    context["assignedto_list"] = [
        int(i) for i in request.POST.getlist('assigned_to', []) if i]
    context["contacts_list"] = [
        int(i) for i in request.POST.getlist('contacts', []) if i]
    return render(request, template_name, context)


class CaseDetailView( LoginRequiredMixin, DetailView):
    model = Case
    context_object_name = "case_record"
    template_name = "view_case.html"

    def get_queryset(self):
        queryset = super(CaseDetailView, self).get_queryset()
        return queryset.prefetch_related("contacts", "account")

    def get_context_data(self, **kwargs):
        context = super(CaseDetailView, self).get_context_data(**kwargs)
        user_assgn_list = [
            assigned_to.id for assigned_to in context['object'].assigned_to.all()]
        user_assigned_accounts = set(self.request.user.account_assigned_users.values_list('id', flat=True))
        if context['object'].account:
            case_account = set([context['object'].account.id])
        else:
            case_account = set()
        if user_assigned_accounts.intersection(case_account):
            user_assgn_list.append(self.request.user.id)
        if self.request.user == context['object'].created_by:
            user_assgn_list.append(self.request.user.id)
        if self.request.user.role != "ADMIN" and not self.request.user.is_superuser:
            if self.request.user.id not in user_assgn_list:
                raise PermissionDenied
        assigned_data = []
        for each in context['case_record'].assigned_to.all():
            assigned_dict = {}
            assigned_dict['id'] = each.id
            assigned_dict['name'] = each.email
            assigned_data.append(assigned_dict)

        if self.request.user.is_superuser or self.request.user.role == 'ADMIN':
            users_mention = list(User.objects.filter(is_active=True).values('username'))
        elif self.request.user != context['object'].created_by:
            users_mention = [{'username': context['object'].created_by.username}]
        else:
            users_mention = list(context['object'].assigned_to.all().values('username'))

        context.update({"comments": context["case_record"].cases.all(),
                        "attachments": context['case_record'].case_attachment.all(),
                        "users_mention": users_mention,
                        "assigned_data": json.dumps(assigned_data)})
        return context


@login_required
@sales_access_required
@service_access_required
def update_case(request, pk):
    request.session['pk']=pk
    closdate=datetime.datetime.now()
    case_object = Case.objects.filter(pk=pk).first()
    cases = Case.objects.all()

    creation_date = Case.objects.values_list('creation_date',flat=True).get(pk=pk)
    print("cd:",creation_date)
    assigned_date = Case.objects.values_list('assigned_date',flat=True).get(pk=pk)
    accounts = Account.objects.filter(status="open")
    contacts = Contact.objects.all()
    if request.user.role != "ADMIN" and not request.user.is_superuser:
        accounts = Account.objects.filter(
            created_by=request.user)
        contacts = Contact.objects.filter(
            Q(assigned_to__in=[request.user]) | Q(created_by=request.user))
    users = []
    if request.user.role == 'ADMIN' or request.user.is_superuser:
        users = User.objects.filter(is_active=True).order_by('email')
    elif request.user.google.all():
        users = []
    else:
        users = User.objects.filter(role='ADMIN').order_by('email')
    kwargs_data = {
        "assigned_to": users,
        "account": accounts, "contacts": contacts}
    form = CaseForm(instance=case_object, **kwargs_data)

    if request.POST:
        form = CaseForm(request.POST, request.FILES,
                        instance=case_object, **kwargs_data)
        status = request.POST.get('status')
        print("status_id:",status)
        uid = request.user.id
        print(uid,":uid")
        print('=================================',pk)
        
     
        
        # else:
        #     sla_time = Sla.objects.values('voiceprogress_respond_within').filter(voiceprogress_status=status)
        #     print(sla_time,":time")

        if form.is_valid():
            assigned_to_ids = case_object.assigned_to.all().values_list('id', flat=True)
            
            case1 = Case.objects.values("name","status","priority",'closed_on','description','case_type').get(id=pk)
            # case1 = Case.objects.raw("select cases_case.name,cases_case.status,cases_case.priority,common_user.username from cases_case,cases_case_assigned_to,common_user where cases_case.id=cases_case_assigned_to.user_id and cases_case_assigned_to.user_id=common_user.id;")
            
            name1 = case1['name']
            priority1=case1['priority']
            status1=case1['status']
            closed_on1=case1['closed_on']
            description1=case1['description']
            case_type1=case1['case_type']
            # assignedto=case1['assigned_to']
            # if assignedto ==None:
            #     print('sd')
            #     common1 = 0
            #     assignedname1=0
            # else:
            #     print('sad')
            #     common1 = User.objects.values('username').get(id=assignedto)
            #     assignedname1 = common1['username']
            # print("common",common['username'])    
            # case_obj = form.save(commit=False)
            # case_obj.contacts.clear()
            # case_obj.save()
            if status == "Open" or status == "Closed":
                sla_time = Sla.objects.values('voiceopen_respond_within').filter(voiceopen_status=status)
                print(sla_time,":time")
                s = request.POST.get("reds")
                print("SSSSS:",s)
                case_obj = form.save(commit=False)
                case_obj.contacts.clear()
                case_obj.sla = s
                case_obj.creation_date=creation_date
                case_obj.assigned_date=assigned_date
                case_obj.closed_on=closdate
                case_obj.save()
                colorupdate=Case.objects.filter(id=pk).update(colorcode="#FFF",assignedcase_status="old_case")

            else:
                sla_time = Sla.objects.values('voiceprogress_respond_within').filter(voiceprogress_status=status)
                print(sla_time,":time")
                for s in sla_time:
                    print("*****")
                    u_sla = s['voiceprogress_respond_within']
                    print("sla:",u_sla)
                    h = u_sla.strftime('%H')
                    print('hours:',h)
                    m = u_sla.strftime('%M')
                    s = u_sla.strftime('%S')
                    # l = Case.objects.values_list('id',flat=True).latest('id')
                    # print("L:",l)
                    cd = Case.objects.values_list('created_on',flat=True).get(id=pk)
                    print("current:",cd)
                    # nh = cd.strftime('%H')
                    # print('hours:',h)
                    # nm = cd.strftime('%M')
                    # ns = cd.strftime('%S')
                    print("PK:",pk)
                    add = cd + datetime.timedelta(hours=int(h), minutes=int(m), seconds=int(s))
                    print("add:",add)
                    # c = Case.objects.filter(id=pk).update(sla=add)
                    # print("C:",c) 
                    case_obj = form.save(commit=False)
                    case_obj.contacts.clear()
                    case_obj.sla = add
                    case_obj.creation_date=creation_date
                    case_obj.assigned_date=assigned_date
                    case_obj.save()  
                    colorupdate=Case.objects.filter(id=pk).update(colorcode="#FFF",assignedcase_status="old_case")

            case2 = Case.objects.values("name","status","priority",'closed_on','description','case_type').get(id=pk)
            uname = case2['name']
            ustatus = case2['status']
            upriority = case2['priority']
            uclosed_on1=case2['closed_on']
            udescription1=case2['description']
            ucase_type1=case2['case_type']
            # uassignedto=case2['assigned_to']
            # if uassignedto ==None:
            #     common2=0
            #     assignedname2=0
            # else:
            #     common2 = User.objects.values('username').get(id=uassignedto)
            #     assignedname2 = common2['username']
            # print("CASE:",case2)

            if (case1==case2):
                oldvalues = case1
                print("oldvalues:",oldvalues)
                newvalues = case2
                print("newvalues:",newvalues)
                print("yes")
            else:
                if name1==uname:
                    print("same")
                else:
                    update = UpdatedCase.objects.create(field="name",oldvalue=name1,newvalue=uname,case_id=pk,changedby=request.user.username)
                if priority1==upriority:
                    print("same")
                else:
                    update = UpdatedCase.objects.create(field="priority",oldvalue=priority1,newvalue=upriority,case_id=pk,changedby=request.user.username)
                if status1==ustatus:
                    print("same")
                else:
                    update = UpdatedCase.objects.create(field="status",oldvalue=status1,newvalue=ustatus,case_id=pk,changedby=request.user.username)
                    print("no")
                if closed_on1==uclosed_on1:
                    print("same")
                else:
                    # update = UpdatedCase.objects.create(field="closed_on",oldvalue=closed_on1,newvalue=uclosed_on1,case_id=pk,changedby=request.user.username)
                    print("no")
                if description1==udescription1:
                    print("same")
                else:
                    update = UpdatedCase.objects.create(field="description",oldvalue=description1,newvalue=udescription1,case_id=pk,changedby=request.user.username)
                    print("no")
                if case_type1==ucase_type1:
                    print("same")
                else:
                    update = UpdatedCase.objects.create(field="case_type",oldvalue=case_type1,newvalue=ucase_type1,case_id=pk,changedby=request.user.username)
                    print("no")
                # if assignedname1==assignedname2:
                #     print("no")
                # else:
                #     update = UpdatedCase.objects.create(field="assigned_to",oldvalue=assignedname1,newvalue=assignedname2,case_id=pk,changedby=request.user.username)
                #     print("no")
            case_obj = form.save(commit=False)
            previous_assigned_to_users = list(case_obj.assigned_to.all().values_list('id', flat=True))
            all_members_list = []
            

            if request.POST.getlist('assigned_to', []):
                current_site = get_current_site(request)

                assigned_form_users = form.cleaned_data.get(
                    'assigned_to').values_list('id', flat=True)
                all_members_list = list(
                    set(list(assigned_form_users)) -
                    set(list(assigned_to_ids)))
                # recipients = all_members_list
                # send_email_to_assigned_user.delay(recipients, case_obj.id, domain=current_site.domain,
                #     protocol=request.scheme)
                # if all_members_list:
                #     for assigned_to_user in all_members_list:
                #         user = get_object_or_404(User, pk=assigned_to_user)
                #         mail_subject = 'Assigned to case.'
                #         message = render_to_string(
                #             'assigned_to/cases_assigned.html', {
                #                 'user': user,
                #                 'domain': current_site.domain,
                #                 'protocol': request.scheme,
                #                 'case': case_obj
                #             })
                #         email = EmailMessage(
                #             mail_subject, message, to=[user.email])
                #         email.content_subtype = "html"
                #         email.send()

                case_obj.assigned_to.clear()
                case_obj.assigned_to.add(*request.POST.getlist('assigned_to'))
            else:
                case_obj.assigned_to.clear()

            if request.POST.getlist('teams', []):
                user_ids = Teams.objects.filter(id__in=request.POST.getlist('teams')).values_list('users', flat=True)
                assinged_to_users_ids = case_obj.assigned_to.all().values_list('id', flat=True)
                for user_id in user_ids:
                    if user_id not in assinged_to_users_ids:
                        case_obj.assigned_to.add(user_id)

            if request.POST.getlist('teams', []):
                case_obj.teams.clear()
                case_obj.teams.add(*request.POST.getlist('teams'))
            else:
                case_obj.teams.clear()

            current_site = get_current_site(request)
            assigned_to_list = list(case_obj.assigned_to.all().values_list('id', flat=True))
            recipients = list(set(assigned_to_list) - set(previous_assigned_to_users))
            send_email_to_assigned_user.delay(recipients, case_obj.id, domain=current_site.domain,
                protocol=request.scheme)

            if request.POST.getlist('contacts', []):
                case_obj.contacts.add(*request.POST.getlist('contacts'))

            success_url = reverse("cases:list")
            if request.POST.get('from_account'):
                from_account = request.POST.get('from_account')
                success_url = reverse("accounts:view_account", kwargs={
                                      'pk': from_account})
            if request.FILES.get('case_attachment'):
                attachment = Attachments()
                attachment.created_by = request.user
                attachment.file_name = request.FILES.get(
                    'case_attachment').name
                attachment.case = case_obj
                attachment.attachment = request.FILES.get('case_attachment')
                attachment.save()

         
            return JsonResponse({'error': False, "success_url": success_url})
        return JsonResponse({'error': True, 'errors': form.errors})
    context = {}
    context["case_obj"] = case_object
    context['cases'] = cases
    context['creation_date'] = creation_date
    context['assigned_date'] = assigned_date
    context['closed_on'] = closdate
    context["pk"] = pk
    user_assgn_list = [
        assgined_to.id for assgined_to in context["case_obj"].assigned_to.all()]

    if request.user == case_object.created_by:
        user_assgn_list.append(request.user.id)
    if request.user.role != "ADMIN" and not request.user.is_superuser:
        if request.user.id not in user_assgn_list:
            raise PermissionDenied
    context["case_form"] = form
    context["accounts"] = accounts
    if request.GET.get('view_account'):
        context['account'] = get_object_or_404(
            Account, id=request.GET.get('view_account'))
    context["contacts"] = contacts
    context["users"] = kwargs_data['assigned_to']
    context["case_types"] = CASE_TYPE
    context["case_priority"] = PRIORITY_CHOICE
    context["case_status"] = STATUS_CHOICE
    context["teams"] = Teams.objects.all()
    context["assignedto_list"] = [
        int(i) for i in request.POST.getlist('assigned_to', []) if i]
    context["contacts_list"] = [
        int(i) for i in request.POST.getlist('contacts', []) if i]
    
    return render(request, "create_cases.html", context)

def changelog(request):
    # print("value:",request.GET.get('sid'))
    print("session",request.session['pk'])
    update = UpdatedCase.objects.all().filter(case_id=request.session['pk']).order_by("-id")
    print("updated result:",update)
    return render(request,'changelog.html',{"update":update})



class RemoveCaseView( LoginRequiredMixin, View):

    def get(self, request, *args, **kwargs):
        case_id = kwargs.get("case_id")
        if (Notification.objects.filter(caseid=case_id).exists()):
            print('yes')
            Notification.objects.filter(caseid=case_id).delete()
        else:
            print('no')
        self.object = get_object_or_404(Case, id=case_id)
        if (
            self.request.user.role == "ADMIN" or
            self.request.user.is_superuser or
            self.request.user == self.object.created_by
        ):
            self.object.delete()
            if request.GET.get('view_account'):
                account = request.GET.get('view_account')
                return redirect("accounts:view_account", pk=account)
            return redirect("cases:list")
        raise PermissionDenied

    def post(self, request, *args, **kwargs):
        case_id = kwargs.get("case_id")
        print(case_id,'===-=-=-===----')
        self.object = get_object_or_404(Case, id=case_id)
        if (self.request.user.role == "ADMIN" or
            self.request.user.is_superuser or
                self.request.user == self.object.created_by):
            self.object.delete()
            if request.is_ajax():
                return JsonResponse({'error': False})
            count = Case.objects.filter(
                Q(assigned_to__in=[request.user]) | Q(created_by=request.user)).distinct().count()
            data = {"case_id": case_id, "count": count}
            return JsonResponse(data)
        raise PermissionDenied


class CloseCaseView( LoginRequiredMixin, View):

    def post(self, request, *args, **kwargs):
        case_id = request.POST.get("case_id")
        self.object = get_object_or_404(Case, id=case_id)
        if (
            self.request.user.role == "ADMIN" or
            self.request.user.is_superuser or
            self.request.user == self.object.created_by
        ):
            self.object.status = "Closed"
            self.object.save()
            data = {'status': "Closed", "cid": case_id}
            return JsonResponse(data)
        raise PermissionDenied


def select_contact(request):
    contact_account = request.GET.get("account")
    if contact_account:
        account = get_object_or_404(Account, id=contact_account)
        contacts = account.contacts.all()
    else:
        contacts = Contact.objects.all()
    data = {contact.pk: contact.first_name for contact in contacts.distinct()}
    return JsonResponse(data)


class GetCasesView(LoginRequiredMixin, ListView):
    model = Case
    context_object_name = "cases"
    template_name = "cases_list.html"


class AddCommentView(LoginRequiredMixin, CreateView):
    model = Comment
    form_class = CaseCommentForm
    http_method_names = ["post"]

    def post(self, request, *args, **kwargs):
        self.object = None
        self.case = get_object_or_404(Case, id=request.POST.get('caseid'))
        if (
            request.user in self.case.assigned_to.all() or
            request.user == self.case.created_by or
            request.user.is_superuser or
            request.user.role == 'ADMIN'
        ):
            form = self.get_form()
            if form.is_valid():
                return self.form_valid(form)

            return self.form_invalid(form)

        data = {'error': "You don't have permission to comment."}
        return JsonResponse(data)

    def form_valid(self, form):
        comment = form.save(commit=False)
        comment.commented_by = self.request.user
        comment.case = self.case
        comment.save()
        comment_id = comment.id
        current_site = get_current_site(self.request)
        send_email_user_mentions.delay(comment_id, 'cases', domain=current_site.domain,
            protocol=self.request.scheme)
        return JsonResponse({
            "comment_id": comment.id, "comment": comment.comment,
            "commented_on": comment.commented_on,
            "commented_on_arrow": comment.commented_on_arrow,
            "commented_by": comment.commented_by.email
        })

    def form_invalid(self, form):
        return JsonResponse({"error": form['comment'].errors})


class UpdateCommentView(LoginRequiredMixin, View):
    http_method_names = ["post"]

    def post(self, request, *args, **kwargs):
        self.comment_obj = get_object_or_404(
            Comment, id=request.POST.get("commentid"))
        if (
            request.user == self.comment_obj.commented_by or
            request.user.is_superuser or
            request.user.role == 'ADMIN'
        ):
            form = CaseCommentForm(request.POST, instance=self.comment_obj)
            if form.is_valid():
                return self.form_valid(form)

            return self.form_invalid(form)

        data = {'error': "You don't have permission to edit this comment."}
        return JsonResponse(data)

    def form_valid(self, form):
        self.comment_obj.comment = form.cleaned_data.get("comment")
        self.comment_obj.save(update_fields=["comment"])
        comment_id = self.comment_obj.id
        current_site = get_current_site(self.request)
        send_email_user_mentions.delay(comment_id, 'cases', domain=current_site.domain,
            protocol=self.request.scheme)
        return JsonResponse({
            "comment_id": self.comment_obj.id,
            "comment": self.comment_obj.comment,
        })

    def form_invalid(self, form):
        return JsonResponse({"error": form['comment'].errors})


class DeleteCommentView(LoginRequiredMixin, View):

    def post(self, request, *args, **kwargs):
        self.object = get_object_or_404(
            Comment, id=request.POST.get("comment_id"))
        if (
            request.user == self.object.commented_by or
            request.user.is_superuser or
            request.user.role == 'ADMIN'
        ):
            self.object.delete()
            data = {"cid": request.POST.get("comment_id")}
            return JsonResponse(data)

        data = {'error': "You don't have permission to delete this comment."}
        return JsonResponse(data)


class AddAttachmentView(LoginRequiredMixin, CreateView):
    model = Attachments
    form_class = CaseAttachmentForm
    http_method_names = ["post"]

    def post(self, request, *args, **kwargs):
        self.object = None
        self.case = get_object_or_404(Case, id=request.POST.get('caseid'))
        if (
            request.user in self.case.assigned_to.all() or
            request.user == self.case.created_by or
            request.user.is_superuser or
            request.user.role == 'ADMIN'
        ):
            form = self.get_form()
            if form.is_valid():
                return self.form_valid(form)

            return self.form_invalid(form)

        data = {"error": True,
                "errors":
                "You don't have permission to add attachment for this case."}
        return JsonResponse(data)

    def form_valid(self, form):
        attachment = form.save(commit=False)
        attachment.created_by = self.request.user
        attachment.file_name = attachment.attachment.name
        attachment.case = self.case
        attachment.save()
        # return JsonResponse({"error": False, "message": "Attachment Saved"
        # })
        return JsonResponse({
            "attachment_id": attachment.id,
            "attachment": attachment.file_name,
            "attachment_url": attachment.attachment.url,
            "download_url":
            reverse('common:download_attachment',
                    kwargs={'pk': attachment.id}),
            "created_on": attachment.created_on,
            "created_on_arrow": attachment.created_on_arrow,
            "created_by": attachment.created_by.email,
            "message": "attachment Created",
            "attachment_display": attachment.get_file_type_display(),
            "file_type": attachment.file_type(),
            "error": False
        })

    def form_invalid(self, form):
        return JsonResponse({"error": True,
                             "errors": form['attachment'].errors})


class DeleteAttachmentsView(LoginRequiredMixin, View):

    def post(self, request, *args, **kwargs):
        self.object = get_object_or_404(
            Attachments, id=request.POST.get("attachment_id"))
        if (
            request.user == self.object.created_by or
            request.user.is_superuser or
            request.user.role == 'ADMIN'
        ):
            self.object.delete()
            data = {"attachment_object": request.POST.get(
                "attachment_id"), "error": False}
            return JsonResponse(data)

        data = {"error": True,
                "errors":
                "You don't have permission to delete this attachment."}
        return JsonResponse(data)



def create_sla(request):
    user_list = User.objects.all()
    
    if request.method=="POST":
        o_status = "Open"
        print(o_status)
        time = request.POST.get('appt1')
        print(time)
        o_vuser = request.POST.get('vuser')
        print(o_vuser)
        o_voice = SlaVoice.objects.create(status=o_status,respond_within=time,escalate_to_id=o_vuser)
        p_status = "In Progress"
        p_time = request.POST.get('appt3')
        p_vuser = request.POST.get('puser')
        p_voice = SlaVoice.objects.create(status=p_status,respond_within=p_time,escalate_to_id=p_vuser)
        return HttpResponseRedirect("/cases/sla/create/")

    return render(request,'sla_create.html',{'user_list':user_list})

def create_slaemail(request):
    if request.method=="POST":
        o_status = "Open"
        print(o_status)
        time = request.POST.get('appt')
        print(time)
        o_euser = request.POST.get('euser')
        print(o_euser)
        o_email = SlaEmail.objects.create(status=o_status,respond_within=time,escalate_to_id=o_euser)
        p_status = "In Progress"
        day = request.POST.get('appt1')
        p_euser = request.POST.get('p_user')
        p_email = SlaEmail.objects.create(status=p_status,respond_within=day,escalate_to_id=p_euser)
        return HttpResponseRedirect("/cases/sla/create/")

    return render(request,'sla_create.html')


def update_sla(request,pk):
    print(pk)
    sla_details = Sla.objects.all()
    edit = Sla.objects.all().filter(id=pk)
    id=pk
    if request.method=="POST":
        status = request.POST.get('status')
        time = request.POST.get('time')
        user = request.user.id
        update_sla = Sla.objects.filter(id=pk).update(status=status,time=time,user_id=user)

        return HttpResponseRedirect("/cases/")

    return render(request,'sla_edit.html',{'sla':sla_details,"edit":edit,'id':id})


# class SlaListView(SalesAccessRequiredMixin, LoginRequiredMixin, TemplateView):
#     model = Sla
#     context_object_name = "sla"
#     template_name = "sla.html"

#     def get_context_data(self, **kwargs):
#         uid = self.request.user.id
#         if self.request.user.role == 'ADMIN' or self.request.user.is_superuser:
#             sla = Sla.objects.all()
#             context = super(SlaListView, self).get_context_data(**kwargs)
#             # context = {}
#             context['sla'] = sla
#             return context
#         else:
#             sla = Sla.objects.all().filter(user_id=uid)
#             context = super(SlaListView, self).get_context_data(**kwargs)
#             # context = {}
#             context['sla'] = sla
#             return context

#     def get(self, request, *args, **kwargs):
#         context = self.get_context_data(**kwargs)
#         return self.render_to_response(context)

#     def post(self, request, *args, **kwargs):
#         context = self.get_context_data(**kwargs)
#         return self.render_to_response(context)

def slalist(request):
    uid = request.user.id

    if request.user.role == 'ADMIN' or request.user.is_superuser:
        
        sla = Sla.objects.all()
        return render(request,'sla.html',{"sla":sla})
    else:
        sla = Sla.objects.all().filter(user_id=uid)
        return render(request,'sla.html',{"sla":sla}) 


def allsla(request):
    user_list = User.objects.all()
    
    if request.method=="POST":
        voiceopen_status = "Open"
        voiceopen_respond_within = request.POST.get('voiceopentime')
        print(voiceopen_respond_within)
        voiceprogress_status = "In Progress"
        voiceprogress_respond_within = request.POST.get('voiceprogresstime')
        print(voiceprogress_respond_within)
       
        emailopen_status = "Open"
        emailopen_respond_within = request.POST.get('emailopentime')
        # eo_vuser = request.POST.get('vuser')       
        emailprogress_status = "In Progress"
        emailprogress_respond_within = request.POST.get('emailprogressday')
        # ep_vuser = request.POST.get('puser')
        if(Sla.objects.exists()):
            print("exists")
            exit_sla = Sla.objects.all().delete()
            vp_voice=Sla.objects.create(voiceopen_status=voiceopen_status,voiceopen_respond_within=voiceopen_respond_within,voiceprogress_status=voiceprogress_status,voiceprogress_respond_within=voiceprogress_respond_within,emailopen_status=emailopen_status,emailopen_respond_within=emailopen_respond_within,emailprogress_status=emailprogress_status,emailprogress_respond_within=emailprogress_respond_within)
        else:
            vp_voice=Sla.objects.create(voiceopen_status=voiceopen_status,voiceopen_respond_within=voiceopen_respond_within,voiceprogress_status=voiceprogress_status,voiceprogress_respond_within=voiceprogress_respond_within,emailopen_status=emailopen_status,emailopen_respond_within=emailopen_respond_within,emailprogress_status=emailprogress_status,emailprogress_respond_within=emailprogress_respond_within)

        return redirect("/cases/sla/")
    return render(request,'sla_create.html',{'user_list':user_list})
    
def allslalist(request):
    # uid = request.user.id

    # if request.user.role == 'ADMIN' or request.user.is_superuser:
    sla = Sla.objects.all()
    return render(request,'sla.html',{"sla":sla})

def allsladel(request, pk):
    # object = CustomUser.objects.get(id=del_id)
    edit = Sla.objects.all().filter(id=pk)
    edit.delete()
    return redirect("/cases/sla/")
 

def allslaedit(request,pk):
    user_list = User.objects.all()
    print(pk)
    sla_details = Sla.objects.all()
    edit = Sla.objects.all().filter(id=pk)
    
    id=pk
    if request.method=="POST":
        voiceopen_status = "Open"
        voiceopen_respond_within = request.POST.get('voiceopentime')
        print('voiceopen_respond_within',voiceopen_respond_within)
        voiceprogress_status = "In Progress"
        voiceprogress_respond_within = request.POST.get('voiceprogresstime')
        print('voiceprogress_respond_within',voiceprogress_respond_within)
        
        emailopen_status = "Open"
        # print(o_status)
        emailopen_respond_within = request.POST.get('emailopentime')
        print('emailopen_respond_within:',emailopen_respond_within)
        # eo_vuser = request.POST.get('vuser')
        # print(o_vuser)
        # eo_voice = SlaVoice.objects.create(e_status=o_status,e_respond_within=time,e_escalate_to_id=o_vuser)
        emailprogress_status = "In Progress"
        emailprogress_respond_within = request.POST.get('emailprogressday')
        print('emailprogress_respond_within:',emailprogress_respond_within)
        # ep_vuser = request.POST.get('puser')
        # ep_voice = SlaVoice.objects.create(e_status=p_status,e_respond_within=p_time,e_escalate_to_id=p_vuser)
        vp_voice=Sla.objects.filter(id=pk).update(voiceopen_status=voiceopen_status,voiceopen_respond_within=voiceopen_respond_within,voiceprogress_status=voiceprogress_status,voiceprogress_respond_within=voiceprogress_respond_within,emailopen_status=emailopen_status,emailopen_respond_within=emailopen_respond_within,emailprogress_status=emailprogress_status,emailprogress_respond_within=emailprogress_respond_within)
        # update_sla = Sla.objects.filter(id=pk).update(status=status,time=time,user_id=user)
        return redirect("/cases/sla/")

    return render(request,'sla_edit.html',{'sla':sla_details,"edit":edit,'id':id,'user_list':user_list})

def notifistatus(request):
    # object = CustomUser.objects.get(id=del_id)
    print('8888888888888888888',request.POST.get('cid'))
    cid=request.POST.get('cid')
    edit = Notification.objects.all().filter(userid=cid)
    den= LeadNotification.objects.all().filter(userid=cid)
    edit.delete()
    den.delete()
    return redirect("/cases/cases/")