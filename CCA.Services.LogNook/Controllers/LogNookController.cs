using System;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using Swashbuckle.AspNetCore.SwaggerGen;
using Newtonsoft.Json.Linq;
using Microsoft.AspNetCore.Authorization;
using CCA.Services.LogNook.JsonHelpers;
using CCA.Services.LogNook.Models;
using CCA.Services.LogNook.Logging.Models;
using Microsoft.Extensions.Logging;

namespace CCA.Services.LogNook.Controllers
{
    [Route("/")]
    public class LogNookController : Controller
    {
        private CustomLoggerDBContext _context;
        private readonly ILogger<LogNookController> _logger;
        public LogNookController( ILogger<LogNookController> logger)   // also can inject,  ... CustomLoggerDBContext context )   to log database operations automatically
        {
            //_context = context;
            _logger = logger;
        }
       
        [HttpGet("ping")]   // ping
        [AllowAnonymous]
        [SwaggerResponse((int)HttpStatusCode.OK, typeof(Response))]
        public IActionResult GetPing()
        {
            _logger.LogInformation("GET ping");
            return ResultFormatter.ResponseOK((new JProperty("Ping", "Success")));
        }
        [HttpGet("version")]   // service version (from compiled assembly version)
        [Authorize]
        [SwaggerResponse((int)HttpStatusCode.OK, typeof(Response))]
        public IActionResult GetVersion()
        {
            _logger.LogInformation("GET version");
            var assemblyVersion = typeof(Startup).Assembly.GetName().Version.ToString();
            return ResultFormatter.ResponseOK((new JProperty("Version", assemblyVersion)));
        }
    }
}
