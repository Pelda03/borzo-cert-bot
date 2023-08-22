import discord
from discord.ext import commands
import config






bot = commands.Bot(command_prefix='!', intents=discord.Intents.all())
cfg = config

@bot.event
async def on_ready():
    print('Logged in as')
    print(bot.user.name)
    print(bot.user.id)
    print('------')

bot.add_cog(commands(bot))
bot.run(cfg.BOT_TOKEN)

