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
    public class RulesDAO<T> : DAOBase<T> where T : Rules, new()
    {
        private int isDummy = 0;
        public RulesDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                //if ( && DataAccess.Read<int>(dataReader, "child") != default(int))
                //{

                //}
                //else 

                objEntity.IsChild = DataAccess.Read<int>(dataReader, "child");


                if (objEntity.IsChild != 1)
                {



                    objEntity.CompanyCode = Context.ComapnyCode;
                    objEntity.id = DataAccess.Read<int>(dataReader, "id");
                    objEntity.is_Customfields_By_ExpanseGroup = DataAccess.Read<int>(dataReader, "is_Customfields_By_ExpanseGroup");

                    if (isDummy == 1)
                    {
                        objEntity.exp_currencyCode_rule = 1;
                    }
                    else
                    {
                        objEntity.exp_currencyCode_rule = DataAccess.Read<int>(dataReader, "exp_currencyCode_rule");
                    }

                    objEntity.number_Of_Days_Prior_Allowed = DataAccess.Read<int>(dataReader, "number_Of_Days_Prior_Allowed");
                    objEntity.override_approver = DataAccess.Read<int>(dataReader, "OverrideApprovals");
                    objEntity.show_billable_check = DataAccess.Read<int>(dataReader, "ShowBillable");
                    objEntity.show_receipt_check = DataAccess.Read<int>(dataReader, "Receipt");

                    objEntity.default_tax_code = !string.IsNullOrEmpty(DataAccess.Read<string>(dataReader, "TaxCode")) ? DataAccess.Read<string>(dataReader, "TaxCode").Trim() : "";
                    objEntity.default_payment_type = !string.IsNullOrEmpty(DataAccess.Read<string>(dataReader, "payment_code")) ? DataAccess.Read<string>(dataReader, "payment_code").Trim() : "";
                    objEntity.show_payment_type = DataAccess.Read<int>(dataReader, "show_payment_type");
                    objEntity.show_tax_code = DataAccess.Read<int>(dataReader, "show_tax_code");
                    objEntity.show_location = DataAccess.Read<int>(dataReader, "show_location");
                    objEntity.show_org_unit = DataAccess.Read<int>(dataReader, "show_org_unit");
                    objEntity.default_location = !string.IsNullOrEmpty(DataAccess.Read<string>(dataReader, "location")) ? DataAccess.Read<string>(dataReader, "location").Trim() : "";
                    objEntity.default_org_unit = !string.IsNullOrEmpty(DataAccess.Read<string>(dataReader, "org_unit")) ? DataAccess.Read<string>(dataReader, "org_unit").Trim() : "";

                    objEntity.allow_cc_report = DataAccess.Read<int>(dataReader, "Allow_CreditCard_Report");
                    objEntity.copy_cc_comments = DataAccess.Read<int>(dataReader, "Copy_cc_comments");
                    objEntity.allow_submit = DataAccess.Read<int>(dataReader, "Allow_submit");
                    objEntity.allow_submit_timesheet = DataAccess.Read<int>(dataReader, "Allow_submit_timesheet");
                    if (isDummy == 1)
                    {
                        objEntity.is_mc = 1;
                    }
                    else
                    {
                        objEntity.is_mc = DataAccess.Read<int>(dataReader, "is_mc");
                    }

                    // New Rules Added
                    objEntity.level2_filter_org_unit_time = DataAccess.Read<int>(dataReader, "filter_level2_orgunit_time");
                    objEntity.level3_filter_org_unit_time = DataAccess.Read<int>(dataReader, "filter_level3_orgunit_time");
                    objEntity.level2_filter_location_time = DataAccess.Read<int>(dataReader, "filter_level2_locationcode_time");
                    objEntity.level3_filter_location_time = DataAccess.Read<int>(dataReader, "filter_level3_locationcode_time");


                    objEntity.level2_filter_org_unit_expense = DataAccess.Read<int>(dataReader, "filter_level2_orgunit_exp");
                    objEntity.level3_filter_org_unit_expense = DataAccess.Read<int>(dataReader, "filter_level3_orgUnit_exp");
                    objEntity.level2_filter_location_expense = DataAccess.Read<int>(dataReader, "filter_level2_locationcode_exp");
                    objEntity.level3_filter_location_expense = DataAccess.Read<int>(dataReader, "filter_level3_locationcode_exp");

                    objEntity.custom_fields_based_on = DataAccess.Read<int>(dataReader, "is_Customfields_By_ExpanseGroup");
                    objEntity.expense_report_name = DataAccess.Read<int>(dataReader, "expense_report_name");
                    objEntity.approvers_based_on = DataAccess.Read<int>(dataReader, "approvers_based_on");

                    objEntity.exp_decimal_places = DataAccess.Read<int>(dataReader, "number_of_decimal_places");

                    objEntity.time_Approval_Comment_Required_On_Rejection = DataAccess.Read<int>(dataReader, "ApprovalCommentRequiredOnRejection_time");
                    objEntity.expense_Approval_Comment_Required_On_Rejection = DataAccess.Read<int>(dataReader, "ApprovalCommentRequiredOnRejection_expense");
              
                    objEntity.Time_Transaction_Editing_Allowed = DataAccess.Read<int>(dataReader, "Time_Transaction_Editing_Allowed");
                    objEntity.TimeSheet_DefaultView = DataAccess.Read<int>(dataReader, "TimeSheet_DefaultView");

                    objEntity.Finance_Approval_Required = DataAccess.Read<int>(dataReader, "FinanceApprovalRequired");
                    objEntity.Show_Reimburse_Check = DataAccess.Read<int>(dataReader, "ShowReimburseCheck");
                    objEntity.Create_Voucher_On_Finance_Approval = DataAccess.Read<int>(dataReader, "CreateVoucherOnFinanceApproval");


                    objEntity.level2FilterLocationApprovals = DataAccess.Read<int>(dataReader, "filter_approvals_level2_locationcode");
                    objEntity.level3FilterLocationApprovals = DataAccess.Read<int>(dataReader, "filter_approvals_level3_locationcode");
                    objEntity.level2FilterOrgUnitApprovals = DataAccess.Read<int>(dataReader, "filter_approvals_level2_orgunit");
                    objEntity.level3FilterOrgUnitApprovals = DataAccess.Read<int>(dataReader, "filter_approvals_level3_orgunit");

                    objEntity.show_cc_mark_as = DataAccess.Read<byte>(dataReader, "show_cc_mark_as");
                    objEntity.attachment_is_required = DataAccess.Read<byte>(dataReader, "attachment_is_required");
                    objEntity.attachment_level = DataAccess.Read<byte>(dataReader, "attachment_level");
                }
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {

            List<T> retList = null;
            RulesCriteria<Rules> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                objCriteria = criteria as RulesCriteria<Rules>;

                isDummy = objCriteria.UseDummyData;

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = objCriteria.ResourceID;
                parameters.Add(param);
            }

            try
            {
                //retList = DbContext.GetEntitiesList(this, "pdsw_apps_rules_get", parameters, enumDatabaes.ESM);

                //List<T> dbRetList = DbContext.GetEntitiesList(this, "pdsw_apps_rules_get", parameters, enumDatabaes.ESM);
                //Change
                List<T> dbRetList = DbContext.GetEntitiesList(this, "pdsw_apps_rules_get", parameters, enumDatabaes.ESM);
                List<T> newRetList = new List<T>();

                foreach (T dbItem in dbRetList)
                {
                    //IsNullOrEmpty is not used as "" can come from db
                    if (dbItem.IsChild == 0)
                    {
                        newRetList.Add(dbItem);
                    }
                }

                if (newRetList != null && newRetList.Count > 0)
                {
                    RulesChildCriteria<RulesChild> childCrit = new RulesChildCriteria<RulesChild>()
                    {
                        ResourceID = objCriteria.ResourceID
                    };

                    RulesChildDAO<RulesChild> childDAO = new RulesChildDAO<RulesChild>(this.Context);

                    //retList[0].childs = 
                    List<RulesChild> fromDB = childDAO.Select(childCrit);
                    List<RulesChild> newList = new List<RulesChild>();

                    foreach (RulesChild childRule in fromDB)
                    {
                        if (!string.IsNullOrEmpty(childRule.path))
                        {
                            newList.Add(childRule);
                        }
                    }

                    newRetList[0].childs = newList;
                }

                retList = newRetList;
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Rule(s): {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Rule(s): {0} .", ex.Message.Trim()), ex);
            }

            return retList;


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
    }
}
