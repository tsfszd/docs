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
    public class ParserKeywordDAO<T> : DAOBase<T> where T : ParserKeyword, new()
    {
        public ParserKeywordDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.keyword = dataReader["keyword"] == DBNull.Value ? "" : Converter.ToString(dataReader["keyword"]);
                objEntity.token = dataReader["token"] == DBNull.Value ? "" : Converter.ToString(dataReader["token"]);
                objEntity.priority = dataReader["priority"] == DBNull.Value ? 0 : Converter.ToInteger(dataReader["priority"]);
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            ParserKeywordCriteria<ParserKeyword> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            if (criteria != null)
            {
                objCriteria = criteria as ParserKeywordCriteria<ParserKeyword>;

                if (objCriteria.LastSyncDate != default(DateTime))
                {
                    SqlParameter param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    param.Value = objCriteria.LastSyncDate;
                    parameters.Add(param);
                }              

            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_parser_keyword_get", parameters, enumDatabaes.ESM);                

            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Parser Keyword(s): {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Parser Keyword(s): {0} .", ex.Message.Trim()), ex);
            }

            return retList;
        }

        public override bool Save(T entity)
        {
            bool retVal = false;

            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@keyword", entity.keyword);
            parameters.Add(param);

            param = new SqlParameter("@token", entity.token);
            parameters.Add(param);

            param = new SqlParameter("@priority", entity.priority);
            parameters.Add(param);            

            try
            {
                retVal = DbContext.Update("pdsw_apps_parser_keyword_set", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error saving the Parser Keyword: {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error saving the Parser Keyword: {0} .", ex.Message.Trim()), ex);
            }

            return retVal;
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }
    }
}
