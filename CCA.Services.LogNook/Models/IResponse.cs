using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace CCA.Services.LogNook.Models
{
    public interface IResponse
    {
        Dictionary<string, string> Meta { get; }
        Object Data { set;  get; }
        void InsertStatusCodeIntoMeta(int statusCode);
        void InsertExceptionIntoMeta(Exception exc);
    }
}