using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

using NexelusApp.Service.Configuration;

namespace NexelusApp.Service.Log
{
    public class Logger
    {
        private static string logPath = "";
        private static int configLogLevel = 1;

        static Logger()
        {
            Config config = new Config();
            string temp;
            temp = config.LogPath;
            if (temp != null)
                logPath = temp;

            temp = config.LogLevel;

            try
            {
                configLogLevel = int.Parse(temp);
            }
            catch (Exception)
            {
                configLogLevel = 1;
            }

            try
            {
                Directory.CreateDirectory(logPath);
            }
            catch (Exception )
            {
            }


        }

        public static void Log(string msg, LogLevelType logLevel)
        {
            try
            {
                Write(DateTime.Now.ToString("MM:dd:yyyy hh:mm:ss") + '\t' + msg, logLevel);
            }
            catch
            {
            }
        }

        public static void Log(string userID, string msg, LogLevelType logLevel)
        {
            try
            {
                Write(DateTime.Now.ToString("MM:dd:dd") + '\t' + "[USER: " + userID + "]" + '\t' + msg, logLevel);
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

            if ((int)logLevel < configLogLevel)
                return;

            switch (logLevel)
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
            catch (Exception ex)
            {
                throw (ex);
            }
        }
    }
}
