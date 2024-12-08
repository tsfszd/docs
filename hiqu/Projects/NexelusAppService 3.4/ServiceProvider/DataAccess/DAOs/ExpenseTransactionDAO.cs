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
using LocalUtility = NexelusApp.Service.Utilities;
using com.paradigm.esm.general;
using System.Collections;
using NexelusApp.Service.Service;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class ExpenseTransactionDAO<T> : DAOBase<T> where T : ExpenseTransaction, new()
    {
        public ExpenseTransactionDAO(NexContext ctx)
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
                    //objEntity.ErrorFlag = dataReader["error_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["error_flag"]);
                    objEntity.ErrorCode = dataReader["error_code"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["error_code"]);
                    objEntity.ErrorFlag = (objEntity.ErrorCode > 0 || objEntity.ErrorCode < 0) ? 1 : 0;
                    objEntity.ErrorDescription = dataReader["error_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["error_description"]);

                    string tempDate = "";

                    try
                    {
                        tempDate = dataReader["error_date"] == DBNull.Value ? "" : Converter.ToDate(dataReader["error_date"]).ToString("MM/dd/yyyy");
                    }
                    catch (Exception)
                    { }

                    if (!string.IsNullOrEmpty(tempDate))
                    {
                        objEntity.ErrorDescription += ": " + tempDate;
                    }

                    if (objEntity.ErrorCode == -11)
                    {
                        objEntity.ErrorDescription += " Please Refresh.";
                    }

                }
                catch (Exception)
                {
                    objEntity.ErrorFlag = 0;
                    objEntity.ErrorCode = 0;
                    objEntity.ErrorDescription = "";
                }

                if (objEntity.ErrorCode == 0)
                {
                    string tempTimeStamp = dataReader["timestamp"] == DBNull.Value ? "" : Converter.ToString(dataReader["timestamp"]);

                    if (!string.IsNullOrEmpty(tempTimeStamp))
                    {
                        objEntity.TimeStamp = dataReader["timestamp"] == DBNull.Value ? default(byte[]) : (byte[])dataReader["timestamp"];

                        if (objEntity.TimeStamp != default(byte[]))
                        {
                            objEntity.StrTimeStamp = ConvertFromByteToString(objEntity.TimeStamp, "|$|");
                        }
                    }

                    objEntity.TransactionID = dataReader["transaction_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["transaction_id"]);
                    objEntity.Level2Key = dataReader["level2_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level2_key"]);
                    objEntity.Level3Key = dataReader["level3_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level3_key"]);

                    objEntity.StrAppliedDate = dataReader["applied_date"] == DBNull.Value ? "" : Converter.ToDate(dataReader["applied_date"]).ToString("yyyy-MM-dd HH:mm:ss");
                    objEntity.AppliedDate = dataReader["applied_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["applied_date"]);


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

                    objEntity.line_id = dataReader["line_id"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["line_id"]);
                    objEntity.res_type = dataReader["res_type"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["res_type"]);
                    objEntity.payment_code = dataReader["payment_code"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["payment_code"]);
                    objEntity.payment_name = dataReader["payment_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["payment_name"]);
                    objEntity.currency_code = dataReader["currency_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["currency_code"]);
                    objEntity.currency_conversion_rate = dataReader["currency_conversion_rate"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["currency_conversion_rate"]);
                    objEntity.amount = dataReader["amount"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["amount"]);
                    objEntity.amount_home = dataReader["amount_home"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["amount_home"]);
                    objEntity.amount_billable = dataReader["amount_billable"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["amount_billable"]);
                    objEntity.recipt_Flag = dataReader["receipt_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["receipt_flag"]);
                    objEntity.reimbursment_flag = dataReader["reimbursment_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["reimbursment_flag"]);
                    objEntity.record_id = dataReader["record_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["record_id"]);
                    objEntity.gst_tax_code = dataReader["gst_tax_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["gst_tax_code"]);
                    objEntity.net_amount = dataReader["net_amount"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["net_amount"]);
                    objEntity.cc_exp_id = dataReader["cc_exp_id"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["cc_exp_id"]);
                    objEntity.cc_num = dataReader["cc_num"] == DBNull.Value ? "" : Converter.ToString(dataReader["cc_num"]);
                    objEntity.cc_type_id = dataReader["cc_type_id"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["cc_type_id"]);
                    objEntity.IsFileAttached = dataReader["is_file_attached"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["is_file_attached"]);
                    objEntity.approval_comments = dataReader["approval_comment"] == DBNull.Value ? "" : Converter.ToString(dataReader["approval_comment"]);
                    objEntity.IsImageChanged = dataReader["is_image_changed"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["is_image_changed"]);
                    objEntity.ApprovalComments = dataReader["approval_comment"] == DBNull.Value ? "" : Converter.ToString(dataReader["approval_comment"]);
                    objEntity.Approvers = dataReader["approvers"] == DBNull.Value ? "" : Converter.ToString(dataReader["approvers"]);
                    //objEntity.UploadFlag = dataReader["upload_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["upload_flag"]);

                    objEntity.trx_approval_flag = dataReader["trx_approval_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["trx_approval_flag"]);
                    objEntity.trx_approval_required_flag = dataReader["trx_approval_required_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["trx_approval_required_flag"]);

                    try
                    {
                        objEntity.UploadFlag = dataReader["upload_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["upload_flag"]);
                    }
                    catch
                    {
                        objEntity.UploadFlag = 0;
                    }

                    try
                    {
                        objEntity.first_name = dataReader["name_first"] == DBNull.Value ? "" : Converter.ToString(dataReader["name_first"]);
                        objEntity.last_name = dataReader["name_last"] == DBNull.Value ? "" : Converter.ToString(dataReader["name_last"]);
                    }
                    catch
                    {
                        objEntity.first_name = "";
                        objEntity.last_name = "";
                    }

                    try
                    {
                        objEntity.finalise_flag = dataReader["finalise_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["finalise_flag"]);
                    }
                    catch
                    {
                        objEntity.finalise_flag = 0;
                    }


                    try
                    {
                        objEntity.is_approver = dataReader["is_approver"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["is_approver"]);
                    }
                    catch
                    {
                        objEntity.is_approver = 0;
                    }

                    try
                    {
                        objEntity.is_finance_approver = dataReader["is_finance_approver"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["is_finance_approver"]);
                    }
                    catch
                    {
                        objEntity.is_finance_approver = 0;
                    }


                    if (objEntity.custom_fields == null)
                    {
                        objEntity.custom_fields = new TransactionExpense();
                    }

                    objEntity.custom_fields.text1 = dataReader["text1"] == DBNull.Value ? "" : Converter.ToString(dataReader["text1"]);
                    objEntity.custom_fields.text2 = dataReader["text2"] == DBNull.Value ? "" : Converter.ToString(dataReader["text2"]);
                    objEntity.custom_fields.text3 = dataReader["text3"] == DBNull.Value ? "" : Converter.ToString(dataReader["text3"]);
                    objEntity.custom_fields.text4 = dataReader["text4"] == DBNull.Value ? "" : Converter.ToString(dataReader["text4"]);
                    objEntity.custom_fields.text5 = dataReader["text5"] == DBNull.Value ? "" : Converter.ToString(dataReader["text5"]);
                    objEntity.custom_fields.text6 = dataReader["text6"] == DBNull.Value ? "" : Converter.ToString(dataReader["text6"]);
                    objEntity.custom_fields.text7 = dataReader["text7"] == DBNull.Value ? "" : Converter.ToString(dataReader["text7"]);
                    objEntity.custom_fields.text8 = dataReader["text8"] == DBNull.Value ? "" : Converter.ToString(dataReader["text8"]);
                    objEntity.custom_fields.text9 = dataReader["text9"] == DBNull.Value ? "" : Converter.ToString(dataReader["text9"]);
                    objEntity.custom_fields.text10 = dataReader["text10"] == DBNull.Value ? "" : Converter.ToString(dataReader["text10"]);

                    objEntity.custom_fields.number11 = dataReader["number11"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number11"]);
                    objEntity.custom_fields.number12 = dataReader["number12"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number12"]);
                    objEntity.custom_fields.number13 = dataReader["number13"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number13"]);
                    objEntity.custom_fields.number14 = dataReader["number14"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number14"]);
                    objEntity.custom_fields.number15 = dataReader["number15"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number15"]);
                    objEntity.custom_fields.number16 = dataReader["number16"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number16"]);
                    objEntity.custom_fields.number17 = dataReader["number17"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number17"]);
                    objEntity.custom_fields.number18 = dataReader["number18"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number18"]);
                    objEntity.custom_fields.number19 = dataReader["number19"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number19"]);
                    objEntity.custom_fields.number20 = dataReader["number20"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["number20"]);

                    objEntity.custom_fields.record_id = objEntity.record_id;
                    objEntity.custom_fields.transaction_id = objEntity.TransactionID;

                    //string tempTimeStamp2 = dataReader["exp_timestamp"] == DBNull.Value ? "" : Converter.ToString(dataReader["exp_timestamp"]);

                    if (!string.IsNullOrEmpty(tempTimeStamp))
                    {
                        byte[] tempTimeStamp2 = dataReader["exp_timestamp"] == DBNull.Value ? default(byte[]) : (byte[])dataReader["exp_timestamp"];

                        if (tempTimeStamp2 != default(byte[]))
                        {
                            objEntity.custom_fields.timestamp = ConvertFromByteToString(tempTimeStamp2, "|$|");
                        }
                    }

                    //objEntity.image_data = Context.EsmWebService.GetExpenseTransactionImage(Context.ComapnyCode, objEntity.record_id, objEntity.TransactionID);
                    // Try catch to handle the file types
                    //try
                    //{
                    //    objEntity.image_data = LocalUtility.Utility.GetExpenseTransactionImage(Context.ESMDocumentPath, Context.ComapnyCode, objEntity.record_id, objEntity.TransactionID);
                    //}
                    //catch (Exception ex)
                    //{
                    //    if (!ex.Message.Contains("The file type is not supported"))
                    //    {
                    //        throw ex;
                    //    }
                    //}
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
            ExpenseTransactionCriteria<ExpenseTransaction> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                objCriteria = criteria as ExpenseTransactionCriteria<ExpenseTransaction>;

                //if (objCriteria.isFirstTime)
                //{
                //    param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
                //    param.Value = Context.SubscriberID;
                //    parameters.Add(param);
                //}

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = objCriteria.ResourceID;
                parameters.Add(param);

                if (objCriteria.LoginID == null) //resource id is the manager in this case
                {
                    param = new SqlParameter("@login_id", SqlDbType.VarChar);
                    param.Value = objCriteria.ResourceID;
                    parameters.Add(param);

                }
                else
                {
                    param = new SqlParameter("@login_id", SqlDbType.VarChar);
                    param.Value = objCriteria.LoginID;
                    parameters.Add(param);

                }

                if (!string.IsNullOrEmpty(objCriteria.record_id))
                {
                    param = new SqlParameter("@record_id", SqlDbType.VarChar);
                    param.Value = objCriteria.record_id;
                    parameters.Add(param);
                }

                if (objCriteria.Keys != null && objCriteria.Keys.Count > 0)
                {
                    param = new SqlParameter("@keys", SqlDbType.Xml);
                    param.Value = GetXMLFromKeys(objCriteria.Keys, objCriteria.IsFromHeader);
                    parameters.Add(param);
                }

                param = new SqlParameter("@is_from_header", SqlDbType.TinyInt);
                param.Value = objCriteria.IsFromHeader ? 1 : 0;
                parameters.Add(param);
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "plsW_apps_exptransactions_get", parameters, enumDatabaes.TE);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);

                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);
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

            foreach (ExpenseTransaction entity in entities)
            {
                T objEntity = null;

                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
                parameters.Add(param);

                param = new SqlParameter("@action_flag", entity.ActionFlag);
                parameters.Add(param);

                param = new SqlParameter("@level2_key", entity.Level2Key);
                parameters.Add(param);

                param = new SqlParameter("@level3_key", entity.Level3Key);
                parameters.Add(param);

                param = new SqlParameter("@transaction_id_inp", entity.TransactionID);
                parameters.Add(param);

                param = new SqlParameter("@applied_date", entity.StrAppliedDate);
                parameters.Add(param);

                param = new SqlParameter("@org_unit", entity.OrgUnit);
                parameters.Add(param);

                param = new SqlParameter("@location_code", entity.LocationCode);
                parameters.Add(param);

                param = new SqlParameter("@resource_id", entity.ResourceID);
                parameters.Add(param);

                param = new SqlParameter("@comments", entity.Comments);
                parameters.Add(param);

                param = new SqlParameter("@submitted_flag", entity.SubmittedFlag);
                parameters.Add(param);

                param = new SqlParameter("@trx_type", entity.TrxType);
                parameters.Add(param);

                param = new SqlParameter("@res_type", entity.res_type);
                parameters.Add(param);

                //param = new SqlParameter("@vendor_id", entity.);
                //parameters.Add(param);

                param = new SqlParameter("@payment_code", entity.payment_code);
                parameters.Add(param);

                param = new SqlParameter("@payment_name", entity.payment_name);
                parameters.Add(param);

                //param = new SqlParameter("@pmt_vendor_code", entity.);
                //parameters.Add(param);

                param = new SqlParameter("@currency_code", entity.currency_code);
                parameters.Add(param);

                param = new SqlParameter("@currency_conversion_rate", entity.currency_conversion_rate);
                parameters.Add(param);

                //param = new SqlParameter("@allocation_prc", entity.allo);
                //parameters.Add(param);

                param = new SqlParameter("@amount", entity.amount);
                parameters.Add(param);

                param = new SqlParameter("@amount_home", entity.amount_home);
                parameters.Add(param);

                param = new SqlParameter("@amount_billable", entity.amount_billable);
                parameters.Add(param);

                param = new SqlParameter("@reimbursment_flag", entity.reimbursment_flag);
                parameters.Add(param);

                param = new SqlParameter("@trx_level", "3.0");
                parameters.Add(param);

                param = new SqlParameter("@parent_id", "");
                parameters.Add(param);

                param = new SqlParameter("@line_id", entity.line_id);
                parameters.Add(param);

                param = new SqlParameter("@record_id", entity.record_id);
                parameters.Add(param);

                param = new SqlParameter("@tax_code", entity.gst_tax_code);
                parameters.Add(param);

                //param = new SqlParameter("@tax_amount", Context.LoginID);
                //parameters.Add(param);

                param = new SqlParameter("@net_amount", entity.net_amount);
                parameters.Add(param);

                param = new SqlParameter("@res_usage_code", entity.ResUsageCode);
                parameters.Add(param);

                //param = new SqlParameter("@mileage_units", entity.m);
                //parameters.Add(param);

                if (entity.StrTimeStamp != null)
                {
                    parameters.Add(GetTimestampParam("@TS", entity.TimeStamp));
                }

                param = new SqlParameter("@override_flag", 0);
                parameters.Add(param);

                param = new SqlParameter("@approval_flag", entity.ApprovalFlag);
                parameters.Add(param);

                //param = new SqlParameter("@approval_comment", entity.appr);
                //parameters.Add(param);

                param = new SqlParameter("@nonbill_flag", entity.NonBillableFlag);
                parameters.Add(param);

                param = new SqlParameter("@create_id", entity.ResourceID);
                parameters.Add(param);

                param = new SqlParameter("@modify_id", entity.ResourceID);
                parameters.Add(param);

                param = new SqlParameter("@extra_param_1", DBNull.Value);
                parameters.Add(param);

                param = new SqlParameter("@extra_param_2", DBNull.Value);
                parameters.Add(param);

                param = new SqlParameter("@business_reason", DBNull.Value);
                parameters.Add(param);

                param = new SqlParameter("@finalise_flag", DBNull.Value);
                parameters.Add(param);

                param = new SqlParameter("@finalised_by", DBNull.Value);
                parameters.Add(param);

                param = new SqlParameter("@finalised_date", DBNull.Value);
                parameters.Add(param);

                //Custom Fields
                if (entity.custom_fields != null)
                {
                    param = new SqlParameter("@text1", entity.custom_fields.text1 != null ? entity.custom_fields.text1 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text2", entity.custom_fields.text2 != null ? entity.custom_fields.text2 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text3", entity.custom_fields.text3 != null ? entity.custom_fields.text3 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text4", entity.custom_fields.text4 != null ? entity.custom_fields.text4 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text5", entity.custom_fields.text5 != null ? entity.custom_fields.text5 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text6", entity.custom_fields.text6 != null ? entity.custom_fields.text6 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text7", entity.custom_fields.text7 != null ? entity.custom_fields.text7 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text8", entity.custom_fields.text8 != null ? entity.custom_fields.text8 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text9", entity.custom_fields.text9 != null ? entity.custom_fields.text9 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@text10", entity.custom_fields.text10 != null ? entity.custom_fields.text10 : "");
                    parameters.Add(param);

                    param = new SqlParameter("@number11", entity.custom_fields.number11);
                    parameters.Add(param);

                    param = new SqlParameter("@number12", entity.custom_fields.number12);
                    parameters.Add(param);

                    param = new SqlParameter("@number13", entity.custom_fields.number13);
                    parameters.Add(param);

                    param = new SqlParameter("@number14", entity.custom_fields.number14);
                    parameters.Add(param);

                    param = new SqlParameter("@number15", entity.custom_fields.number15);
                    parameters.Add(param);

                    param = new SqlParameter("@number16", entity.custom_fields.number16);
                    parameters.Add(param);

                    param = new SqlParameter("@number17", entity.custom_fields.number17);
                    parameters.Add(param);

                    param = new SqlParameter("@number18", entity.custom_fields.number18);
                    parameters.Add(param);

                    param = new SqlParameter("@number19", entity.custom_fields.number19);
                    parameters.Add(param);

                    param = new SqlParameter("@number20", entity.custom_fields.number20);
                    parameters.Add(param);
                }

                param = new SqlParameter("@cc_exp_id", entity.cc_exp_id);
                parameters.Add(param);

                if(entity.str_cc_time_stamp!=null)
                {
                    param = new SqlParameter("@cc_TS", entity.cc_time_stamp);
                    parameters.Add(param);
                }

                param = new SqlParameter("@cc_num", entity.cc_num);
                parameters.Add(param);

                param = new SqlParameter("@validate", DBNull.Value);
                parameters.Add(param);

                //param = new SqlParameter("@Is_file_attached", 0);
                //parameters.Add(param);

                try
                {
                    if (entity.consider_image == 1)
                    {
                        if (!string.IsNullOrEmpty(entity.image_data))
                        {
                            entity.recipt_Flag = 1;
                            param = new SqlParameter("@Is_file_attached", 1);
                        }
                        else
                        {
                            entity.recipt_Flag = 0;
                            param = new SqlParameter("@Is_file_attached", 0);
                        }
                    }
                    else
                    {
                        if (LocalUtility.Utility.DoesImageExists(Context.ESMDocumentPath, Context.ComapnyCode, entity.record_id, entity.TransactionID))
                        {
                            entity.recipt_Flag = 1;
                            param = new SqlParameter("@Is_file_attached", 1);
                        }
                        else
                        {
                            entity.recipt_Flag = 0;
                            param = new SqlParameter("@Is_file_attached", 0);
                        }

                    }

                    parameters.Add(param);

                    param = new SqlParameter("@receipt_flag", entity.recipt_Flag);
                    parameters.Add(param);

                    param = new SqlParameter("@subscriber_id", Context.SubscriberID);
                    parameters.Add(param);

                    //DbContext.SaveForExpenseReport("plsW_apps_exptrx_set", parameters, enumDatabaes.TE, true);
                    DbContext.SaveForExpenseReport("plsW_apps_exptrx_set", parameters, enumDatabaes.TE, true);

                    if (DbContext.ErrorFlag != 0)
                    {
                        objEntity = (T)entity;
                        objEntity.ErrorCode = DbContext.ErrorCode;
                        objEntity.ErrorDescription = DbContext.ErrorDescription;

                        //if (objEntity.ErrorCode == -11)
                        //{
                        //    objEntity.ErrorDescription += "\nPlease Refresh.";
                        //}

                        objEntity.ErrorFlag = DbContext.ErrorFlag;
                        retTrxs.Add(objEntity);
                    }
                    else
                    {
                        if (entity.consider_image == 1)
                        {
                            var docPath = Context.ESMDocumentPath + "\\" + Context.ComapnyCode.ToString() + "\\" + entity.record_id + "\\" + entity.TransactionID + "\\";
                            var trxDetailDoc = new TransactionDetailDocument();
                            trxDetailDoc.TransactionId = entity.TransactionID;
                            trxDetailDoc.UploadedBy = entity.ResourceID;
                            trxDetailDoc.DocumentName = DateTime.Now.ToString("s").Replace("T", "").Replace(":", "") + ".jpg";
                            trxDetailDoc.DocumentLink = "documents/" + Context.ComapnyCode + "/" + entity.record_id + "/" + entity.TransactionID + "/" + trxDetailDoc.DocumentName;
                            trxDetailDoc.DocSource = 1;
                            trxDetailDoc.Action = 1;
                            trxDetailDoc.DocumentPath = docPath;

                            TransactionDetailDocumentCriteria<TransactionDetailDocument> docCriteria = new TransactionDetailDocumentCriteria<TransactionDetailDocument>(trxDetailDoc);
                            DocumentService<TransactionDetailDocument> docService = new DocumentService<TransactionDetailDocument>(this.Context);

                            if (!string.IsNullOrEmpty(entity.image_data))
                            {
                                //if (Context.EsmWebService.SetExpenseTransactionImage(Context.ComapnyCode, entity.record_id, entity.TransactionID, entity.image_data))
                                //if (LocalUtility.Utility.SetExpenseTransactionImage(Context.ESMDocumentPath, Context.ComapnyCode, entity.record_id, entity.TransactionID, entity.image_data))
                                docService.RemoveDocument(docCriteria, trxDetailDoc.DocumentPath);
                                if (docService.AddDocument(trxDetailDoc, entity.image_data))
                                {
                                    objEntity = (T)entity;
                                    objEntity.ErrorCode = 0;
                                    objEntity.ErrorDescription = "";
                                    objEntity.ErrorFlag = 0;

                                    objEntity.image_data = entity.image_data;
                                }
                                else
                                {
                                    objEntity = (T)entity;
                                    objEntity.ErrorFlag = 2;
                                    objEntity.ErrorCode = -200;
                                    objEntity.ErrorDescription = "Image could not be saved.";
                                }
                            }
                            else
                            {
                                // If no image data exists then delete the file
                                //if (LocalUtility.Utility.DeleteExpenseTransactionImage(Context.ESMDocumentPath, Context.ComapnyCode, entity.record_id, entity.TransactionID))
                                if (docService.RemoveDocument(docCriteria, trxDetailDoc.DocumentPath))
                                {
                                    objEntity = (T)entity;
                                    objEntity.ErrorCode = 0;
                                    objEntity.ErrorDescription = "";
                                    objEntity.ErrorFlag = 0;

                                    objEntity.image_data = entity.image_data;
                                }
                                else
                                {
                                    objEntity = (T)entity;
                                    objEntity.ErrorFlag = 2;
                                    objEntity.ErrorCode = -200;
                                    objEntity.ErrorDescription = "Image could not be deleted.";
                                }
                            }
                        }
                        else
                        {
                            objEntity = (T)entity;
                            objEntity.ErrorCode = 0;
                            objEntity.ErrorDescription = "";
                            objEntity.ErrorFlag = 0;
                        }

                        retTrxs.Add(objEntity);
                    }

                }
                catch (AppException ex)
                {
                    objEntity = (T)entity;
                    objEntity.ErrorFlag = 2;
                    objEntity.ErrorCode = -200;
                    objEntity.ErrorDescription = ex.Message;
                    retTrxs.Add(objEntity);

                }
                catch (Exception ex)
                {
                    objEntity = (T)entity;
                    objEntity.ErrorFlag = 2;
                    objEntity.ErrorCode = -200;
                    objEntity.ErrorDescription = ex.Message;
                    retTrxs.Add(objEntity);
                }
            }

            return retTrxs;
        }

        private string GetXMLFromKeys(List<string> keys, bool isFromHeader = false)
        {
            StringBuilder xml = new StringBuilder();
            xml.Append("<keys>");

            foreach (string key in keys)
            {
                if (!isFromHeader)
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
                else
                {
                    xml.Append("<key>");

                    xml.Append("<transaction_id>");
                    xml.Append(key);
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

                ExpenseTransactionCriteria<ExpenseTransaction> objCriteria = null;
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                if (criteria != null)
                {
                    objCriteria = criteria as ExpenseTransactionCriteria<ExpenseTransaction>;

                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = objCriteria.ResourceID;
                    parameters.Add(param);

                    if (objCriteria.LoginID == null)//resource id is the manager in this case
                    {
                        param = new SqlParameter("@login_id", SqlDbType.VarChar);
                        param.Value = objCriteria.ResourceID;
                        parameters.Add(param);

                    }
                    else
                    {
                        param = new SqlParameter("@login_id", SqlDbType.VarChar);
                        param.Value = objCriteria.LoginID;
                        parameters.Add(param);

                    }

                    if (!string.IsNullOrEmpty(splittedKeys[1]))
                    {
                        param = new SqlParameter("@transaction_id", SqlDbType.VarChar);
                        param.Value = splittedKeys[1];
                        parameters.Add(param);
                    }

                    if (objCriteria.Keys != null && objCriteria.Keys.Count > 0)
                    {
                        param = new SqlParameter("@keys", SqlDbType.VarChar);
                        param.Value = GetXMLFromKeys(objCriteria.Keys, objCriteria.IsFromHeader);
                        parameters.Add(param);
                    }

                    param = new SqlParameter("@is_from_header", SqlDbType.TinyInt);
                    param.Value = objCriteria.IsFromHeader ? 1 : 0;
                    parameters.Add(param);
                }

                try
                {
                    //retList = DbContext.GetEntitiesList(this, "plsW_apps_exptransactions_get", parameters, enumDatabaes.TE);
                    retList.Add(DbContext.GetEntity(this, "plsW_apps_exptransactions_get", parameters, enumDatabaes.TE));
                }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);

                    }
                }
                catch (Exception ex)
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);
                }

            }

            return retList;
        }

        public T SetTheFileChangedFlag(string record_id, string transaction_id, int image_changed_flag)
        {
            T retVal = null;

            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@record_id", SqlDbType.VarChar);
            param.Value = record_id;
            parameters.Add(param);

            param = new SqlParameter("@transaction_id", SqlDbType.VarChar);
            param.Value = transaction_id;
            parameters.Add(param);

            param = new SqlParameter("@is_image_changed", SqlDbType.Int);
            param.Value = image_changed_flag;
            parameters.Add(param);

            try
            {
                List<T> tempSavedList = DbContext.GetEntitiesList(this, "plsw_apps_set_image_changed_flag", parameters, enumDatabaes.TE);

                if (tempSavedList != null && tempSavedList.Count > 0)
                {
                    retVal = tempSavedList[0];

                    if (retVal.ErrorFlag > 0)
                    {
                        throw new AppException(Context.LoginID, DbContext.ErrorDescription);
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
                    throw new AppException(Context.LoginID, string.Format("Error fetching the TransactionImage: {0} .", ex.Message.Trim()), ex);

                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the TransactionImage: {0} .", ex.Message.Trim()), ex);
            }

            return retVal;
        }

    }
}
