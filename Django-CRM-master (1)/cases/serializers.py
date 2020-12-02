from rest_framework import serializers
from cases.models import Case
from django.contrib.auth import authenticate


class CaseSerializer(serializers.ModelSerializer):
    
# class UserSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = User
#         fields = ['username','email','password']
#         extra_kwargs = {'password': {'write_only': True}}
#     def create(self, validated_data):
#         password = validated_data.pop('password')
#         user = User.objects.create(**validated_data)
#         user.set_password(password)
#         user.save()

#         return user

# class ContractorSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Contractor
#         fields = '__all__'

# class SampleSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Sample
#         fields = '__all__'