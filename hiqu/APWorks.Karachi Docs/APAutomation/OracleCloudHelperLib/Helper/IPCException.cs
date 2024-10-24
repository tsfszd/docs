using System;

namespace nexelus.oraclehelper
{
	[Serializable()]
	public class IPCException:System.ApplicationException
	{

        public const string AUTHENTICATION_FAULT_CODE = "Authentication Error";
        public const string FETCH_IPC_INTERNAL_DATA_FAULT_CODE = "Fetching Data from iPC Database Error";


		private int lNumber;
		private string lUserID;
		private LogLevelType lLoggerLevel;

		public IPCException(string userID, LogLevelType logLevel)
		{
			Logger.Log(userID, "No specific information", logLevel);
			Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel); 
			lUserID = userID;
			lLoggerLevel = logLevel;
		}

		public IPCException(string userID, int number, LogLevelType logLevel)
		{
			Logger.Log(userID, "Error Number: " + Number, logLevel);
			Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel); 
			lNumber = number;
			lUserID = userID;
			lLoggerLevel = logLevel;
		}

		public IPCException(string userID, string message, LogLevelType logLevel):base(message)
		{
			Logger.Log(userID, "Error Message: " + message, logLevel);
			Logger.Log(userID, "Stack Trace:" + Environment.NewLine + Environment.StackTrace, logLevel); 
			lUserID = userID;
			lLoggerLevel = logLevel;
		}

		public IPCException(string userID, int number, string message, LogLevelType logLevel):base(message)
		{
			Logger.Log(userID, "Error Number: " + number + " Error Message: " + message, logLevel);
			Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel); 
			lNumber = number;
			lUserID = userID;
			lLoggerLevel = logLevel;
		}

		public IPCException(string userID, string message, Exception inner, LogLevelType logLevel):base(message, inner)
		{
			Logger.Log(userID, " Error Message: " + message + "; " + inner.Message, logLevel);
			Logger.Log(userID, "Stack Trace:\n" + Environment.NewLine + Environment.StackTrace, logLevel); 
			lUserID = userID;
			lLoggerLevel = logLevel;
		}

		public IPCException(string userID, int number, string message, Exception inner, LogLevelType logLevel):base(message, inner)
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