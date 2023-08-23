from discord.ext import commands
import subprocess




# Not sure if this works, čekáme než radim napíše ssl scripty.
class OpenSSLCog(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @commands.command()
    async def run_openssl(self, ctx, *, command):
        try:
            result = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, text=True)
            await ctx.send("COmmand executed successfully:\n```\n" + result)
        except subprocess.CalledProcessError as e:
            await ctx.send("Command failed:\n```\n" + e.output) + "\n```" 
def setup(bot):
    bot.add_cog(OpenSSLCog(bot))           