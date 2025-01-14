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
    public class PermanentLineDAO<T> : DAOBase<T> where T : PermanentLine, new()
    {

        public PermanentLineDAO(NexContext ctx) 
            : base(ctx)
        {
             
        }


        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.Level2Key = dataReader["level2_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level2_key"]);
                objEntity.Level2Description = dataReader["level2_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["level2_description"]);
                objEntity.Level3Key = dataReader["level3_key"] == DBNull.Value ? "" : Converter.ToString(dataReader["level3_key"]);
                objEntity.Level3Description = dataReader["level3_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["level3_description"]);
                objEntity.CustomerCode = dataReader["customer_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["customer_code"]);
                objEntity.TaskCode = dataReader["task_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["task_code"]);
                objEntity.StartDate = dataReader["start_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["start_date"]);
                objEntity.EndDate = dataReader["end_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["end_date"]);
                objEntity.ResourceID = dataReader["resource_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["resource_id"]);
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                PermanentLinesCriteria<PermanentLine> objCritreria = criteria as PermanentLinesCriteria<PermanentLine>;

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = objCritreria.ResourceID;
                parameters.Add(param);

                if (objCritreria.StartDate != default(DateTime))
                {
                    param = new SqlParameter("@start_date", SqlDbType.DateTime);
                    param.Value = objCritreria.StartDate;
                    parameters.Add(param);
                }

                if (objCritreria.EndDate != default(DateTime))
                {
                    param = new SqlParameter("@end_date", SqlDbType.DateTime);
                    param.Value = objCritreria.EndDate;
                    parameters.Add(param);
                }
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "plsW_apps_permanent_line_get", parameters, enumDatabaes.TE);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Permanent Line(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Permanent Line(s): {0}.", ex.Message.Trim()), ex);
            }

            return retList;
        }

        public override bool Save(T entity)
        {
            bool retVal = false;

            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
            parameters.Add(param);

            param = new SqlParameter("@action_flag", entity.ActionFlag);
            parameters.Add(param);

            param = new SqlParameter("@resource_id", entity.ResourceID);
            parameters.Add(param);

            param = new SqlParameter("@level2_key", entity.Level2Key);
            parameters.Add(param);

            param = new SqlParameter("@level3_key", entity.Level3Key);
            parameters.Add(param);

            param = new SqlParameter("@task_code", entity.TaskCode);
            parameters.Add(param);

            param = new SqlParameter("@start_date", SqlDbType.DateTime);
            //entity.StartDate == default(DateTime) ? DBNull.Value : entity.StartDate
            if (entity.StartDate == default(DateTime))
            {
                param.Value = DBNull.Value;
            }
            else
            {
                param.Value = entity.StartDate;
            }
             
            parameters.Add(param);

            if (entity.Timestamp != null)
            {
                param = new SqlParameter("@TS", entity.Timestamp);
                parameters.Add(param);
            }
            try
            {
                retVal = DbContext.Update("plsw_apps_permanent_line_set", parameters, enumDatabaes.TE);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error setting the Permanent Line(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error setting the Permanent Line(s): {0}.", ex.Message.Trim()), ex);
            }

            return retVal;
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }
    }
}
