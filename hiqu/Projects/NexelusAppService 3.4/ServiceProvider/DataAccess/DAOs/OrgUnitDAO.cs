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

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class OrgUnitDAO<T> : DAOBase<T> where T : OrgUnit, new()
    {
        public OrgUnitDAO(NexContext ctx) 
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.OrgUnitCode = dataReader.GetString(dataReader.GetOrdinal("org_unit"));
                objEntity.OrgUnitName = dataReader.GetString(dataReader.GetOrdinal("org_name"));
                objEntity.OrgUnitDescription = dataReader.GetString(dataReader.GetOrdinal("org_description"));
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter companyCode = new SqlParameter("@company_code", SqlDbType.Int);
            companyCode.Value = Context.ComapnyCode;
            parameters.Add(companyCode);

            //return Select(this, "", parameters, enumDatabaes.ESM);

            try
            {
                retList = DbContext.GetEntitiesList(this, "", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("OrgUnitDAO:Select(): error calling sp '' {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("OrgUnitDAO:Select(): error calling sp '' {0}.", ex.Message.Trim()), ex);
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
