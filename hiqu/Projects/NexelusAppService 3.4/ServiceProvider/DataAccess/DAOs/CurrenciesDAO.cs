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
    public class CurrenciesDAO<T> : DAOBase<T> where T : Currencies, new()
    {
        public CurrenciesDAO(NexContext ctx)
            : base (ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                string tempTimeStamp = dataReader["timestamp"] == DBNull.Value ? "" : Converter.ToString(dataReader["timestamp"]);

                if (!string.IsNullOrEmpty(tempTimeStamp))
                {
                    byte[] tempTimeStampBytes = dataReader["timestamp"] == DBNull.Value ? default(byte[]) : (byte[])dataReader["timestamp"];

                    if (tempTimeStampBytes != default(byte[]))
                    {
                        objEntity.timestamp = ConvertFromByteToString(tempTimeStampBytes, "|$|");
                    }
                }

                objEntity.currency_code = Converter.ToString(DataAccess.Read<string>(dataReader, "currency_code")).Trim();
                objEntity.currency_name = Converter.ToString(DataAccess.Read<string>(dataReader, "currency_name")).Trim();
                objEntity.currency_sign = Converter.ToString(DataAccess.Read<string>(dataReader, "currency_sign")).Trim();
                objEntity.decimal_places = DataAccess.Read<int>(dataReader, "decimal_places");
                objEntity.positive_format = Converter.ToString(DataAccess.Read<string>(dataReader, "positive_format")).Trim();
                objEntity.negative_format = Converter.ToString(DataAccess.Read<string>(dataReader, "negative_format")).Trim();
                objEntity.status_flag = DataAccess.Read<int>(dataReader, "status_flag");
                objEntity.str_create_date = DataAccess.Read<DateTime>(dataReader, "create_date").ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.create_id = Converter.ToString(DataAccess.Read<string>(dataReader, "create_id")).Trim();


            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {

            List<T> retList = null;
            CurrenciesCriteria<Currencies> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                objCriteria = criteria as CurrenciesCriteria<Currencies>;

                if (objCriteria.LastSyncDate != default(DateTime))
                {
                    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    param.Value = objCriteria.LastSyncDate;
                    parameters.Add(param);
                }

            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_currency_codes_get", parameters, enumDatabaes.ESM);

            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching currency(s): {0} .", ex.Message.Trim()), ex);

                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching currency(s): {0} .", ex.Message.Trim()), ex);
            }

            return retList;


        }

        public override bool Save(T entity)
        {
            bool retVal = false;            

            return retVal;
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

        private SqlParameter GetTimestampParam(string name, byte[] val)
        {
            SqlParameter retVal = null;

            if (val == null || val.Length <= 0)
            {
                retVal = new SqlParameter(name, DBNull.Value);
            }
            else
            {
                retVal = new SqlParameter(name, val);
            }
            retVal.DbType = DbType.Binary;
            return retVal;
        }

        private string ConvertFromByteToString(byte[] bytesArray, string delim)
        {
            string str = "";
            if (bytesArray == null || bytesArray.Length < 1)
                return "";
            for (int i = 0; i < bytesArray.Length; i++)
            {
                str = str + bytesArray[i] + delim;
            }
            return str;

        }

        private byte[] ConvertFromStringToBytes(string str, string delim)
        {
            byte[] bytesArray = { 0, 0, 0, 0, 0, 0, 0, 0 };
            ArrayList arr = new ArrayList();
            arr = Utility.SplitString(str, delim);
            for (int i = 0; i < arr.Count; i++)
            {

                bytesArray[i] = Convert.ToByte(arr[i]);

            }
            return bytesArray;

        }

        private DateTime GetDBDate(IDataReader dataReader, string colName)
        {
            if (dataReader[colName] == DBNull.Value)
            {
                return default(DateTime);
            }
            else
            {
                return DateTime.SpecifyKind(Converter.ToDate(dataReader[colName]), DateTimeKind.Utc);
            }
        }

        
    }
}
