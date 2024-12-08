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
    public class TaskDAO<T> : DAOBase<T> where T : Task, new()
    {
        public TaskDAO(NexContext ctx) 
            : base(ctx)
        { 

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.TaskType = dataReader["task_type"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["task_type"]);
                objEntity.TaskTypeDescription = dataReader["task_type_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["task_type_description"]);
                objEntity.TaskCode = dataReader["task_code"] == DBNull.Value ? "" : Converter.ToString(dataReader["task_code"]);
                objEntity.TaskDescription = dataReader["task_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["task_description"]);
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.VarChar);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                TaskCriteria<Task> objCriteria = criteria as TaskCriteria<Task>;

                if (!string.IsNullOrEmpty(objCriteria.TaskCode))
                {
                    param = new SqlParameter("@task_code", SqlDbType.VarChar);
                    param.Value = objCriteria.TaskCode;
                    parameters.Add(param);
                }

                if (objCriteria.LastSyncDate != default(DateTime))
                {
                    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    param.Value = objCriteria.LastSyncDate;
                    parameters.Add(param);
                }
                
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_task_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Task(s): {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Task(s): {0}.", ex.Message.Trim()), ex);
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
