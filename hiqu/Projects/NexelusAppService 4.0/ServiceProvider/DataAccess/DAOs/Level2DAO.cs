using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Exceptions;
using com.paradigm.esm.general;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class Level2DAO<T> : DAOBase<T> where T : Level2, new()
    {
        private int isDummy = 0;
        public Level2DAO(NexContext ctx) 
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
                objEntity.Level2Status = dataReader["level2_status"] == DBNull.Value ? 1 : Converter.ToInteger(dataReader["level2_status"]);
                DateTime tempDate = dataReader["level2_opendate"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["level2_opendate"]);

                objEntity.StrOpenDate = tempDate == default(DateTime) ? "" : tempDate.ToString("yyyy-MM-dd HH:mm:ss");

                tempDate = dataReader["level2_closedate"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["level2_closedate"]);
                objEntity.StrCloseDate = tempDate == default(DateTime) ? "" : tempDate.ToString("yyyy-MM-dd HH:mm:ss");

                objEntity.comments_required_for_expense = dataReader["comments_for_expense_required_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["comments_for_expense_required_flag"]);
                objEntity.comments_required_for_timesheet = dataReader["comments_for_time_required_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["comments_for_time_required_flag"]);
                objEntity.org_unit = dataReader["l2_org_unit"] == DBNull.Value ? "" : Converter.ToString(dataReader["l2_org_unit"]);
                objEntity.parent_org_unit = dataReader["l2_parent_org_unit"] == DBNull.Value ? "" : Converter.ToString(dataReader["l2_parent_org_unit"]);
                objEntity.location_code = dataReader["l2_location_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["l2_location_code"]);
                objEntity.BillableFlag = dataReader["billable_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["billable_flag"]);
                objEntity.self_approver = dataReader["self_approver"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["self_approver"]);
                if (isDummy == 1)
                {
                    objEntity.Level2RateType = "AVERAGE";
                }
                else
                {
                    objEntity.Level2RateType = dataReader["l2_rate_type"] == DBNull.Value ? "" : Converter.ToString(dataReader["l2_rate_type"]);
                }

                objEntity.manager_id = dataReader["manager_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["manager_id"]);
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
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                param = new SqlParameter("@include_level3", SqlDbType.TinyInt);
                param.Value = 0;
                parameters.Add(param);

                param = new SqlParameter("@count", SqlDbType.Int);
                param.Value = Configuration.Config.Instance.DBRecordsCount;
                parameters.Add(param);

                if (criteria != null)
                {
                    Level2Criteria<Level2> l2Criteria = criteria as Level2Criteria<Level2>;

                    isDummy = l2Criteria.UseDummyData;

                    if (l2Criteria.isFirstTime)
                    {
                        param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
                        param.Value = Context.SubscriberID;
                        parameters.Add(param);
                    }

                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = l2Criteria.ResourceID;
                    parameters.Add(param);

                    if (!string.IsNullOrEmpty(l2Criteria.CustomerCode))
                    {
                        param = new SqlParameter("@customer_code", SqlDbType.VarChar);
                        param.Value = l2Criteria.CustomerCode;
                        parameters.Add(param);
                    }

                    if (!string.IsNullOrEmpty(l2Criteria.SearchString))
                    {
                        param = new SqlParameter("@level2_key", SqlDbType.VarChar);
                        param.Value = l2Criteria.SearchString;
                        parameters.Add(param);
                    }

                    if (l2Criteria.Mode != default(int))
                    {
                        param = new SqlParameter("@mode", SqlDbType.TinyInt);
                        param.Value = l2Criteria.Mode;
                        parameters.Add(param);
                    }

                    //if (l2Criteria.LastSyncDate != default(DateTime))
                    //{
                    //    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    //    param.Value = l2Criteria.LastSyncDate;
                    //    parameters.Add(param);
                    //}

                    if (l2Criteria.Keys != null && l2Criteria.Keys.Count > 0)
                    {
                        param = new SqlParameter("@keys", SqlDbType.Xml);
                        param.Value = GetXMLFromKeys(l2Criteria.Keys);
                        parameters.Add(param);
                    }

                    //param = new SqlParameter("@source", SqlDbType.TinyInt);
                    //param.Value = l2Criteria.source;
                    //parameters.Add(param);

                    //if (l2Criteria.Keys != null && l2Criteria.Keys.Count > 0)
                    //{
                    //    param = new SqlParameter("@keys", SqlDbType.VarChar);
                    //    param.Value = GetXMLFromKeys(l2Criteria.Keys);
                    //    parameters.Add(param);
                    //}
                }

                try
                {
                    retList = DbContext.GetEntitiesList(this, "pdsw_apps_level2_get", parameters, enumDatabaes.ESM);
                }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the <<TIME_BASED_Level2_descr>>(s): {0}.", ex.Message.Trim()), ex);
                    }
                }
                catch (Exception ex)
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the <<TIME_BASED_Level2_descr>>(s): {0}.", ex.Message.Trim()), ex);
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
                if (splittedKeys.Length  == 2)
                {
                    xml.Append("<key>");

                    xml.Append("<company_code>");
                    xml.Append(splittedKeys[0]);
                    xml.Append("</company_code>");

                    xml.Append("<level2_key>");
                    xml.Append(splittedKeys[1].Replace("&", "&amp;"));
                    xml.Append("</level2_key>");

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

            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@include_level3", SqlDbType.TinyInt);
            param.Value = 0;
            parameters.Add(param);

            param = new SqlParameter("@count", SqlDbType.Int);
            param.Value = Configuration.Config.Instance.DBRecordsCount;
            parameters.Add(param);

            if (criteria != null)
            {
                Level2Criteria<Level2> l2Criteria = criteria as Level2Criteria<Level2>;

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = l2Criteria.ResourceID;
                parameters.Add(param);

                if (!string.IsNullOrEmpty(l2Criteria.CustomerCode))
                {
                    param = new SqlParameter("@customer_code", SqlDbType.VarChar);
                    param.Value = l2Criteria.CustomerCode;
                    parameters.Add(param);
                }

                //if (!string.IsNullOrEmpty(splittedKeys[1]))
                //{
                //    param = new SqlParameter("@level2_key", SqlDbType.VarChar);
                //    param.Value = splittedKeys[1];
                //    parameters.Add(param);
                //}

                if (l2Criteria.Mode != default(int))
                {
                    param = new SqlParameter("@mode", SqlDbType.TinyInt);
                    param.Value = l2Criteria.Mode;
                    parameters.Add(param);
                }

                //if (l2Criteria.LastSyncDate != default(DateTime))
                //{
                //    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                //    param.Value = l2Criteria.LastSyncDate;
                //    parameters.Add(param);
                //}

                //param = new SqlParameter("@source", SqlDbType.TinyInt);
                //param.Value = l2Criteria.source;
                //parameters.Add(param);

                param = new SqlParameter("@keys", SqlDbType.TinyInt);
                param.Value = GetXMLFromKeys(l2Criteria.Keys);
                parameters.Add(param);
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_level2_get", parameters, enumDatabaes.ESM);

                //T tempEntity = DbContext.GetEntity(this, "pdsw_apps_level2_get", parameters, enumDatabaes.ESM);

                //if (tempEntity != null)
                //{
                //    retList.Add(tempEntity);
                //}

                //retList.Add(DbContext.GetEntity(this, "pdsw_apps_level2_get", parameters, enumDatabaes.ESM));
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the <<TIME_BASED_Level2_descr>>(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the <<TIME_BASED_Level2_descr>>(s): {0}.", ex.Message.Trim()), ex);
            }

            return retList;
        }
    }
}
