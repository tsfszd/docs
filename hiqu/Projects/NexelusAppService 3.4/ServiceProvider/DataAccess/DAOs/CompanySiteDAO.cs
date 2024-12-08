using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using com.paradigm.esm.general;

using NexelusApp.Service.Model;
using Entities = NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Exceptions;

namespace NexelusApp.Service.DataAccess.DAOs
{
    class CompanySiteDAO<T> : DAOBase<T> where T : Entities.CompanySite, new()
    {

        public CompanySiteDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public T AuthenticateUser(Entities.Authentication auth) 
        {
            T retSite = new T();
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@auth_key", SqlDbType.VarChar);
            param.Value = auth.AuthenticationKey;
            parameters.Add(param);

            try
            {
                List<T> siteList = DbContext.GetEntitiesList(this, "pdsW_app_authenticate", parameters, enumDatabaes.App);
                retSite = siteList[0];
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    if (ex.Message.Contains("The authentication key is not valid"))
                    {
                        throw new AppException(Context.LoginID, string.Format("Authentication Failed: {0}.", ex.Message.Trim()), ex);
                    }
                    else
                    {
                        throw new AppException(Context.LoginID, string.Format("Error while authenticating: {0}.", ex.Message.Trim()), ex);
                    }
                }
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("The authentication key is not valid"))
                {
                    throw new AppException(Context.LoginID, string.Format("Authentication Failed: {0}.", ex.Message.Trim()), ex);
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error while authenticating: {0}.", ex.Message.Trim()), ex);
                }
            }

            return retSite;
        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = dataReader.GetInt32(dataReader.GetOrdinal("company_code"));
                objEntity.CompanyName = dataReader.GetString(dataReader.GetOrdinal("company_name"));

                objEntity.DatabaseServerESM = dataReader.GetString(dataReader.GetOrdinal("database_server_esm"));
                objEntity.DatabaseNameESM = dataReader.GetString(dataReader.GetOrdinal("database_name_esm"));
                objEntity.UserIDESM = dataReader.GetString(dataReader.GetOrdinal("user_id_esm"));

                string pass = dataReader.GetString(dataReader.GetOrdinal("password_esm"));
                TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                objEntity.PasswordESM = TwofishAlgorithm.eDecrypt(pass);

                objEntity.ConnectionTimeoutESM = dataReader.GetInt32(dataReader.GetOrdinal("connection_timeout_esm"));
                objEntity.QueryTimeoutESM = dataReader.GetInt32(dataReader.GetOrdinal("query_timeout_esm"));

                objEntity.DatabaseServerESMTE = dataReader.GetString(dataReader.GetOrdinal("database_server_esmte"));
                objEntity.DatabaseNameESMTE = dataReader.GetString(dataReader.GetOrdinal("database_name_esmte"));
                objEntity.UserIDESMTE = dataReader.GetString(dataReader.GetOrdinal("user_id_esmte"));

                pass = dataReader.GetString(dataReader.GetOrdinal("password_esmte"));
                TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                objEntity.PasswordESMTE = TwofishAlgorithm.eDecrypt(pass);

                objEntity.ConnectionTimeoutESMTE = dataReader.GetInt32(dataReader.GetOrdinal("connection_timeout_esmte"));
                objEntity.QueryTimeoutESMTE = dataReader.GetInt32(dataReader.GetOrdinal("query_timeout_esmte"));

                objEntity.AuthenticationMode = dataReader["authentication_mode"] == DBNull.Value ? "" : dataReader.GetString(dataReader.GetOrdinal("authentication_mode"));
                objEntity.ADServerName = dataReader["ad_server_name"] == DBNull.Value ? "" : dataReader.GetString(dataReader.GetOrdinal("ad_server_name"));
                objEntity.ADDomainName = dataReader["ad_domain_name"] == DBNull.Value ? "" : dataReader.GetString(dataReader.GetOrdinal("ad_domain_name"));
                objEntity.ServicePath = dataReader["service_path"] == DBNull.Value ? "" : dataReader.GetString(dataReader.GetOrdinal("service_path"));
                objEntity.WebURL = dataReader["web_url"] == DBNull.Value ? "" : dataReader.GetString(dataReader.GetOrdinal("web_url"));
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
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
