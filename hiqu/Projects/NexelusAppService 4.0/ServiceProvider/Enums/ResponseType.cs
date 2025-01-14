using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Enums
{
    public enum ResponseType
    {
        Success = 0,
        GeneralError = 1,
        Warning = 2,
        Message = 3,
        SQLError = 4
    }
}
