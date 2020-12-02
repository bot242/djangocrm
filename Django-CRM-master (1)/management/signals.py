from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from management.models import Sample

@receiver(post_save, sender=Sample)
def perannounce_new_user(sender, instance, created, **kwargs):
    print("^^^^^^",sender)
    if created:
        print('=====asdasd======')
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)("gossip", 
        {"type": "user.gossip",
        "event": "New User",
        "username": instance.staffname,
        "phone":instance.phone,
        "user":instance.developer})
    
       
