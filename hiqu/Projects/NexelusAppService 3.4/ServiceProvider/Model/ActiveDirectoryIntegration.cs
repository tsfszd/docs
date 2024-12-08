using System;
using System.DirectoryServices;
using System.Configuration;
using NexelusApp.Service.Log;

namespace com.paradigm.esm.model
{
  /// <summary>
  /// Summary description for ActiveDirectoryIntegration.
  /// </summary>
  public class ActiveDirectoryIntegration
  {
    private string _domainName;
    private string _serverName;
    private string _path;

    public ActiveDirectoryIntegration(string domainName, string serverName)
    {
      _domainName = domainName;
      _serverName = serverName;
      _path = "LDAP://" + _serverName;
    }

    #region "Public Functions"
    public bool IsAuthenticated(string username, string pwd, out bool directoryExists)
    {
        directoryExists = true;
        DirectoryEntry entry = null;

        string domainAndUsername = _domainName + "\\" + username;

        entry = new DirectoryEntry(_path, username, pwd);

        try
        {
            //Bind to the native AdsObject to force authentication.			
            object obj = entry.NativeObject;

            DirectorySearcher search = new DirectorySearcher(entry);
            search.Filter = "(SAMAccountName=" + username + ")";

            search.PropertiesToLoad.Add("cn");
            SearchResult result = search.FindOne();


            if (result != null)
            {
                return true;
            }

            _path = result.Path; // Update the new path to the user in the directory.

            Logger.Log(_path, LogLevelType.INFO);
            string filterAtribute = (string)result.Properties["cn"][0];
        }
        catch (Exception ex)
        {
            Logger.Log(ex.Message, LogLevelType.ERROR);
            if (ex.Message.ToLower().IndexOf("logon failure") < 0)
                directoryExists = false;
            return false;
        }

        return false;
    }
    # endregion
  }
}
