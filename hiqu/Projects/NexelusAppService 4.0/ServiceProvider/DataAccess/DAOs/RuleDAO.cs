using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Criteria;
using System.Data;
using System.Data.SqlClient;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class RuleDAO<T> : DAOBase<T> where T : Model.Entities.Rule, new()
    {
        public RuleDAO(NexContext ctx) 
            : base(ctx)
        {

        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            throw new NotImplementedException();
        }

        public override bool Save(T entity)
        {
            var response = false;
            SqlParameter[] param = new SqlParameter[] {
                new SqlParameter("@company_code", Context.ComapnyCode),
                new SqlParameter("@default_code", entity.DefaultCode),
                new SqlParameter("@resource_id", entity.ResourceId)
            };
            List<SqlParameter> parameters = param.ToList();

            response = DbContext.Update("pdsw_apps_rule_set", parameters, enumDatabaes.ESM, true);

            return response;
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }
    }
}
