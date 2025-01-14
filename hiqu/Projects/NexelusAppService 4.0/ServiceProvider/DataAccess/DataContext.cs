using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.DataAccess.DAOs;
using NexelusApp.Service.Exceptions;
using com.paradigm.esm.general;
using System.Text.RegularExpressions;
using System.Xml.Serialization;
using System.IO;
using NexelusApp.Service.Configuration;

namespace NexelusApp.Service.DataAccess
{

    /// <summary>
    /// this class will be used for special update, in the case of Level2 Time approval. 
    /// </summary>
    /// 
    [XmlRoot("row")]
    public class XmlResponseFromLevel2UpdateSp
    {
        [XmlElement("transaction_id")]
        public string transaction_id { get; set; }
        [XmlElement("timestamp")]
        public string timestamp { get; set; }
    }

    public class DataContext<T> where T : EntityBase, new()
    {
        private NexContext _Context;
        private int Error_code = 0;
        private string Error_Description = "";
        private int Error_Flag = 0;
        //private string Error_Date = ""; // This is used in some cases.
        private string time_stamp = "";

        public int ErrorFlag
        {
            get { return Error_Flag; }
        }
        public string TimeStamp
        {
            get { return time_stamp; }
        }

        public string ErrorDescription
        {
            get { return Error_Description; }            
        }

        public int ErrorCode
        {
            get { return Error_code; }
        }

        public DataContext(NexContext ctx)
        {
            _Context = ctx;
        }

        public List<T> GetEntitiesList(DAOBase<T> DOAObject, string sp_name, List<SqlParameter> paramersrs, enumDatabaes db)
        {
            return GetEntitiesList(DOAObject, sp_name, paramersrs, db, false);
        }
        
        public List<T> GetEntitiesList(DAOBase<T> DOAObject, string sp_name, List<SqlParameter> paramersrs, enumDatabaes db, bool useTransaction)
        {
            List<T> list = null;
            SqlConnection connection = null;
            SqlCommand cmd = null;
            IDataReader dataReader = null;

            try
            {
                connection = _Context.DBConnection.GetActiveConnection(db);
                cmd = new SqlCommand();

                if (_Context.DBConnection.ActiveTransactions.ContainsKey(connection))
                {
                    cmd.Transaction = _Context.DBConnection.ActiveTransactions[connection];
                }

                cmd.Connection = connection;
                cmd.CommandText = sp_name;
                cmd.CommandTimeout = Config.Instance.CommandTimeout;
                cmd.CommandType = CommandType.StoredProcedure;

                foreach (SqlParameter parm in paramersrs)
                {
                    cmd.Parameters.Add(parm);
                }


                dataReader = cmd.ExecuteReader();
                list = new List<T>();

                while (dataReader.Read())
                {
                    T objEntity = new T();


                    try
                    {
                        Error_code = dataReader.GetInt32(dataReader.GetOrdinal("ERROR_CODE"));
                        Error_Description = dataReader.GetString(dataReader.GetOrdinal("ERROR_DESCRIPTION"));
                    }
                    catch (Exception ex )
                    {
                        string message = ex.Message;
                    }

                   
                    if (Error_code >= 0)
                    {
                        
                            DOAObject.PopulateEntityFromReader(objEntity, dataReader);
                            objEntity.IsDirety = false;

                            list.Add(objEntity);
                    }
                    else
                    {
                        throw new AppException(this._Context.LoginID, Error_Description, Log.LogLevelType.SQLERROR);
                    }

                }

                if (!dataReader.IsClosed)
                {
                    dataReader.Close();
                }

            }
            catch (AppException ex)
            {
                throw ex;
            }
            catch (SqlException ex)
            {
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.SQLERROR);
            }
            catch (Exception ex)
            {
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.ERROR);
            }
            finally
            {
                if (dataReader !=null &&  !dataReader.IsClosed)
                {
                    dataReader.Close();
                }

               _Context.DBConnection.Close();
            }

            return list;

        }

        public T GetEntity(DAOBase<T> DAOObject, string sp_name, List<SqlParameter> parameters, enumDatabaes db)
        {
            T objEntity = null;
            SqlConnection connection = null;
            SqlCommand cmd = null;
            IDataReader dataReader = null;

            try
            {

                connection = _Context.DBConnection.GetActiveConnection(db);
                cmd = new SqlCommand();
                                
                cmd.Connection = connection;
                cmd.CommandText = sp_name;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = Config.Instance.CommandTimeout;

                foreach (SqlParameter parm in parameters)
                {
                    cmd.Parameters.Add(parm);
                }


                dataReader = cmd.ExecuteReader();

                while (dataReader.Read())
                {
                    objEntity = new T();

                    try
                    {
                        Error_code = dataReader.GetInt32(dataReader.GetOrdinal("ERROR_CODE"));
                        Error_Description = dataReader.GetString(dataReader.GetOrdinal("ERROR_DESCRIPTION"));
                    }
                    catch
                    {
                        // no need to handle this exception  
                    }


                    DAOObject.PopulateEntityFromReader(objEntity, dataReader);
                    objEntity.IsDirety = false;

                }

                dataReader.Close();

            }
            catch (AppException ex)
            {
                throw ex;
            }
            catch (SqlException ex)
            {
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.SQLERROR);
            }
            catch (Exception ex)
            {
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.ERROR);
            }
            finally
            {
                if (dataReader != null && !dataReader.IsClosed)
                {
                    dataReader.Close();
                }

                _Context.DBConnection.Close();
            }

            return objEntity;
        }

        public List<T> SaveForCCTransactions(DAOBase<T> DOAObject, string sp_name, List<SqlParameter> paramersrs, enumDatabaes db)
        {
            List<T> list = null;
            SqlConnection connection = null;
            SqlCommand cmd = null;
            IDataReader dataReader = null;

            try
            {
                connection = _Context.DBConnection.GetActiveConnection(db);
                cmd = new SqlCommand();

                if (_Context.DBConnection.ActiveTransactions.ContainsKey(connection))
                {
                    cmd.Transaction = _Context.DBConnection.ActiveTransactions[connection];
                }

                cmd.Connection = connection;
                cmd.CommandText = sp_name;
                cmd.CommandTimeout = Config.Instance.CommandTimeout;
                cmd.CommandType = CommandType.StoredProcedure;

                foreach (SqlParameter parm in paramersrs)
                {
                    cmd.Parameters.Add(parm);
                }


                dataReader = cmd.ExecuteReader();
                list = new List<T>();

                while (dataReader.Read())
                {
                    T objEntity = new T();


                    try
                    {
                        Error_code = dataReader.GetInt32(dataReader.GetOrdinal("ERROR_CODE"));
                        Error_Description = dataReader.GetString(dataReader.GetOrdinal("ERROR_DESCRIPTION"));
                    }
                    catch (Exception ex)
                    {
                        string message = ex.Message;
                    }


                    if (Error_code == -1 || Error_code >= 0)
                    {

                        DOAObject.PopulateEntityFromReader(objEntity, dataReader);
                        objEntity.IsDirety = false;
                        objEntity.ErrorCode = Error_code;

                        list.Add(objEntity);
                    }
                    else
                    {
                        throw new AppException(this._Context.LoginID, Error_Description, Log.LogLevelType.SQLERROR);
                    }

                }

                if (!dataReader.IsClosed)
                {
                    dataReader.Close();
                }

            }
            catch (AppException ex)
            {
                throw ex;
            }
            catch (SqlException ex)
            {
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.SQLERROR);
            }
            catch (Exception ex)
            {
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.ERROR);
            }
            finally
            {
                if (dataReader != null && !dataReader.IsClosed)
                {
                    dataReader.Close();
                }

                _Context.DBConnection.Close();
            }

            return list;
        }

        public void SaveForExpenseReport(string sp_name, List<SqlParameter> parameters, enumDatabaes db, bool useTransaction)
        {
            SqlConnection connection = null;
            SqlCommand cmd = null;
            IDataReader dataReader = null;

            try
            {

                connection = _Context.DBConnection.GetActiveConnection(db);
                cmd = new SqlCommand();

                if (_Context.DBConnection.ActiveTransactions.ContainsKey(connection))
                {
                    cmd.Transaction = _Context.DBConnection.ActiveTransactions[connection];
                }

                cmd.Connection = connection;
                cmd.CommandText = sp_name;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = Config.Instance.CommandTimeout;

                foreach (SqlParameter parm in parameters)
                {
                    cmd.Parameters.Add(parm);
                }


                dataReader = cmd.ExecuteReader();

                while (dataReader.Read())
                {
                    try
                    {
                        Error_code = dataReader.GetInt32(dataReader.GetOrdinal("ERROR_CODE"));
                        Error_Description = dataReader.GetString(dataReader.GetOrdinal("ERROR_DESCRIPTION"));
                        string tempDate = "";

                        try
                        {
                            tempDate = dataReader["error_date"] == DBNull.Value ? "" : Converter.ToDate(dataReader["error_date"]).ToString("MM/dd/yyyy");
                        }
                        catch (Exception)
                        { }

                        if (!string.IsNullOrEmpty(tempDate))
                        {
                            Error_Description += tempDate;
                        }

                        // This is for the cost code error, "Please Refresh" cannot be added in eSM SP.
                        if (Error_code == -11)
                        {
                            Error_Description += "\nPlease Refresh.";
                        }
                    }
                    catch
                    {
                        // no need to handle this exception  
                    }

                    if (Error_code > 0 || Error_code < 0)
                    {
                        Error_Flag = 1;
                    }
                }

                dataReader.Close();

            }
            catch (AppException ex)
            {
                throw ex;
            }
            catch (SqlException ex)
            {
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.SQLERROR);
            }
            catch (Exception ex)
            {
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.ERROR);
            }
            finally
            {
                if (dataReader != null && !dataReader.IsClosed)
                {
                    dataReader.Close();
                }

                _Context.DBConnection.Close();
            }
        }

        public bool Update(string sp_name, List<SqlParameter> parameters, enumDatabaes db)
        {
            return Update(sp_name, parameters, db, false); 
        }

        public bool Update(string sp_name, List<SqlParameter> parameters, enumDatabaes db, bool useTransaction) 
        {
            bool retVal = false;
            SqlConnection connection = null;
            SqlCommand cmd = null;
            IDataReader dataReader = null;

            try
            {
                if (useTransaction == true)
                {
                    _Context.DBConnection.BeginTransaction();
                }

                connection = _Context.DBConnection.GetActiveConnection(db);
                cmd = new SqlCommand();

                if (useTransaction == true && _Context.DBConnection.ActiveTransactions.ContainsKey(connection))
                {
                    cmd.Transaction = _Context.DBConnection.ActiveTransactions[connection];
                }

                cmd.Connection = connection;
                cmd.CommandText = sp_name;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = Config.Instance.CommandTimeout;

                foreach (SqlParameter parm in parameters)
                {
                    cmd.Parameters.Add(parm);
                }

                dataReader = cmd.ExecuteReader();

                if (dataReader.Read())
                {
                    try
                    {
                        Error_code = dataReader.GetInt32(dataReader.GetOrdinal("ERROR_CODE"));
                        Error_Description = dataReader.GetString(dataReader.GetOrdinal("ERROR_DESCRIPTION"));
                    }
                    catch
                    {
                        //no need to handle this exception  
                    }

                    if (Error_code < 0)
                    {
                        if (useTransaction == true)
                        {
                            dataReader.Close();
                            _Context.DBConnection.RollbackTransaction();
                        }

                        throw new AppException(this._Context.LoginID, Error_Description, Log.LogLevelType.SQLERROR);
                    }
                }

                retVal = true;

                dataReader.Close();

                if (useTransaction == true)
                {
                    _Context.DBConnection.CommitTransaction();
                }

            }
            catch (AppException ex)
            {
                
                retVal = false;
                throw ex;
            }
            catch (SqlException ex)
            {
                if (useTransaction == true)
                {
                    _Context.DBConnection.RollbackTransaction();
                }

                retVal = false;
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.SQLERROR);
            }
            catch (Exception ex)
            {
                if (useTransaction == true)
                {
                    _Context.DBConnection.RollbackTransaction();
                }

                retVal = false;
                throw new AppException(_Context.LoginID, ex.Message, Log.LogLevelType.ERROR);
            }
            finally
            {
                if(useTransaction == true && _Context.DBConnection.IsTransactionStarted)
                {
                    _Context.DBConnection.RollbackTransaction();
                }

                if (dataReader != null && !dataReader.IsClosed)
                {
                    dataReader.Close();
                }

                _Context.DBConnection.Close();
            }

            return retVal;
        }

        public string SaveTimeExpenseApproval(string sp_name, List<SqlParameter> parameters, enumDatabaes db, bool useTransaction, NexContext context,out string timestamp, out int uploadFlag)
        {
            //bool retVal = false;
            SqlConnection connection = null;
            SqlCommand cmd = null;
            IDataReader dataReader = null;
            byte[] timestampbyte;
            timestamp = "0x0";
            uploadFlag = 0;
            //bool xmlResponseFlag = false;

            XmlResponseFromLevel2UpdateSp result = null;

            try
            {
                if (useTransaction == true)
                {
                    context.DBConnection.BeginTransaction();
                }

                connection = context.DBConnection.GetActiveConnection(db);
                cmd = new SqlCommand();

                if (useTransaction == true && context.DBConnection.ActiveTransactions.ContainsKey(connection))
                {
                    cmd.Transaction = context.DBConnection.ActiveTransactions[connection];
                }
               // cmd.Transaction = context.DBConnection.ActiveTransactions[connection];
                cmd.Connection = connection;
                cmd.CommandText = sp_name;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = Config.Instance.CommandTimeout;

                foreach (SqlParameter parm in parameters)
                {
                    cmd.Parameters.Add(parm);
                }

                dataReader = cmd.ExecuteReader();

                if (dataReader.Read())
                {
                    try
                    {
                        try
                        {
                            Error_code = dataReader.GetInt32(dataReader.GetOrdinal("ERROR_CODE"));
                        }
                        catch
                        {

                            Regex digitsOnly = new Regex(@"[^\d]");
                            string errorcode = digitsOnly.Replace(dataReader.GetString(dataReader.GetOrdinal("ERROR_CODE")), "");
                            Error_code = Convert.ToInt32(errorcode);
                        }

                        Error_Description = dataReader["ERROR_DESCRIPTION"].ToString();
                        if (Error_code == 1003)
                            return Error_Description;

                        //if  Error description is XML returning in the case of Level2 Time approval

                        if (!string.IsNullOrEmpty(Error_Description) && Error_Description.TrimStart().StartsWith("<"))
                        {

                            XmlSerializer serializer = new XmlSerializer(typeof(XmlResponseFromLevel2UpdateSp));
                            using (System.IO.TextReader reader = new StringReader(Error_Description))
                            {
                                 result = (XmlResponseFromLevel2UpdateSp)serializer.Deserialize(reader);
                            }

                       

                        }

                        string fieldTimesamp = "r_ts";
                        if(sp_name.Equals("plsw_app_exp_trx_hdr_update"))
                        {
                            fieldTimesamp = "timestamp";
                        }

                        //timestampbyte = (dataReader["r_ts"] == DBNull.Value || dataReader["r_ts"] == null) ? default(byte[]) : (byte[])dataReader["r_ts"];
                        timestampbyte = (dataReader[fieldTimesamp] == DBNull.Value || dataReader[fieldTimesamp] == null) ? default(byte[]) : (byte[])dataReader[fieldTimesamp];
                        if (timestampbyte != default(byte[]))
                            {
                                timestamp = ConvertFromByteToString(timestampbyte, "|$|");
                            }
                            else
                            {
                                timestamp = "0x0";
                            }
                        try
                        {
                            if (dataReader.GetOrdinal("upload_flag") > 0)
                            {
                                uploadFlag = Convert.ToInt32(dataReader["upload_flag"]);
                                if (uploadFlag > 0 && dataReader.GetOrdinal("report_uploaded") > 0)//3A. 20180910 : return 2 if full report uploaded
                                {
                                    int nFullReportUploadedFlag = Convert.ToInt32(dataReader["report_uploaded"]);
                                    if (nFullReportUploadedFlag == 1)
                                        uploadFlag = 2;
                                }
                            }
                        }
                        catch {}
                    }
                    catch(Exception ex)
                    {
                        string str = ex.Message;
                        //no need to handle this exception  
                    }

                    if (Error_code < 0)
                    {
                        if (useTransaction == true)
                        {
                            dataReader.Close();
                            context.DBConnection.RollbackTransaction();
                        }

                        throw new AppException(context.LoginID, Error_Description, Log.LogLevelType.SQLERROR);
                    }
                }

                //retVal = true;

                dataReader.Close();

                if (useTransaction == true)
                {
                    context.DBConnection.CommitTransaction();
                }

            }
            catch (AppException ex)
            {

                //retVal = false;
                throw ex;
            }
            catch (SqlException ex)
            {
                if (useTransaction == true)
                {
                    context.DBConnection.RollbackTransaction();
                }

                //retVal = false;
                throw new AppException(context.LoginID, ex.Message, Log.LogLevelType.SQLERROR);
            }
            catch (Exception ex)
            {
                if (useTransaction == true)
                {
                    context.DBConnection.RollbackTransaction();
                }

                //retVal = false;
                throw new AppException(context.LoginID, ex.Message, Log.LogLevelType.ERROR);
            }
            finally
            {
                if (useTransaction == true && _Context.DBConnection.IsTransactionStarted)
                {
                    _Context.DBConnection.RollbackTransaction();
                }
                if (dataReader != null && !dataReader.IsClosed)
                {
                    dataReader.Close();
                }

                context.DBConnection.Close();
            }


            return (Error_code < 0 || Error_code == 1003 || Error_code == 1004 || Error_code == 1005) ? Error_Description : "";
        }

        private string ConvertFromByteToString(byte[] bytesArray, string delim)
        {
            string str = "";
            if (bytesArray == null || bytesArray.Length < 1)
                return "";
            for (int i = 0; i < bytesArray.Length; i++)
            {
                str = str + bytesArray[i] + delim;
            }
            return str;

        }
    }
}
