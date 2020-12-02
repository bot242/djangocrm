from channels.generic.websocket import AsyncJsonWebsocketConsumer


class AssignConsumer(AsyncJsonWebsocketConsumer):

    async def connect(self):
        await self.accept()
        await self.channel_layer.group_add("assignuser", self.channel_name)
        print(f"+-+++++++++++-Added +++++++++++{self.channel_name} channel to assignuser")

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard("assignuser", self.channel_name)
        print(f"+++++++++++++Removed -------------------{self.channel_name} channel to assignuser")

    async def user_assignuser(self, event):
        await self.send_json(event)
        print(f"---++++++++++Got message______+++++++++++++++++++= {event} at {self.channel_name}")
