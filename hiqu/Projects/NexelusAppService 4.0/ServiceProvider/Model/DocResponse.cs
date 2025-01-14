using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Model
{
    public enum DocResponseType
    {
        Success,
        Error
    }
    public class DocResponse
    {
        public DocResponseType ResponseType { get; set; }
        public string Message { get; set; }
    }
}
