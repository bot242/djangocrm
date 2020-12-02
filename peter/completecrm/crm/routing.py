from channels.routing import ProtocolTypeRouter, URLRouter
from django.urls import path
from contacts.consumers import NoseyConsumer
from cases.consumers import AssignConsumer

application = ProtocolTypeRouter({
    "websocket": URLRouter([
        path("contatcts/", NoseyConsumer),
        path("cases/cases/", AssignConsumer),
    ])
})
