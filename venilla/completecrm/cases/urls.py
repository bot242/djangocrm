from django.urls import path
from cases.views import (
    CasesListView, create_case, CaseDetailView, update_case, RemoveCaseView,
    CloseCaseView, select_contact, GetCasesView, AddCommentView,
    UpdateCommentView, DeleteCommentView, CasesListInd,
    AddAttachmentView, DeleteAttachmentsView,create_sla,create_slaemail,allsla,slalist,allslalist,allslaedit,allsladel,update_sla,changelog)

app_name = 'cases'

urlpatterns = [
    path('cases/', CasesListView.as_view(), name='list'),
    path('individual/', CasesListInd.as_view(), name='individual'),
#     path('',dashboardCase, name='dash'),
    path('create/', create_case, name='add_case'),
    path('<int:pk>/view/', CaseDetailView.as_view(), name="view_case"),
    path('<int:pk>/edit_case/', update_case, name="edit_case"),
    path('<int:case_id>/remove/',
         RemoveCaseView.as_view(), name="remove_case"),

    path('close_case/', CloseCaseView.as_view(), name="close_case"),
    path('select_contacts/', select_contact, name="select_contacts"),
    path('get/list/', GetCasesView.as_view(), name="get_cases"),

    path('comment/add/', AddCommentView.as_view(), name="add_comment"),
    path('comment/edit/', UpdateCommentView.as_view(), name="edit_comment"),
    path('comment/remove/',
         DeleteCommentView.as_view(), name="remove_comment"),
    path('changelog/',changelog,name="changelog"),

    path('attachment/add/',
         AddAttachmentView.as_view(), name="add_attachment"),
    path('attachment/remove/', DeleteAttachmentsView.as_view(),
         name="remove_attachment"),
    path('sla/create/',create_sla, name='create_sla'),
    path('sla/create/email',create_slaemail,name='create_slaemail'),
    path('sla/allsla/',allsla,name='allsla'),
    path('sla/',allslalist,name='allslalist'),
    path('sla/',slalist,name='slalist'),
    path('sla/del/<int:pk>',allsladel,name="allsladel"),
    path('sla/edit/<int:pk>/',update_sla, name='edit_sla'),
    path('sla/edit/<int:pk>',allslaedit, name='allslaedit'),
   

]
