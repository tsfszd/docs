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
    public class CostCodesDAO<T> : DAOBase<T> where T : CostCodes, new()
    {
        public CostCodesDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
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

                objEntity.cost_type = DataAccess.Read<int>(dataReader, "cost_type");
                objEntity.res_category_code = Converter.ToString(DataAccess.Read<string>(dataReader, "res_category_code")).Trim();
                objEntity.res_type = DataAccess.Read<int>(dataReader, "res_type");
                objEntity.str_effective_date = DataAccess.Read<DateTime>(dataReader, "effective_date").ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.markup = DataAccess.Read<int>(dataReader, "markup");
                objEntity.str_create_date = DataAccess.Read<DateTime>(dataReader, "create_date").ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.create_id = Converter.ToString(DataAccess.Read<string>(dataReader, "create_id"));
                objEntity.str_modify_date = DataAccess.Read<DateTime>(dataReader, "modify_date").ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.modify_id = Converter.ToString(DataAccess.Read<string>(dataReader, "modify_id"));
                objEntity.tax_code = Converter.ToString(DataAccess.Read<string>(dataReader, "tax_code")).Trim();
                objEntity.expense_report_flag = DataAccess.Read<int>(dataReader, "expense_report_flag");

            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            CostCodeCriteria<CostCodes> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            if (criteria != null)
            {
                objCriteria = criteria as CostCodeCriteria<CostCodes>;

                if (objCriteria.LastSyncDate != default(DateTime))
                {
                    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    param.Value = objCriteria.LastSyncDate;
                    parameters.Add(param);
                }                
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_cost_codes_get", parameters, enumDatabaes.ESM);

            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Cost Code(s): {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Cost Code(s): {0} .", ex.Message.Trim()), ex);
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
    }
}
