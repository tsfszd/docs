using System;
using System.IO;


namespace nexelus.oraclehelper
{
	public class Logger
	{

        public const string LOG_DATE_TIME_FORMAT = "MM-dd-yyyy HH:mm:ss";

		private static string logPath = "";
		private static int configLogLevel = 1;

		static Logger()
		{
			string temp;  
			temp = System.Configuration.ConfigurationManager.AppSettings.Get("LogPath");
			if (temp!=null)
				logPath = temp;
			
			temp = System.Configuration.ConfigurationManager.AppSettings.Get("LogLevel");
			
			try
			{
				configLogLevel = int.Parse(temp);
			}
			catch(Exception e)
			{
				configLogLevel = 1;
			}

			try
			{
				Directory.CreateDirectory(logPath); 
			}
			catch (Exception e)
			{
			}

		
		}

		public static void Log(string msg, LogLevelType logLevel)
		{
			try
			{
                Write(DateTime.Now.ToString(LOG_DATE_TIME_FORMAT) + '\t' + msg, logLevel);
			}
			catch
			{
			}
		}

		public static void Log(string userID, string msg, LogLevelType logLevel)
		{
			try
			{
                Write(DateTime.Now.ToString(LOG_DATE_TIME_FORMAT) + '\t' + "[USER: " + userID + "]" + '\t' + msg, logLevel);
			}
			catch
			{
			}
		}

		private static void Write(string msg, LogLevelType logLevel)
		{
            string fileName;
            TextWriter output;
            string levelString = "";

			if ((int )logLevel < configLogLevel)
				return;

			switch(logLevel)
			{
				case LogLevelType.DEBUG:
					levelString = "DEBUG: ";
					break;
				case LogLevelType.INFO:
					levelString = "INFO: ";
					break;
				case LogLevelType.ERROR:
					levelString = "ERROR: ";
					break;
				case LogLevelType.SQLERROR:
					levelString = "SQL ERROR: ";
					break;
				case LogLevelType.SQLINTEGRITYERROR:
					levelString = "SQL INTEGRITY ERROR: ";
					break;
			}

			try
			{
				fileName = logPath + "\\eSM_NET_Log_" + DateTime.Now.ToString("MMddyyyy") + ".txt";

				output = File.AppendText(fileName);

				output.WriteLine(levelString + '\t' + msg);

				output.Close();
			}
			catch(Exception ex)
			{
				throw(ex);
			}
		}
	}
}
