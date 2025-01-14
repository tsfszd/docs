using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Exceptions;
using com.paradigm.esm.general;
using System.Collections;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class TransactionExpenseDAO<T> : DAOBase<T> where T : TransactionExpense, new()
    {
        public TransactionExpenseDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                string tempTimeStamp = dataReader["timestamp"] == DBNull.Value ? "" : Converter.ToString(dataReader["timestamp"]);

                if (!string.IsNullOrEmpty(tempTimeStamp))
                {
                    byte[] tempTimeStampBytes = dataReader["timestamp"] == DBNull.Value ? default(byte[]) : (byte[])dataReader["timestamp"];

                    if (tempTimeStampBytes != default(byte[]))
                    {
                        objEntity.timestamp = ConvertFromByteToString(tempTimeStampBytes, "|$|");
                    }
                }
                objEntity.transaction_id = Converter.ToString(DataAccess.Read<string>(dataReader, "transaction_id"));
                objEntity.record_id = Converter.ToString(DataAccess.Read<string>(dataReader, "record_id"));
                objEntity.text1 = Converter.ToString(DataAccess.Read<string>(dataReader, "text1"));
                objEntity.text2 = Converter.ToString(DataAccess.Read<string>(dataReader, "text2"));
                objEntity.text3 = Converter.ToString(DataAccess.Read<string>(dataReader, "text3"));
                objEntity.text4 = Converter.ToString(DataAccess.Read<string>(dataReader, "text4"));
                objEntity.text5 = Converter.ToString(DataAccess.Read<string>(dataReader, "text5"));
                objEntity.text6 = Converter.ToString(DataAccess.Read<string>(dataReader, "text6"));
                objEntity.text7 = Converter.ToString(DataAccess.Read<string>(dataReader, "text7"));
                objEntity.text8 = Converter.ToString(DataAccess.Read<string>(dataReader, "text8"));
                objEntity.text9 = Converter.ToString(DataAccess.Read<string>(dataReader, "text9"));
                objEntity.text10 = Converter.ToString(DataAccess.Read<string>(dataReader, "text10"));
                objEntity.number11 = DataAccess.Read<double>(dataReader, "number11");
                objEntity.number12 = DataAccess.Read<double>(dataReader, "number12");
                objEntity.number13 = DataAccess.Read<double>(dataReader, "number13");
                objEntity.number14 = DataAccess.Read<double>(dataReader, "number14");
                objEntity.number15 = DataAccess.Read<double>(dataReader, "number15");
                objEntity.number16 = DataAccess.Read<double>(dataReader, "number16");
                objEntity.number17 = DataAccess.Read<double>(dataReader, "number17");
                objEntity.number18 = DataAccess.Read<double>(dataReader, "number18");
                objEntity.number19 = DataAccess.Read<double>(dataReader, "number19");
                objEntity.number20 = DataAccess.Read<double>(dataReader, "number20");
                objEntity.create_id = Converter.ToString(DataAccess.Read<string>(dataReader, "create_id"));
                objEntity.str_create_date = DataAccess.Read<DateTime>(dataReader, "create_date").ToString("yyyy-MM-dd HH:mm:ss");                
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            //if (criteria.Keys != null && criteria.Keys.Count > 0)
            //{
            //    return SelectFromList(criteria);
            //}
            //else
            //{
                List<T> retList = null;
                TransactionExpenseCriteria<TransactionExpense> objCriteria = null;
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                if (criteria != null)
                {
                    objCriteria = criteria as TransactionExpenseCriteria<TransactionExpense>;

                    //if (objCriteria.isFirstTime)
                    //{
                    //    param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
                    //    param.Value = Context.SubscriberID;
                    //    parameters.Add(param);
                    //}

                    if (!string.IsNullOrEmpty(objCriteria.ResourceID))
                    {
                        param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                        param.Value = objCriteria.ResourceID;
                        parameters.Add(param);
                    }

                    if (!string.IsNullOrEmpty(objCriteria.transaction_id))
                    {
                        param = new SqlParameter("@transaction_id", SqlDbType.VarChar);
                        param.Value = objCriteria.transaction_id;
                        parameters.Add(param);
                    }

                    if (!string.IsNullOrEmpty(objCriteria.record_id))
                    {
                        param = new SqlParameter("@record_id", SqlDbType.VarChar);
                        param.Value = objCriteria.record_id;
                        parameters.Add(param);
                    }

                    if (objCriteria.LastSyncDate != default(DateTime))
                    {
                        param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                        param.Value = objCriteria.LastSyncDate;
                        parameters.Add(param);
                    }

                    if (objCriteria.Keys != null && objCriteria.Keys.Count > 0)
                    {
                        param = new SqlParameter("@keys", SqlDbType.Xml);
                        param.Value = GetXMLFromKeys(objCriteria.Keys);
                        parameters.Add(param);
                    }
                }

                try
                {
                    retList = DbContext.GetEntitiesList(this, "plsw_apps_transactions_exp_get", parameters, enumDatabaes.TE);

                }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction Expense Field(s): {0} .", ex.Message.Trim()), ex);

                    }
                }
                catch (Exception ex)
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction Expense Field(s): {0} .", ex.Message.Trim()), ex);
                }

                return retList;
            //}

        }

        public override bool Save(T entity)
        {
            bool retVal = false;


            return retVal;
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

        private SqlParameter GetTimestampParam(string name, byte[] val)
        {
            SqlParameter retVal = null;

            if (val == null || val.Length <= 0)
            {
                retVal = new SqlParameter(name, DBNull.Value);
            }
            else
            {
                retVal = new SqlParameter(name, val);
            }
            retVal.DbType = DbType.Binary;
            return retVal;
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

        private byte[] ConvertFromStringToBytes(string str, string delim)
        {
            byte[] bytesArray = { 0, 0, 0, 0, 0, 0, 0, 0 };
            ArrayList arr = new ArrayList();
            arr = Utility.SplitString(str, delim);
            for (int i = 0; i < arr.Count; i++)
            {

                bytesArray[i] = Convert.ToByte(arr[i]);

            }
            return bytesArray;

        }

        private DateTime GetDBDate(IDataReader dataReader, string colName)
        {
            if (dataReader[colName] == DBNull.Value)
            {
                return default(DateTime);
            }
            else
            {
                return DateTime.SpecifyKind(Converter.ToDate(dataReader[colName]), DateTimeKind.Utc);
            }
        }

        public override List<T> SaveAndGet(List<T> entities)
        {
            List<T> retTrxs = new List<T>();

            

            return retTrxs;
        }

        private string GetXMLFromKeys(List<string> keys)
        {
            StringBuilder xml = new StringBuilder();
            xml.Append("<keys>");

            foreach (string key in keys)
            {
                string[] splittedKeys = key.Split(new string[] { "~-~" }, StringSplitOptions.None);

                if (splittedKeys.Length == 2)
                {
                    xml.Append("<key>");

                    xml.Append("<company_code>");
                    xml.Append(splittedKeys[0]);
                    xml.Append("</company_code>");

                    xml.Append("<transaction_id>");
                    xml.Append(splittedKeys[1]);
                    xml.Append("</transaction_id>");

                    xml.Append("</key>");
                }

            }

            xml.Append("</keys>");
            return xml.ToString();
        }

        private List<T> SelectFromList(CriteriaBase<T> criteria)
        {
            List<T> retList = new List<T>();

            foreach (string key in criteria.Keys)
            {
                string[] splittedKeys = key.Split(new string[] { "~-~" }, StringSplitOptions.None);

                TransactionExpenseCriteria<TransactionExpense> objCriteria = null;
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                if (criteria != null)
                {
                    objCriteria = criteria as TransactionExpenseCriteria<TransactionExpense>;

                    if (!string.IsNullOrEmpty(objCriteria.ResourceID))
                    {
                        param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                        param.Value = objCriteria.ResourceID;
                        parameters.Add(param);
                    }

                    param = new SqlParameter("@transaction_id", SqlDbType.VarChar);
                    param.Value = splittedKeys[1];
                    parameters.Add(param);

                    if (!string.IsNullOrEmpty(objCriteria.record_id))
                    {
                        param = new SqlParameter("@record_id", SqlDbType.VarChar);
                        param.Value = objCriteria.record_id;
                        parameters.Add(param);
                    }

                    if (objCriteria.LastSyncDate != default(DateTime))
                    {
                        param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                        param.Value = objCriteria.LastSyncDate;
                        parameters.Add(param);
                    }
                }

                try
                {
                    //retList = DbContext.GetEntitiesList(this, "plsw_apps_transactions_exp_get", parameters, enumDatabaes.TE);
                    T tempEntity = DbContext.GetEntity(this, "plsw_apps_transactions_exp_get", parameters, enumDatabaes.TE);

                    if (tempEntity != null)
                    {
                        retList.Add(tempEntity);
                    }

                    //retList.Add(DbContext.GetEntity(this, "plsw_apps_transactions_exp_get", parameters, enumDatabaes.TE));

                }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction Expense Field(s): {0} .", ex.Message.Trim()), ex);

                    }
                }
                catch (Exception ex)
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction Expense Field(s): {0} .", ex.Message.Trim()), ex);
                }
            }

            return retList; 
        }
    }
}
