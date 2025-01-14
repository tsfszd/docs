using System;

namespace NexelusApp.Service.Log
{
    [Flags]
    public enum LogLevelType
    {
        NONE = 0,
        DEBUG = 1,
        INFO = 2,
        SQLINTEGRITYERROR = 3,
        SQLERROR = 4,
        ERROR = 5,
        INNER
    }
}
