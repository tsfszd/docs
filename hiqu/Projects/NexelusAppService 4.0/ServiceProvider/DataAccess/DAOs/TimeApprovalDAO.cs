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
    public class TimeApprovalDAO<T> : DAOBase<T> where T : TimeApproval, new()
    {
        public TimeApprovalDAO(NexContext ctx)
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
            //bool retVal = false;
            string timestamp = "0x0";
            int uploadFlag = 0;
            List<T> retTrxs = new List<T>();
            //string SP = "plsW_app_trx_update";

           // Context.DBConnection.BeginTransaction();
            foreach (T entity in Entities)
            {
                string SP = "plsW_apps_app_trx_update";
                List<SqlParameter> parameters = new List<SqlParameter>();

                SqlParameter param = new SqlParameter("@company_code", Context.ComapnyCode);
                parameters.Add(param);

                if (entity.PageMode != 3)
                {
                    if (entity.ByteTS != null)
                    {
                        parameters.Add(GetTimestampParam("@TS", entity.ByteTS));
                    }

                    param = new SqlParameter("@transaction_id", entity.TransactionID);
                    parameters.Add(param);

                    param = new SqlParameter("@units", entity.Units);
                    parameters.Add(param);

                    param = new SqlParameter("@nonbill_flag", entity.NonBillableFlag);
                    parameters.Add(param);

                    param = new SqlParameter("@approved_by", Context.LoginID);
                    parameters.Add(param);

                    param = new SqlParameter("@modify_id", Context.LoginID);
                    parameters.Add(param);

                }
                else
                {
                    //SP="plsW_app_level2_trx_update";
                    SP = "plsW_apps_app_level2_trx_update";

                    param = new SqlParameter("@level2_key", entity.Level2Key);
                    parameters.Add(param);

                    param = new SqlParameter("@level3_key", entity.Level3Key);
                    parameters.Add(param);

                    param = new SqlParameter("@task_code", entity.TaskCode);
                    parameters.Add(param);

                    param = new SqlParameter("@resource_id", entity.ResourceID);
                    parameters.Add(param);

                    param = new SqlParameter("@create_id", Context.LoginID);
                    parameters.Add(param);

                    param = new SqlParameter("@manager_id", entity.ResourceID);
                    parameters.Add(param);

                    param = new SqlParameter("@approval_Mode", entity.ApprovalMode);
                    parameters.Add(param);

                    param = new SqlParameter("@from_date", DBNull.Value);
                    parameters.Add(param);

                    param = new SqlParameter("@to_date", DBNull.Value);
                    parameters.Add(param);

                    param = new SqlParameter("@l2_org_unit", DBNull.Value);
                    parameters.Add(param);

                    param = new SqlParameter("@l2_location_code", DBNull.Value);
                    parameters.Add(param);

                    param = new SqlParameter("@l3_org_unit", DBNull.Value);
                    parameters.Add(param);

                    param = new SqlParameter("@l3_location_code", DBNull.Value);
                    parameters.Add(param);


                }

                param = new SqlParameter("@approval_flag", entity.ApprovalFlag);
                parameters.Add(param);


                param = new SqlParameter("@approval_comment", entity.ApprovalComments);
                parameters.Add(param);



                try
                {
                    //retVal = DbContext.Update(SP, parameters, enumDatabaes.TE);
                    string errorDescription = DbContext.SaveTimeExpenseApproval(SP, parameters, enumDatabaes.TE, false, Context, out timestamp, out uploadFlag);

                    if (errorDescription != null && errorDescription != "")
                    {
                        entity.IsValid = false;
                        entity.ErrorDescription = errorDescription;
                        entity.ErrorFlag = 1;
                        entity.ErrorCode = -200;
                        entity.StrTimeStamp = timestamp;
                        retTrxs.Add(entity);
                    }
                    else
                    {
                        entity.IsValid = true;
                        entity.ErrorDescription = "";
                        entity.ErrorFlag = 0;
                        entity.StrTimeStamp = timestamp;
                        retTrxs.Add(entity);
                    }

                }



                catch (AppException ex)
                {
                    entity.IsValid = false;
                    entity.ErrorDescription = ex.Message;
                    entity.ErrorFlag = 1;
                    entity.ErrorCode = -200;
                    entity.StrTimeStamp = timestamp;
                    retTrxs.Add(entity);

                }
                catch (Exception ex)
                {
                    entity.IsValid = false;
                    entity.ErrorDescription = ex.Message;
                    entity.ErrorFlag = 1;
                    entity.ErrorCode = -200;
                    entity.StrTimeStamp = timestamp;
                    retTrxs.Add(entity);
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
