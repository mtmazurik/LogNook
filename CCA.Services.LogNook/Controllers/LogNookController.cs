using System;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using Swashbuckle.AspNetCore.SwaggerGen;
using Newtonsoft.Json.Linq;
using Microsoft.AspNetCore.Authorization;
using CCA.Services.LogNook.JsonHelpers;
using CCA.Services.LogNook.Models;
using Microsoft.Extensions.Logging;
using CCA.Services.LogNook.Service;
using Microsoft.AspNetCore.Hosting;

namespace CCA.Services.LogNook.Controllers
{
    [Route("/")]
    public class LogNookController : Controller
    {
        [HttpPut("kill")]   // Kills the main thread, effectively shutting it down (todo:  rearchect a "restart", by creating the service code on its own thread, leaving the API /Controller running)
        [SwaggerResponse((int)HttpStatusCode.OK, typeof(Response))]
        public IActionResult Kill([FromServices]ILogNookService service)
        {
            return ResultFormatter.ResponseOK(service.kill());
        }
        [HttpGet("ping")]   // ping
        [AllowAnonymous]    // no Auth needed 
        [SwaggerResponse((int)HttpStatusCode.OK, typeof(Response))]
        public IActionResult GetPing()
        {
            return ResultFormatter.ResponseOK((new JProperty("Ping", "Success")));
        }
        [HttpGet("version")]   // service version (from compiled assembly version)
        [SwaggerResponse((int)HttpStatusCode.OK, typeof(Response))]
        public IActionResult GetVersion()
        {
            var assemblyVersion = typeof(Startup).Assembly.GetName().Version.ToString();
            return ResultFormatter.ResponseOK((new JProperty("Version", assemblyVersion)));
        }
    }
}
