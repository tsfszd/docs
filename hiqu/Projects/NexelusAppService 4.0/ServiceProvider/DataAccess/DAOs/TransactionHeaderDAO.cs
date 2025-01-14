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
    public class TransactionHeaderDAO<T> : DAOBase<T> where T : TransactionHeader, new()
    {
        private bool isAfterSave = false;

        public TransactionHeaderDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            isAfterSave = false;
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;

                //transaction_id
                string tempTimeStamp = dataReader["timestamp"] == DBNull.Value ? "" : Converter.ToString(dataReader["timestamp"]);

                if (!string.IsNullOrEmpty(tempTimeStamp))
                {
                    byte[] tempTimeStampBytes = dataReader["timestamp"] == DBNull.Value ? default(byte[]) : (byte[])dataReader["timestamp"];

                    if (tempTimeStampBytes != default(byte[]))
                    {
                        objEntity.timestamp = ConvertFromByteToString(tempTimeStampBytes, "|$|");
                    }
                }

                try
                {
                    objEntity.error_flag = dataReader["error_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["error_flag"]);
                    objEntity.ErrorFlag = objEntity.error_flag;

                    objEntity.error_code = dataReader["error_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["error_code"]);
                    objEntity.ErrorCode = Int32.Parse(objEntity.error_code);

                    objEntity.error_description = dataReader["error_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["error_description"]);
                    objEntity.ErrorDescription = objEntity.error_description;

                    isAfterSave = dataReader["is_after_save"] == DBNull.Value ? false : Converter.ToBool(dataReader["is_after_save"]);
                }
                catch (Exception)
                {
                    objEntity.error_flag = 0;
                    objEntity.error_code = "0";
                    objEntity.error_description = "";
                }

                if (objEntity.error_flag == 0 && isAfterSave == false)
                {
                    objEntity.report_name = Converter.ToString(DataAccess.Read<string>(dataReader, "report_name"));
                    objEntity.ResourceID = Converter.ToString(DataAccess.Read<string>(dataReader, "resource_id"));
                    objEntity.record_id = Converter.ToString(DataAccess.Read<string>(dataReader, "record_id"));
                    objEntity.comments = Converter.ToString(DataAccess.Read<string>(dataReader, "comments"));
                    objEntity.str_date_from = DataAccess.Read<DateTime>(dataReader, "date_from").ToString("yyyy-MM-dd HH:mm:ss");
                    objEntity.str_date_to = DataAccess.Read<DateTime>(dataReader, "date_to").ToString("yyyy-MM-dd HH:mm:ss");
                    objEntity.expense_num = Converter.ToString(DataAccess.Read<string>(dataReader, "expense_num"));
                    objEntity.amount = DataAccess.Read<double>(dataReader, "amount");
                    objEntity.str_create_date = DataAccess.Read<DateTime>(dataReader, "create_date").ToString("yyyy-MM-dd HH:mm:ss");
                    objEntity.create_id = Converter.ToString(DataAccess.Read<string>(dataReader, "create_id"));
                    objEntity.str_modify_date = DataAccess.Read<DateTime>(dataReader, "modify_date").ToString("yyyy-MM-dd HH:mm:ss");
                    objEntity.modify_id = Converter.ToString(DataAccess.Read<string>(dataReader, "modify_id"));
                    objEntity.approver_id = Converter.ToString(DataAccess.Read<string>(dataReader, "approver_id"));
                    objEntity.print_format = Converter.ToString(DataAccess.Read<string>(dataReader, "print_format"));
                    objEntity.re_approval_flag = Converter.ToString(DataAccess.Read<string>(dataReader, "re_approval_flag"));
                    objEntity.submitter_id = Converter.ToString(DataAccess.Read<string>(dataReader, "submitter_id"));
                    objEntity.summary_flag = Converter.ToInteger(DataAccess.Read<int>(dataReader, "summary_flag"));
                    objEntity.approved_flag = Converter.ToInteger(DataAccess.Read<int>(dataReader, "approved"));
                    objEntity.name_first = Converter.ToString(DataAccess.Read<string>(dataReader, "name_first"));
                    objEntity.name_last = Converter.ToString(DataAccess.Read<string>(dataReader, "name_last"));
                    objEntity.report_owner_currency_code = Converter.ToString(DataAccess.Read<string>(dataReader, "currency_code"));
                    //objEntity.Approvers = Converter.ToString(DataAccess.Read<string>(dataReader, "approvers"));
                }
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
            TransactionHeaderCriteria<TransactionHeader> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);


            if (criteria != null)
            {
                objCriteria = criteria as TransactionHeaderCriteria<TransactionHeader>;

                //if (objCriteria.isFirstTime)
                //{
                //    param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
                //    param.Value = Context.SubscriberID;
                //    parameters.Add(param);
                //}

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = objCriteria.ResourceID;
                parameters.Add(param);

                if (!string.IsNullOrEmpty(objCriteria.record_id))
                {
                    param = new SqlParameter("@record_id", SqlDbType.VarChar);
                    param.Value = objCriteria.record_id;
                    parameters.Add(param);
                }

                if (objCriteria.LastSyncDate != default(DateTime) && string.IsNullOrEmpty(objCriteria.record_id))
                {
                    param = new SqlParameter("@last_sync_date", SqlDbType.VarChar);
                    param.Value = objCriteria.LastSyncDate;
                    parameters.Add(param);
                }

                if (objCriteria.Keys != null && objCriteria.Keys.Count > 0)
                {
                    param = new SqlParameter("@keys", SqlDbType.Xml);
                    param.Value = GetXMLFromKeys(objCriteria.Keys);
                    parameters.Add(param);
                }

                //if (objCriteria.ActionFlag != 4)
                //{
                //    if (objCriteria.StartDate != default(DateTime))
                //    {
                //        param = new SqlParameter("@start_date", SqlDbType.DateTime);
                //        param.Value = objCriteria.StartDate;
                //        parameters.Add(param);
                //    }

                //    if (objCriteria.EndDate != default(DateTime))
                //    {
                //        param = new SqlParameter("@end_date", SqlDbType.DateTime);
                //        param.Value = objCriteria.EndDate;
                //        parameters.Add(param);
                //    }

                //    if (objCriteria.LastSyncDate != default(DateTime))
                //    {
                //        param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                //        param.Value = objCriteria.LastSyncDate;
                //        parameters.Add(param);
                //    }
                //}

            }

            try
            {
                //Adding from_finance flag to remove timeout issue due to high amount of data
                param = new SqlParameter("@from_fin_menu", SqlDbType.Int);
                param.Value = 0;
                parameters.Add(param);

                retList = DbContext.GetEntitiesList(this, "plsW_apps_exptrx_hdr_get", parameters, enumDatabaes.TE);


                List<SqlParameter> parameters1 = new List<SqlParameter>();
                SqlParameter param1 = new SqlParameter("@company_code", SqlDbType.Int);
                param1.Value = Context.ComapnyCode;
                parameters1.Add(param1);


                if (criteria != null)
                {
                    objCriteria = criteria as TransactionHeaderCriteria<TransactionHeader>;

                    param1 = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param1.Value = objCriteria.ResourceID;
                    parameters1.Add(param1);

                    if (!string.IsNullOrEmpty(objCriteria.record_id))
                    {
                        param1 = new SqlParameter("@record_id", SqlDbType.VarChar);
                        param1.Value = objCriteria.record_id;
                        parameters1.Add(param1);
                    }

                    if (objCriteria.LastSyncDate != default(DateTime) && string.IsNullOrEmpty(objCriteria.record_id))
                    {
                        param1 = new SqlParameter("@last_sync_date", SqlDbType.VarChar);
                        param1.Value = objCriteria.LastSyncDate;
                        parameters1.Add(param1);
                    }

                    if (objCriteria.Keys != null && objCriteria.Keys.Count > 0)
                    {
                        param1 = new SqlParameter("@keys", SqlDbType.Xml);
                        param1.Value = GetXMLFromKeys(objCriteria.Keys);
                        parameters1.Add(param1);
                    }
                }

                param1 = new SqlParameter("@from_fin_menu", SqlDbType.Int);
                param1.Value = 1;
                parameters1.Add(param1);

                List<T> retList1 = null;
                retList1 = DbContext.GetEntitiesList(this, "plsW_apps_exptrx_hdr_get", parameters1, enumDatabaes.TE);

                foreach (var value in retList1)
                    retList.Add(value);                

                List<string> recordIds = new List<string>();

                foreach (TransactionHeader trxHdr in retList)
                    recordIds.Add(trxHdr.record_id);

                ExpenseTransactionCriteria<ExpenseTransaction> expTrxCrit = new ExpenseTransactionCriteria<ExpenseTransaction>()
                {
                    ResourceID = objCriteria.ResourceID,
                    Keys = recordIds,
                    LastSyncDate = criteria.LastSyncDate,
                    LoginID = objCriteria.ResourceID,
                    IsFromHeader = true
                };

                List<ExpenseTransaction> allTrxs = new ExpenseTransactionDAO<ExpenseTransaction>(this.Context).Select(expTrxCrit);

                for (int i = 0; i < retList.Count; i++)
                {
                    TransactionHeader trxHdr = retList[i];
                    trxHdr.transactions = new List<ExpenseTransaction>();
                    foreach (ExpenseTransaction trx in allTrxs)
                    {
                        if (trx.record_id == trxHdr.record_id)
                            trxHdr.transactions.Add(trx);                        
                    }
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
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s) Header(s): {0} .", ex.Message.Trim()), ex);

                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s) Header(s): {0} .", ex.Message.Trim()), ex);
            }

            return retList;
            //}

        }

        public override bool Save(T entity)
        {
            bool retVal = false;

            //List<SqlParameter> parameters = new List<SqlParameter>();

            //SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
            //parameters.Add(param);

            //param = new SqlParameter("@action_flag", entity.ActionFlag);
            //parameters.Add(param);

            //param = new SqlParameter("@resource_id", entity.ResourceID);
            //parameters.Add(param);

            //param = new SqlParameter("@transaction_id", entity.TransactionID);
            //parameters.Add(param);

            //param = new SqlParameter("@comments", entity.Comments);
            //parameters.Add(param);

            //param = new SqlParameter("@level2_key", entity.Level2Key);
            //parameters.Add(param);

            //param = new SqlParameter("@level3_key", entity.Level3Key);
            //parameters.Add(param);

            //param = new SqlParameter("@task_code", entity.TaskCode);
            //parameters.Add(param);

            //param = new SqlParameter("@res_usage_code", entity.ResUsageCode);
            //parameters.Add(param);

            //param = new SqlParameter("@line_id", entity.line_id);
            //parameters.Add(param);

            //param = new SqlParameter("@units", entity.Units);
            //parameters.Add(param);

            //param = new SqlParameter("@applied_date", entity.AppliedDate);
            //parameters.Add(param);

            //param = new SqlParameter("@submitted_flag", entity.SubmittedFlag);
            //parameters.Add(param);

            //param = new SqlParameter("@create_id", Context.LoginID);
            //parameters.Add(param);

            ////if (entity.DeviceInfo != "")
            ////{

            ////}
            ////param = new SqlParameter("@create_id", Context.LoginID);
            ////parameters.Add(param);

            //if (entity.TimeStamp != null)
            //{
            //    parameters.Add(GetTimestampParam("@TS", entity.TimeStamp));
            //}

            //if (entity.ModifyDate != default(DateTime))
            //{
            //    param = new SqlParameter("@modify_date", entity.ModifyDate);
            //    parameters.Add(param);
            //}

            //param = new SqlParameter("@temp_modify_date", Context.LoginID);
            //param.Value = DateTime.Now;
            //parameters.Add(param);

            //try
            //{
            //    //retVal = DbContext.Update("Plsw_Apps_Transaction_Set", parameters, enumDatabaes.TE);

            //    retVal = DbContext.Update("Plsw_Apps_Transaction_Set", parameters, enumDatabaes.TE);
            //}
            //catch (AppException ex)
            //{
            //    if (ex.LoggerLevel == Log.LogLevelType.INNER)
            //    {
            //        throw ex;
            //    }
            //    else
            //    {
            //        throw new AppException(Context.LoginID, string.Format("Error saving the Transaction: {0} .", ex.Message.Trim()), ex);
            //    }
            //}
            //catch (Exception ex)
            //{
            //    throw new AppException(Context.LoginID, string.Format("Error saving the Transaction: {0} .", ex.Message.Trim()), ex);
            //}

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
            foreach (TransactionHeader entity in entities)
            {
                T objEntity = null;

                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
                parameters.Add(param);

                param = new SqlParameter("@action_flag", entity.ActionFlag);
                parameters.Add(param);

                param = new SqlParameter("@resource_id", entity.ResourceID);
                parameters.Add(param);

                param = new SqlParameter("@report_name", entity.report_name);
                parameters.Add(param);

                param = new SqlParameter("@record_id", entity.record_id);
                parameters.Add(param);

                param = new SqlParameter("@comments", entity.comments);
                parameters.Add(param);

                param = new SqlParameter("@date_from", entity.DateFrom);
                parameters.Add(param);

                param = new SqlParameter("@date_to", entity.DateTo);
                parameters.Add(param);

                param = new SqlParameter("@expense_num", entity.expense_num);
                parameters.Add(param);

                param = new SqlParameter("@amount", entity.amount);
                parameters.Add(param);

                param = new SqlParameter("@override_flag", 0);
                parameters.Add(param);

                param = new SqlParameter("@create_id", Context.LoginID);
                parameters.Add(param);

                param = new SqlParameter("@modify_id", Context.LoginID);
                parameters.Add(param);

                if (entity.timestamp != null)
                {
                    parameters.Add(GetTimestampParam("@TS", entity.ByteTS));
                }

                param = new SqlParameter("@approver_id", entity.approver_id);
                parameters.Add(param);

                param = new SqlParameter("@print_format", entity.print_format);
                parameters.Add(param);

                if (entity.is_cc == 1)
                {
                    param = new SqlParameter("@report_name_prefix", "AX");
                    parameters.Add(param);
                }

                param = new SqlParameter("@subscriber_id", Context.SubscriberID);
                parameters.Add(param);

                try
                {
                    // This is wrong, just get the entity from entity list on success, on failure get error from db.
                    //objEntity = DbContext.GetEntity(this, "Plsw_Apps_Transaction_Set", parameters, enumDatabaes.TE);

                    List<T> entList = DbContext.GetEntitiesList(this, "plsW_apps_exptrx_hdr_set", parameters, enumDatabaes.TE, true);

                    if (entList != null)
                    {
                        objEntity = entList[0];
                    }


                    if (objEntity != null)
                    {
                        if (objEntity.error_flag != 0)
                        {
                            //Copy the error in original header and then send back
                            TransactionHeader tempEntity = objEntity;
                            objEntity = (T)entity;
                            objEntity.error_code = tempEntity.error_code;
                            objEntity.ErrorCode = Int32.Parse(tempEntity.error_code);

                            objEntity.error_flag = tempEntity.error_flag;
                            objEntity.ErrorFlag = tempEntity.error_flag;

                            objEntity.error_description = tempEntity.error_description;
                            objEntity.ErrorDescription = tempEntity.error_description;

                            retTrxs.Add(objEntity);

                        }
                        else
                        {
                            objEntity.ActionFlag = entity.ActionFlag;
                            objEntity.ResourceID = entity.ResourceID;
                            objEntity.record_id = entity.record_id;
                            objEntity.re_approval_flag = entity.re_approval_flag;
                            objEntity.submitter_id = entity.submitter_id;
                            objEntity.summary_flag = entity.summary_flag;
                            objEntity.is_submitted = entity.is_submitted;

                            if (isAfterSave)
                            {
                                objEntity.DateFrom = entity.DateFrom;
                                objEntity.DateTo = entity.DateTo;
                                objEntity.str_date_from = entity.str_date_from;
                                objEntity.str_date_to = entity.str_date_to;
                            }

                            retTrxs.Add(objEntity);
                        }
                    }
                    else
                    {
                        objEntity = (T)entity;
                        objEntity.error_flag = 2;
                        objEntity.ErrorFlag = 2;

                        objEntity.error_code = "-200";
                        objEntity.ErrorCode = -200;

                        objEntity.error_description = "Could not save the transaction.";
                        objEntity.ErrorDescription = "Could not save the transaction.";

                        retTrxs.Add(objEntity);
                    }

                }
                catch (AppException ex)
                {
                    objEntity = (T)entity;
                    objEntity.error_flag = 2;
                    objEntity.ErrorFlag = 2;

                    objEntity.error_code = "-200";
                    objEntity.ErrorCode = -200;

                    objEntity.error_description = ex.Message;
                    objEntity.ErrorDescription = ex.Message;

                    retTrxs.Add(objEntity);

                }
                catch (Exception ex)
                {
                    objEntity = (T)entity;
                    objEntity.error_flag = 2;
                    objEntity.ErrorFlag = 2;

                    objEntity.error_code = "-200";
                    objEntity.ErrorCode = -200;

                    objEntity.error_description = ex.Message;
                    objEntity.ErrorDescription = ex.Message;

                    retTrxs.Add(objEntity);
                }
            }

            return retTrxs;
        }

        public T SubmitReport(T entity)
        {
            T objEntity = null;

            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
            parameters.Add(param);

            param = new SqlParameter("@action_flag", entity.ActionFlag);
            parameters.Add(param);

            param = new SqlParameter("@resource_id", entity.ResourceID);
            parameters.Add(param);

            param = new SqlParameter("@report_name", entity.report_name);
            parameters.Add(param);

            param = new SqlParameter("@record_id", entity.record_id);
            parameters.Add(param);

            param = new SqlParameter("@comments", entity.comments);
            parameters.Add(param);

            param = new SqlParameter("@date_from", entity.DateFrom);
            parameters.Add(param);

            param = new SqlParameter("@date_to", entity.DateTo);
            parameters.Add(param);

            param = new SqlParameter("@expense_num", entity.expense_num);
            parameters.Add(param);

            param = new SqlParameter("@amount", entity.amount);
            parameters.Add(param);

            param = new SqlParameter("@override_flag", 0);
            parameters.Add(param);

            param = new SqlParameter("@create_id", Context.LoginID);
            parameters.Add(param);

            param = new SqlParameter("@modify_id", Context.LoginID);
            parameters.Add(param);

            if (entity.timestamp != null)
            {
                parameters.Add(GetTimestampParam("@TS", entity.ByteTS));
            }

            param = new SqlParameter("@approver_id", entity.approver_id);
            parameters.Add(param);

            param = new SqlParameter("@print_format", entity.print_format);
            parameters.Add(param);

            if (entity.is_cc == 1)
            {
                param = new SqlParameter("@report_name_prefix", "AX");
                parameters.Add(param);
            }

            try
            {
                // This is wrong, just get the entity from entity list on success, on failure get error from db.
                //objEntity = DbContext.GetEntity(this, "Plsw_Apps_Transaction_Set", parameters, enumDatabaes.TE);

                List<T> entList = DbContext.GetEntitiesList(this, "plsW_apps_exptrx_hdr_set", parameters, enumDatabaes.TE, true);

                if (entList != null)
                {
                    objEntity = entList[0];
                }


                if (objEntity != null)
                {
                    if (objEntity.error_flag != 0)
                    {
                        //Copy the error in original header and then send back
                        TransactionHeader tempEntity = objEntity;
                        objEntity = (T)entity;
                        objEntity.error_code = tempEntity.error_code;
                        objEntity.error_flag = tempEntity.error_flag;
                        objEntity.error_description = tempEntity.error_description;

                    }
                    else
                    {
                        objEntity.ActionFlag = entity.ActionFlag;
                        objEntity.ResourceID = entity.ResourceID;
                        objEntity.record_id = entity.record_id;
                        objEntity.re_approval_flag = entity.re_approval_flag;
                        objEntity.submitter_id = entity.submitter_id;
                        objEntity.summary_flag = entity.summary_flag;
                    }
                }
                else
                {
                    objEntity = (T)entity;
                    objEntity.error_flag = 2;
                    objEntity.error_code = "-200";
                    objEntity.error_description = "Could not save the transaction.";
                }

            }
            catch (AppException ex)
            {
                objEntity = (T)entity;
                objEntity.error_flag = 2;
                objEntity.error_code = "-200";
                objEntity.error_description = ex.Message;

            }
            catch (Exception ex)
            {
                objEntity = (T)entity;
                objEntity.error_flag = 2;
                objEntity.error_code = "-200";
                objEntity.error_description = ex.Message;
            }


            return objEntity;
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

                    xml.Append("<record_id>");
                    xml.Append(splittedKeys[1]);
                    xml.Append("</record_id>");

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

                TransactionHeaderCriteria<TransactionHeader> objCriteria = null;
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                if (criteria != null)
                {
                    objCriteria = criteria as TransactionHeaderCriteria<TransactionHeader>;

                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = objCriteria.ResourceID;
                    parameters.Add(param);

                    param = new SqlParameter("@record_id", SqlDbType.VarChar);
                    param.Value = splittedKeys[1];
                    parameters.Add(param);

                    if (objCriteria.LastSyncDate != default(DateTime) && string.IsNullOrEmpty(objCriteria.record_id))
                    {
                        param = new SqlParameter("@last_sync_date", SqlDbType.VarChar);
                        param.Value = objCriteria.LastSyncDate;
                        parameters.Add(param);
                    }
                }

                try
                {
                    // = DbContext.GetEntitiesList(this, "plsW_apps_exptrx_hdr_get", parameters, enumDatabaes.TE);
                    retList.Add(DbContext.GetEntity(this, "plsW_apps_exptrx_hdr_get", parameters, enumDatabaes.TE));

                    if (retList != null)
                    {
                        foreach (TransactionHeader trxHdr in retList)
                        {
                            if (trxHdr != null)
                            {
                                ExpenseTransactionCriteria<ExpenseTransaction> expTrxCrit = new ExpenseTransactionCriteria<ExpenseTransaction>();
                                expTrxCrit.ResourceID = trxHdr.ResourceID;
                                expTrxCrit.record_id = trxHdr.record_id;
                                //,LastSyncDate = ((criteria != null)? criteria.LastSyncDate : DateTime.Now)


                                var obj = retList.FirstOrDefault(x => x.report_name == trxHdr.report_name);
                                if (obj != null) obj.transactions = new ExpenseTransactionDAO<ExpenseTransaction>(this.Context).Select(expTrxCrit);
                            }

                        }
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
                        throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s) Header(s): {0} .", ex.Message.Trim()), ex);

                    }
                }
                catch (Exception ex)
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s) Header(s): {0} .", ex.Message.Trim()), ex);
                }
            }

            return retList;
        }
    }
}
