using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using com.paradigm.esm.general;

namespace NexelusApp.Service.Configuration
{
    public class Config
    {
        private static Config config;

        #region Singulton Implementaion

        private static object syncLock = new object();

        public static Config Instance
        {
            get
            {
                if (config == null)
                {
                    lock (syncLock)
                    {
                        if (config == null)
                        {
                            config = new Config();
                        }
                    }
                }

                return config;
            }
        }

        #endregion

        public string DatabaseServer { get; set; }
        public string DatabaseName { get; set; }
        public string DatabaseUID { get; set; }
        public string DatabasePWD { get; set; }
        public int ConnectionTimeOut { get; set; }
        public int QueryTimeOut { get; set; }
        public int CommandTimeout { get; set; }
        public string LogPath { get; set; }
        public string LogLevel { get; set; }
        public int DBRecordsCount { get; set; }

        public Config()
        {
            DatabaseServer = ConfigurationManager.AppSettings["databaseserver_esmapp"];
            DatabaseName = ConfigurationManager.AppSettings["databasename_esmapp"];
            DatabaseUID = ConfigurationManager.AppSettings["DatabaseUID_esmapp"];

            string password = ConfigurationManager.AppSettings["DatabasePWD_esmapp"];
            TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
            password = TwofishAlgorithm.eDecrypt(password);

            DatabasePWD = password;

            ConnectionTimeOut = Converter.ToInteger(ConfigurationManager.AppSettings["ConnectTimeout_esmapp"]);
            QueryTimeOut = Converter.ToInteger(ConfigurationManager.AppSettings["QueryTimeout_esmapp"]);
            CommandTimeout = Converter.ToInteger(ConfigurationManager.AppSettings["CommandTimeout"]);
            LogPath = ConfigurationManager.AppSettings["LogPath"];
            LogLevel = ConfigurationManager.AppSettings["LogLevel"];
            DBRecordsCount = Converter.ToInteger(ConfigurationManager.AppSettings["DBRecordsCount"]);
        }

        
    }
}
