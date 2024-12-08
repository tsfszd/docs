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
    public class CompanyAuthenticationDAO<T> : DAOBase<T> where T : CompanyAuthentication, new()
    {
        public CompanyAuthenticationDAO(NexContext ctx) : base(ctx)
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

                objEntity.AuthKey = dataReader["auth_key"] == DBNull.Value ? "" : TwofishAlgorithm.eDecrypt(Converter.ToString(dataReader["auth_key"]));
                objEntity.AuthMode = dataReader["authentication_mode"] == DBNull.Value ? "" : Converter.ToString(dataReader["authentication_mode"]);
                objEntity.SourceField = dataReader["source_field"] == DBNull.Value ? "" : Converter.ToString(dataReader["source_field"]);
                objEntity.MappedField = dataReader["mapped_field"] == DBNull.Value ? "" : Converter.ToString(dataReader["mapped_field"]);

                objEntity.ApiToken = dataReader["api_token"] == DBNull.Value ? "" : Converter.ToString(dataReader["api_token"]);
                objEntity.ClientCode = dataReader["client_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["client_code"]);
                objEntity.ClientSecret = dataReader["client_secret"] == DBNull.Value ? "" : Converter.ToString(dataReader["client_secret"]);
                objEntity.BaseUrl = dataReader["base_url"] == DBNull.Value ? "" : Converter.ToString(dataReader["base_url"]);
                objEntity.OktaRedirectUrl = dataReader["okta_redirect_url"] == DBNull.Value ? "" : Converter.ToString(dataReader["okta_redirect_url"]);
                objEntity.authServerId = dataReader["auth_server_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["auth_server_id"]);
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
            var Criteria = criteria as CompanyAuthenticationCriteria<T>;
            TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
             
            SqlParameter param = new SqlParameter("@auth_key", SqlDbType.VarChar);
            param.Value = TwofishAlgorithm.eEncrypt(Criteria.AuthenticationKey);
            parameters.Add(param);

            retList = DbContext.GetEntitiesList(this, "pdsw_validate_authentication_key", parameters, enumDatabaes.App);

            return retList;
        }
    }
}
