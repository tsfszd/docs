using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Criteria;
using System.Data.SqlClient;
using System.Data;
using NexelusApp.Service.Exceptions;

namespace NexelusApp.Service.DataAccess.DAOs
{
    class RulesChildDAO<T> : DAOBase<T> where T : RulesChild, new()
    {

        public RulesChildDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (DataAccess.Read<int>(dataReader, "child") == 1 && DataAccess.Read<int>(dataReader, "child") != default(int))
            {   
                objEntity.id = DataAccess.Read<int>(dataReader, "id");
                objEntity.path = DataAccess.Read<string>(dataReader, "path");
                objEntity.code = DataAccess.Read<string>(dataReader, "code").Trim();
                objEntity.value = DataAccess.Read<string>(dataReader, "value").Trim();
            }
        }

        public override List<T> Select(Model.Criteria.CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            RulesChildCriteria<RulesChild> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                objCriteria = criteria as RulesChildCriteria<RulesChild>;

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = objCriteria.ResourceID;
                parameters.Add(param);
            }

            try
            {
                //retList = DbContext.GetEntitiesList(this, "pdsw_apps_rules_get", parameters, enumDatabaes.ESM);
                //Change here
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_rules_get", parameters, enumDatabaes.ESM);
                
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Rule(s): {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Rule(s): {0} .", ex.Message.Trim()), ex);
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
