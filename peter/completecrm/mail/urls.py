from django.urls import path, include
from .views import (
    dashboard, notification )

app_name = 'mail'

urlpatterns = [
    path('', dashboard, name='dashboard'),
    path('view/<int:pk>/',notification, name='notification'),

]
