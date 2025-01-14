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
    public class MultiCurrencyRatesTypeDetailDAO<T> : DAOBase<T> where T : MultiCurrencyRateTypeDetail, new()
    {
        public MultiCurrencyRatesTypeDetailDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                objEntity.rate_type = Converter.ToString(DataAccess.Read<string>(dataReader, "rate_type"));
                objEntity.from_currency = Converter.ToString(DataAccess.Read<string>(dataReader, "from_currency"));
                objEntity.to_currency = Converter.ToString(DataAccess.Read<string>(dataReader, "to_currency"));
                objEntity.factor = DataAccess.Read<double>(dataReader, "factor");
                objEntity.str_effective_date = DataAccess.Read<DateTime>(dataReader, "effective_date").ToString("yyyy-MM-dd HH:mm:ss");
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            MultiCurrencyRatesTypeDetailCriteria<MultiCurrencyRateTypeDetail> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                objCriteria = criteria as MultiCurrencyRatesTypeDetailCriteria<MultiCurrencyRateTypeDetail>;

                param = new SqlParameter("@rate_type", SqlDbType.VarChar);
                param.Value = objCriteria.rate_type;
                parameters.Add(param);

                param = new SqlParameter("@to_currency", SqlDbType.VarChar);
                param.Value = objCriteria.ToCurrency;
                parameters.Add(param);

            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_mc_rate_type_dtl_get", parameters, enumDatabaes.ESM);                

            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Multi Currency Rates Detail(s): {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Multi Currency Rates Detail(s): {0} .", ex.Message.Trim()), ex);
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
