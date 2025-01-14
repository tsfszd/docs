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
    public class ResourceTypeDAO<T> : DAOBase<T> where T : ResourceType, new()
    {
        public ResourceTypeDAO(NexContext ctx)
            : base (ctx)
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

                objEntity.res_category_code = Converter.ToString(DataAccess.Read<string>(dataReader, "res_category_code"));
                objEntity.res_type = Converter.ToInteger(DataAccess.Read<int>(dataReader, "res_type"));
                objEntity.rtype_name = Converter.ToString(DataAccess.Read<string>(dataReader, "rtype_name"));
                objEntity.rtype_description = Converter.ToString(DataAccess.Read<string>(dataReader, "rtype_description"));
                objEntity.uom_code = Converter.ToString(DataAccess.Read<string>(dataReader, "uom_code"));
                objEntity.rtype_status = Converter.ToInteger(DataAccess.Read<int>(dataReader, "rtype_status"));
                objEntity.normalize_units_flag = Converter.ToInteger(DataAccess.Read<int>(dataReader, "normalize_units_flag"));
                objEntity.standard_units = Converter.ToDouble(DataAccess.Read<double>(dataReader, "standard_units"));
                objEntity.seg_value = Converter.ToString(DataAccess.Read<string>(dataReader, "seg_value"));
                objEntity.gl_account = Converter.ToString(DataAccess.Read<string>(dataReader, "gl_account"));
                objEntity.create_id = Converter.ToString(DataAccess.Read<string>(dataReader, "create_id"));
                //3A. 20181114 : Added flag for receipt required
                objEntity.receiptExamptedFlag = Converter.ToByte(DataAccess.Read<byte>(dataReader, "exempt_from_receipt"));
                //objEntity.create_date = Converter.ToString(DataAccess.Read<string>(dataReader, "res_category_code"));
                //objEntity.str_create_date = Converter.ToString(DataAccess.Read<string>(dataReader, "res_category_code"));
                //objEntity.modify_id = Converter.ToString(DataAccess.Read<string>(dataReader, "res_category_code"));
                //objEntity.modify_date = Converter.ToString(DataAccess.Read<string>(dataReader, "res_category_code"));
                //objEntity.str_modify_date = Converter.ToString(DataAccess.Read<string>(dataReader, "res_category_code"));
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            ResourceTypeCriteria<ResourceType> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter companyCode = new SqlParameter("@company_code", SqlDbType.Int);
            companyCode.Value = Context.ComapnyCode;
            parameters.Add(companyCode);

            if (criteria != null)
            {
                objCriteria = criteria as ResourceTypeCriteria<ResourceType>;

                if (objCriteria.LastSyncDate != default(DateTime))
                {
                    SqlParameter param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    param.Value = objCriteria.LastSyncDate;
                    parameters.Add(param);
                }
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsw_apps_rtypes_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("ResourceTypeDAO: Select(): error calling sp 'pdsw_apps_rtypes_get' {0}.", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("ResourceTypeDAO: Select(): error calling sp 'pdsw_apps_rtypes_get' {0}.", ex.Message.Trim()), ex);
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
