from django import forms
from contacts.models import Contact
from common.models import Comment, Attachments
from teams.models import Teams


class ContactForm(forms.ModelForm):
    teams_queryset = []
    teams = forms.MultipleChoiceField(choices=teams_queryset)

    def __init__(self, *args, **kwargs):
        assigned_users = kwargs.pop('assigned_to', [])
        super(ContactForm, self).__init__(*args, **kwargs)
        for field in self.fields.values():
            field.widget.attrs = {"class": "form-control"}
        self.fields['description'].widget.attrs.update({
            'rows': '6'})
        self.fields['address'].widget.attrs.update({
            'rows': '4'})
   
        if assigned_users:
            self.fields['assigned_to'].queryset = assigned_users
        self.fields['assigned_to'].required = False
        self.fields['phone1'].required = False
        self.fields['phone2'].required = False
        for key, value in self.fields.items():
            if key == 'phone1':
                value.widget.attrs['placeholder'] = "Phone number"
            elif key == 'phone2':
                value.widget.attrs['placeholder'] = "Mobile number"
            else:
                value.widget.attrs['placeholder'] = value.label
        self.fields["teams"].choices = [(team.get('id'), team.get('name')) for team in Teams.objects.all().values('id', 'name')]
        self.fields["teams"].required = False

    class Meta:
        model = Contact
        fields = (
            'assigned_to', 'first_name',
            'last_name',
            'phone1','phone2', 'address', 'description', 'company_name'
        )
        widgets = {
        'phone1': forms.NumberInput(attrs={'class': 'form-control','type': 'number'}),
        'phone2': forms.NumberInput(attrs={'class': 'form-control','type': 'number'}),
        'address': forms.Textarea(attrs={'class': 'form-control','type': 'textarea'})
        # widget=forms.TextInput(attrs={'min':1,'max': '5','type': 'number'}))
        }

class ContactCommentForm(forms.ModelForm):
    comment = forms.CharField(max_length=255, required=True)

    class Meta:
        model = Comment
        fields = ('comment', 'contact', 'commented_by')


class ContactAttachmentForm(forms.ModelForm):
    attachment = forms.FileField(max_length=1001, required=True)

    class Meta:
        model = Attachments
        fields = ('attachment', 'contact')
