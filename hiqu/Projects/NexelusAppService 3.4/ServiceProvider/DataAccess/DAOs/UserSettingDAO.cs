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
using com.paradigm.esm.general;

namespace NexelusApp.Service.DataAccess.DAOs
{
    class UserSettingDAO<T> : DAOBase<T> where T : UserSetting, new()
    {
        public UserSettingDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.ResourceID = Converter.ToString(dataReader["resource_id"]);
                objEntity.SortBy = Converter.ToInteger(dataReader["sort_by"]);
                objEntity.MaxHrsDay = Converter.ToInteger(dataReader["max_hours_day"]);
                objEntity.MaxHrsWeek = Converter.ToInteger(dataReader["max_hours_week"]);
                objEntity.MaxHrsMonth = Converter.ToInteger(dataReader["max_hours_month"]);
                objEntity.WeekStarts = Converter.ToInteger(dataReader["week_starts"]);
                objEntity.DateFormat = Converter.ToString(dataReader["Date_Format"]);
                objEntity.SortActivityBy = Converter.ToInteger(dataReader["Activity_description"]);
                objEntity.Level2Level3ColumnLength = Converter.ToInteger(dataReader["Level2Level3ColumnLength"]);
                


            }
        }

        public override List<T> Select(Model.Criteria.CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            UserSettingCriteria<UserSetting> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                objCriteria = criteria as UserSettingCriteria<UserSetting>;

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = objCriteria.ResourceID;
                parameters.Add(param);

            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "plsw_apps_user_settings_get", parameters, enumDatabaes.TE);
                
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the User Settings: {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the User Settings: {0}.", ex.Message.Trim()), ex);
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
