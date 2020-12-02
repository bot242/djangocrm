from django.shortcuts import render,redirect,get_object_or_404
from .models import User,Staff,Contractor,Visitor,EntryExit,Sample
from management.forms import UserForm
from django.contrib import messages
from django.contrib.auth import authenticate, login , logout
import qrcode
import time
import datetime
from PIL import Image
from cryptography.fernet import Fernet
# Create your views here.
import cv2
import numpy as np
import pyzbar.pyzbar as pyzbar
from django.http import StreamingHttpResponse
import json
import sys
from twilio.rest import Client
from rest_framework import viewsets
from django.contrib.auth.decorators import login_required
from django.template import Context, Template
from datetime import date
import csv
import time
from django.db.models import Q
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from django.core.mail import send_mail
from django.core.mail import EmailMessage
import email
# ipecs import
from management.serializers import SampleSerializer
from rest_framework.decorators import api_view
from django.core import serializers
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.views.decorators.csrf import csrf_exempt,csrf_protect 


entrydetails=[]
def index(request):
    return render(request,'login.html')
def test(request):
    if request.method == 'GET':
        tasks = test.objects.all()



def register(request):
    registered = False
    if request.method == 'POST':
        user_form = UserForm(data=request.POST)
        print("ssss")
        if user_form.is_valid() :
            user = user_form.save()
            user.set_password(user.password)
            user.save()
            print("Registered successfully")
            registered = True
            messages.success(request, 'Account created successfully')
            return redirect('/userlogin')
        else:
            messages.success(request,'Already Registered')
            print("iiiiiiiiiii",user_form.errors)

    else:
        user_form = UserForm()
    return render(request,'register.html',{'user_form':user_form,'registered':registered})


def userlogin(request):
  
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        name = User.objects.get(username = username)
        print("username:",name)
        
        
        user = authenticate(username=name, password=password)
        if user:
            if user.is_active:
                login(request,user)
                return redirect('/dashboard')
            else:
                return HttpResponse("Your account was inactive.")

        else:
            print("Someone tried to login and failed.")
            print("They used username: {} and password: {}".format(username,password))
            messages.success(request, 'Invalid Password')

            return redirect('/userlogin')                
    return render(request,'login.html')  

def userlogout(request):
    logout(request)
    if request.user.is_authenticated:
        return render(request,'/dashboard/')
    else:
        logout(request)
        return redirect("/userlogin/")        

@login_required(login_url='/login')

def dashboard(request):
    print('ues')
    loginusername = request.user.username
    contractor = Contractor.objects.all().count()
    visitor = Visitor.objects.all().count()
    entryexit = EntryExit.objects.all().count()
    loginid = request.user.id
    loginemail = request.user.email
    print("hai",contractor)
    return render(request,'management/dashboard.html',{'loginusername':loginusername,'loginemail':loginemail,'c_count':contractor,'v_count':visitor,'ex_count':entryexit})
@login_required(login_url='/login')
def staff(request):
    loginusername = request.user.username
    loginid = request.user.id
    loginemail = request.user.email
    return render(request,'management/staffs.html',{'loginusername':loginusername,'loginemail':loginemail})



# @login_required(login_url='/login')
@api_view(['GET', 'POST'])
@csrf_exempt
def ipecs(request):
    if request.method == 'POST':
        d = request.data
        p=d.get('phone')
        s=d.get('staffname')
        staff = request.POST.get('staff')   
        print("enter)(()_())")   
        if (Sample.objects.filter(staffname=s).exists()):
            visitor = Sample.objects.get(staffname=s)
            id = visitor.id
            v_name = visitor.staffname
            v_phone = visitor.phone
            v_developer=visitor.developer
            print("already")
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)("gossip", 
            {"type": "user.gossip",
            "event": "New User",
            "username": v_name,
            "phone":v_phone,
            "user":v_developer})
            return Response(data="created",status=status.HTTP_200_OK)                  
        else:
            print('new')
            staffs=Sample(staffname=s,phone=p)
            staffs.save()
            return Response(data="created",status=status.HTTP_200_OK)
    return render(request,'management/pop.html')


@login_required
def contractor(request):
    loginusername = request.user.username
    loginid = request.user.id
    loginemail = request.user.email
    if request.method == 'POST':
        contractorname = request.POST.get('contractorname')
        contractorid = request.POST.get('contractorid')
        companyname = request.POST.get('companyname')
        mailid = request.POST.get('mailid')
        phone = request.POST.get('phone')
        validity = request.POST.get('validity')
        address = request.POST.get('address')

        qr = qrcode.QRCode(
            version = 1,
            error_correction = qrcode.constants.ERROR_CORRECT_H,
            box_size = 10,
            border = 4,
        )
        
        # The data that you want to store
        data =('Name:'+ contractorname,'id:'+contractorid,'Company:'+ companyname,'Phone:'+ phone,'Email:'+ mailid,'Address:'+ address)
        print(data,"rfsdfs")
        # Add data
        qr.add_data(data)
        qr.make(fit=True)

        # Create an image from the QR Code instance
        img = qr.make_image()

        # Save it somewhere, change the extension as needed:
        img.save("management/static/qrdata/Contractor/"+ contractorname+".png")
        if(Contractor.objects.filter(contractorname=contractorname).exists()):
            print("The contractorname already exists")
            return redirect('mangement/contractor/')
        else:
            contractor = Contractor(contractorname=contractorname,contractorid=contractorid,companyname=companyname,mailid=mailid,phone=phone,address=address,qrimage=qrcodeimage)
            contractor.save()
            print("Image Saved Sucessfully")
            

        ###################### Email ##########################################
      
        #######################################################################
            key = Fernet.generate_key()
            cipher_suite = Fernet(key)
            cipher_text = cipher_suite.encrypt(b"A really secret message. Not for prying eyes.")
            plain_text = cipher_suite.decrypt(cipher_text)
            print(plain_text)
    c = Contractor.objects.all()
    return render(request,'contractors.html',{'loginusername':loginusername,'loginemail':loginemail,"contractor":c})
@login_required
def visitor(request):
    loginusername = request.user.username
    loginid = request.user.id
    loginemail = request.user.email
    if request.method == 'POST':
        visitorname = request.POST.get('visitorname')
        mailid = request.POST.get('mailid')
        phone = request.POST.get('phone')
        purpose = request.POST.get('purpose')

        qr = qrcode.QRCode(
            version = 1,
            error_correction = qrcode.constants.ERROR_CORRECT_H,
            box_size = 10,
            border = 4,
        )

        # The data that you want to store
        data =('Name:'+ visitorname,'Phone:'+ phone,'Email:'+ mailid,'Purpose:'+ purpose)
        print(data,"rfsdfs")
        # Add data
        qr.add_data(data)
        qr.make(fit=True)

        # Create an image from the QR Code instance
        img = qr.make_image()

        # Save it somewhere, change the extension as needed:
        img.save("management/static/qrdata/Visitor/"+ visitorname +".png")
        qrcodeimage = "management/static/qrdata/Visitor/"+ visitorname +".png"
        if(Visitor.objects.filter(visitorname=visitorname).exists()):
            print("The visitorname already exists")
            return redirect('mangement/visitor/')
        else:

            visitor = Visitor(visitorname=visitorname,mailid=mailid,phone=phone,purpose=purpose,qrimage=qrcodeimage) 
            visitor.save()
            print("Image Saved Sucessfully")
    

      

        ####################### Email ##############################
           
        ###########################################################
            key = Fernet.generate_key()
            cipher_suite = Fernet(key)
            cipher_text = cipher_suite.encrypt(b"A really secret message. Not for prying eyes.")
            plain_text = cipher_suite.decrypt(cipher_text)
            print(plain_text)
    v = Visitor.objects.all()
    print(v)
    return render(request,'visitor.html',{'loginusername':loginusername,'loginemail':loginemail,"visitor":v})

@login_required
def entryexit(request):
    loginusername = request.user.username
    loginid = request.user.id
    loginemail = request.user.email
    entryexit = EntryExit.objects.all()
    # e = EntryExit.objects.filter(name=ename).latest('id')
    # print("id.html",e.id)
    # name=e.name
    # print("n.html",name)
    # category = e.category
    # intime = e.intime
    # outtime = e.outtime
    # d = e.date
    # print(outtime)
    return render(request,'entryexit.html',{'loginusername':loginusername,'loginemail':loginemail,'entryexit':entryexit})

def contractordelete(request,contractordelete_id =None):
    object = Contractor.objects.get(id=contractordelete_id)
    object.delete()
    return redirect('/contractor/')
def visitordelete(request,visitordelete_id =None):
    object = Visitor.objects.get(id=visitordelete_id)
    object.delete()
    return redirect('/management/visitor/')


def visitoredit(request,visitoredit_id=None):
    visitor = Visitor.objects.get(id=visitoredit_id)
    id = visitor.id
    v_name = visitor.visitorname
    v_mailid = visitor.mailid
    v_phone = visitor.phone
    v_purpose = visitor.purpose
    if request.method == "POST":
        vnew_name = request.POST.get('visitorname')
        vnew_mailid = request.POST.get('mailid')
        vnew_phone = request.POST.get('phone')
        vnew_purpose = request.POST.get('purpose')

        qr = qrcode.QRCode(
            version = 1,
            error_correction = qrcode.constants.ERROR_CORRECT_H,
            box_size = 10,
            border = 4,
        )

        # The data that you want to store
        data =('Name:'+ vnew_name,'Phone:'+ vnew_phone,'Email:'+ vnew_mailid,'Purpose:'+ vnew_purpose)
        print(data,"rfsdfs")
        # Add data
        qr.add_data(data)
        qr.make(fit=True)

        # Create an image from the QR Code instance
        img = qr.make_image()

        # Save it somewhere, change the extension as needed:
        img.save("management/static/qrdata/Visitor/"+ vnew_name +".png")
        qrcodeimage = "management/static/qrdata/Visitor/"+ vnew_name +".png"
        visitor = Visitor.objects.filter(id=id).update(visitorname=vnew_name,mailid=vnew_mailid,phone=vnew_phone,purpose=vnew_purpose,qrimage=qrcodeimage)
        key = Fernet.generate_key()
        cipher_suite = Fernet(key)
        cipher_text = cipher_suite.encrypt(b"A really secret message. Not for prying eyes.")
        plain_text = cipher_suite.decrypt(cipher_text)
        print(plain_text)
        return redirect('/management/visitor/')
    
    print("Name:",v_name)
    return render(request,'management/visitoredit.html',{'id':id,'visitorname':v_name,'mailid':v_mailid,'phone':v_phone,'purpose':v_purpose})


def contractoredit(request,contractoredit_id=None):
    contractor = Contractor.objects.get(id=contractoredit_id)
    id = contractor.id
    c_name = contractor.contractorname
    c_id = contractor.contractorid
    c_company = contractor.companyname
    c_mailid = contractor.mailid
    c_phone = contractor.phone
    c_validity = contractor.validity
    c_address = contractor.address
    if request.method == "POST":
        cnew_name = request.POST.get('contractorname')
        cnew_id = request.POST.get('contractorid')
        cnew_company = request.POST.get('companyname')
        cnew_mailid = request.POST.get('mailid')
        cnew_phone = request.POST.get('phone')
        cnew_validity = request.POST.get('validity')
        cnew_address = request.POST.get('address')
        contractor = Contractor.objects.filter(id=id).update(contractorname=cnew_name,contractorid=cnew_id,companyname=cnew_company,mailid=cnew_mailid,phone=cnew_phone,validity=cnew_validity,address=cnew_address)

        qr = qrcode.QRCode(
            version = 1,
            error_correction = qrcode.constants.ERROR_CORRECT_H,
            box_size = 10,
            border = 4,
        )

        # The data that you want to store
        data =('Name:'+ cnew_name,'Company:'+ cnew_company,'Phone:'+cnew_phone,'Email:'+cnew_mailid,'Address:'+ cnew_address)
        print(data,"rfsdfs")
        # Add data
        qr.add_data(data)
        qr.make(fit=True)

        # Create an image from the QR Code instance
        img = qr.make_image()

        # Save it somewhere, change the extension as needed:
        img.save("management/static/qrdata/Contractor/"+ cnew_name +".png")
        print("Image Saved Sucessfully")
        img.show()
        key = Fernet.generate_key()
        cipher_suite = Fernet(key)
        cipher_text = cipher_suite.encrypt(b"A really secret message. Not for prying eyes.")
        plain_text = cipher_suite.decrypt(cipher_text)
        print(plain_text)
        return redirect('/contractor')
    
    print("Name:",c_name)
    return render(request,'contractoredit.html',{'id':id,'contractorname':c_name,'contractorid':c_id,'companyname':c_company,'mailid':c_mailid,'phone':c_phone,'validity':c_validity,'address':c_address})
@login_required
def qrscanner(request):
    loginusername = request.user.username
    loginid = request.user.id
    loginemail = request.user.email
    return render(request,'qrscanner.html',{'loginusername':loginusername,'loginemail':loginemail})    

def stream_video(request):
	return StreamingHttpResponse(media(request),content_type="multipart/x-mixed-replace;boundary=frame")

                 
def media(request):
    cap = cv2.VideoCapture(0)
    font = cv2.FONT_HERSHEY_PLAIN
    hasOpened = False

    while True:
        _, frame = cap.read()

        decodedObjects = pyzbar.decode(frame)
        for obj in decodedObjects:
            datac=obj.data
            name=datac.decode("utf-8")
            print('*****',name)
            res = dict(item.split(":") for item in name.split(", "))
            print('......>>>>>>',res)
            len_name = len(res)
            print(len_name)
         
            if obj.data and not hasOpened:
                print("data here")
                hasOpened = True
                print("retrive data:",name)
                if len_name == 4:
                    a,b,c,d = name.split(",")
                    s=a
                    v = (s.split(':')[1])
                    qr_name = v.strip("'")
                    print(qr_name)
                    vname = qr_name
                    visitor = Visitor.objects.all()
                    print("Visitors:",visitor)
                    datee=date.today()
                    t = time.localtime()
                    current_time = time.strftime("%H:%M:%S", t)
                    if (Visitor.objects.filter(visitorname=vname).exists()):
                        if(EntryExit.objects.filter(name=vname).exists()):
                                e = EntryExit.objects.filter(name=vname).latest('id')
                                print("eee",e.id)
                                name=e.name
                                print("nnnnnnn",name)
                                category = e.category
                                intime = e.intime
                                outtime = e.outtime
                                d = e.date
                                print(outtime)
                                
                                if (outtime != ""):
                                    print("again entry")                                  
                                    return render (request,'entryexit.html',{'name':name,'category':category,'intime':intime,'outtime':outtime,'date':d})

                                else:
                                    print("updated outtime")
                                    EntryExit.objects.filter(name=vname).update(outtime=current_time)                                
                                    return render (request,'entryexit.html',{'name':name,'category':category,'intime':intime,'outtime':outtime,'date':d})

                         
                        else:
                            EntryExit.objects.create(name=vname,category="Visitor",intime=current_time,outtime="",date=datee)
                            print("else",vname)
                            e = EntryExit.objects.filter(name=vname).latest('id')
                            print("eee",e.id)
                            sname=e.name
                            category = e.category
                            intime = e.intime
                            outtime = e.outtime
                            d = e.date
                            print(outtime)
                            return render (request,'entryexit.html',{'name':name,'category':category,'intime':intime,'outtime':outtime,'date':d})

                    else:
                        print("not matched")
                        
                        return render(request,'qrscanner.html',{'name':vname})
                else:
                    a,b,c,d,e,f = name.split(",")
                    s=a
                    v = (s.split(':')[1])
                    qr_name = v.strip("'")
                    print(qr_name)
            
                    vname = qr_name
                    contractor = Contractor.objects.all()
                    print("Contractors:",contractor)
                    datee=date.today()
                    t = time.localtime()
                    current_time = time.strftime("%H:%M:%S", t)
                   
                    if (Contractor.objects.filter(contractorname=vname).exists()):
                        if(EntryExit.objects.filter(name=vname).exists()):
                                e = EntryExit.objects.filter(name=vname).latest('id')
                                print("eee",e.id)
                                name=e.name
                                print("nnnnnnn",name)
                                category = e.category
                                intime = e.intime
                                outtime = e.outtime
                                d = e.date
                                print(outtime)
                                
                                if (outtime != ""):
                                    print("again entry")
                                    EntryExit.objects.create(name=vname,category="Contractor",intime=current_time,outtime="",date=datee)
    
                                    return render (request,'entryexit.html',{'name':name,'category':category,'intime':intime,'outtime':outtime,'date':d})

                                else:
                                    print("updated outtime")
                                    EntryExit.objects.filter(name=vname).update(outtime=current_time)
                             
                                    return render (request,'entryexit.html',{'name':name,'category':category,'intime':intime,'outtime':outtime,'date':d})
                        else:
                            EntryExit.objects.create(name=vname,category="Contractor",intime=current_time,outtime="",date=datee)
                            print("else",vname)
                            e = EntryExit.objects.filter(name=vname).latest('id')
                            print("eee",e.id)
                            name=e.name
                            print("nnnnnnn",name)
                            category = e.category
                            intime = e.intime
                            outtime = e.outtime
                            d = e.date
                            print(outtime)
                            return render (request,'entryexit.html',{'name':name,'category':category,'intime':intime,'outtime':outtime,'date':d})

                    else:
                        print("not matched")
                        return render(request,'qrscanner.html',{'name':vname})

        imgencode=cv2.imencode('.jpg',frame)[1]
        stringData=imgencode.tostring()
        yield (b'--frame\r\n'
			b'Content-Type: text/plain\r\n\r\n'+stringData+b'\r\n')
    del(camera)

  