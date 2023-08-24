from discord.ext import commands
import subprocess




# Not sure if this works, čekáme než radim napíše ssl scripty.
class OpenSSLCog(commands.Cog):
    def __init__(self, bot):
        self.bot = bot


# Spustí script, jeste neni přidaná cesta na scripty
@commands.command()
async def run_openssl(self, ctx):
    try:
        result = subprocess.check_output(['openssl', 'jmeno_ssl_scriptu'], shell=True, stderr=subprocess.STDOUT, text=True)
        await ctx.send("Certificate:\n```\n" + result + "\n```")
    except subprocess.CalledProcessError as e:
        await ctx.send("Command failed:\n```\n" + e.output + "\n```")

def setup(bot):
    bot.add_cog(OpenSSLCog(bot))

