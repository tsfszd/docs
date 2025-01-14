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
    public class ExpenseApprovalDAO<T> : DAOBase<T> where T : ExpenseApproval, new()
    {
        public ExpenseApprovalDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
        {
            throw new NotImplementedException();
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
            /*List<T> retList = null;
            return retList;*/
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

        public override List<T> SaveAndGet(List<T> Entities)
        {
            List<T> retTrxs = new List<T>();
            string timestamp = "0x0";
            int uploadFlag = 0;
            int i = 0;
            string errorDescriptionHdr = "";
            int nFullRepUploadedFlag = 0;

            foreach (T entity in Entities)
            {
                i++;

                List<SqlParameter> parameters = new List<SqlParameter>();
                SqlParameter param = new SqlParameter();

                
                    param = new SqlParameter("@company_code", Context.ComapnyCode);
                    parameters.Add(param);

                    if (entity.ByteTS != null)
                    {
                        parameters.Add(GetTimestampParam("@TS", entity.ByteTS));
                    }

                    param = new SqlParameter("@report_name", entity.report_name);
                    parameters.Add(param);

                    param = new SqlParameter("@record_id", entity.record_id);
                    parameters.Add(param);

                    param = new SqlParameter("@amount", entity.AmountNet);
                    parameters.Add(param);

                    param = new SqlParameter("@modify_id", Context.LoginID);
                    parameters.Add(param);

                    param = new SqlParameter("@re_approval_flag", entity.re_approval_flag);
                    parameters.Add(param);

                // Context.DBConnection.BeginTransaction(); plsw_apps_app_exp_trx_hdr_update plsw_apps_app_exp_trx_update
                
                    errorDescriptionHdr = DbContext.SaveTimeExpenseApproval("plsw_app_exp_trx_hdr_update", parameters, enumDatabaes.TE, false, Context,out timestamp, out uploadFlag);
                
                if (errorDescriptionHdr == "")
                {
                    entity.IsValid = true;
                    entity.ErrorDescription = "";
                    entity.ErrorFlag = 0;
                    entity.StrTimeStamp = timestamp;
                    retTrxs.Add(entity);

                    foreach (NewExpenseTransaction trx in entity.transactions)

                    {
                        parameters = new List<SqlParameter>();

                        param = new SqlParameter("@company_code", Context.ComapnyCode);
                        parameters.Add(param);

                        if (entity.ByteTS != null)
                        {
                            parameters.Add(GetTimestampParam("@TS", entity.ConvertFromStringToBytes(trx.StrTimeStamp, "|$|")));
                        }

                        param = new SqlParameter("@modify_id", Context.LoginID);
                        parameters.Add(param);

                        param = new SqlParameter("@transaction_id", trx.TransactionID);
                        parameters.Add(param);

                        param = new SqlParameter("@nonbill_flag", trx.NonBillableFlag);
                        parameters.Add(param);
                        param = new SqlParameter("@approval_flag", trx.ApprovalFlag);
                        parameters.Add(param);

                        param = new SqlParameter("@approval_comment", trx.approval_comments);
                        parameters.Add(param);

                        param = new SqlParameter("@approved_by", Context.LoginID);
                        parameters.Add(param);

                        param = new SqlParameter("@finalise_flag", trx.IsFinalisedFlag);
                        parameters.Add(param);

                        param = new SqlParameter("@save_as_unsubmitted", trx.ApprovalFlag == 2 ? 1 : 0);
                        parameters.Add(param);

                        param = new SqlParameter("@amount_home", trx.AmountHome);
                        parameters.Add(param);

                        param = new SqlParameter("@amount_billable", trx.AmountBillable);
                        parameters.Add(param);

                        param = new SqlParameter("@amount_tax", trx.AmountTax);
                        parameters.Add(param);

                        param = new SqlParameter("@amount_net", trx.AmountNet);
                        parameters.Add(param);

                        param = new SqlParameter("@amount", trx.TotalAmount);
                        parameters.Add(param);



                        try
                        {
                            //retVal = DbContext.Update(SP, parameters, enumDatabaes.TE);
                            int uploadFlagTrx = 0;
                            string errorDescription = DbContext.SaveTimeExpenseApproval("plsw_apps_app_exp_trx_update", parameters, enumDatabaes.TE, false, Context, out timestamp, out uploadFlagTrx);

                            if (uploadFlagTrx == 2)//3A. 20180910 - In case of full report uploaded
                            {
                                nFullRepUploadedFlag = 1;
                                uploadFlagTrx = 1;
                            }

                            if (errorDescription != null && errorDescription != "")
                            {
                                //Added to update transaction - Mati
                                trx.IsValid = false;
                                trx.ErrorDescription = errorDescription;
                                trx.ErrorFlag = 1;
                                trx.ErrorCode = -200;
                                trx.StrTimeStamp = timestamp;
                                trx.UploadFlag = uploadFlagTrx;

                               /* entity.IsValid = false;
                                entity.ErrorDescription = errorDescription;
                                entity.ErrorFlag = 1;
                                entity.ErrorCode = -200;
                                entity.StrTimeStamp = timestamp;
                                retTrxs.Add(entity);
                                */


                            }
                            else
                            {
                                //Added to update transaction - Mati
                                trx.IsValid = true;
                                trx.ErrorDescription = "";
                                trx.ErrorFlag = 0;
                                trx.UploadFlag = uploadFlagTrx;
                                trx.StrTimeStamp = timestamp;
                                

/*
                                entity.IsValid = true;
                                entity.ErrorDescription = "";
                                entity.ErrorFlag = 0;
                                entity.StrTimeStamp = timestamp;
                                retTrxs.Add(entity);
                                */
                            }

                        }



                        catch (AppException ex)
                        {
                           /* entity.IsValid = false;
                            entity.ErrorDescription = ex.Message;
                            entity.ErrorFlag = 1;
                            entity.ErrorCode = -200;
                            entity.StrTimeStamp = timestamp;
                            retTrxs.Add(entity);
                            */
                            trx.IsValid = false;
                            trx.ErrorDescription = ex.Message;
                            trx.ErrorFlag = 1;
                            trx.ErrorCode = -200;
                            trx.StrTimeStamp = timestamp;

                        }
                        catch (Exception ex)
                        {
                            /*
                            entity.IsValid = false;
                            entity.ErrorDescription = ex.Message;
                            entity.ErrorFlag = 1;
                            entity.ErrorCode = -200;
                            entity.StrTimeStamp = timestamp;
                            retTrxs.Add(entity);
                            */

                            trx.IsValid = false;
                            trx.ErrorDescription = ex.Message;
                            trx.ErrorFlag = 1;
                            trx.ErrorCode = -200;
                            trx.StrTimeStamp = timestamp;
                        }
                    }

                    if (nFullRepUploadedFlag == 1)
                    {
                        foreach (NewExpenseTransaction trx in entity.transactions)//3A. 20180910
                        {
                            trx.UploadFlag = 1;
                        }
                    }
                    
                }
                else
                {
                    // Context.DBConnection.RollbackTransaction();
                    entity.IsValid = false;
                    entity.ErrorDescription = errorDescriptionHdr;
                    entity.ErrorFlag = 1;
                    entity.ErrorCode = -200;
                    if(!string.IsNullOrEmpty(timestamp) && timestamp != "0x0")
                        entity.StrTimeStamp = timestamp;
                    retTrxs.Add(entity);
                    break;
                }

            }

            //if (retTrxs.Where(x => x.ErrorFlag == 1).Count() == 0)
            //{
            //    Context.DBConnection.CommitTransaction();
            //}
            //else
            //{
            //    Context.DBConnection.RollbackTransaction();
            //}

            return retTrxs;
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

    }
}
