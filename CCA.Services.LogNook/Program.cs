using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace CCA.Services.LogNook
{
    public class Program
    {
        public static void Main(string[] args)
        {
            BuildWebHost(args).Run();       // .Net Core lowest lvl event handler, thread.   Allows controller to listen, for WebApi REST MVC events
        }

       public static IWebHost BuildWebHost(string[] args) =>        // NLog suggested rework of BuildWebHost
            WebHost.CreateDefaultBuilder(args)
               .UseStartup<Startup>()
               .ConfigureLogging(logging =>
               {
                   logging.ClearProviders();
                   logging.SetMinimumLevel(Microsoft.Extensions.Logging.LogLevel.Trace);
               })
               .Build();
    }
}
