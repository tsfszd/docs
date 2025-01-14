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
    public class NotificationDAO<T> : DAOBase<T> where T : Notification, new()
    {
        public NotificationDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public NotificationDAO()
            : base(null)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.company_code = dataReader["company_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["company_code"]);
                objEntity.notification_id = dataReader["email_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["email_id"]);
                objEntity.resource_id = dataReader["resource_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["resource_id"]);
                objEntity.subscriber_id = dataReader["subscriber_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["subscriber_id"]);
                objEntity.notification_body = dataReader["notification_body"] == DBNull.Value ? "" : Converter.ToString(dataReader["notification_body"]);
                objEntity.notification_type = dataReader["notification_type"] == DBNull.Value ? "" : Converter.ToString(dataReader["notification_type"]);
                objEntity.delete_flag = dataReader["delete_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["delete_flag"]);
                //objEntity.delete_date = dataReader["delete_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["delete_date"]);
                objEntity.read_flag = dataReader["read_flag"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["read_flag"]);
                //objEntity.read_date = dataReader["read_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["read_date"]);
                //objEntity.create_id = dataReader["create_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["create_id"]);
                //objEntity.create_date = dataReader["create_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["create_date"]);
                //objEntity.modify_id = dataReader["modify_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["modify_id"]);
                //objEntity.modify_date = dataReader["modify_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["modify_date"]);
                objEntity.record_id = dataReader["record_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["record_id"]);
                objEntity.transaction_id = dataReader["transaction_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["transaction_id"]);
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
            param.Value = "88"; // Context.SubscriberID;
            parameters.Add(param);

            if (criteria != null)
            {
                NotificationCriteria<Notification> notificationCriteria = criteria as NotificationCriteria<Notification>;

                if (!string.IsNullOrEmpty(notificationCriteria.Mode))
                {
                    param = new SqlParameter("@mode", SqlDbType.VarChar);
                    param.Value = notificationCriteria.Mode;
                    parameters.Add(param);
                }
                else
                {
                    param = new SqlParameter("@mode", SqlDbType.VarChar);
                    param.Value = "ShowList";
                    parameters.Add(param);
                }

                if (!string.IsNullOrEmpty(notificationCriteria.ResourceID))
                {
                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = notificationCriteria.ResourceID;
                    parameters.Add(param);
                }
                else
                {
                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = "";
                    parameters.Add(param);
                }

                if (!string.IsNullOrEmpty(notificationCriteria.NotificationID))
                {
                    param = new SqlParameter("@notification_id", SqlDbType.VarChar);
                    param.Value = notificationCriteria.NotificationID;
                    parameters.Add(param);
                }
                else
                {
                    param = new SqlParameter("@notification_id", SqlDbType.VarChar);
                    param.Value = "";
                    parameters.Add(param);
                }
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_resources_notification_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching <<Notifications>>(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching <<Notifications>>(s): {0}.", ex.Message.Trim()), ex);
            }

            return retList;
        }

        public List<T> GetNotificationsList(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
            param.Value = Context.SubscriberID;
            parameters.Add(param);

            if (criteria != null)
            {
                NotificationCriteria<Notification> notificationCriteria = criteria as NotificationCriteria<Notification>;

                if (!string.IsNullOrEmpty(notificationCriteria.Mode))
                {
                    param = new SqlParameter("@mode", SqlDbType.VarChar);
                    param.Value = notificationCriteria.Mode;
                    parameters.Add(param);
                }else
                {
                    param = new SqlParameter("@mode", SqlDbType.VarChar);
                    param.Value = "ShowList";
                    parameters.Add(param);
                }

                if (!string.IsNullOrEmpty(notificationCriteria.ResourceID))
                {
                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = notificationCriteria.ResourceID;
                    parameters.Add(param);
                }else
                {
                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = "";
                    parameters.Add(param);
                }

                if (notificationCriteria.Keys != null && notificationCriteria.Keys.Count > 0)
                {
                    param = new SqlParameter("@notification_id", SqlDbType.Xml);
                    param.Value = GetXMLFromKeys(notificationCriteria.Keys);
                    parameters.Add(param);
                }
                else
                {
                    param = new SqlParameter("@notification_id", SqlDbType.VarChar);
                    param.Value = "";
                    parameters.Add(param);
                }
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_resources_notification_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching <<Notifications>>(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching <<Notifications>>(s): {0}.", ex.Message.Trim()), ex);
            }

            return retList;

        }

        public List<T> UpdatePushNotification(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
            param.Value = Context.SubscriberID;
            parameters.Add(param);

            if (criteria != null)
            {
                NotificationCriteria<Notification> notificationCriteria = criteria as NotificationCriteria<Notification>;

                if (!string.IsNullOrEmpty(notificationCriteria.Mode))
                {
                    param = new SqlParameter("@mode", SqlDbType.VarChar);
                    param.Value = notificationCriteria.Mode;
                    parameters.Add(param);
                }
                else
                {
                    param = new SqlParameter("@mode", SqlDbType.VarChar);
                    param.Value = "ShowList";
                    parameters.Add(param);
                }

                if (!string.IsNullOrEmpty(notificationCriteria.ResourceID))
                {
                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = notificationCriteria.ResourceID;
                    parameters.Add(param);
                }
                else
                {
                    param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                    param.Value = "";
                    parameters.Add(param);
                }

                if (notificationCriteria.Keys != null && notificationCriteria.Keys.Count > 0)
                {
                    param = new SqlParameter("@notification_id", SqlDbType.Xml);
                    param.Value = GetXMLFromKeys(notificationCriteria.Keys);
                    parameters.Add(param);
                }
                else
                {                    
                    param = new SqlParameter("@notification_id", SqlDbType.VarChar);
                    param.Value = "";
                    parameters.Add(param);                   
                }
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_resources_notification_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching <<Notifications>>(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching <<Notifications>>(s): {0}.", ex.Message.Trim()), ex);
            }

            return retList;

        }

        private string GetXMLFromKeys(List<string> keys)
        {
            StringBuilder xml = new StringBuilder();
            xml.Append("<keys>");

            foreach (string key in keys)
            {
                //string[] splittedKeys = key.Split(new string[] { "," }, StringSplitOptions.None);
                //if (splittedKeys.Length == 2)
                //{
                    xml.Append("<key>");
                    
                    xml.Append("<notification_id>");
                    xml.Append(key.Replace("&", "&amp;"));
                    xml.Append("</notification_id>");

                    xml.Append("</key>");
                //}
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


        //////PUSH NOTIFICATIONS///////
        public void CheckgForNotificationsInDatabase()
        {

        }
    }
}
