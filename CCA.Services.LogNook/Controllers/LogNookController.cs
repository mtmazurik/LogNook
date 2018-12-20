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
        private readonly ILogger<LogNookController> _logger;
         public LogNookController( ILogger<LogNookController> logger )   
        {
            _logger = logger;
        }
        [HttpPut("kill")]   // PUT in killed state : container ASPNETCore is shut down completely -> no more logging via its host container
        //[Authorize]
        [SwaggerResponse((int)HttpStatusCode.OK, typeof(Response))]
        public IActionResult Kill([FromServices]ILogNookService service)
        {
            _logger.LogInformation("PUT kill requested");
            return ResultFormatter.ResponseOK(service.kill());
        }
        [HttpGet("ping")]   // ping
        [AllowAnonymous]    // no Auth needed 
        [SwaggerResponse((int)HttpStatusCode.OK, typeof(Response))]
        public IActionResult GetPing()
        {
            _logger.LogInformation("GET ping method called.");
            return ResultFormatter.ResponseOK((new JProperty("Ping", "Success")));
        }
        [HttpGet("version")]   // service version (from compiled assembly version)
        //[Authorize]
        [SwaggerResponse((int)HttpStatusCode.OK, typeof(Response))]
        public IActionResult GetVersion()
        {
            _logger.LogInformation("GET version");
            var assemblyVersion = typeof(Startup).Assembly.GetName().Version.ToString();
            return ResultFormatter.ResponseOK((new JProperty("Version", assemblyVersion)));
        }
    }
}
