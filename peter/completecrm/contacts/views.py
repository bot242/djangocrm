import json
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.sites.shortcuts import get_current_site
from django.core.mail import EmailMessage
from django.http import JsonResponse
from django.shortcuts import get_object_or_404, redirect
from django.template.loader import render_to_string
from django.urls import reverse
from django.views.generic import (
    CreateView, UpdateView, DetailView, TemplateView, View)
from common.models import User, Comment, Attachments
from common.forms import BillingAddressForm
from common.utils import COUNTRIES
from cases.models import *
from contacts.models import *
from contacts.forms import (ContactForm,
                            ContactCommentForm, ContactAttachmentForm)
from accounts.models import Account
from cases.models import Case
from django.core.exceptions import PermissionDenied
from django.db.models import Q
from common.tasks import send_email_user_mentions
from contacts.tasks import send_email_to_assigned_user
from common.access_decorators_mixins import (
    sales_access_required, marketing_access_required,service_access_required,ServiceAccessRequiredMixin, SalesAccessRequiredMixin, MarketingAccessRequiredMixin)
from teams.models import Teams
from django.db.models import Count

from rest_framework.status import (
    HTTP_400_BAD_REQUEST,
    HTTP_404_NOT_FOUND,
    HTTP_200_OK
)

from rest_framework.decorators import api_view
from django.core import serializers
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.views.decorators.csrf import csrf_exempt,csrf_protect 
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.renderers import TemplateHTMLRenderer
from datetime import date
import re
from cases.models import Case
from cases.views import create_case
import imaplib
import email
from django.shortcuts import render
def dashboard(request):
    contact = Contact.objects.values('first_name').filter(created_on=date.today()).count()

    dataset = Contact.objects \
        .values('first_name') \
        .annotate(case_count=Count('first_name', filter=Q(created_on=date.today())))
    case = Contact.objects.values('first_name').filter(created_on=date.today()).count()
    print("Total case:",case)
    print("dataset:",dataset)

    return render(request, 'sales/index.html', {'dataset': dataset,'case':case})
@api_view(['GET',])    
def ipcontact(request,phone=None):
    print("//////////////////")
    if request.method == "GET":

        if (Contact.objects.filter(phone1=phone).exists()):
            visitor = Contact.objects.filter(phone1=phone)
            print("Visitor:",visitor)
            for v in visitor:
                id = v.id
                v_name = v.first_name
                v_phone = v.phone1
                contact = Contact.objects.filter(created_on=date.today())
                print("Contact date",contact)
                print("already exists")
                channel_layer = get_channel_layer()
                async_to_sync(channel_layer.group_send)("gossip", 
                {"type": "user.gossip",
                "event": "Old User",
                "username": v_name,
                "phone":v_phone,
                })
                return Response(data="success",status=status.HTTP_200_OK)     
        else:
            print('new')
           
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)("gossip", 
            {"type": "user.gossip",
            "event": "New User",
            "username": "Unkown Number",
            "phone":phone
            })
            return Response(data="created",status=status.HTTP_200_OK)

@api_view(['GET', 'POST'])
@csrf_exempt
def ipecs(request):
    renderer_classes = [TemplateHTMLRenderer]
    template_name = 'contacts/create_contact.html'
    if request.method == 'POST':
        d = request.data
        # p=d.get('phone')
        # fname=d.get('first_name')
        # lname=d.get('last_name')
        # mail=d.get('email')
        phone1=d.get('phone1') 
        phone2=d.get('phone2') 
        # date = d.get('created_on')
        # print("/////",date)
        # day = datetime.today().strftime('%Y-%m-%d')
        # x = re.findall(date,day) 
        # print("aaa",x) 
        print("enter)(()_())") 
        # today = date.today()
        contact = Contact.objects.values('first_name').filter(created_on=date.today()).count()
        print("CCC",contact)
        if (Contact.objects.filter(Q(phone1=phone1)|Q(phone2=phone2)).exists()):
            v = Contact.objects.filter(Q(phone1=phone1)|Q(phone2=phone2))
            for visitor in v:

                id = visitor.id
                v_name = visitor.first_name
                v_phone = visitor.phone1
                v_email=visitor.email
                v_lastname=visitor.last_name
                v_date = visitor.created_on
                contact = Contact.objects.filter(created_on=date.today())
                print("Contact date",contact)
                print("already exists")
                channel_layer = get_channel_layer()
                async_to_sync(channel_layer.group_send)("gossip", 
                {"type": "user.gossip",
                "event": "Old User",
                "username": v_name,
                "phone":v_phone,

                })
            return Response(data="success",status=status.HTTP_200_OK)     
            # return redirect('/cases/create')             
        else:
            print('new')
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)("gossip", 
            {"type": "user.gossip",
            "event": "New User",
            "username": "Unkown Number",
            "phone":phone1
            })
            return Response(data="created",status=status.HTTP_200_OK)
    elif request.method == "GET":

        return Response(data="ee",status=status.HTTP_200_OK)

def emailscheck(request):
    a_email="Nuarcpro.demo@gmail.com"
    pwd="vitae2304"
    server = "imap.gmail.com"
    port="993"
    imap = imaplib.IMAP4_SSL(server, port)
    imap.login(a_email,pwd)
    imap.select('INBOX')
    
    ###------To get count of unread mail from particular user-----####
    status, response = imap.search(None, '(UNSEEN)')
    unread_msg_nums = response[0].split()
    count = len(unread_msg_nums)
    print('********',count)
    email_ids = [e_id for e_id in response[0].split()]
    print("........................................")
    print(email_ids)
    a={}
    if email_ids:

        for e_id in email_ids:
            print("=======",e_id)
            _, response = imap.fetch(e_id, '(RFC822)')
            r=response[0][1][9:] 

            email_message = email.message_from_bytes(r)
            subject = email_message['subject']
            
            print("SUBJECT:",subject)
            ##################################################
            e_from = email_message['from']
            print(e_from)
            
            ################# From address username ###########
            e_user = e_from.split('<')
            print(e_user)
            e_username=e_user[0].capitalize()
            print("USERNAME:",e_username)
            ################### From addess Email #############
            e_email = e_user[1]
            email_address = e_email.strip('< >')

            a['email']=email_address
            print("global email address:",a)
            print("Email FROM ADDRESS:",email_address)
            ###################################################
            e_to = email_message['to']
            a_to = re.findall("([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)",e_to)
            to = a_to[0]
            print("EMAIL TO ADDRESS:",to)
            if email_message.is_multipart():

                for part in email_message.walk():
                    if part.get_content_type() == "text/plain":
                        body = part.get_payload()
                        print('body:',body)
                        
                        if (Contact.objects.filter(email=email_address).exists()):
                            print("exist")
                            # channel_layer = get_channel_layer()
                            # async_to_sync(channel_layer.group_send)("gossip", 
                            # {"type": "user.gossip",
                            # "event": "emailnewcase",
                            # "newemailcase": email_address,
                            # })
                            # e_inbox = Emailinfo(subject_inbox=subject,description=body,username=e_username,from_address=email_address,to_address=to,status=1)
                            # e_inbox.save()
                            # name=Contact.objects.values_list('first_name',flat=True).get(email=email_address)
                            # print('first_name:',name)
                            createcontact=Case(name=email_address,description=body)
                            createcontact.save()
                            
                        else:
                            e_inbox = Emailinfo(subject_inbox=subject,description=body,username=e_username,from_address=email_address,to_address=to,status=1)
                            e_inbox.save()
                            # print(s[0])
                            newemail=Contact(email=email_address,first_name=email_address,last_name="by-mail")
                            newemail.save()
                            createcontact=Case(name=email_address,description=body)
                            createcontact.save()
                            print('new contact')                            
    getmail=Emailinfo.objects.values('from_address','id')
    return render(request, 'sales/email.html',{'email':getmail})
def clientedit(request, uid=None):
    name = Contact.objects.values('id').get(id=uid)
    nm = name["id"]
    # valu = CustomUser.objects.filter(id=nm).all()
    # for v in valu:
    #     uname = v.username
    #     email = v.email
    #     phone = v.phone
    #     dob = v.dob
    #     nationality = v.nationality
    #     gender = v.gender
    #     gname = v.groupid

    #     if request.method == 'POST':
    #         username = request.POST.get('uname')
    #         email = request.POST.get('email')
    #         phone = request.POST.get('phone')
    #         dob = request.POST.get('dob')
    #         nationality = request.POST.get('nationality')
    #         gender = request.POST.get('gender')
    #         groupid = request.POST.get('gname')
    #         update = CustomUser.objects.filter(id=uid).update(username=username, email=email, phone=phone, dob=dob, nationality=nationality, gender=gender, groupid=groupid)
    #         return redirect("/clients/")

    #     else:
    #         print("create")
    return render(request, "partview.html", {'id':nm})

def emailcontact(request,e_id=None):
    print("//////////////////",e_id)
    e_inbox = Emailinfo.objects.all().get(id=e_id)
    email_address=e_inbox.from_address
    print('***',email_address)
    channel_layer = get_channel_layer()
    async_to_sync(channel_layer.group_send)("gossip", 
    {"type": "user.gossip",
    "event": "emailnewcontact",
    "newemailcase": email_address,
    })
    return redirect('/contacts/create/',{"visitor":"visitor"})
def myfunc(request):
    context = {}
    if request.method == "POST" and request.is_ajax():
        contact_name=request.POST.get('text')
        if(Case.objects.filter(name=contact_name).exists()):
            print("The name Exist")
            status = Case.objects.all().filter(Q(name=contact_name) & (Q(status="Open")| Q(status="In Progress") | Q(status="Closed")) )
            closed_status = Case.objects.values_list('status',flat=True).get(name=contact_name)
            print("CLOSED STATUS:",closed_status)
            print("ID:",Case.objects.values_list('id',flat=True).get(name=contact_name))
            caseid = Case.objects.values_list('id',flat=True).get(name=contact_name)
            # if (UpdatedCase.objects.filter(case_id=caseid).exists()):
            # print("CHANGEDBY",UpdatedCase.objects.values_list('changedby',flat=True).get(case_id=caseid))

            for ds in status:
                print(ds.case_type)
                context['case_type'] = ds.case_type
                context['case_number'] =ds.case_number
                context['case_status'] =ds.status
                context['case_creation_date'] =ds.creation_date
                context['closed_date'] = ds.closed_on
                if (UpdatedCase.objects.filter(case_id=caseid).exists()):
                    context['changedby'] = UpdatedCase.objects.values_list('changedby',flat=True).get(case_id=caseid)
                else:
                    context['changedby'] = User.objects.values_list('username',flat=True).get(id=ds.created_by_id)
                print(ds.closed_on)
            context['status'] = closed_status
        print ('ssssssssssss',context)
        return JsonResponse(context)

class ContactsListView( LoginRequiredMixin, TemplateView):
    model = Contact
    context_object_name = "contact_obj_list"
    template_name = "contacts.html"

    def get_queryset(self):
        # contact_name = self.request.GET.get('cid')
        # print("Name:",contact_name)
        # # name =  Contact.objects.values_list('first_name',flat=True).filter(id=contact_id)
        # # print("Name:",name)
        # if(Case.objects.filter(name=contact_name).exists()):
        #     print("The name Exist")
        #     status = Case.objects.all().filter(name=contact_name)
        #     print(status)
       

        queryset = self.model.objects.all().order_by('-id')
        if (self.request.user.role != "ADMIN" and not
                self.request.user.is_superuser):
            queryset = queryset.filter(
                Q(assigned_to__in=[self.request.user]) |
                Q(created_by=self.request.user))

        request_post = self.request.POST
     
        if request_post:
            if request_post.get('first_name'):
                queryset = queryset.filter(
                    first_name__icontains=request_post.get('first_name'))
            if request_post.get('city'):
                queryset = queryset.filter(
                    address__city__icontains=request_post.get('city'))
            if request_post.get('phone1'):
                queryset = queryset.filter(
                    phone1__icontains=request_post.get('phone1'))
            if request_post.get('phone2'):
                queryset = queryset.filter(
                    phone2__icontains=request_post.get('phone2'))
            if request_post.get('email'):
                queryset = queryset.filter(
                    email__icontains=request_post.get('email'))
            if request_post.getlist('assigned_to'):
                queryset = queryset.filter(
                    assigned_to__id__in=request_post.getlist('assigned_to'))
        return queryset.distinct()

    def get_context_data(self, **kwargs):
        context = super(ContactsListView, self).get_context_data(**kwargs)

        data = []
        contact_name = self.request.GET.get('cid')
        print("Name:",contact_name)
     
        if(Case.objects.filter(name=contact_name).exists()):
            print("The name Exist")
            status = Case.objects.all().filter(name=contact_name)
            print(status)

            data.append(status)
        
        print(data,"data:...")
        # for d in data:
        #     for j in d:
        #         print(j.status,"status")
        context["case"] = data
        context["contact_obj_list"] = self.get_queryset()
        context["per_page"] = self.request.POST.get('per_page')
        context["users"] = User.objects.filter(
            is_active=True).order_by('email')
        context["assignedto_list"] = [
            int(i) for i in self.request.POST.getlist('assigned_to', []) if i]
        search = False
        if (
            self.request.POST.get('first_name') or
            self.request.POST.get('city') or
            self.request.POST.get('phone1') or
            self.request.POST.get('phone2') or
            self.request.POST.get('email') or self.request.POST.get('assigned_to')
        ):
            search = True
        context["search"] = search
        return context

    def post(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)


class CreateContactView(LoginRequiredMixin, CreateView):
    model = Contact
    form_class = ContactForm
    template_name = "create_contact.html"

    def dispatch(self, request, *args, **kwargs):
        if self.request.user.role == 'ADMIN' or self.request.user.is_superuser:
            self.users = User.objects.filter(is_active=True).order_by('email')
        else:
            self.users = User.objects.filter(role='ADMIN').order_by('email')
        return super(CreateContactView, self).dispatch(
            request, *args, **kwargs)

    def get_form_kwargs(self):
        kwargs = super(CreateContactView, self).get_form_kwargs()
        if self.request.user.role == 'ADMIN' or self.request.user.is_superuser:
            self.users = User.objects.filter(is_active=True).order_by('email')
            kwargs.update({"assigned_to": self.users})
        return kwargs

    def post(self, request, *args, **kwargs):
        self.object = None
        form = self.get_form()
        address_form = BillingAddressForm(request.POST)
        if request.method=="POST":
            m_email=request.POST.getlist('context')
            rate=request.POST.get('defaultSelected')
            fn=request.POST.get('first_name')
        if form.is_valid() and address_form.is_valid():
            address_obj = address_form.save()
            contact_obj = form.save(commit=False)
            contact_obj.address = address_obj
            contact_obj.created_by = self.request.user
            print('****0000',rate)
            s=int(rate)
            print('**********',m_email[s])
            contact_obj.save()
            if Contact.objects.filter(first_name=fn).exists():
                v=Contact.objects.filter(first_name=fn).update(email=m_email[s])
                lid = Contact.objects.values_list('id',flat=True).latest('id')
                print("lid:",lid)
                # ids=Contact.objects.values_list('id',flat=True).get(id=lid)
                # print('^&*(',ids)
                for m in m_email:
                    print('87777777',m)
                    if m != "":
                        print("email is there")
                        mmail=Multimail.objects.create(email=m,category_id=lid)
                    else:
                        print("email is not there")
            else:
                print('no')
            if self.request.GET.get('view_account', None):
                if Account.objects.filter(
                        id=int(self.request.GET.get('view_account'))).exists():
                    Account.objects.get(id=int(self.request.GET.get(
                        'view_account'))).contacts.add(contact_obj)
            return self.form_valid(form)

        return self.form_invalid(form)

    def form_valid(self, form):
        contact_obj = form.save(commit=False)
        if self.request.POST.getlist('assigned_to', []):
            contact_obj.assigned_to.add(
                *self.request.POST.getlist('assigned_to'))
            # for assigned_to_user in assigned_to_list:
            #     user = get_object_or_404(User, pk=assigned_to_user)
            #     mail_subject = 'Assigned to contact.'
            #     message = render_to_string(
            #         'assigned_to/contact_assigned.html', {
            #             'user': user,
            #             'domain': current_site.domain,
            #             'protocol': self.request.scheme,
            #             'contact': contact_obj
            #         })
            #     email = EmailMessage(mail_subject, message, to=[user.email])
            #     email.content_subtype = "html"
            #     email.send()
        if self.request.POST.getlist('teams', []):
            user_ids = Teams.objects.filter(id__in=self.request.POST.getlist('teams')).values_list('users', flat=True)
            assinged_to_users_ids = contact_obj.assigned_to.all().values_list('id', flat=True)
            for user_id in user_ids:
                if user_id not in assinged_to_users_ids:
                    contact_obj.assigned_to.add(user_id)

        if self.request.POST.getlist('teams', []):
            contact_obj.teams.add(*self.request.POST.getlist('teams'))

        assigned_to_list = list(contact_obj.assigned_to.all().values_list('id', flat=True))
        current_site = get_current_site(self.request)
        recipients = assigned_to_list
        send_email_to_assigned_user.delay(recipients, contact_obj.id, domain=current_site.domain,
            protocol=self.request.scheme)

        if self.request.FILES.get('contact_attachment'):
            attachment = Attachments()
            attachment.created_by = self.request.user
            attachment.file_name = self.request.FILES.get(
                'contact_attachment').name
            attachment.contact = contact_obj
            attachment.attachment = self.request.FILES.get(
                'contact_attachment')
            attachment.save()

        if self.request.is_ajax():
            return JsonResponse({'error': False})
        if self.request.POST.get("savenewform"):
            return redirect("cases:add_case")

        return redirect('contacts:list')

    def form_invalid(self, form):
        address_form = BillingAddressForm(self.request.POST)
        if self.request.is_ajax():
            return JsonResponse({'error': True, 'contact_errors': form.errors,
                                 'address_errors': address_form.errors})
        return self.render_to_response(
            self.get_context_data(form=form, address_form=address_form))

    def get_context_data(self, **kwargs):
        context = super(CreateContactView, self).get_context_data(**kwargs)
        context["contact_form"] = context["form"]
        context["users"] = self.users
        context["countries"] = COUNTRIES
        context["assignedto_list"] = [
            int(i) for i in self.request.POST.getlist('assigned_to', []) if i]
        if "address_form" in kwargs:
            context["address_form"] = kwargs["address_form"]
        else:
            if self.request.POST:
                context["address_form"] = BillingAddressForm(self.request.POST)
            else:
                context["address_form"] = BillingAddressForm()
        context["teams"] = Teams.objects.all()
        return context




class ContactDetailView( LoginRequiredMixin, DetailView):
    model = Contact
    context_object_name = "contact_record"
    template_name = "view_contact.html"

    def get_queryset(self):
        queryset = super(ContactDetailView, self).get_queryset()
        return queryset.select_related("address")

    def get_context_data(self, **kwargs):
        context = super(ContactDetailView, self).get_context_data(**kwargs)
        user_assgn_list = [
            assigned_to.id for assigned_to in context['object'].assigned_to.all()]
        user_assigned_accounts = set(self.request.user.account_assigned_users.values_list('id', flat=True))
        contact_accounts = set(context['object'].account_contacts.values_list('id', flat=True))
        if user_assigned_accounts.intersection(contact_accounts):
            user_assgn_list.append(self.request.user.id)
        if self.request.user == context['object'].created_by:
            user_assgn_list.append(self.request.user.id)
        if (self.request.user.role != "ADMIN" and not
                self.request.user.is_superuser):
            if self.request.user.id not in user_assgn_list:
                raise PermissionDenied
        assigned_data = []
        for each in context['contact_record'].assigned_to.all():
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

        context.update({"comments":
                        context["contact_record"].contact_comments.all(),
                        'attachments':
                        context["contact_record"].contact_attachment.all(),
                        "assigned_data": json.dumps(assigned_data),
                        "tasks" : context['object'].contacts_tasks.all(),
                        'users_mention':  users_mention,
                        })
        return context


class UpdateContactView( LoginRequiredMixin, UpdateView):
    model = Contact
    form_class = ContactForm
    template_name = "create_contact.html"

    def dispatch(self, request, *args, **kwargs):
        if self.request.user.role == 'ADMIN' or self.request.user.is_superuser:
            self.users = User.objects.filter(is_active=True).order_by('email')
        else:
            self.users = User.objects.filter(role='ADMIN').order_by('email')
        return super(UpdateContactView, self).dispatch(
            request, *args, **kwargs)

    def get_form_kwargs(self):
        kwargs = super(UpdateContactView, self).get_form_kwargs()
        if self.request.user.role == 'ADMIN' or self.request.user.is_superuser:
            self.users = User.objects.filter(is_active=True).order_by('email')
            kwargs.update({"assigned_to": self.users})
        return kwargs

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        address_obj = self.object.address
        form = self.get_form()
        address_form = BillingAddressForm(request.POST, instance=address_obj)
        if request.method=="POST":
            m_email=request.POST.getlist('context')
            rate=request.POST.get('defaultSelected')
            fn=request.POST.get('first_name')
        if form.is_valid() and address_form.is_valid():
            addres_obj = address_form.save()
            contact_obj = form.save(commit=False)
            contact_obj.address = addres_obj
            print('****0000',rate)
            s=int(rate)
            print('**********',m_email[s])
            contact_obj.save()
            
            if Contact.objects.filter(first_name=fn).exists():
                v=Contact.objects.filter(first_name=fn).update(email=m_email[s])
                ids=self.object.id
                print('^&*(',ids)
                dels=Multimail.objects.filter(category_id=ids).delete()
                for m in m_email:
                    print('87777777',m)
                    if m != "":
                        print("email is there")
                        mmail=Multimail.objects.create(email=m,category_id=ids)
                    else:
                        print("email is not there")
            else:
                print('no')
            return self.form_valid(form)
        return self.form_invalid(form)

    def form_valid(self, form):
        assigned_to_ids = self.get_object().assigned_to.all().values_list(
            'id', flat=True)

        contact_obj = form.save(commit=False)
        previous_assigned_to_users = list(contact_obj.assigned_to.all().values_list('id', flat=True))
        all_members_list = []
        if self.request.POST.getlist('assigned_to', []):
            current_site = get_current_site(self.request)
            assigned_form_users = form.cleaned_data.get(
                'assigned_to').values_list('id', flat=True)
            all_members_list = list(
                set(list(assigned_form_users)) - set(list(assigned_to_ids)))
            # if all_members_list:
            #     for assigned_to_user in all_members_list:
            #         user = get_object_or_404(User, pk=assigned_to_user)
            #         mail_subject = 'Assigned to contact.'
            #         message = render_to_string(
            #             'assigned_to/contact_assigned.html', {
            #                 'user': user,
            #                 'domain': current_site.domain,
            #                 'protocol': self.request.scheme,
            #                 'contact': contact_obj
            #             })
            #         email = EmailMessage(
            #             mail_subject, message, to=[user.email])
            #         email.content_subtype = "html"
            #         email.send()

            contact_obj.assigned_to.clear()
            contact_obj.assigned_to.add(
                *self.request.POST.getlist('assigned_to'))
        else:
            contact_obj.assigned_to.clear()

        if self.request.POST.getlist('teams', []):
            user_ids = Teams.objects.filter(id__in=self.request.POST.getlist('teams')).values_list('users', flat=True)
            assinged_to_users_ids = contact_obj.assigned_to.all().values_list('id', flat=True)
            for user_id in user_ids:
                if user_id not in assinged_to_users_ids:
                    contact_obj.assigned_to.add(user_id)

        if self.request.POST.getlist('teams', []):
            contact_obj.teams.clear()
            contact_obj.teams.add(*self.request.POST.getlist('teams'))
        else:
            contact_obj.teams.clear()

        current_site = get_current_site(self.request)
        assigned_to_list = list(contact_obj.assigned_to.all().values_list('id', flat=True))
        recipients = list(set(assigned_to_list) - set(previous_assigned_to_users))
        send_email_to_assigned_user.delay(recipients, contact_obj.id, domain=current_site.domain,
            protocol=self.request.scheme)

        if self.request.FILES.get('contact_attachment'):
            attachment = Attachments()
            attachment.created_by = self.request.user
            attachment.file_name = self.request.FILES.get(
                'contact_attachment').name
            attachment.contact = contact_obj
            attachment.attachment = self.request.FILES.get(
                'contact_attachment')
            attachment.save()
        if self.request.POST.get('from_account'):
            from_account = self.request.POST.get('from_account')
            return redirect("accounts:view_account", pk=from_account)
        if self.request.is_ajax():
            return JsonResponse({'error': False})
        return redirect("contacts:list")

    def form_invalid(self, form):
        address_obj = self.object.address
        address_form = BillingAddressForm(
            self.request.POST, instance=address_obj)
        if self.request.is_ajax():
            return JsonResponse({'error': True, 'contact_errors': form.errors,
                                 'address_errors': address_form.errors})
        return self.render_to_response(
            self.get_context_data(form=form, address_form=address_form))

    def get_context_data(self, **kwargs):
        context = super(UpdateContactView, self).get_context_data(**kwargs)
        context["contact_obj"] = self.object
        user_assgn_list = [
            assigned_to.id for assigned_to in context["contact_obj"].assigned_to.all()]
        if self.request.user == context['contact_obj'].created_by:
            user_assgn_list.append(self.request.user.id)
        if (self.request.user.role != "ADMIN" and not
                self.request.user.is_superuser):
            if self.request.user.id not in user_assgn_list:
                raise PermissionDenied
        self.object = self.get_object()
        print("id:",self.object.id)
        ids=self.object.id
        memail=Multimail.objects.values('email').filter(category_id=ids)
        data=[]
        if memail.exists():
            print("yes")
        else:
            temps={}
            cs=Contact.objects.values_list('email',flat=True).get(id=ids)
            # print("no",cs)
            temps['email']=cs
            data.append(temps)
        
        for ms in memail:
            
            temp={}
            temp['email']=ms["email"]
            data.append(temp)
            print("mmm",ms["email"])
        
        context["address_obj"] = self.object.address
        context["contact_form"] = context["form"]
        context["users"] = self.users
        context["countries"] = COUNTRIES
        context["email"]=data
        context["teams"] = Teams.objects.all()
        context["assignedto_list"] = [
            int(i) for i in self.request.POST.getlist('assigned_to', []) if i]
        if "address_form" in kwargs:
            context["address_form"] = kwargs["address_form"]
        else:
            if self.request.POST:
                context["address_form"] = BillingAddressForm(
                    self.request.POST, instance=context["address_obj"])
            else:
                context["address_form"] = BillingAddressForm(
                    instance=context["address_obj"])
        return context


class RemoveContactView( LoginRequiredMixin, View):

    def get(self, request, *args, **kwargs):
        return self.post(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        contact_id = kwargs.get("pk")
        self.object = get_object_or_404(Contact, id=contact_id)
        if (self.request.user.role != "ADMIN" and not
            self.request.user.is_superuser and
                self.request.user != self.object.created_by):
            raise PermissionDenied
        else:
            if self.object.address_id:
                self.object.address.delete()
            self.object.delete()
            if self.request.is_ajax():
                return JsonResponse({'error': False})
            return redirect("contacts:list")


class AddCommentView(LoginRequiredMixin, CreateView):
    model = Comment
    form_class = ContactCommentForm
    http_method_names = ["post"]

    def post(self, request, *args, **kwargs):
        self.object = None
        self.contact = get_object_or_404(
            Contact, id=request.POST.get('contactid'))
        if (
            request.user in self.contact.assigned_to.all() or
            request.user == self.contact.created_by or
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
        comment.contact = self.contact
        comment.save()
        comment_id = comment.id
        current_site = get_current_site(self.request)
        send_email_user_mentions.delay(comment_id, 'contacts', domain=current_site.domain,
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
        if request.user == self.comment_obj.commented_by:
            form = ContactCommentForm(request.POST, instance=self.comment_obj)
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
        send_email_user_mentions.delay(comment_id, 'contacts', domain=current_site.domain,
            protocol=self.request.scheme)
        return JsonResponse({
            "commentid": self.comment_obj.id,
            "comment": self.comment_obj.comment,
        })

    def form_invalid(self, form):
        return JsonResponse({"error": form['comment'].errors})


class DeleteCommentView(LoginRequiredMixin, View):

    def post(self, request, *args, **kwargs):
        self.object = get_object_or_404(
            Comment, id=request.POST.get("comment_id"))
        if request.user == self.object.commented_by:
            self.object.delete()
            data = {"cid": request.POST.get("comment_id")}
            return JsonResponse(data)

        data = {'error': "You don't have permission to delete this comment."}
        return JsonResponse(data)


class GetContactsView(LoginRequiredMixin, TemplateView):
    model = Contact
    context_object_name = "contacts"
    template_name = "contacts_list.html"

    def get_context_data(self, **kwargs):
        context = super(GetContactsView, self).get_context_data(**kwargs)
        context["contacts"] = self.get_queryset()
        return context


class AddAttachmentsView(LoginRequiredMixin, CreateView):
    model = Attachments
    form_class = ContactAttachmentForm
    http_method_names = ["post"]

    def post(self, request, *args, **kwargs):
        self.object = None
        self.contact = get_object_or_404(
            Contact, id=request.POST.get('contactid'))
        if (
                request.user in self.contact.assigned_to.all() or
                request.user == self.contact.created_by or
                request.user.is_superuser or
                request.user.role == 'ADMIN'
        ):
            form = self.get_form()
            if form.is_valid():
                return self.form_valid(form)

            return self.form_invalid(form)

        data = {'error': "You don't have permission to add attachment."}
        return JsonResponse(data)

    def form_valid(self, form):
        attachment = form.save(commit=False)
        attachment.created_by = self.request.user
        attachment.file_name = attachment.attachment.name
        attachment.contact = self.contact
        attachment.save()
        return JsonResponse({
            "attachment_id": attachment.id,
            "attachment": attachment.file_name,
            "attachment_url": attachment.attachment.url,
            "created_on": attachment.created_on,
            "created_on_arrow": attachment.created_on_arrow,
            "download_url": reverse('common:download_attachment',
                                    kwargs={'pk': attachment.id}),
            "attachment_display": attachment.get_file_type_display(),
            "created_by": attachment.created_by.email,
            "file_type": attachment.file_type()
        })

    def form_invalid(self, form):
        return JsonResponse({"error": form['attachment'].errors})


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
            data = {"aid": request.POST.get("attachment_id")}
            return JsonResponse(data)

        data = {'error':
                "You don't have permission to delete this attachment."}
        return JsonResponse(data)
