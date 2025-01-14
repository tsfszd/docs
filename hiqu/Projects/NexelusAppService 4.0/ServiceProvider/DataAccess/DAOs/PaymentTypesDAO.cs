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
using System.Collections;
using com.paradigm.esm.general;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class PaymentTypesDAO<T> : DAOBase<T> where T : PaymentTypes, new()
    {
        public PaymentTypesDAO(NexContext ctx)
            : base (ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.paymentCode = Converter.ToInteger(DataAccess.Read<int>(dataReader, "payment_code"));
                objEntity.paymentName = Converter.ToString(DataAccess.Read<string>(dataReader, "payment_name"));
                objEntity.vendorCode = Converter.ToString(DataAccess.Read<string>(dataReader, "vendor_code"));
                objEntity.paymentCategory = Converter.ToInteger(DataAccess.Read<int>(dataReader, "payment_category"));
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            //ResourceTypeCriteria<ResourceType> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter companyCode = new SqlParameter("@company_code", SqlDbType.Int);
            companyCode.Value = Context.ComapnyCode;
            parameters.Add(companyCode);

            try
            {
                retList = DbContext.GetEntitiesList(this, "plsW_apps_pmt_types_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("PaymentTypesDAO: Select(): error calling sp 'plsW_apps_pmt_types_get' {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("PaymentTypesDAO: Select(): error calling sp 'plsW_apps_pmt_types_get' {0}.", ex.Message.Trim()), ex);
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
    }
}
