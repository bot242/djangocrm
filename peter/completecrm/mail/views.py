from django.shortcuts import render,redirect,get_object_or_404
from django.urls import reverse
from django.db.models import Count
import imaplib
import email
from django.core.mail import EmailMessage
from django.core.mail import send_mail,EmailMultiAlternatives
import re
from .models import Inbox,Subjectmatch
from django.template.loader import render_to_string
from django.db.models import Q
from cases.models import Case,SlaVoice,SlaEmail,Sla,UpdatedCase
import datetime
from .models import User

def dashboard(request):
    print('test')
    server = "imap.gmail.com"
    port='993'
    a_email="orangeapp345@gmail.com"
    pwd="zoogle@123 "
    imap = imaplib.IMAP4_SSL(server, port)
    imap.login(a_email,pwd)
    imap.select('INBOX')
    status, response = imap.search(None, '(UNSEEN)')

    unread_msg_nums = response[0].split()
    count = len(unread_msg_nums)
    print(count)
    email_ids = [e_id for e_id in response[0].split()]
    print("........................................")
    print(email_ids)
    
    if email_ids:

        for e_id in email_ids:
            print("=======",e_id)
            _, response = imap.fetch(e_id, '(RFC822)')
            r=response[0][1][9:] 

            email_message = email.message_from_bytes(r)
            subject = email_message['subject']
            
            print("SUBJECT:",subject)
            # s = word_tokenize(subject)
            # print("NLP:",word_tokenize(subject))
            ##################################################
            e_from = email_message['from']
            print(e_from)
            
            ################# From address username ###########
            e_user = e_from.split('<')
            # print(e_user)
            e_username=e_user[0].capitalize()
            print("USERNAME:",e_username)
            ################### From addess Email #############
            e_email = e_user[1]
            email_address = e_email.strip('< >')
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
                        print('**************',body)
                        e_inbox = Inbox(subject_inbox=subject,description=body,username=e_username,from_address=email_address,to_address=to,status=1)
                        e_inbox.save()
                        status="Open"
                        sla_time = Sla.objects.values('voiceopen_respond_within').filter(voiceopen_status=status)
                        print(sla_time,":time")          
                        counts_case=Case.objects.all().count()
                        print('8888888888888888888888888888',counts_case)
                        addcase = counts_case+1
                        # print("--------",addcase)   
                        ccase="C_00"+str(addcase) 
                        print('==========ssss',ccase)       
                        c_case=Case(name=e_username,email=email_address,status=status,case_number=ccase,creation_date=datetime.datetime.now())
                        c_case.save()
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

                        print('=============')
    ebox=Inbox.objects.all()

    return render(request,'mailbox.html',{'ebox':ebox})

def notification(request, pk):
    addrs = Inbox.objects.values_list('from_address', flat=True).get(id=pk)
    print(addrs,"----adrs---")
    ids = Inbox.objects.values_list('id', flat=True).get(id=pk)
    print(ids,"-----ids-----")
    new_status = 'read'
    
    # ink = Case.objects.create(inbox_id=pk) 
    # print(pk,"-----")
    if request.user.role != "ADMIN" and not request.user.is_superuser:

        if(Inbox.objects.filter(id=pk, read_status='unread').exists()):
            user = request.user.id
            print(user, "-----------user------------------")
            nam = Inbox.objects.values('read_status', 'username').get(id=pk)

            add = Inbox.objects.filter(id=pk).update(read_status=new_status)
            
            mn = Case.objects.values_list('id', flat=True).get(email=addrs)
            print(mn,"+++++++++++++++++")
            from django.db import connections

            cursor = connections['default'].cursor()
            cursor.execute("INSERT INTO cases_case_assigned_to(case_id,user_id) VALUES( %s , %s )", [mn, user])
            
            # abc = Case.objects.create(assigned_to.add(user_id=user))
            # print(abc,"++++++++++++++")
            # if(Inbox.objects.filter(id=pk, read_status='read')):
            #     # aabc = 
            #     print('success')
        else:
            print('failed')
            add = Inbox.objects.filter(id=pk).update(read_status=new_status)



    

    sub = Inbox.objects.values('username', 'from_address', 'to_address', 'created_datetime', 'subject_inbox', 'description').filter(id=pk)
    # print(sub)
    for s in sub:
        name = s['username']
        print(name)
        fr_add = s['from_address']
        to_add = s['to_address']
        subject = s['subject_inbox']
        descpt = s['description']
        date = s['created_datetime']


        return render(request,'notice.html', {'username':name, 'fr_add':fr_add, 'to_add':to_add, 'subject':subject, 'descpt':descpt, 'date':date})