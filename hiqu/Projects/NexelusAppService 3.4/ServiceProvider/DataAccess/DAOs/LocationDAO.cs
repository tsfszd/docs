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
    public class LocationDAO<T> : DAOBase<T> where T : Location, new()
    {
        public LocationDAO(NexContext ctx) 
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.LocationCode = dataReader.GetString(dataReader.GetOrdinal("location_code"));
                objEntity.LocationName = dataReader.GetString(dataReader.GetOrdinal("location_name"));
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

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
                    throw new AppException(Context.LoginID, string.Format("LocationDAO:Select(): error calling sp '' {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("LocationDAO:Select(): error calling sp '' {0} .", ex.Message.Trim()), ex);
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
