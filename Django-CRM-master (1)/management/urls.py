from django.contrib import admin

from django.urls import path, include
from management import views
# from .views import UserViewSet,ContractorAPIView
from rest_framework import routers
# SET THE NAMESPACE!
app_name = 'management'

router = routers.DefaultRouter()
# router.register(r'api/register', UserViewSet)###Register
# router.register(r'api/contractor',ContractorViewSet)
# Be careful setting the name to just /login use userlogin instead!
urlpatterns=[
    # path(r'^', include(router.paths)),
    # path(r'^api/contractor/?$', ContractorAPIView.as_view()),
    path('register/',views.register,name='register'),
    path('userlogin/',views.userlogin,name='userlogin'),
    # path('userlogout/',views.userlogout,name='userlogout'),
    path('dashboard/',views.dashboard,name='dashboard'),
    path('staff/',views.staff,name='staff'),
    path('contractor/',views.contractor,name='contractor'),
    path('visitor/',views.visitor,name='visitor'),
    path('ipecs/',views.ipecs,name='ipecs'),
    path('entryexit/',views.entryexit,name='entryexit'),
    path('qrscanner/',views.qrscanner,name='qrscanner'),
    path('contractordelete/(?P<contractordelete_id>[0-9]+)/', views.contractordelete, name='contractordelete'),
    path('visitordelete/(?P<visitordelete_id>[0-9]+)/', views.visitordelete, name='visitordelete'),
    path('contractoredit/(?P<contractoredit_id>[0-9]+)/', views.contractoredit, name='contractoredit'),
    path('visitoredit/(?P<visitoredit_id>[0-9]+)/', views.visitoredit, name='visitoredit'),
    #path('stream_video/',views.stream_video,name="stream_video"),
    path('stream_video',views.stream_video,name="stream_video"),
    # path('/(?P<visitordelete_id>[0-9]+)/', views.visitordelete, name='visitordelete'),



]