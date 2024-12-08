using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using NexelusApp.Service.Log;


namespace NexelusApp.Service.Exceptions
{
    [Serializable()]
    public class AppException : System.ApplicationException
    {

        private int lNumber;
        private string lUserID;
        private LogLevelType lLoggerLevel;

        public AppException(string userID, string message)
            : base(message)
        {
            LogLevelType logLevel = LogLevelType.INNER;
            
            Logger.Log(userID, "No specific information", logLevel);
            Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel);
            lUserID = userID;
            lLoggerLevel = logLevel;
        }

        public AppException(string userID, LogLevelType logLevel)
        {
            Logger.Log(userID, "No specific information", logLevel);
            Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel);
            lUserID = userID;
            lLoggerLevel = logLevel;
        }

        public AppException(string userID, int number, LogLevelType logLevel)
        {
            Logger.Log(userID, "Error Number: " + Number, logLevel);
            Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel);
            lNumber = number;
            lUserID = userID;
            lLoggerLevel = logLevel;
        }

        public AppException(string userID, string message, Exception innerException)
            : base(message)
        {
            LogLevelType logLevel;
            //TODO: define levels here
            if (innerException.InnerException is SqlException)
            {
                logLevel = LogLevelType.SQLERROR;
            }
            else
            {
                logLevel = LogLevelType.ERROR;
            }

            Logger.Log(userID, "Error Message: " + message, logLevel);
            Logger.Log(userID, "Stack Trace:" + Environment.NewLine + Environment.StackTrace, logLevel);
            lUserID = userID;
            lLoggerLevel = logLevel;
        }

        public AppException(string userID, string message, LogLevelType logLevel)
            : base(message)
        {
            Logger.Log(userID, "Error Message: " + message, logLevel);
            Logger.Log(userID, "Stack Trace:" + Environment.NewLine + Environment.StackTrace, logLevel);
            lUserID = userID;
            lLoggerLevel = logLevel;
        }

        public AppException(string userID, int number, string message, LogLevelType logLevel)
            : base(message)
        {
            Logger.Log(userID, "Error Number: " + number + " Error Message: " + message, logLevel);
            Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel);
            lNumber = number;
            lUserID = userID;
            lLoggerLevel = logLevel;
        }

        public AppException(string userID, string message, Exception inner, LogLevelType logLevel)
            : base(message, inner)
        {
            Logger.Log(userID, " Error Message: " + message + "; " + inner.Message, logLevel);
            Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel);
            lUserID = userID;
            lLoggerLevel = logLevel;
        }

        public AppException(string userID, int number, string message, Exception inner, LogLevelType logLevel)
            : base(message, inner)
        {
            Logger.Log(userID, "Error Number: " + number + " Error Message: " + message + "; " + inner.Message, logLevel);
            Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel);
            lNumber = number;
            lUserID = userID;
            lLoggerLevel = logLevel;
        }

        public int Number
        {
            get
            {
                return lNumber;
            }
        }

        public string UserID
        {
            get
            {
                return lUserID;
            }
        }

        public LogLevelType LoggerLevel
        {
            get
            {
                return lLoggerLevel;
            }
        }
    }
}
