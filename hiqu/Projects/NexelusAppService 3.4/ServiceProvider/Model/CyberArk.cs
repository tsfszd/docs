using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
//using System.Web.Script.Serialization;
namespace NexelusApp.Service.Model
{
    public class CyberArk
    {
        public static string loginResult="ok";
        static bool TryLogin(string userName,string Password)
        {
            //Constants
            const string JSON_CONTENT_TYPE = "application/json";
            const string VERB_METHOD_POST = "POST";
            const string VERB_METHOD_GET = "GET";
            const string JSON_SESSION_TOKEN_HEADER = "CyberArkLogonResult";
            const string HTTP_SESSION_TOKEN_HEADER = "Authorization";
            const string JSON_GET_ACCOUNT_RES_HEADER = "application";
            const string APPID = "SAMAccountName";
            //URI information
            const string PVWA_WS_URI = @"http://192.168.2.13/PasswordVault/WebServices";
            const string LOGON_AUTHENTICATION_URI = PVWA_WS_URI + @"/auth/CyberArk/CyberArkAuthenticationService.svc/logon";
            const string LOGOFF_AUTHENTICATION_URI = PVWA_WS_URI + @"/auth/CyberArk/CyberArkAuthenticationService.svc/logoff";
            const string AIM_WS_ONE = PVWA_WS_URI + @"/PIMServices.svc/Applications";

            //Variables
            WebRequest restRequest;
            WebResponse restResponse;
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            Dictionary<string, object> deserializedJsonDictionary;
            string SessionToken = null;
            object[] ApplicationIds;
            
            string ConnectionString = "{\"username\":\"" + userName + "\",\"password\":\"" + Password + "\"}";
            //Token retrieval
            try
            {
                restRequest = WebRequest.Create(LOGON_AUTHENTICATION_URI); //Specifying URI
                restRequest.Method = VERB_METHOD_POST;
                restRequest.ContentType = JSON_CONTENT_TYPE;
                byte[] inputStringBytes = Encoding.UTF8.GetBytes(ConnectionString);
                Stream requestStream = restRequest.GetRequestStream();
                requestStream.Write(inputStringBytes, 0, inputStringBytes.Length);
                
                using (restResponse = restRequest.GetResponse())
                {
                    using (Stream responseStream = restResponse.GetResponseStream())
                    {
                        StreamReader rdr = new StreamReader(responseStream, Encoding.UTF8);
                        string rawJsonSessionToken = rdr.ReadToEnd();
                        if (string.IsNullOrEmpty(rawJsonSessionToken))
                        {
                            loginResult = "Session Token not created";
                            return false;
                        }
                        deserializedJsonDictionary = (Dictionary<string, object>)jsonSerializer.DeserializeObject(rawJsonSessionToken);
                        SessionToken = (string)deserializedJsonDictionary[JSON_SESSION_TOKEN_HEADER];
                        if (string.IsNullOrEmpty(SessionToken))
                        {
                            loginResult = "session token was not created";
                            return false;
                        }
                    }
                }
            }
            catch (Exception    )
            {
                loginResult = "A Logon Error Has Occured";
                //HandleError(ex);
                return false;
            }
            //Create the AppID request
            try
            {
                restRequest = WebRequest.Create(AIM_WS_ONE);
                restRequest.Method = VERB_METHOD_POST;
                restRequest.ContentType = JSON_CONTENT_TYPE;
                restRequest.Headers[HTTP_SESSION_TOKEN_HEADER] = SessionToken;
                string APPIDRequest = "{\"application\":{\"AppID\":\"" + APPID + "\"}}";

                using (Stream requestStream = restRequest.GetRequestStream())
                {
                    byte[] inputStringBytes = Encoding.UTF8.GetBytes(APPIDRequest);
                    requestStream.Write(inputStringBytes, 0, inputStringBytes.Length);
                }
                using (restResponse = restRequest.GetResponse())
                {
                    using (Stream responseStream = restResponse.GetResponseStream())
                    {
                        StreamReader rdr = new StreamReader(responseStream, Encoding.UTF8);
                        string response = rdr.ReadToEnd();

                    }
                }
            }
            catch (Exception)
            {
                loginResult = "Error occured creating AppID";
                return false;
                //HandleError(ex);
            }

            //List of existing AppIDs
            try
            {
                restRequest = WebRequest.Create(AIM_WS_ONE);
                restRequest.Method = VERB_METHOD_GET;
                restRequest.ContentType = JSON_CONTENT_TYPE;
                restRequest.Headers[HTTP_SESSION_TOKEN_HEADER] = SessionToken;
                using (restResponse = restRequest.GetResponse())
                {
                    using (Stream responseStream = restResponse.GetResponseStream())
                    {
                        StreamReader rdr = new StreamReader(responseStream, Encoding.UTF8);
                        string rawJsonResult = rdr.ReadToEnd();

                        if (string.IsNullOrEmpty(rawJsonResult))
                        {
                            loginResult = "Json result was not created";
                            return false;
                        }
                        deserializedJsonDictionary = (Dictionary<string, object>)jsonSerializer.DeserializeObject(rawJsonResult);
                        ApplicationIds =
                    (object[])deserializedJsonDictionary[JSON_GET_ACCOUNT_RES_HEADER];
                        foreach (Dictionary<string, object> AppID in ApplicationIds)
                        {
                            Console.WriteLine("ApplicationID: {0}",
                                              AppID["AppID"]);



                        }
                    }
                }
            }
            catch (Exception)
            {
                //Console.WriteLine("An error occured while retrieving Application List");
                return false;
            }
            //Logoff
            try
            {
                restRequest = WebRequest.Create(LOGOFF_AUTHENTICATION_URI);
                restRequest.Method = VERB_METHOD_POST;
                restRequest.ContentType = JSON_CONTENT_TYPE;
                restRequest.Headers[HTTP_SESSION_TOKEN_HEADER] = SessionToken;
                using (Stream requestStream = restRequest.GetRequestStream())
                {
                    byte[] inputStringBytes = Encoding.UTF8.GetBytes("");
                    requestStream.Write(inputStringBytes, 0, inputStringBytes.Length);
                }
                using (restResponse = restRequest.GetResponse())
                {
                    using (Stream responseStream = restResponse.GetResponseStream())
                    {
                        StreamReader rdr = new StreamReader(responseStream, Encoding.UTF8);
                        string rawJsonResult = rdr.ReadToEnd();
                    }
                }
            }
            catch (Exception)
            {
                //Console.WriteLine("An error occured while logging off");
                return false;
            }
            return true;
        }
        private static void HandleError(Exception ex)
        {
            if (ex is WebException)
            {
                WebException wex = ex as WebException;
                HttpWebResponse res = ((HttpWebResponse)(wex.Response));
                switch (res.StatusCode)
                {
                    case HttpStatusCode.Forbidden:
                        Console.WriteLine("An Authentication error occured: " + res.StatusDescription);
                        break;
                    case HttpStatusCode.InternalServerError:
                    default:
                        Console.WriteLine("An error occured: " + res.StatusDescription);
                        break;
                }
            }
            else
            {
                Console.WriteLine("An Error Occured: " + ex.Message);
            }
        }
    }
}
