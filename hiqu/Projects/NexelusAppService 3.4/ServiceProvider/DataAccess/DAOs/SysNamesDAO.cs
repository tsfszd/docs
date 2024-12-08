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
    class SysNamesDAO<T> : DAOBase<T> where T : SysNames, new()
    {
        public SysNamesDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.FieldName = dataReader["field_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["field_name"]);
                objEntity.DisplayName = dataReader["display_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["display_name"]);
            }
        }

        public override List<T> Select(Model.Criteria.CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                SysNamesCriteria<SysNames> SysNamesCrit = criteria as SysNamesCriteria<SysNames>;

                if (SysNamesCrit.LastSyncDate != default(DateTime))
                {
                    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    param.Value = SysNamesCrit.LastSyncDate;
                    parameters.Add(param);
                }

            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "plsw_apps_sysnames_get", parameters, enumDatabaes.TE);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Variable Name(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Variable Name(s): {0}.", ex.Message.Trim()), ex);
            }

            return retList;
        }

        public override bool Save(T entity)
        {
            throw new NotImplementedException();
        }

        public override bool Delete(Model.Criteria.CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }
    }
}
