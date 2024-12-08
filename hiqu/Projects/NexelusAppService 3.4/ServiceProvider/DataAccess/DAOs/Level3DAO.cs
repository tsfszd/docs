using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using com.paradigm.esm.general;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Exceptions;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class Level3DAO<T> : DAOBase<T> where T : Level3, new()
    {
        public Level3DAO(NexContext ctx) 
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.Level2Key = dataReader["level2_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level2_key"]);
                objEntity.Level2Description = dataReader["level2_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["level2_description"]);
                objEntity.Level3Key = dataReader["level3_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level3_key"]);
                objEntity.Level3Description = dataReader["level3_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["level3_description"]);
                objEntity.TaskTypeCode = dataReader["task_type"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["task_type"]);
                objEntity.BillableFlag = dataReader["billable_flag"] == DBNull.Value ? default(bool) : Converter.ToBool(dataReader["billable_flag"]);

                DateTime tempDate = dataReader["closed_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["closed_date"]);
                objEntity.StrClosedDate = tempDate == default(DateTime) ? "" : tempDate.ToString("yyyy-MM-dd HH:mm:ss");

                tempDate = dataReader["open_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["open_date"]);
                objEntity.StrOpenDate = tempDate == default(DateTime) ? "" : tempDate.ToString("yyyy-MM-dd HH:mm:ss");

                objEntity.LaborFlag = dataReader["labor_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["labor_flag"]);

                objEntity.org_unit = dataReader["org_unit"] == DBNull.Value ? "" : Converter.ToString(dataReader["org_unit"]);
                objEntity.parent_org_unit = dataReader["l3_parent_org_unit"] == DBNull.Value ? "" : Converter.ToString(dataReader["l3_parent_org_unit"]);
                objEntity.location_code = dataReader["location_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["location_code"]);
                objEntity.expense_flag = dataReader["expense_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["expense_flag"]);

                tempDate = dataReader["date_due"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["date_due"]);
                objEntity.str_date_due = tempDate == default(DateTime) ? "" : tempDate.ToString("yyyy-MM-dd HH:mm:ss");

                objEntity.cost_type = dataReader["cost_type"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["cost_type"]);
                objEntity.rate_table1 = dataReader["rate_table1"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["rate_table1"]);
                objEntity.rate_table2 = dataReader["rate_table2"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["rate_table2"]);
                objEntity.level3_status = dataReader["level3_status"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["level3_status"]);
                objEntity.self_approver = dataReader["self_approver"] == DBNull.Value ? false : Converter.ToBool(dataReader["self_approver"]);
                objEntity.finance_approval_flag = dataReader["finance_approval"] == DBNull.Value ? false : Converter.ToBool(dataReader["finance_approval"]);
                objEntity.header_approver_flag = dataReader["header_approver"] == DBNull.Value ? false : Converter.ToBool(dataReader["header_approver"]);

                objEntity.trx_approval_flag = dataReader["trx_approval_flag"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["trx_approval_flag"]);
                //objEntity.manager_id = dataReader["manager_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["manager_id"]);

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
                Level3Criteria<Level3> l3Criteria = null;
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                param = new SqlParameter("@include_level3", SqlDbType.TinyInt);
                param.Value = 1;
                parameters.Add(param);

                param = new SqlParameter("@count", SqlDbType.Int);
                param.Value = Configuration.Config.Instance.DBRecordsCount;
                parameters.Add(param);

                if (criteria != null)
                {
                    l3Criteria = criteria as Level3Criteria<Level3>;

                    if (l3Criteria.ActionFlag != 4)
                    {
                        if (l3Criteria.isFirstTime)
                        {
                            param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
                            param.Value = Context.SubscriberID;
                            parameters.Add(param);
                        }

                        param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                        param.Value = l3Criteria.ResourceID;
                        parameters.Add(param);

                        if (!string.IsNullOrEmpty(l3Criteria.CustomerCode))
                        {
                            param = new SqlParameter("@customer_code", SqlDbType.VarChar);
                            param.Value = l3Criteria.CustomerCode;
                            parameters.Add(param);
                        }

                        if (!string.IsNullOrEmpty(l3Criteria.SearchString))
                        {
                            param = new SqlParameter("@level3_key", SqlDbType.VarChar);
                            param.Value = l3Criteria.SearchString;
                            parameters.Add(param);
                        }

                        if (!string.IsNullOrEmpty(l3Criteria.Level2Key))
                        {
                            param = new SqlParameter("@level2_key", SqlDbType.VarChar);
                            param.Value = l3Criteria.Level2Key;
                            parameters.Add(param);
                        }

                        if (l3Criteria.Mode != default(int))
                        {
                            param = new SqlParameter("@mode", SqlDbType.TinyInt);
                            param.Value = l3Criteria.Mode;
                            parameters.Add(param);
                        }

                        //if (l3Criteria.LastSyncDate != default(DateTime))
                        //{
                        //    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                        //    param.Value = l3Criteria.LastSyncDate;
                        //    parameters.Add(param);
                        //}

                        if (l3Criteria.Keys != null && l3Criteria.Keys.Count > 0)
                        {
                            param = new SqlParameter("@keys", SqlDbType.Xml);
                            param.Value = GetXMLFromKeys(l3Criteria.Keys);
                            parameters.Add(param);
                        }

                        //param = new SqlParameter("@source", SqlDbType.TinyInt);
                        //param.Value = l3Criteria.source;
                        //parameters.Add(param);

                    }
                }

                try
                {
                    if (l3Criteria != null && l3Criteria.ActionFlag == 4)
                    {
                        retList = DbContext.GetEntitiesList(this, "pdsw_apps_level3_delete_get", parameters, enumDatabaes.ESM);
                    }
                    else
                    {
                        retList = DbContext.GetEntitiesList(this, "Pdsw_apps_level2_get", parameters, enumDatabaes.ESM);
                    }

              //  retList.Select(c => { c.self_approver = Convert.ToBoolean(c.self_approver); return c; }).ToList();
            }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {

                        if (l3Criteria != null && l3Criteria.ActionFlag == 4)
                        {
                            throw new AppException(Context.LoginID, string.Format("Error fetching the <<TIME_BASED_Level3_descr>>(s) for delete: {0} .", ex.Message.Trim()), ex);
                        }
                        else
                        {
                            throw new AppException(Context.LoginID, string.Format("Error fetching the <<TIME_BASED_Level3_descr>>(s): {0} .", ex.Message.Trim()), ex);
                        }
                    }
                }
                catch (Exception ex)
                {
                    if (l3Criteria != null && l3Criteria.ActionFlag == 4)
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the <<Level3_descr>>(s) for delete: {0} .", ex.Message.Trim()), ex);
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the <<Level3_descr>>(s): {0} .", ex.Message.Trim()), ex);
                    }
                }

                return retList;
            //}
        }

        private string GetXMLFromKeys(List<string> keys)
        {
            StringBuilder xml = new StringBuilder();
            xml.Append("<keys>");

            foreach (string key in keys)
            {
                string[] splittedKeys = key.Split(new string[] { "~-~" }, StringSplitOptions.None);

                if (splittedKeys.Length == 3)
                {
                    xml.Append("<key>");

                    xml.Append("<company_code>");
                    xml.Append(splittedKeys[0]);
                    xml.Append("</company_code>");

                    xml.Append("<level2_key>");
                    xml.Append(splittedKeys[1].Replace("&", "&amp;"));
                    xml.Append("</level2_key>");
                    
                    xml.Append("<level3_key>");
                    xml.Append(splittedKeys[2].Replace("&", "&amp;"));
                    xml.Append("</level3_key>");

                    xml.Append("</key>");
                }
                
            }

            xml.Append("</keys>");
            return xml.ToString();
        }

        public override bool Save(T entity)
        {
            throw new NotImplementedException();
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

        private List<T> SelectFromList(CriteriaBase<T> criteria)
        {
            List<T> retList = new List<T>();

            foreach (string key in criteria.Keys)
            {
                string[] splittedKeys = key.Split(new string[] { "~-~" }, StringSplitOptions.None);

                Level3Criteria<Level3> l3Criteria = null;
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                param = new SqlParameter("@include_level3", SqlDbType.TinyInt);
                param.Value = 1;
                parameters.Add(param);

                param = new SqlParameter("@count", SqlDbType.Int);
                param.Value = Configuration.Config.Instance.DBRecordsCount;
                parameters.Add(param);

                if (criteria != null)
                {
                    l3Criteria = criteria as Level3Criteria<Level3>;

                    if (l3Criteria.ActionFlag != 4)
                    {

                        param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                        param.Value = l3Criteria.ResourceID;
                        parameters.Add(param);

                        if (!string.IsNullOrEmpty(l3Criteria.CustomerCode))
                        {
                            param = new SqlParameter("@customer_code", SqlDbType.VarChar);
                            param.Value = l3Criteria.CustomerCode;
                            parameters.Add(param);
                        }

                        if (!string.IsNullOrEmpty(splittedKeys[2]))
                        {
                            param = new SqlParameter("@level3_key", SqlDbType.VarChar);
                            param.Value = splittedKeys[2];
                            parameters.Add(param);
                        }

                        if (!string.IsNullOrEmpty(splittedKeys[1]))
                        {
                            param = new SqlParameter("@level2_key", SqlDbType.VarChar);
                            param.Value = splittedKeys[1];
                            parameters.Add(param);
                        }

                        if (l3Criteria.Mode != default(int))
                        {
                            param = new SqlParameter("@mode", SqlDbType.TinyInt);
                            param.Value = l3Criteria.Mode;
                            parameters.Add(param);
                        }

                        if (l3Criteria.LastSyncDate != default(DateTime))
                        {
                            param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                            param.Value = l3Criteria.LastSyncDate;
                            parameters.Add(param);
                        }

                        param = new SqlParameter("@source", SqlDbType.TinyInt);
                        param.Value = l3Criteria.source;
                        parameters.Add(param);

                    }
                }

                try
                {
                    //retList = DbContext.GetEntitiesList(this, "Pdsw_apps_level2_get", parameters, enumDatabaes.ESM);
                    T tempEntity = DbContext.GetEntity(this, "Pdsw_apps_level2_get", parameters, enumDatabaes.ESM);

                    if (tempEntity != null)
                    {
                        retList.Add(tempEntity);
                    }

                    //retList.Add(DbContext.GetEntity(this, "Pdsw_apps_level2_get", parameters, enumDatabaes.ESM));
                }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {

                        if (l3Criteria != null && l3Criteria.ActionFlag == 4)
                        {
                            throw new AppException(Context.LoginID, string.Format("Error fetching the <<TIME_BASED_Level3_descr>>(s) for delete: {0} .", ex.Message.Trim()), ex);
                        }
                        else
                        {
                            throw new AppException(Context.LoginID, string.Format("Error fetching the <<TIME_BASED_Level3_descr>>(s): {0} .", ex.Message.Trim()), ex);
                        }
                    }
                }
                catch (Exception ex)
                {
                    if (l3Criteria != null && l3Criteria.ActionFlag == 4)
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the <<Level3_descr>>(s) for delete: {0} .", ex.Message.Trim()), ex);
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the <<Level3_descr>>(s): {0} .", ex.Message.Trim()), ex);
                    }
                }
            }

            return retList;
        }
        
    }
}
