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
    public class PushNotificationDAO<T> : DAOBase<T> where T : PushNotification, new()
    {
        public PushNotificationDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public PushNotificationDAO()
            : base(null)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            throw new NotImplementedException();
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

        public override bool Save(T entity)
        {
            bool retVal = false;

            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
            parameters.Add(param);

            param = new SqlParameter("@resource_id", entity.resource_id);
            parameters.Add(param);

            param = new SqlParameter("@product_number", entity.product_number);
            parameters.Add(param);

            param = new SqlParameter("@device_token", entity.device_token);
            parameters.Add(param);

            try
            {
                retVal = DbContext.Update("pdsw_apps_subscriber_defince_token_update", parameters, enumDatabaes.TE);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error saving the Device Token: {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error saving the Device Token: {0} .", ex.Message.Trim()), ex);
            }

            return retVal;
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
