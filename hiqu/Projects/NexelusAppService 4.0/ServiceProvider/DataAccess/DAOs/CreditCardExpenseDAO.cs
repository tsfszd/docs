using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using com.paradigm.esm.general;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Exceptions;
using System.Collections;
using System.Globalization;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class CreditCardExpenseDAO<T> : DAOBase<T> where T : CreditCardExpense, new()
    {
        public CreditCardExpenseDAO(NexContext ctx)
            :base(ctx)
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
                    byte[] tempTimestampBytes = dataReader["timestamp"] == DBNull.Value ? default(byte[]) : (byte[])dataReader["timestamp"];

                    if (tempTimestampBytes != default(byte[]))
                    {
                        objEntity.timestamp = ConvertFromByteToString(tempTimestampBytes, "|$|");
                    }
                }

                objEntity.cc_exp_id = dataReader["cc_exp_id"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["cc_exp_id"]);
                objEntity.ResourceID = dataReader["resource_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["resource_id"]);
                objEntity.applied_date = dataReader["applied_date"] == DBNull.Value ? default(DateTime) : Converter.ToDate(dataReader["applied_date"]);
                objEntity.str_applied_date = dataReader["applied_date"] == DBNull.Value ? null : Converter.ToDate(dataReader["applied_date"]).ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.amount = dataReader["amount"] == DBNull.Value ? default(double) : Converter.ToDouble(dataReader["amount"]);
                objEntity.ext_reference_no = Converter.ToString(DataAccess.Read<string>(dataReader, "ext_reference_no"));
                objEntity.comments = Converter.ToString(DataAccess.Read<string>(dataReader, "comments")).Trim();                
                objEntity.create_id = Converter.ToString(DataAccess.Read<string>(dataReader, "create_id")).Trim();
                objEntity.str_create_date = DataAccess.Read<DateTime>(dataReader, "create_date").ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.modify_id = Converter.ToString(DataAccess.Read<string>(dataReader, "modify_id")).Trim();
                objEntity.str_modify_date = DataAccess.Read<DateTime>(dataReader, "modify_date").ToString("yyyy-MM-dd HH:mm:ss");
                objEntity.split_flag = DataAccess.Read<int>(dataReader, "split_flag");
                objEntity.company_or_personal_flag = DataAccess.Read<int>(dataReader, "company_or_personal_flag");
                objEntity.cc_num = Converter.ToString(DataAccess.Read<string>(dataReader, "cc_num")).Trim();
                objEntity.payment_code = DataAccess.Read<int>(dataReader, "payment_code");
                objEntity.payment_name = Converter.ToString(DataAccess.Read<string>(dataReader, "payment_name")).Trim();
                objEntity.vendor_name = Converter.ToString(DataAccess.Read<string>(dataReader, "vendor_name")).Trim();
                objEntity.cc_type_id = DataAccess.Read<int>(dataReader, "cc_type_id");

            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            CreditCardExpenseCriteria<CreditCardExpense> ccExpCrit = null;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);


            if (criteria != null)
            {
                ccExpCrit = criteria as CreditCardExpenseCriteria<CreditCardExpense>;

                param = new SqlParameter("@resource_id", SqlDbType.VarChar);
                param.Value = ccExpCrit.ResourceID;
                parameters.Add(param);

                if (ccExpCrit.LastSyncDate != default(DateTime))
                {
                    param = new SqlParameter("@last_sync_date", SqlDbType.DateTime);
                    param.Value = ccExpCrit.LastSyncDate;
                    parameters.Add(param);
                }
                
            }

            try
            {
                retList = DbContext.GetEntitiesList(this, "plsW_apps_cc_exp_get", parameters, enumDatabaes.TE);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Credit Card Expense(s): {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Credit Card Expense(s): {0} .", ex.Message.Trim()), ex);                
            }

            return retList;
        }

        public override List<T> SaveAndGet(List<T> Entities)
        {
            //return base.SaveAndGet(Entities);

            List<T> retList = new List<T>();

            T objEntity = null;

            StringBuilder xmlTrsnactionsList = new StringBuilder();
            xmlTrsnactionsList.Append("<transactions>");
            CCOperationTrxDetail ccOperationTrxDetail;
            if (Entities!=null && Entities.Count>0)
            {
                ccOperationTrxDetail = Entities[0].ccOperationTrxDetail;

                for (int i = 0; i < ccOperationTrxDetail.cCTranxDetails.Count; i++)
                {
                    CCTranxDetails cCTranxDetails = ccOperationTrxDetail.cCTranxDetails[i];

                    xmlTrsnactionsList.Append("<transaction>");

                    xmlTrsnactionsList.Append("<cc_exp_id>");
                    xmlTrsnactionsList.Append(cCTranxDetails.CCTrxID);
                    xmlTrsnactionsList.Append("</cc_exp_id>");

                    xmlTrsnactionsList.Append("<amount>");
                    xmlTrsnactionsList.Append(cCTranxDetails.CCTrxAmount.ToString());
                    xmlTrsnactionsList.Append("</amount>");
                    xmlTrsnactionsList.Append("<TS>");
                    xmlTrsnactionsList.Append(GetSqlTimestamp(cCTranxDetails.TimeStamp));
                    xmlTrsnactionsList.Append("</TS>");



                    xmlTrsnactionsList.Append("</transaction>");

                }

                xmlTrsnactionsList.Append("</transactions>");

                StringBuilder xmlAmountList = new StringBuilder();

                xmlAmountList.Append("<amounts>");


                foreach (Double amounts in ccOperationTrxDetail.split_amount_list)
                {
                    String doubleString = amounts.ToString();
                    xmlAmountList.Append("<amt><amount>");
                    xmlAmountList.Append(doubleString);
                    xmlAmountList.Append("</amount></amt>");
                }
                xmlAmountList.Append("</amounts>");

                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter paramTransactionList = new SqlParameter("@xml_transaction", SqlDbType.Xml);
                paramTransactionList.Value = xmlTrsnactionsList.ToString();
                parameters.Add(paramTransactionList);

                SqlParameter paramAmountList = new SqlParameter("@xml_split_amounts", SqlDbType.Xml);
                paramAmountList.Value = xmlAmountList.ToString();
                parameters.Add(paramAmountList);

                SqlParameter companyCode = new SqlParameter("@company_code", SqlDbType.Int);
                companyCode.Value = Context.ComapnyCode;
                parameters.Add(companyCode);

                SqlParameter createId = new SqlParameter("@create_id", SqlDbType.VarChar);
                createId.Value = ccOperationTrxDetail.create_id;
                parameters.Add(createId);


                SqlParameter actionFlag = new SqlParameter("@action_flag", SqlDbType.VarChar);
                actionFlag.Value = ccOperationTrxDetail.action_flag;
                parameters.Add(actionFlag);


                try
                {
                    List<T> tempEntity = DbContext.SaveForCCTransactions(this, "plsW_apps_cc_exp_save", parameters, enumDatabaes.ESM);

                    if (tempEntity != null)
                    {
                        for (int i=0;i<tempEntity.Count;i++)
                        {
                            retList.Add(tempEntity[i]);
                        }
                        
                    }
                }
                catch (AppException ex)
                {
                    objEntity = new T();
                    objEntity.ErrorFlag = 2;
                    objEntity.ErrorCode = -200;
                    objEntity.ErrorDescription = ex.Message;
                    retList.Add(objEntity);

                }
                catch (Exception ex)
                {
                    objEntity = new T();
                    objEntity.ErrorFlag = 2;
                    objEntity.ErrorCode = -200;
                    objEntity.ErrorDescription = ex.Message;
                    retList.Add(objEntity);
                }
            }

            

            return retList;
        }

        public string GetSqlTimestamp(byte [] byteArray)
        {
            if (byteArray == null)
                return string.Empty;

            //return string.Format("0x{0}", String.Join("", TimeStamp.Select(b => b.ToString("X2"))));//b == 0 ? "00" : 

            var rowVersion = "0x" + string.Concat(Array.ConvertAll(byteArray, x => x.ToString("X2")));


            return rowVersion;
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

      
    }
}
