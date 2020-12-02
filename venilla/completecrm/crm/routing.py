from channels.routing import ProtocolTypeRouter, URLRouter
from django.urls import path
from contacts.consumers import NoseyConsumer

application = ProtocolTypeRouter({
    "websocket": URLRouter([
        path("contatcts/", NoseyConsumer),
    ])
})
