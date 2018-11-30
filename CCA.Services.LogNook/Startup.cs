﻿using System.Net.Http;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Hosting;
using CCA.Services.LogNook.Config;
using CCA.Services.LogNook.Security;
using CCA.Services.LogNook.Models;
using CCA.Services.LogNook.Tasks;
using CCA.Services.LogNook.Logging.Models;
using CCA.Services.LogNook.Logging.Provider;
using Microsoft.AspNetCore.Authentication.JwtBearer;

namespace CCA.Services.LogNook
{
    public class Startup
    {
        public IConfigurationRoot _configuration { get; }

        public Startup(Microsoft.AspNetCore.Hosting.IHostingEnvironment env)       // ctor
        {
            var builder = new ConfigurationBuilder()        
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            _configuration = builder.Build();                
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
 
            services.AddMvc(options =>
            {
                options.Filters.Add(new AllowAnonymousFilter());
            }).AddJsonOptions( options =>
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

            string  dbConnectionString = _configuration.GetConnectionString("LogNookSvcRepository");


            services.AddTransient<IResponse, Response>();                       // Dependency injection (DI) - using ASPNETCore's built-in facility
            services.AddTransient<HttpClient>();
            services.AddTransient<IJsonConfiguration, JsonConfiguration>();
            services.AddTransient<IWorker, Worker>();
           
            // logger setup
            CustomLoggerDBContext.ConnectionString = _configuration.GetConnectionString("LoggerDatabase");
        }

        // Use this method to configure the HTTP request pipeline. This method gets called by the runtime. 
        public void Configure(IApplicationBuilder app, Microsoft.AspNetCore.Hosting.IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            loggerFactory.AddConsole(_configuration.GetSection("Logging"));
            loggerFactory.AddDebug();
            loggerFactory.AddContext(LogLevel.Information, _configuration.GetConnectionString("LoggerDatabase"));

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
        }
    }
}
