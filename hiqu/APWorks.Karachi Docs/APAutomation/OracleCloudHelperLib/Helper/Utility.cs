using System;
using System.Text;
using System.IO;
using System.Security.Cryptography;
using System.Configuration;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Net;

using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Zip.Compression.Streams;

namespace nexelus.oraclehelper
{
	public sealed class Utility
	{
		
		private Utility(){}

		public static string PrefixInteger(char prefixChar, int pValue, int maxLength)
		{
			string sTemp;
			string sResult;

			sResult = "";
			sTemp = pValue.ToString();

			for (int i = maxLength; i>=sTemp.Length + 1; i--)
			{
				sResult = sResult + prefixChar;
			}
			sResult = sResult + sTemp;

			return sResult;
		}

		public static string GenerateKey()
		{
			try
			{
				DESCryptoServiceProvider des  = new DESCryptoServiceProvider();
				KeySizes[] ks = des.LegalKeySizes;

				string temp;

				des.GenerateIV();
				des.GenerateKey();

				temp = "";
				for (int i = 0; i < des.Key.Length; i++)
				{
					temp = temp + PrefixInteger('0', des.IV[i], 3);
				}
				temp = temp + "_";
				for (int i = 0; i < des.Key.Length; i++)
				{
					temp = temp + PrefixInteger('0', des.Key[i], 3);
				}

				return temp;
			}
			catch (Exception ex)
			{
				throw (new IPCException("", "Source: Utility::GenerateKey: " + ex.Message, LogLevelType.ERROR));
			}
		}


		
		public static void AddToHashtable(Hashtable hash, object key, object valueObject)
		{
			AddToHashtable(hash, key, valueObject, true);
		}
		//it adds to hahstable if it key doesnt exist otherwise modify it
		public static void AddToHashtable(Hashtable hash, object key, object valueObject, bool caseSensitive)
		{
			if(hash != null && key != null)
			{
				if(caseSensitive)
				{
					if(hash.Contains(key))
						hash[key] = valueObject;
					else
						hash.Add(key, valueObject);
				}
				else
				{
					if(CaseIncensitiveContains(hash, key))
						hash[key] = valueObject;
					else
						hash.Add(key, valueObject);
				}
			}
		}

		public static bool	IsNull(object o)
		{
			if( o == null || (o is DBNull))
				return true;
			return false;
		}


       
		public static ArrayList SplitString(string val, string delim)
		{
			string[] fields = CustomSplit(val, delim);
			ArrayList tempFields = new ArrayList();
			for(int i=0; i<fields.Length; i++)
			{
				string field = fields[i];
				if(field != null && field.Trim().Length > 0)
					tempFields.Add(field);
			}
			return tempFields;
		}
        public static ArrayList SplitStringWithBlankValue(string val, string delim)
        {
            string[] fields = CustomSplit(val, delim);
            ArrayList tempFields = new ArrayList();
            for (int i = 0; i < fields.Length; i++)
            {
                string field = fields[i];
                tempFields.Add(field);
            }
            return tempFields;
        }

		public static ArrayList SplitStringAll(string val, string delim)
		{
			string[] fields = CustomSplit(val, delim);
			ArrayList tempFields = new ArrayList();
			for(int i=0; i<fields.Length; i++)
			{
				tempFields.Add(fields[i]);
			}
			return tempFields;
		}

		public static Hashtable ParseString(string query, string pairDelim, string valueDelim, bool caseSensitive)
		{
			Hashtable retVal = new Hashtable();
			if(
				query != null && query.Length > 0 && 
				pairDelim != null && pairDelim.Length > 0 &&
				valueDelim != null && valueDelim.Length > 0 
				)
			{
				int pairIndex = query.IndexOf(pairDelim);
				string rest = query;
				int valueIndex = -1;
				string key = "";
				string val = "";
				while(pairIndex != -1)
				{
					string keyVal = rest.Substring(0, pairIndex);
					rest = rest.Substring(pairIndex + pairDelim.Length);
					
					pairIndex = rest.IndexOf(pairDelim);

					valueIndex = keyVal.IndexOf(valueDelim);
					if(valueIndex == -1)//bad key pair
						continue;
					key = keyVal.Substring(0, valueIndex);
					val = keyVal.Substring(valueIndex + valueDelim.Length);
					AddToHashtable(retVal, key, val, caseSensitive);
				}
				valueIndex = rest.IndexOf(valueDelim);
				if(valueIndex != -1)
				{
					key = rest.Substring(0, valueIndex);
					val = rest.Substring(valueIndex + valueDelim.Length);
					AddToHashtable(retVal, key, val, caseSensitive);
				}
			}
			return retVal;
		}

		public static bool CaseIncensitiveContains(Hashtable table, object keyVal)
		{
			bool retVal = false;
			if(table != null)
			{
				IEnumerator keys = table.Keys.GetEnumerator();

				while(keys.MoveNext())
				{
					object key = keys.Current;
					if(key.ToString().ToLower() == keyVal.ToString().ToLower())
					{
						retVal = true;
						break;
					}
				}
			}
			return retVal;
		}

		public static string[] CustomSplit(string paramvals, string parseChar)
		{
			ArrayList retVal = new ArrayList();
			int eIndex = paramvals.IndexOf(parseChar);
			string temp = "";
			int sIndex = 0;
			if(eIndex != -1 )
			{
				while(eIndex != -1 && sIndex < paramvals.Length )
				{
					temp = paramvals.Substring(sIndex, eIndex - sIndex);
					retVal.Add(temp);
					sIndex = eIndex + parseChar.Length;
					eIndex = paramvals.IndexOf(parseChar,sIndex);
				}
			}
			//for last entry
			if( eIndex == -1 && sIndex < paramvals.Length)
			{
				temp = paramvals.Substring(sIndex);
				retVal.Add(temp);
			}
			string[] ret = new string[retVal.Count];

			for(int i = 0; i < retVal.Count; i++)
			{
				ret[i] = (string)retVal[i];
			}
			return ret;
		}

        public static string ReplaceFirstFromSpecifiedIndex(string text, int startIndex, string search, string replace)
        {
            int pos = text.IndexOf(search, startIndex);
            if (pos < 0)
            {
                return text;
            }
            return text.Substring(0, pos) + replace + text.Substring(pos + search.Length);
        }

		public static string JavaScriptEscape(string str)
		{
			string retVal = "";
			if(str != null && str.Trim().Length > 0)
			{
				retVal = str.Replace("\\", "\\\\");
				retVal = retVal.Replace("\"", "\\\"");
				retVal = retVal.Replace("\'", "\\\'");
				retVal = retVal.Replace(Environment.NewLine, "\\n");

			}
			return retVal;
		}

		public static bool IsSameDate(DateTime date1, DateTime date2)
		{
			return (date1.Year == date2.Year && date1.Month == date2.Month && date1.Day == date2.Day);
		}

        public static string ToEmpty(string s)
        {
            if (s == null)
                return "";
            else
                return s;
        }

        public static string ConvertToYYYYMMDDDate(string s)
        {
            if (s == null)
                return null;

            return s.Replace("-", "");
        }

        public static string ConvertToYYYY_MM_DDDate(string s)
        {
            if (s == null)
                return null;

            if (s.Length != 8)
                throw new IPCException("Date " + s + " is not in YYYYMMDD format.", LogLevelType.ERROR);
            
            return s.Substring(0, 4) + "-" + s.Substring(4, 2) + "-" + s.Substring(6);
        }

        public static string ConvertToYYYY_MM_DDDateTimeWithTimeZone(string s)
        {
            //Expected Input Format: 20130101 080000 America/New_York
            //Output Format: 2013-01-01 08:00:00 America/New_York

            if (s == null)
                return null;

            if (s.Length <= 18)
                throw new IPCException("Date " + s + " is not in YYYYMMDD HHMMSS TZ format.", LogLevelType.ERROR);

            return s.Substring(0, 4) + "-" + s.Substring(4, 2) + "-" + s.Substring(6, 2) + " " + s.Substring(9,2) + ":" + s.Substring(11,2) + ":" + s.Substring(13, 2) + " " + s.Substring(16);
        }

        public static void DownloadReport(string downloadUrl, string fileName)
        {
            // Open a connection to the URL where the report is available.

            BinaryWriter binaryWriter = null;
            BinaryReader binaryReader = null;
            FileStream fileStream = null;
            Stream httpStream = null;

            try
            {
                HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(downloadUrl);
                HttpWebResponse response = (HttpWebResponse)webRequest.GetResponse();
                httpStream = response.GetResponseStream();

                // Open the report file.
                FileInfo fileInfo = new FileInfo(fileName);

                fileStream = new FileStream(fileInfo.FullName, FileMode.Create);
                binaryWriter = new BinaryWriter(fileStream);
                binaryReader = new BinaryReader(httpStream);

                // Read the report and save it to the file.
                int bufferSize = 100000;
                while (true)
                {
                    // Read report data from API.
                    byte[] buffer = binaryReader.ReadBytes(bufferSize);

                    // Write report data to file.
                    binaryWriter.Write(buffer);

                    // If the end of the report is reached, break out of the loop.
                    if (buffer.Length != bufferSize)
                    {
                        break;
                    }
                }
            }
            catch (Exception e)
            {
                throw new IPCException("SYSTEM", "Cannot Download data from URL: " + downloadUrl, e, LogLevelType.ERROR);
            }
            finally
            {
                // Clean up.
                if (binaryWriter!=null)
                    binaryWriter.Close();
                if (binaryReader!=null)
                    binaryReader.Close();
                if (fileStream!=null)
                    fileStream.Close();
                if (httpStream!=null)
                    httpStream.Close();
            }
        }


        public static void UnzipFile(string zippedFileName, string unzippedFileName)
        {
            try
            {
    		    using (ZipInputStream s = new ZipInputStream(File.OpenRead(zippedFileName))) 
                {
			        ZipEntry theEntry;
        			while ((theEntry = s.GetNextEntry()) != null) 
                    {
        				Console.WriteLine(theEntry.Name);
				
		        		string directoryName = Path.GetDirectoryName(theEntry.Name);
        				string fileName = Path.GetFileName(theEntry.Name);
				
				        // create directory
				        if ( directoryName.Length > 0 ) {
					        Directory.CreateDirectory(directoryName);
				        }
				
				        if (fileName != String.Empty) 
                        {
					        using (FileStream streamWriter = File.Create(unzippedFileName)) 
                            {
        						int size = 2048;
		        				byte[] data = new byte[2048];
				        		while (true) 
                                {
							        size = s.Read(data, 0, data.Length);
							        if (size > 0) {
								        streamWriter.Write(data, 0, size);
							        } 
                                    else 
                                    {
								        break;
							        }
						        }
					        }
				        }
			        }
		        }
            }
            catch (Exception e)
            {
                throw new IPCException("SYSTEM", "Cannot Unzip file: " + zippedFileName, e, LogLevelType.ERROR);
            }
        }

        public static bool ConvertToBool(string sBool)
        {
            string sBoolConvert = ToEmpty(sBool).Trim().ToUpper();

            if (sBoolConvert == "YES" || sBoolConvert == "Y" || sBoolConvert == "1" || sBoolConvert == "TRUE")
                return true;
            else if (sBoolConvert == "NO" || sBoolConvert == "N" || sBoolConvert == "0" || sBoolConvert == "FALSE")
                return false;
            else
                throw new IPCException("SYSTEM", "Cannot Convert to bool: " + sBool + ". Acceptible values (case incensetive): Yes, Y, 1, True or No, N, 0, False.", LogLevelType.ERROR);
        }

    }	
}