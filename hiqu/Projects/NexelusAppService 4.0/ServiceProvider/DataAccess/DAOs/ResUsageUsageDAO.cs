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
    public class ResUsageDAO<T> : DAOBase<T> where T : ResUsage, new()
    {
        public ResUsageDAO(NexContext ctx) 
            : base(ctx)
        {
             
        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.ResUsageCode = dataReader["res_usage_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["res_usage_code"]);
                objEntity.ResUsageDescription = dataReader["res_usage_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["res_usage_description"]);
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
                ResUsageCriteria<ResUsage> resUsageCrit = criteria as ResUsageCriteria<ResUsage>;

                if (resUsageCrit.LastSyncDate != default(DateTime))
                {
                    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    param.Value = resUsageCrit.LastSyncDate;
                    parameters.Add(param);
                }

            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "Pdsw_Apps_Workfunction_Get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the <<Resource_Usage>>(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the <<Resource_Usage>>(s): {0}.", ex.Message.Trim()), ex);
            }

            return retList;
        }

        public override bool Save(T entity)
        {
            throw new NotImplementedException();
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }
    }
}
