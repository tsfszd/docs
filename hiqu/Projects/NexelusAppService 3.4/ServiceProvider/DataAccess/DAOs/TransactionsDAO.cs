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
    public class TransactionsDAO<T> : DAOBase<T> where T : Transaction, new()
    {
        public TransactionsDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;

                try
                {
                    objEntity.ErrorFlag = dataReader["error_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["error_flag"]);
                    objEntity.ErrorCode = dataReader["error_code"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["error_code"]);
                    objEntity.ErrorDescription = dataReader["error_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["error_description"]);
                }
                catch (Exception)
                {
                    objEntity.ErrorFlag = 0;
                    objEntity.ErrorCode = 0;
                    objEntity.ErrorDescription = "";
                }

                objEntity.TransactionID = dataReader["transaction_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["transaction_id"]);
                objEntity.Level2Key = dataReader["level2_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level2_key"]);
                objEntity.Level3Key = dataReader["level3_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level3_key"]);
                //objEntity.AppliedDate = dataReader["applied_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["applied_date"]);

                //This is to fix the timezone issue for the app
                objEntity.StrAppliedDate = dataReader["applied_date"] == DBNull.Value ? "" : Converter.ToDate(dataReader["applied_date"]).ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.TrxType = dataReader["trx_type"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["trx_type"]);
                objEntity.ResourceID = dataReader["resource_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["resource_id"]);
                objEntity.ResUsageCode = dataReader["res_usage_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["res_usage_code"]);
                objEntity.Units = dataReader["units"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["units"]);
                objEntity.LocationCode = dataReader["location_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["location_code"]);
                objEntity.OrgUnit = dataReader["org_unit"] == DBNull.Value ? "" : Converter.ToString(dataReader["org_unit"]);
                objEntity.TaskCode = dataReader["task_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["task_code"]);
                objEntity.Comments = dataReader["comments"] == DBNull.Value ? "" : Converter.ToString(dataReader["comments"]);
                objEntity.NonBillableFlag = dataReader["nonbill_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["nonbill_flag"]);
                objEntity.SubmittedFlag = dataReader["submitted_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["submitted_flag"]);
                objEntity.SubmittedDate = dataReader["submitted_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["submitted_date"]);
                objEntity.ApprovalFlag = dataReader["approval_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["approval_flag"]);
                objEntity.ApprovalComments = dataReader["approval_comments"] == DBNull.Value ? "" : Converter.ToString(dataReader["approval_comments"]);
                
                objEntity.UploadFlag = dataReader["upload_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["upload_flag"]);

                string tempTimeStamp = dataReader["timestamp"] == DBNull.Value ? "" : Converter.ToString(dataReader["timestamp"]);

                if (!string.IsNullOrEmpty(tempTimeStamp))
                {
                    objEntity.TimeStamp = dataReader["timestamp"] == DBNull.Value ? default(byte[]) : (byte[])dataReader["timestamp"];

                    if (objEntity.TimeStamp != default(byte[]))
                    {
                        objEntity.StrTimeStamp = ConvertFromByteToString(objEntity.TimeStamp, "|$|");
                    }
                }

                try
                {
                    objEntity.first_name = dataReader["name_first"] == DBNull.Value ? "" : Converter.ToString(dataReader["name_first"]);
                    objEntity.last_name = dataReader["name_last"] == DBNull.Value ? "" : Converter.ToString(dataReader["name_last"]);
                }
                catch {
                    objEntity.first_name = "";
                    objEntity.last_name="";
                }

                objEntity.is_approver = dataReader["is_approver"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["is_approver"]);
                objEntity.is_finance_approver = dataReader["is_finance_approver"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["is_finance_approver"]);







                //objEntity.line_id = dataReader["line_id"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["line_id"]);
                //objEntity.res_type = dataReader["res_type"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["res_type"]);
                //objEntity.payment_code = dataReader["payment_code"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["payment_code"]);
                //objEntity.payment_name = dataReader["payment_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["payment_name"]);
                //objEntity.currency_code = dataReader["currency_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["currency_code"]);
                //objEntity.currency_conversion_rate = dataReader["currency_conversion_rate"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["currency_conversion_rate"]);
                //objEntity.amount = dataReader["amount"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["amount"]);
                //objEntity.amount_home = dataReader["amount_home"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["amount_home"]);
                //objEntity.amount_billable = dataReader["amount_billable"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["amount_billable"]);
                //objEntity.recipt_Flag = dataReader["receipt_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["receipt_flag"]);
                //objEntity.reimbursment_flag = dataReader["reimbursment_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["reimbursment_flag"]);
                //objEntity.record_id = dataReader["record_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["record_id"]);
                //objEntity.gst_tax_code = dataReader["gst_tax_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["gst_tax_code"]);
                //objEntity.net_amount = dataReader["net_amount"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["net_amount"]);
                //objEntity.cc_exp_id = dataReader["cc_exp_id"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["cc_exp_id"]);
                //objEntity.cc_num = dataReader["cc_num"] == DBNull.Value ? "" : Converter.ToString(dataReader["cc_num"]);
                //objEntity.cc_type_id = dataReader["cc_type_id"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["cc_type_id"]);
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {

            List<T> retList = null;
            //if (criteria != null && criteria.Keys != null && criteria.Keys.Count > 0)
            //{
            //    retList = SelectFromList(criteria);
            //}
            //else
            //{
            TransactionCriteria<Transaction> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);


            if (criteria != null)
            {
                objCriteria = criteria as TransactionCriteria<Transaction>;

                //if (objCriteria.isFirstTime)
                //{
                //    param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
                //    param.Value = Context.SubscriberID;
                //    parameters.Add(param);
                //}

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = objCriteria.ResourceID;
                parameters.Add(param);

                if (objCriteria.ActionFlag != 4)
                {
                    if (objCriteria.StartDate != default(DateTime))
                    {
                        param = new SqlParameter("@start_date", SqlDbType.DateTime);
                        param.Value = objCriteria.StartDate;
                        parameters.Add(param);
                    }

                    if (objCriteria.EndDate != default(DateTime))
                    {
                        param = new SqlParameter("@end_date", SqlDbType.DateTime);
                        param.Value = objCriteria.EndDate;
                        parameters.Add(param);
                    }

                    if (objCriteria.LastSyncDate != default(DateTime))
                    {
                        param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                        param.Value = objCriteria.LastSyncDate;
                        parameters.Add(param);
                    }

                    if (!string.IsNullOrEmpty(objCriteria.TransactionID))
                    {
                        param = new SqlParameter("@transaction_id", SqlDbType.VarChar);
                        param.Value = objCriteria.TransactionID;
                        parameters.Add(param);
                    }

                    if (!string.IsNullOrEmpty(objCriteria.NotificationID))
                    {
                        param = new SqlParameter("@notification_id", SqlDbType.VarChar);
                        param.Value = objCriteria.NotificationID;
                        parameters.Add(param);
                    }

                    if (objCriteria.Keys != null && objCriteria.Keys.Count > 0)
                    {
                        param = new SqlParameter("@keys", SqlDbType.Xml);
                        param.Value = GetXMLFromKeys(objCriteria.Keys);
                        parameters.Add(param);
                    }
                }

            }

            try
            {
                if (objCriteria != null && objCriteria.ActionFlag != 4)
                {
                    retList = DbContext.GetEntitiesList(this, "Plsw_Apps_Transaction_Get", parameters, enumDatabaes.TE);
                }
                else
                {
                    retList = DbContext.GetEntitiesList(this, "plsw_apps_transaction_delete_get", parameters, enumDatabaes.TE);
                }

            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    if (objCriteria != null && objCriteria.ActionFlag == 4)
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the deleted Transaction(s): {0} .", ex.Message.Trim()), ex);
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);
                    }

                }
            }
            catch (Exception ex)
            {
                if (objCriteria != null && objCriteria.ActionFlag == 4)
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the deleted Transaction(s): {0} .", ex.Message.Trim()), ex);
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);
                }
            }
            //}

            return retList;


        }

        public override bool Save(T entity)
        {
            bool retVal = false;

            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
            parameters.Add(param);

            param = new SqlParameter("@action_flag", entity.ActionFlag);
            parameters.Add(param);

            param = new SqlParameter("@resource_id", entity.ResourceID);
            parameters.Add(param);

            param = new SqlParameter("@transaction_id", entity.TransactionID);
            parameters.Add(param);

            param = new SqlParameter("@comments", entity.Comments);
            parameters.Add(param);

            param = new SqlParameter("@level2_key", entity.Level2Key);
            parameters.Add(param);

            param = new SqlParameter("@level3_key", entity.Level3Key);
            parameters.Add(param);

            param = new SqlParameter("@task_code", entity.TaskCode);
            parameters.Add(param);

            param = new SqlParameter("@res_usage_code", entity.ResUsageCode);
            parameters.Add(param);

            param = new SqlParameter("@line_id", entity.line_id);
            parameters.Add(param);

            param = new SqlParameter("@units", entity.Units);
            parameters.Add(param);

            param = new SqlParameter("@applied_date", entity.AppliedDate);
            parameters.Add(param);

            param = new SqlParameter("@submitted_flag", entity.SubmittedFlag);
            parameters.Add(param);

            param = new SqlParameter("@create_id", Context.LoginID);
            parameters.Add(param);

            param = new SqlParameter("@approval_comments", entity.ApprovalComments);
            parameters.Add(param);


            //if (entity.DeviceInfo != "")
            //{

            //}
            //param = new SqlParameter("@create_id", Context.LoginID);
            //parameters.Add(param);

            if (entity.TimeStamp != null)
            {
                parameters.Add(GetTimestampParam("@TS", entity.TimeStamp));
            }

            if (entity.ModifyDate != default(DateTime))
            {
                param = new SqlParameter("@modify_date", entity.ModifyDate);
                parameters.Add(param);
            }

            param = new SqlParameter("@temp_modify_date", Context.LoginID);
            param.Value = DateTime.Now;
            parameters.Add(param);

            try
            {
                //retVal = DbContext.Update("Plsw_Apps_Transaction_Set", parameters, enumDatabaes.TE);

                retVal = DbContext.Update("Plsw_Apps_Transaction_Set", parameters, enumDatabaes.TE);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error saving the Transaction: {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error saving the Transaction: {0} .", ex.Message.Trim()), ex);
            }

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

            foreach (Transaction entity in entities)
            {
                T objEntity = null;

                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
                parameters.Add(param);

                param = new SqlParameter("@action_flag", entity.ActionFlag);
                parameters.Add(param);

                param = new SqlParameter("@resource_id", entity.ResourceID);
                parameters.Add(param);

                param = new SqlParameter("@transaction_id", entity.TransactionID);
                parameters.Add(param);

                param = new SqlParameter("@comments", entity.Comments);
                parameters.Add(param);

                param = new SqlParameter("@level2_key", entity.Level2Key);
                parameters.Add(param);

                param = new SqlParameter("@level3_key", entity.Level3Key);
                parameters.Add(param);

                param = new SqlParameter("@task_code", entity.TaskCode);
                parameters.Add(param);

                param = new SqlParameter("@res_usage_code", entity.ResUsageCode);
                parameters.Add(param);

                param = new SqlParameter("@line_id", entity.line_id);
                parameters.Add(param);

                param = new SqlParameter("@units", entity.Units);
                parameters.Add(param);

                param = new SqlParameter("@applied_date", entity.AppliedDate);
                parameters.Add(param);

                param = new SqlParameter("@submitted_flag", entity.SubmittedFlag);
                parameters.Add(param);

                param = new SqlParameter("@create_id", Context.LoginID);
                parameters.Add(param);

                
                param = new SqlParameter("@approval_comments", entity.ApprovalComments);
                parameters.Add(param);

                if (entity.TimeStamp != null)
                {
                    parameters.Add(GetTimestampParam("@TS", entity.TimeStamp));
                }

                if (entity.ModifyDate != default(DateTime))
                {
                    param = new SqlParameter("@modify_date", entity.ModifyDate);
                    parameters.Add(param);
                }

                param = new SqlParameter("@device_info", entity.DeviceInfo);
                parameters.Add(param);

                //param = new SqlParameter("@temp_modify_date", Context.LoginID);
                //param.Value = DateTime.Now;
                //parameters.Add(param);

                try
                {
                    // This is wrong, just get the entity from entity list on success, on failure get error from db.
                    //objEntity = DbContext.GetEntity(this, "Plsw_Apps_Transaction_Set", parameters, enumDatabaes.TE);

                    objEntity = DbContext.GetEntity(this, "Plsw_Apps_Transaction_Set", parameters, enumDatabaes.TE);

                    if (objEntity != null)
                    {
                        objEntity.ActionFlag = entity.ActionFlag;
                        retTrxs.Add(objEntity);
                    }
                    else
                    {
                        objEntity = new T();
                        objEntity.ErrorFlag = 2;
                        objEntity.ErrorCode = -200;
                        objEntity.ErrorDescription = "Could not save the transaction.";
                        retTrxs.Add(objEntity);
                    }

                }
                catch (AppException ex)
                {
                    objEntity = new T();
                    objEntity.ErrorFlag = 2;
                    objEntity.ErrorCode = -200;
                    objEntity.ErrorDescription = ex.Message;
                    retTrxs.Add(objEntity);

                }
                catch (Exception ex)
                {
                    objEntity = new T();
                    objEntity.ErrorFlag = 2;
                    objEntity.ErrorCode = -200;
                    objEntity.ErrorDescription = ex.Message;
                    retTrxs.Add(objEntity);
                }
            }

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

                TransactionCriteria<Transaction> objCriteria = null;
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);


                if (criteria != null)
                {
                    objCriteria = criteria as TransactionCriteria<Transaction>;

                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = objCriteria.ResourceID;
                    parameters.Add(param);

                    param = new SqlParameter("@transaction_id", SqlDbType.VarChar);
                    param.Value = splittedKeys[1];
                    parameters.Add(param);

                }

                try
                {
                    T tempEntity = DbContext.GetEntity(this, "Plsw_Apps_Transaction_Get", parameters, enumDatabaes.TE);

                    if (tempEntity != null)
                    {
                        retList.Add(tempEntity);
                    }

                }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {
                        if (objCriteria != null && objCriteria.ActionFlag == 4)
                        {
                            throw new AppException(Context.LoginID, string.Format("Error fetching the deleted Transaction(s): {0} .", ex.Message.Trim()), ex);
                        }
                        else
                        {
                            throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);
                        }

                    }
                }
                catch (Exception ex)
                {
                    if (objCriteria != null && objCriteria.ActionFlag == 4)
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the deleted Transaction(s): {0} .", ex.Message.Trim()), ex);
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);
                    }
                }
            }

            return retList;
        }

    }
}
