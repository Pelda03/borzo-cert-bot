import discord
from discord.ext import commands
import config
from cogs.opensslcog import OpenSSLCog  
from cogs.commands import commands

bot = commands.Bot(command_prefix='!', intents=discord.Intents.all())
cfg = config

def loadcogs():
    bot.add_cog(OpenSSLCog(bot))  
    bot.add_cog(commands(bot))
loadcogs()

@bot.event
async def on_ready():
    print('Logged in as')
    print(bot.user.name)
    print(bot.user.id)
    print('------')

bot.run(cfg.BOT_TOKEN)
