using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using com.paradigm.esm.general;
using NexelusApp.Service.Exceptions;
using com.paradigm.esm.model;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class ResourceDAO<T> : DAOBase<T> where T : Resource, new()
    {
        public ResourceDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public Resource LoginUsingDB(string pass)
        {
            return LoginUsingDB(pass, false);
        }

        public Resource LoginUsingDB(string pass, bool isFromAD)
        {
            Resource retRes = null;
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@login_id", SqlDbType.VarChar);
            param.Value = Context.LoginID;
            parameters.Add(param);

            if (!isFromAD)
            {
                param = new SqlParameter("@password", SqlDbType.VarChar);
                param.Value = pass;
                parameters.Add(param);
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_resource_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Authentication Failed: {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Authentication Failed: {0}.", ex.Message.Trim()), ex);
            }

            if (retList != null && retList.Count > 0)
            {
                retRes = retList[0];
            }

            return retRes;
        }

        public Resource LoginUsingAD(string serverName, string domainName, string pass)
        {
            bool directoryExists = false;
            Resource res = null;

            ActiveDirectoryIntegration ad = new ActiveDirectoryIntegration(domainName, serverName);

            if (!ad.IsAuthenticated(this.Context.LoginID, pass, out directoryExists))
            {
                if (directoryExists)
                {
                    throw new AppException(this.Context.LoginID, "Authentication failed: Please enter valid credentials.", Log.LogLevelType.ERROR);
                }
                else
                {
                    throw new AppException(this.Context.LoginID, "Active Directory does not exist.", Log.LogLevelType.ERROR);
                }

            }
            else
            {
                try
                {
                    res = LoginUsingDB(pass, true);
                }
                catch (AppException ex)
                {
                    throw ex;
                }
            }

            return res;
        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.ResourceID = dataReader["resource_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["resource_id"]);
                objEntity.NameFirst = dataReader["name_first"] == DBNull.Value ? "" : Converter.ToString(dataReader["name_first"]);
                objEntity.NameLast = dataReader["name_last"] == DBNull.Value ? "" : Converter.ToString(dataReader["name_last"]);
                objEntity.LocationCode = dataReader["location_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["location_code"]);
                objEntity.OrgUnitCode = dataReader["org_unit"] == DBNull.Value ? "" : Converter.ToString(dataReader["org_unit"]);
                //change by hamad
                objEntity.parent_org_unit_code = dataReader["parent_org_unit"] == DBNull.Value ? "" : Converter.ToString(dataReader["parent_org_unit"]);

                objEntity.ResUsageCode = dataReader["res_usage_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["res_usage_code"]);
                objEntity.ShowTask = dataReader["show_task"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["show_task"]);
                objEntity.ShowWorkFunction = dataReader["show_workfunction"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["show_workfunction"]);
                objEntity.is_expense_report_available = dataReader["Is_expenseReport_availible"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["Is_expenseReport_availible"]);
                objEntity.is_timeSheet_available = dataReader["Is_timeSheet_availible"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["Is_timeSheet_availible"]);
                objEntity.currency_code = dataReader["currency_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["currency_code"]);
                objEntity.location_name = dataReader["loc_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["loc_name"]);
                objEntity.org_unit_name = dataReader["org_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["org_name"]);
              
                objEntity.IsUsingAD = this.Context.IsUsingAD;
                Random rnd = new Random();
                objEntity.is_expense_approval_available = dataReader["Is_expense_approval_availible"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["Is_expense_approval_availible"]);
                objEntity.is_time_approval_available = dataReader["Is_timeSheet_approval_available"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["Is_timeSheet_approval_available"]);
                objEntity.is_self_approver = 1; //TSF-20190522 rnd.Next(0, 2);
                objEntity.is_pending_finance_approval_available = dataReader["Is_pending_finance_approval_available"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["Is_pending_finance_approval_available"]);
                objEntity.is_finance_approved_available = dataReader["Is_finance_approved_available"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["Is_finance_approved_available"]);
                objEntity.reports_to = dataReader["reports_to"] == DBNull.Value ? "" : Converter.ToString(dataReader["reports_to"]);
                objEntity.trx_type = dataReader["trx_type"] == DBNull.Value ? -1 : Converter.ToInteger(dataReader["trx_type"]);
                objEntity.parent_org_unit_name = dataReader["parent_org_unit_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["parent_org_unit_name"]);

            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@login_id", SqlDbType.VarChar);
            param.Value = Context.LoginID;
            parameters.Add(param);

            if (criteria != null)
            {
                ResourceCriteria<Resource> resCrit = criteria as ResourceCriteria<Resource>;

                if (resCrit.LastSyncDate != default(DateTime))
                {
                    param = new SqlParameter("@last_sync_date", SqlDbType.VarChar);
                    param.Value = resCrit.LastSyncDate;
                    parameters.Add(param);
                }

            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_resource_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error getting the Resource: {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error getting the Resource: {0}.", ex.Message.Trim()), ex);
            }

            return retList;
        }

        public bool UpdatePassword(T entity)
        {
            bool retVal = false;

            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@login_id", SqlDbType.VarChar);
            param.Value = Context.LoginID;
            parameters.Add(param);

            param = new SqlParameter("@old_password", SqlDbType.VarChar);
            param.Value = entity.OldPassword;
            parameters.Add(param);

            param = new SqlParameter("@new_password", SqlDbType.VarChar);
            param.Value = entity.NewPassword;
            parameters.Add(param);

            try
            {
                retVal = this.DbContext.Update("plsW_apps_password_update", parameters, enumDatabaes.TE, true);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error changing the password: {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error changing the password: {0} .", ex.Message.Trim()), ex);
            }

            return retVal;
        }

        public override bool Save(T entity)
        {
            throw new NotImplementedException();
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

        public int GetResourceSubscriberID(SubscriberInfo subInfo, string resource_id)
        {
            int subscriberId = 0;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@resource_id", SqlDbType.VarChar);
            param.Value = resource_id;
            parameters.Add(param);

            param = new SqlParameter("@os_version", SqlDbType.VarChar);
            param.Value = subInfo.OSVersion;
            parameters.Add(param);

            param = new SqlParameter("@model", SqlDbType.VarChar);
            param.Value = subInfo.Model;
            parameters.Add(param);

            param = new SqlParameter("@make", SqlDbType.VarChar);
            param.Value = subInfo.Make;
            parameters.Add(param);

            param = new SqlParameter("@product_number", SqlDbType.VarChar);
            param.Value = subInfo.ProductNumber;
            parameters.Add(param);

            param = new SqlParameter("@locale", SqlDbType.VarChar);
            param.Value = subInfo.Locale;
            parameters.Add(param);

            param = new SqlParameter("@timeZone", SqlDbType.VarChar);
            param.Value = subInfo.TimeZone;
            parameters.Add(param);

            if (!string.IsNullOrEmpty(subInfo.AppVersion))
            {
                param = new SqlParameter("@app_version", SqlDbType.VarChar);
                param.Value = subInfo.AppVersion;
                parameters.Add(param);
            }

            try
            {
                List<T> list = null;
                SqlConnection connection = null;
                SqlCommand cmd = null;
                IDataReader dataReader = null;

                try
                {
                    connection = Context.DBConnection.GetActiveConnection(enumDatabaes.ESM);
                    cmd = new SqlCommand();

                    cmd.Connection = connection;
                    cmd.CommandText = "pdsw_apps_subscriber_get";
                    cmd.CommandType = CommandType.StoredProcedure;

                    foreach (SqlParameter parm in parameters)
                    {
                        cmd.Parameters.Add(parm);
                    }


                    dataReader = cmd.ExecuteReader();
                    list = new List<T>();

                    while (dataReader.Read())
                    {
                        int error_code = Converter.ToInteger(dataReader["ERROR_CODE"]);
                        if (error_code < 0)
                            throw new AppException(resource_id, Converter.ToString(dataReader["ERROR_DESCRIPTION"]), Log.LogLevelType.SQLERROR);
                        else
                            subscriberId = dataReader["subscriber_id"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["subscriber_id"]);
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
                    throw new AppException(Context.LoginID, ex.Message, Log.LogLevelType.SQLERROR);
                }
                catch (Exception ex)
                {
                    throw new AppException(Context.LoginID, ex.Message, Log.LogLevelType.ERROR);
                }
                finally
                {
                    if (dataReader != null && !dataReader.IsClosed)
                    {
                        dataReader.Close();
                    }

                    Context.DBConnection.Close();
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
                    throw new AppException(Context.LoginID, string.Format("Authentication Failed: {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Authentication Failed: {0}.", ex.Message.Trim()), ex);
            }

            return subscriberId;
        }
    }
}
