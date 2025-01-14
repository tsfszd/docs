using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Criteria;
using System.Data;
using NexelusApp.Service.Model;
using com.paradigm.esm.general;
using System.Data.SqlClient;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class LoginInfoDAO<T> : DAOBase<T> where T : LoginInfo, new()
    {
        public LoginInfoDAO(NexContext ctx) : base(ctx)
        {
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            if (objEntity != null)
            {
                TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);

                objEntity.LoginId = dataReader["loginid"] == DBNull.Value ? "" : Converter.ToString(dataReader["loginid"]);
                objEntity.ResPassword = dataReader["res_password"] == DBNull.Value ? "" : TwofishAlgorithm.eDecrypt(Converter.ToString(dataReader["res_password"]));
                //objEntity.ResourceId = dataReader["resource_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["resource_id"]);
            }
        }

        public override bool Save(T entity)
        {
            throw new NotImplementedException();
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();
            var Criteria = criteria as LoginInfoCriteria<T>;

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@source_field_value", SqlDbType.VarChar);
            param.Value = Criteria.SourceField;
            parameters.Add(param);

            param = new SqlParameter("@mapped_field", SqlDbType.VarChar);
            param.Value = Criteria.MappedField;
            parameters.Add(param);

            retList = DbContext.GetEntitiesList(this, "pdsw_login_credentials_get", parameters, enumDatabaes.TE);

            return retList;
        }
    }
}
