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
    public class MultiCurrrencyRateTypeHeaderDAO<T> : DAOBase<T> where T : MultiCurrencyRateTypeHeader, new()
    {
        public MultiCurrrencyRateTypeHeaderDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;
                
                objEntity.mc_rate_type = Converter.ToString(DataAccess.Read<string>(dataReader, "rate_type"));
                objEntity.rate_type_name = Converter.ToString(DataAccess.Read<string>(dataReader, "rate_type_name"));
                objEntity.str_start_date = DataAccess.Read<DateTime>(dataReader, "start_date").ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.str_end_date = DataAccess.Read<DateTime>(dataReader, "end_date").ToString("yyyy-MM-dd HH:mm:ss");                
                objEntity.active_flag = DataAccess.Read<int>(dataReader, "active");
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {

            List<T> retList = null;
            MultiCurrencyRateTypeHeaderCriteria<MultiCurrencyRateTypeHeader> objCriteria = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            ResourceDAO<Resource> resDAO = new ResourceDAO<Resource>(this.Context);
            Resource tempResource = resDAO.LoginUsingDB("", true);

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@expense_only", SqlDbType.Int);
            param.Value = 1;
            parameters.Add(param);

            if (criteria != null)
            {
                objCriteria = criteria as MultiCurrencyRateTypeHeaderCriteria<MultiCurrencyRateTypeHeader>;

            }

            try
            {
                if (objCriteria.UseDummyData == 0)
                {
                    retList = DbContext.GetEntitiesList(this, "pdsw_apps_mc_rate_type_hdr_get", parameters, enumDatabaes.ESM);

                    if (retList != null && retList.Count > 0)
                    {
                        foreach (MultiCurrencyRateTypeHeader rateTypeHdr in retList)
                        {
                            

                            MultiCurrencyRatesTypeDetailCriteria<MultiCurrencyRateTypeDetail> tempDetCrit = new MultiCurrencyRatesTypeDetailCriteria<MultiCurrencyRateTypeDetail>();
                            tempDetCrit.ToCurrency = tempResource.currency_code; // Just to get the currencyCode.
                            tempDetCrit.rate_type = rateTypeHdr.mc_rate_type;

                            var obj = retList.FirstOrDefault(x => x.mc_rate_type == rateTypeHdr.mc_rate_type);
                            if (obj != null) obj.Rates = new MultiCurrencyRatesTypeDetailDAO<MultiCurrencyRateTypeDetail>(this.Context).Select(tempDetCrit);
                        }
                    }
                }
                else
                {
                    string[] fromCurrencies = new string[] { "UK", "BDH", "PKR", "GBP" };
                    List<T> returnList = new List<T>();
                    MultiCurrencyRateTypeHeader tempHdr = new MultiCurrencyRateTypeHeader();
                    tempHdr.CompanyCode = 2;
                    tempHdr.mc_rate_type = "AVERAGE";
                    tempHdr.rate_type_name = "AVERAGE";
                    tempHdr.str_end_date = "2099-12-31 00:00:00";
                    tempHdr.str_start_date = "1999-01-01 00:00:00";
                    tempHdr.active_flag = 1;
                    tempHdr.Rates = new List<MultiCurrencyRateTypeDetail>();

                    DateTime tempDate = new DateTime(2015, 10, 15);

                    for (int i = 0; i < 50; i++)
                    {
                        MultiCurrencyRateTypeDetail tempDtl = new MultiCurrencyRateTypeDetail();
                        tempDtl.CompanyCode = 2;
                        tempDtl.to_currency = tempResource.currency_code;

                        if (i <= 4)
                        {
                            tempDtl.from_currency = fromCurrencies[0];
                        }
                        else if (i <= 9)
                        {
                            tempDtl.from_currency = fromCurrencies[1];
                        }
                        else if (i <= 14)
                        {
                            tempDtl.from_currency = fromCurrencies[2];
                        }
                        else if (i <= 19)
                        {
                            tempDtl.from_currency = fromCurrencies[3];
                        }
                        
                        tempDtl.str_effective_date = tempDate.AddDays(i).ToString("yyyy-MM-dd HH:mm:ss");
                        int divident = i;

                        if (i == 0)
                        {
                            divident = 1;
                        }

                        tempDtl.factor = (double)10 / (double)divident;

                        tempHdr.Rates.Add(tempDtl);
                    }

                    returnList.Add((T) tempHdr);

                    retList = returnList;
                    
                }
                
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Multi Currency Rate(s): {0} .", ex.Message.Trim()), ex);                    

                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Multi Currency Rate(s): {0} .", ex.Message.Trim()), ex);
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
