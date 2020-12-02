from django import forms
from cases.models import Case
from common.models import Comment, Attachments
from teams.models import Teams
# import phonenumbers
import datetime


class CaseForm(forms.ModelForm):
    teams_queryset = []
    teams = forms.MultipleChoiceField(choices=teams_queryset)
    
    def __init__(self, *args, **kwargs):

        casecount = Case.objects.all().count()
        print("CASECOUNT:",casecount)
        c = casecount+1
        assigned_users = kwargs.pop('assigned_to', [])
        case_accounts = kwargs.pop('account', [])
        case_contacts = kwargs.pop('contacts', [])
        super(CaseForm, self).__init__(*args, **kwargs)
        for field in self.fields.values():
            field.widget.attrs = {"class": "form-control"}
        self.fields['description'].widget.attrs.update({
            'rows': '4'})
        self.fields['address'].widget.attrs.update({
            'rows': '4'})
        self.fields['action_items'].widget.attrs.update({
            'rows': '4'})
        self.fields['parent_description'].widget.attrs.update({
            'rows': '3'})
        if assigned_users:
            self.fields['assigned_to'].queryset = assigned_users
        
        self.fields['assigned_to'].required = False

        self.fields['assigned_date'].required = False
        self.fields['assigned_date'].widget.attrs['readonly'] = True
        self.fields['assigned_date' ].input_formats = [ '%d-%m-%Y %H:%M:%S' ]
        self.fields['assigned_date'].initial = datetime.datetime.now().strftime('%d-%m-%Y %H:%M:%S')

        self.fields['account'].queryset = case_accounts

        self.fields['contacts'].queryset = case_contacts
        self.fields['contacts'].required = False

        self.fields['case_number'].required = True
        self.fields['case_number'].initial = "C_00"+str(c)
        self.fields['case_number'].widget.attrs['readonly'] = True

        self.fields['creation_date'].required = True
        self.fields['creation_date'].widget.attrs['readonly'] = True
        self.fields['creation_date'].input_formats = [ '%d-%m-%Y %H:%M:%S' ]
        self.fields['creation_date'].initial = datetime.datetime.now().strftime('%d-%m-%Y %H:%M:%S')

        self.fields['case_type'].required = True
        self.fields['closed_on'].required = False
        self.fields['closed_on'].widget.attrs['readonly'] = True
        self.fields['closed_on' ].input_formats = [ '%d-%m-%Y  %H:%M:%S']
        self.fields['closed_on'].initial = datetime.datetime.now().strftime('%d-%m-%Y %H:%M:%S')
        # self.fields['assigned_to'].required = True
        # self.fields['assigned_date'].required = True
        self.fields['sla'].widget.attrs.update({'class' :'sla'})
        # self.fields['sla'].widget.attrs['placeholder'] = "00:00:00"
        for key, value in self.fields.items():
            value.widget.attrs['placeholder'] = value.label

        self.fields["teams"].choices = [(team.get('id'), team.get('name')) for team in Teams.objects.all().values('id', 'name')]
        self.fields["teams"].required = False

    class Meta:
        model = Case
        fields = ('assigned_to','phone1', 'name', 'status',
                  'priority', 'case_type', 'account','remark',
                  'contacts', 'closed_on', 'description', 'sla',
                  'case_number', 'email', 'address', 'action_items', 'creation_date','assigned_date','parent_case','parent_description')

        widgets = {
            'phone1': forms.NumberInput(attrs={'class': 'form-control','type': 'number'})
            # widget=forms.TextInput(attrs={'min':1,'max': '5','type': 'number'}))
            }

    # def clean_name(self):
    #     name = self.cleaned_data['name']
    #     case = Case.objects.filter(
    #         name__iexact=name).exclude(id=self.instance.id)
    #     if case:
    #         raise forms.ValidationError("Case Already Exists with this Name")
    #     else:
    #         return name

    # def clean_phone1(self):
    #     phone1 = self.cleaned_data.get("phone1")
    #     z = phonenumbers.parse(phone1)
    #     if not phonenumbers.is_valid_number(z):
    #         raise forms.ValidationError("Number not in valid")
    #     return phone1


class CaseCommentForm(forms.ModelForm):
    comment = forms.CharField(max_length=255, required=True)

    class Meta:
        model = Comment

        fields = ('comment', 'case', 'commented_by', )


class CaseAttachmentForm(forms.ModelForm):
    attachment = forms.FileField(max_length=1001, required=True)

    class Meta:
        model = Attachments
        fields = ('attachment', 'case')

# class SlaForm(forms.ModelForm):
#     class Meta:
#         time = forms.TimeField(input_formats=["%H:%M"])
#         model = Sla
#         fields = ('status','time')