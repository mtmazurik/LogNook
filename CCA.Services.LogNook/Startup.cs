using System.Net.Http;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using CCA.Services.LogNook.Config;
using CCA.Services.LogNook.Security;
using CCA.Services.LogNook.Models;
using CCA.Services.LogNook.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using CCA.Services.LogNook.Service;
using System;

namespace CCA.Services.LogNook
{
    public class Startup
    {
        private ILogger<Startup> _logger;
        private IConfigurationRoot _configuration { get; }

        private ILoggerFactory _loggerFactory;

        public Startup(Microsoft.AspNetCore.Hosting.IHostingEnvironment env, ILogger<Startup> logger, ILoggerFactory loggerFactory)       // ctor
        {
            var builder = new ConfigurationBuilder()        
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            _configuration = builder.Build();
            _logger = logger;
            _loggerFactory = loggerFactory;
        }
        private void OnShutdown() // callback, applicationLifetime.ApplicationStopping triggers it
        {
           _logger.Log(LogLevel.Information, "LogNook service stopped.");
        }

        public void ConfigureServices(IServiceCollection services)    // Add services to the ASPNETCore App. This gets called by the runtime. 
        {
            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy",
                    builder => builder.AllowAnyOrigin()
                    .WithMethods("Get", "Post", "Put")
                    .AllowAnyHeader()
                    .AllowCredentials());
            });

            // leverage Auth0.com FREE service for API Authentication (for now)
            services.AddAuthentication(options =>
               {
                   options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                   options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
               }).AddJwtBearer(options =>
               {
                   options.Authority = $"https://{_configuration["Auth0:Domain"]}/";
                   options.Audience = _configuration["Auth0:ApiIdentifier"];
               }
            );


            services.AddApplicationInsightsTelemetry(_configuration);           // Azure Application Insights
            IServiceProvider serviceProvider = services.BuildServiceProvider();
            _loggerFactory.AddApplicationInsights(serviceProvider, LogLevel.Information);

            services.AddMvc(options =>
            {
                options.Filters.Add(new AllowAnonymousFilter(_logger));
            }).AddJsonOptions(options =>
            {
                options.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
                options.SerializerSettings.DefaultValueHandling = DefaultValueHandling.Include;
                options.SerializerSettings.NullValueHandling = NullValueHandling.Ignore;
            });


            /* services.AddSingleton<IHostedService, TaskManager>();     */     // task manager  (for background processing)


            services.AddSwaggerGen(options =>                                   // Swagger - autodocument setup
            {
                options.DescribeAllEnumsAsStrings();
                options.SwaggerDoc("v1", new Swashbuckle.AspNetCore.Swagger.Info
                {
                    Title = "LogNook Service",
                    Version = "v1",
                    Description = "RESTful API, micro service called 'LogNook'",
                    TermsOfService = "(C) 2018 Cloud Computing Associates (CCA)  All Rights Reserved."
                });
            });

            string dbConnectionString = _configuration.GetConnectionString("LogNookSvcRepository");


            services.AddTransient<IResponse, Response>();                       // Dependency injection (DI) - using ASPNETCore's built-in facility
            services.AddTransient<HttpClient>();
            services.AddTransient<IJsonConfiguration, JsonConfiguration>();
            services.AddTransient<IWorker, Worker>();
            services.AddTransient<ILogNookService, LogNookService>();

        }
        public void Configure(IApplicationBuilder app, IApplicationLifetime applicationLifetime, Microsoft.AspNetCore.Hosting.IHostingEnvironment env)
        {

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            // Swagger- autodocument
            app.UseStaticFiles();
            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "LogNook Service");
            });

            app.UseAuthentication();    // JWT Auth - using ASPNETCore methodology

            app.UseCors("CorsPolicy");

            app.UseMvc();

            _logger.Log(LogLevel.Warning,"LogNook service started.");

            applicationLifetime.ApplicationStopping.Register( OnShutdown );
        }
    }
}
