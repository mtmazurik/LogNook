using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CCA.Services.LogNook.Security
{
    public class AllowAnonymousFilter: IActionFilter
    {

        public AllowAnonymousFilter()
        {

        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
            //do nothing
        }

        public void OnActionExecuting(ActionExecutingContext context)
        {
            if (SkipAuthorization(context))
                return;

            if (!context.HttpContext.User.Identity.IsAuthenticated)
            {
                context.Result = new ContentResult()
                {
                    StatusCode = 401,
                    Content = "Not Authorized"
                };
            }
        }

        private static bool SkipAuthorization(ActionExecutingContext actionContext)
        {
            var endpointMethod = actionContext.ActionDescriptor as ControllerActionDescriptor;
            
            if (endpointMethod != null)
            {
                return endpointMethod.MethodInfo.CustomAttributes.Any(attr => attr.AttributeType == typeof(AllowAnonymousAttribute));
            }
            return false;           
        }
    }
}
