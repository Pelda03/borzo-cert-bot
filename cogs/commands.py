import discord
from discord.ext import commands

class Commands(commands.Cog):
    def __init__(self, bot):
        self.bot = bot
        self.last_member = None
    @commands.Cog.listener()
    async def on_member_join(self, member):
        channel = member.guild.system_channel
        if channel is not None:
            await channel.send(f"Vítej {member.mention}!")
            
                