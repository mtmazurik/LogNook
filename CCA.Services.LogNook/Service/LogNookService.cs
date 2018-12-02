using Microsoft.AspNetCore.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CCA.Services.LogNook.Service
{
    public class LogNookService : ILogNookService
    {
        private IApplicationLifetime _applicationLifetime;
        public LogNookService(IApplicationLifetime applicationLifetime)     //ctor
        {
            _applicationLifetime = applicationLifetime;
        } 
        public string kill()
        {
            _applicationLifetime.StopApplication();
            return "LogNook service stopped.";
        }
    }
}
