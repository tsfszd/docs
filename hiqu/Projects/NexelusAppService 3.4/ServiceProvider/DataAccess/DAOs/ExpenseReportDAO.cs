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
    public class ExpenseReportDAO<T> : DAOBase<T> where T : ExpenseReport, new()
    {
        public ExpenseReportDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            throw new NotImplementedException();
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = new List<T>();
            ExpenseReportCriteria<ExpenseReport> objCriteria = null;

            try
            {
                if (objCriteria != null)
                {
                    objCriteria = criteria as ExpenseReportCriteria<ExpenseReport>;

                    TransactionHeaderCriteria<TransactionHeader> trxHdrCrit = new TransactionHeaderCriteria<TransactionHeader>()
                    {
                        ResourceID = objCriteria.ResourceID,
                        LastSyncDate = objCriteria.LastSyncDate
                    };                    

                    List<TransactionHeader> trxHdrs = new TransactionHeaderDAO<TransactionHeader>(this.Context).Select(trxHdrCrit);
                    foreach (TransactionHeader trxHdr in trxHdrs)
                    {
                        T expRep = new T();
                        expRep.TransactionHdr = trxHdr;

                        ExpenseTransactionCriteria<ExpenseTransaction> expTrxCrit = new ExpenseTransactionCriteria<ExpenseTransaction>() 
                        { 
                            record_id = trxHdr.record_id,
                            ResourceID = trxHdr.ResourceID,
                            LastSyncDate = objCriteria.LastSyncDate
                        };

                        expRep.ExpTransactions = new ExpenseTransactionDAO<ExpenseTransaction>(this.Context).Select(expTrxCrit);

                        retList.Add(expRep);
                    }

                }
                

                //retList = DbContext.GetEntitiesList(this, "Plsw_Apps_Transaction_Get", parameters, enumDatabaes.TE);
                //if (objCriteria != null && objCriteria.ActionFlag != 4)
                //{
                //    retList = DbContext.GetEntitiesList(this, "Plsw_Apps_Transaction_Get", parameters, enumDatabaes.TE);
                //}
                //else
                //{
                //    retList = DbContext.GetEntitiesList(this, "plsw_apps_transaction_delete_get", parameters, enumDatabaes.TE, true);
                //}

            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Expense Report(s): {0} .", ex.Message.Trim()), ex);
                    //if (objCriteria != null && objCriteria.ActionFlag == 4)
                    //{
                    //    throw new AppException(Context.LoginID, string.Format("Error fetching the deleted Transaction(s): {0} .", ex.Message.Trim()), ex);
                    //}
                    //else
                    //{
                    //    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);
                    //}

                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Expense Report(s): {0} .", ex.Message.Trim()), ex);
                //if (objCriteria != null && objCriteria.ActionFlag == 4)
                //{
                //    throw new AppException(Context.LoginID, string.Format("Error fetching the deleted Transaction(s): {0} .", ex.Message.Trim()), ex);
                //}
                //else
                //{
                //    throw new AppException(Context.LoginID, string.Format("Error fetching the Transaction(s): {0} .", ex.Message.Trim()), ex);
                //}
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
