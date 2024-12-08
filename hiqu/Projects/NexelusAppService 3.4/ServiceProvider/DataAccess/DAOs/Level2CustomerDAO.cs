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

namespace NexelusApp.Service.DataAccess.DAOs
{
    class Level2CustomerDAO<T> : DAOBase<T> where T : Level2Customer, new()
    {
        public Level2CustomerDAO(NexContext ctx) 
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.CusomterName = dataReader["customer_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["customer_name"]);
                objEntity.CustomerCode = dataReader["customer_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["customer_code"]);
                objEntity.Level2Key = dataReader["level2_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level2_key"]);
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
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                param = new SqlParameter("@login_id", SqlDbType.VarChar);
                param.Value = Context.LoginID;
                parameters.Add(param);

                if (criteria != null)
                {
                    Level2CustomerCriteria<Level2Customer> l2CustCrit = criteria as Level2CustomerCriteria<Level2Customer>;

                    //if (l2CustCrit.isFirstTime)
                    //{
                    //    param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
                    //    param.Value = Context.SubscriberID;
                    //    parameters.Add(param);
                    //}

                    if (!string.IsNullOrEmpty(l2CustCrit.CustomerCode))
                    {
                        param = new SqlParameter("@customer_code", SqlDbType.VarChar);
                        param.Value = l2CustCrit.CustomerCode;
                        parameters.Add(param);
                    }

                    //if (l2CustCrit.LastSyncDate != default(DateTime))
                    //{
                    //    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    //    param.Value = l2CustCrit.LastSyncDate;
                    //    parameters.Add(param);
                    //}

                    if (l2CustCrit.Keys != null && l2CustCrit.Keys.Count > 0)
                    {
                        param = new SqlParameter("@keys", SqlDbType.Xml);
                        param.Value = GetXMLFromKeys(l2CustCrit.Keys);
                        parameters.Add(param);
                    }
                }

                try
                {
                    retList = DbContext.GetEntitiesList(this, "pdsw_apps_customer_get", parameters, enumDatabaes.ESM);
                }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the <<cust_descr>>(s): {0}.", ex.Message.Trim()), ex);
                    }
                }
                catch (Exception ex)
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the <<cust_descr>>(s): {0}.", ex.Message.Trim()), ex);
                }
            //}

            return retList;
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
                    xml.Append(splittedKeys[0].Replace("&", "&amp;"));
                    xml.Append("</company_code>");

                    xml.Append("<level2_customer>");
                    xml.Append(splittedKeys[1].Replace("&", "&amp;"));
                    xml.Append("</level2_customer>");

                    xml.Append("<level2_key>");
                    xml.Append(splittedKeys[2]);
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

            foreach (string key in criteria.Keys)
            {
                string[] splittedKeys = key.Split(new string[] { "~-~" }, StringSplitOptions.None);

                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                param.Value = Context.ComapnyCode;
                parameters.Add(param);

                param = new SqlParameter("@login_id", SqlDbType.VarChar);
                param.Value = Context.LoginID;
                parameters.Add(param);

                if (criteria != null)
                {
                    Level2CustomerCriteria<Level2Customer> l2CustCrit = criteria as Level2CustomerCriteria<Level2Customer>;

                    if (!string.IsNullOrEmpty(splittedKeys[2]))
                    {
                        param = new SqlParameter("@customer_code", SqlDbType.VarChar);
                        param.Value = splittedKeys[2];
                        parameters.Add(param);
                    }

                    if (l2CustCrit.LastSyncDate != default(DateTime))
                    {
                        param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                        param.Value = l2CustCrit.LastSyncDate;
                        parameters.Add(param);
                    }
                }

                try
                {
                    retList = DbContext.GetEntitiesList(this, "pdsw_apps_customer_get", parameters, enumDatabaes.ESM);
                }
                catch (AppException ex)
                {
                    if (ex.LoggerLevel == Log.LogLevelType.INNER)
                    {
                        throw ex;
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error fetching the <<cust_descr>>(s): {0}.", ex.Message.Trim()), ex);
                    }
                }
                catch (Exception ex)
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the <<cust_descr>>(s): {0}.", ex.Message.Trim()), ex);
                }
            }

            return retList; 
        }
    }
}
