using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.DataAccess;
using NexelusApp.Service.DataAccess.DAOs;
using System.Data.SqlClient;
using NexelusApp.Service.Exceptions;
using com.paradigm.esm.general;

namespace NexelusApp.Service.Service
{
    public class TimesheetService<T> where T : EntityBase, new()
    {
        /// <summary>
        /// Generic Load Method for service where T should be of type EntityBase
        /// </summary>
        /// <param name="request">Request of type EntityBase</param>
        /// <returns>Response of type EntityBase</returns>
        public Response<T> Load(Request<T> request)
        {
            Response<T> res = new Response<T>();

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    NexContext ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

                    //Added by Mati to delete all notifications against the subscriber id if first time login
                    if (request.Authentication.isFirstTimeLogin)
                    {
                        deleteNotificationsDataAgainstSubscriber(ctx);
                    }


                    //ctx.DBConnection.BeginTransaction();

                    if (ctx != null)
                    {
                        Repository<T> resRepository = new Repository<T>(ctx);
                        List<T> resList = resRepository.Select(request.SearchCriteria);

                        //ctx.DBConnection.CommitTransaction();

                        if (resList != null)
                        {
                            res.Entities = resList;
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                        else
                        {
                            res.Entities = resList;
                            res.Message = "Something went wrong, please contact administrator";
                            res.ResponseType = Enums.ResponseType.GeneralError;
                        }
                    }

                }
                else
                {
                    res.Message = authString.Trim();
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    res.Message = ex.Message.Trim();
                    //if (!ex.Message.ToLower().Contains("error"))
                    //{
                    //    res.Message = "An SQL error occured: " + ex.Message;
                    //}
                    //else
                    //{
                    //    res.Message = ex.Message;
                    //}
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;
                    res.Message = ex.Message.Trim();
                    //if (!ex.Message.ToLower().Contains("error"))
                    //{
                    //    res.Message = "An error occured: " + ex.Message;
                    //}
                    //else
                    //{
                    //    res.Message = ex.Message;
                    //}

                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                res.Message = ex.Message.Trim();
                Logger.Log(ex.StackTrace, LogLevelType.DEBUG);
                //if (!ex.Message.ToLower().Contains("error"))
                //{
                //    res.Message = "An error occured: " + ex.Message;
                //}
                //else
                //{
                //    res.Message = ex.Message;
                //}
            }

            return res;
        }

        public void deleteNotificationsDataAgainstSubscriber(NexContext ctx)
        {
            SubscriberDAO<Subscriber> subDAO = new SubscriberDAO<Subscriber>(ctx);
            subDAO.deleteNotificationsDataAgainstSubscriber(ctx.SubscriberID);
        }

        /// <summary>
        /// Generic Set Method for service where T should be of type EntityBase
        /// </summary>
        /// <param name="request">Request of type EntityBase</param>
        /// <returns>Response of type EntityBase</returns>
        public Response<T> Set(Request<T> request)
        {
            Response<T> res = new Response<T>();
            NexContext ctx = null;
            bool isUpdated = false;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));


                    Repository<T> resRepository = new Repository<T>(ctx);
                    //ctx.DBConnection.BeginTransaction();

                    if (request.SearchCriteria != null)
                    {
                        if (request.SearchCriteria.ActionFlag == 3)
                        {
                            isUpdated = resRepository.Delete(request.SearchCriteria);
                        }
                    }
                    else
                    {
                        foreach (T entity in request.Entities)
                        {
                            isUpdated = resRepository.Save(entity);
                        }
                    }



                    if (isUpdated == true)
                    {
                        //ctx.DBConnection.CommitTransaction();
                        res.Message = "Data saved successfully.";
                        res.ResponseType = Enums.ResponseType.Success;
                    }
                    else
                    {
                        //ctx.DBConnection.RollbackTransaction();                        
                        res.Message = "Data was already changed.";
                        res.ResponseType = Enums.ResponseType.GeneralError;
                    }

                    //ctx.DBConnection.Close();

                }
                else
                {
                    res.Message = authString.Trim();
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    res.Message = ex.Message.Trim();
                    //if (!ex.Message.ToLower().Contains("error"))
                    //{
                    //    res.Message = "An SQL error occured: " + ex.Message;
                    //}
                    //else
                    //{
                    //    res.Message = ex.Message;
                    //}
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;
                    res.Message = ex.Message.Trim();
                    //if (!ex.Message.ToLower().Contains("error"))
                    //{
                    //    res.Message = "An error occured: " + ex.Message;
                    //}
                    //else
                    //{
                    //    res.Message = ex.Message;
                    //}
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                res.Message = ex.Message.Trim();
                //if (!ex.Message.ToLower().Contains("error"))
                //{
                //    res.Message = "An error occured: " + ex.Message;
                //}
                //else
                //{
                //    res.Message = ex.Message;
                //}
            }

            return res;
        }

        public Response<Resource> ChangePassword(Request<Resource> request)
        {
            Response<Resource> res = new Response<Resource>();

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    NexContext ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

                    //ctx.DBConnection.BeginTransaction();

                    if (ctx != null)
                    {
                        bool updated = false;

                        ResourceDAO<Resource> resDAO = new ResourceDAO<Resource>(ctx);

                        foreach (Resource entity in request.Entities)
                        {
                            string tempPassNew = entity.NewPassword;
                            TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                            tempPassNew = TwofishAlgorithm.eEncrypt(tempPassNew);

                            entity.NewPassword = tempPassNew;

                            tempPassNew = entity.OldPassword;
                            TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                            tempPassNew = TwofishAlgorithm.eEncrypt(tempPassNew);

                            entity.OldPassword = tempPassNew;

                            updated = resDAO.UpdatePassword(entity);
                        }


                        if (updated)
                        {
                            res.Message = "Password changed successfully.";
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                        else
                        {
                            res.Message = "Error: Something went wrong, please contact administrator";
                            res.ResponseType = Enums.ResponseType.GeneralError;
                        }
                    }

                }
                else
                {
                    res.Message = authString;
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    res.Message = ex.Message.Trim();

                    //if (!ex.Message.ToLower().Contains("error"))
                    //{
                    //    res.Message = "An SQL error occured: " + ex.Message;
                    //}
                    //else
                    //{
                    //    res.Message = ex.Message;
                    //}
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;
                    res.Message = ex.Message.Trim();
                    //if (!ex.Message.ToLower().Contains("error"))
                    //{
                    //    res.Message = "An error occured: " + ex.Message;
                    //}
                    //else
                    //{
                    //    res.Message = ex.Message;
                    //}

                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                res.Message = ex.Message.Trim();
                //if (!ex.Message.ToLower().Contains("error"))
                //{
                //    res.Message = "An error occured: " + ex.Message;
                //}
                //else
                //{
                //    res.Message = ex.Message;
                //}
            }

            return res;
        }

        public Response<T> SetAndReturnEntity(Request<T> request)
        {
            Response<T> res = new Response<T>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

                    Repository<T> resRepository = new Repository<T>(ctx);
                    res.Entities = resRepository.SaveAndGet(request.Entities);

                    if (res.Entities.Count > 0)
                    {
                        res.Message = "Data saved successfully.";
                        res.ResponseType = Enums.ResponseType.Success;
                    }
                    else
                    {
                        res.Message = "Data was already changed.";
                        res.ResponseType = Enums.ResponseType.GeneralError;
                    }


                }
                else
                {
                    res.Message = authString;
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {

                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }

        public Response<Transaction> SaveTransactions(Request<Transaction> request)
        {

            Response<Transaction> res = new Response<Transaction>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

                    TransactionsDAO<Transaction> trxDAO = new TransactionsDAO<Transaction>(ctx);
                    res.Entities = trxDAO.SaveAndGet(request.Entities);

                    if (res.Entities.Count > 0)
                    {
                        res.Message = "Data saved successfully.";
                        res.ResponseType = Enums.ResponseType.Success;
                    }
                    else
                    {
                        res.Message = "Data was already changed.";
                        res.ResponseType = Enums.ResponseType.GeneralError;
                    }


                }
                else
                {
                    res.Message = authString;
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {

                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;

        }

        public Response<TransactionHeader> SaveExpenseReport(Request<TransactionHeader> request)
        {
            return SaveExpenseReport2(request);
        }

        public Response<TransactionHeader> SaveExpenseReport2(Request<TransactionHeader> request)
        {
            Response<TransactionHeader> res = new Response<TransactionHeader>();

            // This list is only used for DAO method as it requires a list for saving.
            List<TransactionHeader> tempListForSave = new List<TransactionHeader>();

            // This list is for the response (This may contains headers with errors as well as successfully saved headers).
            List<TransactionHeader> listForResponse = new List<TransactionHeader>();
            //Expense Transaction List for each header in the response;
            List<ExpenseTransaction> tempListExpenseTransactionsForReturn = new List<ExpenseTransaction>();

            // This is a temp variable to get the transactionHeader after it is saved as it is 
            TransactionHeader tempTrxHdrAfterSave = null;

            List<TransactionHeader> errorList = new List<TransactionHeader>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

                    foreach (TransactionHeader trxHdrRequest in request.Entities)
                    {
                        ctx.DBConnection.BeginTransaction();

                        if (trxHdrRequest.is_submitted == 1)
                        {
                            trxHdrRequest.ActionFlag = 1;
                        }

                        //The list is bieng cleared as only one transaction header should be sent for saved at a time.
                        tempListForSave.Clear();
                        tempListForSave.Add(trxHdrRequest);

                        TransactionHeaderDAO<TransactionHeader> trxDAO = new TransactionHeaderDAO<TransactionHeader>(ctx);
                        List<TransactionHeader> tempListAfterSave = trxDAO.SaveAndGet(tempListForSave);

                        if (tempListAfterSave != null && tempListAfterSave.Count > 0)
                        {
                            tempTrxHdrAfterSave = tempListAfterSave[0];
                        }


                        bool isError = false;
                        if (tempTrxHdrAfterSave != null)
                        {
                            if (tempTrxHdrAfterSave.error_flag > 0)
                            {
                                // Copying the error returned after save to the original header.
                                trxHdrRequest.error_flag = tempTrxHdrAfterSave.error_flag;
                                trxHdrRequest.ErrorFlag = tempTrxHdrAfterSave.ErrorFlag;

                                trxHdrRequest.error_code = tempTrxHdrAfterSave.error_code;
                                trxHdrRequest.ErrorCode = tempTrxHdrAfterSave.ErrorCode;

                                trxHdrRequest.error_description = tempTrxHdrAfterSave.error_description;
                                trxHdrRequest.ErrorDescription = tempTrxHdrAfterSave.ErrorDescription;

                                // Assigning the original transaction header to the after saved transaction in case of error 
                                // as needed to send the original transaction header back to app.
                                tempTrxHdrAfterSave = trxHdrRequest;
                                isError = true;
                            }

                            if (isError)
                            {
                                listForResponse.Add(tempTrxHdrAfterSave);
                                ctx.DBConnection.RollbackTransaction();
                                // Continue with other transactions
                                continue;
                            }
                            else
                            {

                                // If Header is for delete then do not go for the rest of the implementation.
                                if (trxHdrRequest.ActionFlag == 3)
                                {
                                    ctx.DBConnection.CommitTransaction();
                                    continue;
                                }

                                // This variable defines if the transaction is rolledback then continue with next transaction header.
                                bool shouldRollbackTransaction = false;

                                // Save the transactions here..
                                foreach (ExpenseTransaction expTrxInMainTrx in trxHdrRequest.transactions)
                                {
                                    List<ExpenseTransaction> tempListExpenseTransactions = new List<ExpenseTransaction>();
                                    ExpenseTransaction tempExpTrxAfterSave = new ExpenseTransaction();

                                    // Clear the transactions list or it will send the transactions again for saving.
                                    tempListExpenseTransactions.Clear();
                                    tempListExpenseTransactions.Add(expTrxInMainTrx);

                                    ExpenseTransactionDAO<ExpenseTransaction> expTrxDAO = new ExpenseTransactionDAO<ExpenseTransaction>(ctx);
                                    List<ExpenseTransaction> tempExpListAfterSave = expTrxDAO.SaveAndGet(tempListExpenseTransactions);

                                    if (tempExpListAfterSave != null && tempExpListAfterSave.Count > 0)
                                    {
                                        tempExpTrxAfterSave = tempExpListAfterSave[0];
                                    }


                                    if (tempExpTrxAfterSave != null)
                                    {
                                        if (tempExpTrxAfterSave.ErrorFlag > 0)
                                        {
                                            // Copying the error returned after save to the original transactions.
                                            expTrxInMainTrx.ErrorFlag = tempExpTrxAfterSave.ErrorFlag;
                                            expTrxInMainTrx.ErrorCode = tempExpTrxAfterSave.ErrorCode;
                                            expTrxInMainTrx.ErrorDescription = tempExpTrxAfterSave.ErrorDescription;

                                            // Assigning the original transaction header to the after saved transaction in case of error 
                                            // as needed to send the original transaction header back to app.
                                            tempExpTrxAfterSave = expTrxInMainTrx;
                                            isError = true;
                                        }

                                        tempListExpenseTransactionsForReturn.Add(tempExpTrxAfterSave);
                                    }


                                    if (isError)
                                    {
                                        shouldRollbackTransaction = true;
                                        //break;
                                    }
                                }

                                if (shouldRollbackTransaction == true)
                                {
                                    ctx.DBConnection.RollbackTransaction();
                                    trxHdrRequest.transactions = tempListExpenseTransactionsForReturn;
                                    listForResponse.Add(trxHdrRequest);
                                    continue;
                                }
                                else
                                {
                                    tempTrxHdrAfterSave.transactions = tempListExpenseTransactionsForReturn;
                                }

                                TransactionHeader tempTrxHdrForSubmit = null;
                                // After the Transaction Header and its transactions have been saved, get the latest transactions
                                // and send the transactions for submit/return to server.
                                // submit if is_submit flag = 1
                                // else return to server.
                                TransactionHeaderCriteria<TransactionHeader> trxHdrCrit = new TransactionHeaderCriteria<TransactionHeader>()
                                {
                                    ResourceID = tempTrxHdrAfterSave.ResourceID,
                                    record_id = tempTrxHdrAfterSave.record_id
                                };

                                List<TransactionHeader> tempTrxGetAfterSave = trxDAO.Select(trxHdrCrit);

                                if (tempTrxGetAfterSave != null && tempTrxGetAfterSave.Count > 0)
                                {
                                    tempTrxHdrForSubmit = tempTrxGetAfterSave[0];
                                }

                                if (tempTrxHdrForSubmit != null)
                                {
                                    // Set the is_submitted flag for the newly get transactions.
                                    if (tempTrxHdrForSubmit.record_id == trxHdrRequest.record_id)
                                    {
                                        if (trxHdrRequest.is_submitted == 1)
                                        {
                                            tempTrxHdrForSubmit.is_submitted = 1;
                                            tempTrxHdrForSubmit.approver_id = trxHdrRequest.approver_id;
                                        }
                                    }

                                    if (tempTrxHdrForSubmit.is_submitted == 1)
                                    {
                                        tempTrxHdrForSubmit.ActionFlag = 5;
                                        List<TransactionHeader> newTempTrxHdr = new List<TransactionHeader>();
                                        newTempTrxHdr.Add(tempTrxHdrForSubmit);

                                        try
                                        {
                                            TransactionHeader tempTrxHdrAfterSubmit = null;

                                            List<TransactionHeader> listAfterSubmit = trxDAO.SaveAndGet(newTempTrxHdr);

                                            if (listAfterSubmit != null && listAfterSubmit.Count > 0)
                                            {
                                                tempTrxHdrAfterSubmit = listAfterSubmit[0];
                                            }


                                            if (tempTrxHdrAfterSubmit.error_flag > 0)
                                            {
                                                // Copying the error returned after save to the original header.
                                                trxHdrRequest.error_flag = tempTrxHdrAfterSubmit.error_flag;
                                                trxHdrRequest.ErrorFlag = tempTrxHdrAfterSubmit.ErrorFlag;

                                                trxHdrRequest.error_code = tempTrxHdrAfterSubmit.error_code;
                                                trxHdrRequest.ErrorCode = tempTrxHdrAfterSubmit.ErrorCode;

                                                trxHdrRequest.error_description = tempTrxHdrAfterSubmit.error_description;
                                                trxHdrRequest.ErrorDescription = tempTrxHdrAfterSubmit.ErrorDescription;

                                                tempTrxHdrAfterSave = trxHdrRequest;
                                                isError = true;
                                            }

                                            if (isError)
                                            {
                                                listForResponse.Add(tempTrxHdrAfterSave);
                                                ctx.DBConnection.RollbackTransaction();
                                                continue; //Continue to next header
                                            }
                                            else
                                            {
                                                // If there is no error in the submission then commit the transacion.
                                                ctx.DBConnection.CommitTransaction();
                                                trxHdrCrit = new TransactionHeaderCriteria<TransactionHeader>()
                                                {
                                                    ResourceID = tempTrxHdrAfterSave.ResourceID,
                                                    record_id = tempTrxHdrAfterSave.record_id
                                                };

                                                List<TransactionHeader> tempListForRet = trxDAO.Select(trxHdrCrit);

                                                if (tempListForRet != null && tempListForRet.Count > 0)
                                                {
                                                    tempTrxHdrAfterSave = tempListForRet[0];
                                                }

                                                if (trxHdrRequest.is_submitted == 1)
                                                {
                                                    if (tempTrxHdrAfterSave.record_id == tempTrxHdrAfterSave.record_id)
                                                    {
                                                        if (tempListForRet.Count == 2)
                                                        {
                                                            TransactionHeader tempTrxhdr = tempListForRet[1];
                                                            if (tempTrxhdr != null && tempTrxHdrAfterSave.record_id == tempTrxhdr.record_id && tempTrxhdr.transactions == null)
                                                            {
                                                                tempTrxHdrAfterSave.summary_flag = tempTrxhdr.summary_flag;
                                                            }
                                                        }
                                                        tempTrxHdrAfterSave.is_submitted = 1;
                                                    }
                                                }

                                                listForResponse.Add(tempTrxHdrAfterSave);
                                            }
                                        }
                                        catch (Exception ex)
                                        {
                                            if (ctx.DBConnection.IsTransactionStarted)
                                            {
                                                ctx.DBConnection.RollbackTransaction();
                                            }

                                            listForResponse.Add(trxHdrRequest);
                                            res.ResponseType = Enums.ResponseType.GeneralError;

                                            if (!ex.Message.ToLower().Contains("error"))
                                            {
                                                res.Message = "An error occured: " + ex.Message;
                                            }
                                            else
                                            {
                                                res.Message = ex.Message;
                                            }

                                            continue; //Continue to next header
                                        }
                                    } //  end of if (tempTrxHdrForSubmit.is_submitted == 1)
                                    else
                                    {
                                        listForResponse.Add(tempTrxHdrForSubmit);

                                        if (ctx.DBConnection.IsTransactionStarted)
                                        {
                                            ctx.DBConnection.CommitTransaction();
                                        }

                                    }
                                } // end of if (tempTrxHdrForSubmit != null)
                                else
                                {
                                    //Should rollback changes?
                                }

                            }
                        } // end of (tempTrxHdrAfterSave != null)
                        else
                        {
                            ctx.DBConnection.RollbackTransaction();

                            res.Message = "Something went wrong, please contact administrator.";
                            res.ResponseType = Enums.ResponseType.GeneralError;
                        }
                    } // end of foreach(TransactionHeader trxHdrRequest in request.Entities)


                    res.Entities = listForResponse;
                    res.Message = "Data Saved Successfully.";
                    res.ResponseType = Enums.ResponseType.Success;
                }
                else
                {
                    res.Message = authString;
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }


            }
            catch (AppException ex)
            {
                if (ctx != null)
                {
                    if (ctx.DBConnection != null && ctx.DBConnection.IsTransactionStarted)
                    {
                        ctx.DBConnection.RollbackTransaction();
                    }
                }
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                if (ctx != null)
                {
                    if (ctx.DBConnection != null && ctx.DBConnection.IsTransactionStarted)
                    {
                        ctx.DBConnection.RollbackTransaction();
                    }
                }
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }
            finally
            {
                if (ctx.DBConnection != null && ctx.DBConnection.IsTransactionStarted)
                {
                    ctx.DBConnection.RollbackTransaction();
                    ctx.DBConnection.Close();
                }
            }

            return res;
        }

        public Response<TransactionHeader> SetExpenseTransaction(Request<ExpenseTransaction> request)
        {
            Response<TransactionHeader> res = new Response<TransactionHeader>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

                    ExpenseTransactionDAO<ExpenseTransaction> trxDAO = new ExpenseTransactionDAO<ExpenseTransaction>(ctx);
                    List<ExpenseTransaction> retList = trxDAO.SaveAndGet(request.Entities);

                    if (retList.Count > 0)
                    {
                        if (retList[0].ErrorFlag > 0)
                        {
                            TransactionHeader fakeTrxHdrToRtrn = new TransactionHeader();
                            fakeTrxHdrToRtrn.transactions = new List<ExpenseTransaction>();
                            fakeTrxHdrToRtrn.transactions.Add(request.Entities[0]);
                            List<TransactionHeader> retListHdr = new List<TransactionHeader>();
                            retListHdr.Add(fakeTrxHdrToRtrn);

                            res.Entities = retListHdr;
                            res.Message = "Data Saved Successfully.";
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                        else
                        {
                            TransactionHeaderCriteria<TransactionHeader> hdrCrit = new TransactionHeaderCriteria<TransactionHeader>();
                            TransactionHeaderDAO<TransactionHeader> hdrDAO = new TransactionHeaderDAO<TransactionHeader>(ctx);

                            hdrCrit.record_id = request.Entities[0].record_id;
                            hdrCrit.ResourceID = request.Entities[0].ResourceID;

                            List<TransactionHeader> retListHdr = hdrDAO.Select(hdrCrit);

                            if (retListHdr != null && retListHdr.Count > 0)
                            {
                                retListHdr[0].transactions = null;
                            }

                            res.Entities = retListHdr;
                            res.Message = "Data Saved Successfully.";
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                    }
                    else
                    {
                        res.Message = "Data was already changed.";
                        res.ResponseType = Enums.ResponseType.GeneralError;
                    }


                }
                else
                {
                    res.Message = authString;
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {

                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }

        // This method is especially for Android as it requires the Response to be of Type ExpenseTransaction
        public Response<ExpenseTransaction> SetExpenseTransactionForAndroid(Request<ExpenseTransaction> request)
        {
            Response<ExpenseTransaction> res = new Response<ExpenseTransaction>();
            List<ExpenseTransaction> retList = null;
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));
                    //foreach (ExpenseTransaction trxFromReq in request.Entities)
                    //{
                    //    ExpenseTransactionDAO<ExpenseTransaction> trxDAO = new ExpenseTransactionDAO<ExpenseTransaction>(ctx);
                    //    List<ExpenseTransaction> tempListAfterSave = null;
                    //    List<ExpenseTransaction> tempListForSave = new List<ExpenseTransaction>();
                    //    tempListForSave.Add(trxFromReq);

                    //    tempListAfterSave = trxDAO.SaveAndGet(tempListForSave);

                    //    if (tempListAfterSave != null && tempListAfterSave.Count > 0)
                    //    {
                    //        if (tempListAfterSave[0].ErrorFlag > 0)
                    //        {

                    //        }
                    //    }


                    //}
                    ExpenseTransactionDAO<ExpenseTransaction> trxDAO = new ExpenseTransactionDAO<ExpenseTransaction>(ctx);
                    retList = trxDAO.SaveAndGet(request.Entities);

                    if (retList != null && retList.Count > 0)
                    {
                        if (retList[0].ErrorFlag > 0)
                        {
                            //TransactionHeader fakeTrxHdrToRtrn = new TransactionHeader();
                            //fakeTrxHdrToRtrn.transactions = new List<ExpenseTransaction>();
                            //fakeTrxHdrToRtrn.transactions.Add(request.Entities[0]);
                            //List<TransactionHeader> retListHdr = new List<TransactionHeader>();
                            //retListHdr.Add(fakeTrxHdrToRtrn);

                            res.Entities = retList;
                            res.Message = "Data Saved Successfully.";
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                        else
                        {
                            TransactionHeaderCriteria<TransactionHeader> hdrCrit = new TransactionHeaderCriteria<TransactionHeader>();
                            TransactionHeaderDAO<TransactionHeader> hdrDAO = new TransactionHeaderDAO<TransactionHeader>(ctx);

                            hdrCrit.record_id = request.Entities[0].record_id;
                            hdrCrit.ResourceID = request.Entities[0].ResourceID;

                            List<TransactionHeader> retListHdr = hdrDAO.Select(hdrCrit);

                            if (retListHdr != null && retListHdr.Count > 0)
                            {
                                retList[0].hdr_timestamp = retListHdr[0].timestamp;
                                retList[0].hdr_amount = retListHdr[0].amount;
                                retList[0].hdr_date_from = retListHdr[0].str_date_from;
                                retList[0].hdr_date_to = retListHdr[0].str_date_to;
                            }

                            res.Entities = retList;
                            res.Message = "Data Saved Successfully.";
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                    }
                    else
                    {
                        res.Message = "Data was already changed";
                        res.ResponseType = Enums.ResponseType.GeneralError;
                    }


                }
                else
                {
                    res.Message = authString;
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {

                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }

        public Response<ExpenseTransaction> GetExpenseImage(Request<ExpenseTransaction> request)
        {
            Response<ExpenseTransaction> res = new Response<ExpenseTransaction>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

                    string record_id = request.Entities[0].record_id;
                    string transaction_id = request.Entities[0].TransactionID;


                    var trxDetailDoc = new TransactionDetailDocument();
                    trxDetailDoc.TransactionId = transaction_id;
                    trxDetailDoc.UploadedBy = request.Entities[0].ResourceID;
                    bool IsUrl = false;
                    TransactionDetailDocumentCriteria<TransactionDetailDocument> docCriteria = new TransactionDetailDocumentCriteria<TransactionDetailDocument>(trxDetailDoc);
                    DocumentService<TransactionDetailDocument> docService = new DocumentService<TransactionDetailDocument>(ctx);
                    string imageData = docService.GetDocument(docCriteria, ctx.ESMDocumentPath, ref IsUrl);

                    //string imageData = Utilities.Utility.GetExpenseTransactionImage(ctx.ESMDocumentPath, ctx.ComapnyCode, record_id, transaction_id);

                    if (!string.IsNullOrEmpty(imageData))
                    {
                        List<ExpenseTransaction> responseList = new List<ExpenseTransaction>();
                        ExpenseTransactionDAO<ExpenseTransaction> trxDAO = new ExpenseTransactionDAO<ExpenseTransaction>(ctx);
                        ExpenseTransaction trxAfterSave = null;

                        try
                        {
                            trxAfterSave = trxDAO.SetTheFileChangedFlag(record_id, transaction_id, 0);

                            if (trxAfterSave != null)
                            {
                                trxAfterSave.ActionFlag = 6; // Just for android to find out that this call was for image get only.
                                //3A. 20181119 : PDF support added.
                                if (IsUrl == true)
                                {
                                    trxAfterSave.attachment_url = string.Format("{0}/{1}", ctx.WebURL, imageData);
                                }
                                else
                                {
                                    trxAfterSave.image_data = imageData;
                                }
                                trxAfterSave.IsImageChanged = 0;
                                trxAfterSave.IsFileAttached = 1;

                                responseList.Add(trxAfterSave);
                                res.Entities = responseList;
                            }
                            else
                            {
                                res.Entities = request.Entities;
                                res.Entities[0].ErrorFlag = 1;
                                res.Entities[0].ErrorCode = 2;
                                res.Entities[0].ErrorDescription = "Could not get the Image file.";
                            }
                        }
                        catch (AppException ex)
                        {
                            res.Entities = request.Entities;
                            res.Entities[0].ErrorFlag = 1;
                            res.Entities[0].ErrorCode = 2;
                            res.Entities[0].ErrorDescription = ex.Message;
                        }
                        catch (Exception ex)
                        {
                            res.Entities = request.Entities;
                            res.Entities[0].ErrorFlag = 1;
                            res.Entities[0].ErrorCode = 2;
                            res.Entities[0].ErrorDescription = ex.Message;
                        }


                    }
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }


        public Response<ExpenseReportAttachment> GetExpenseReportAttachment(Request<ExpenseReportAttachment> request)
        {
            Response<ExpenseReportAttachment> res = new Response<ExpenseReportAttachment>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

                    string record_id = request.Entities[0].record_id; // request.Entities[0].record_id;
                    string file_url = "";
                    string imageData = Utilities.Utility.GetExpenseReportAttachment(ctx.ESMDocumentPath, ctx.ComapnyCode, record_id, out file_url);

                    if (!string.IsNullOrEmpty(imageData))
                    {
                        List<ExpenseReportAttachment> responseList = new List<ExpenseReportAttachment>();
                        ExpenseReportAttachmentDAO<ExpenseReportAttachment> trxDAO = new ExpenseReportAttachmentDAO<ExpenseReportAttachment>(ctx);
                        ExpenseReportAttachment trxAfterSave = new ExpenseReportAttachment();

                        try
                        {
                            if (trxAfterSave != null)
                            {
                                if (imageData == "Not an image file")
                                {
                                    trxAfterSave.image_data = "";
                                    trxAfterSave.is_image_file = 0;
                                    trxAfterSave.file_url = file_url;
                                }
                                else
                                {
                                    trxAfterSave.image_data = imageData;
                                    trxAfterSave.is_image_file = 1;
                                    trxAfterSave.file_url = "";
                                }



                                responseList.Add(trxAfterSave);
                                res.Entities = responseList;
                            }
                            else
                            {
                                res.Entities = request.Entities;
                                res.Entities[0].ErrorFlag = 1;
                                res.Entities[0].ErrorCode = 2;
                                res.Entities[0].ErrorDescription = "Could not get the Image file.";
                            }
                        }
                        catch (AppException ex)
                        {
                            res.Entities = request.Entities;
                            res.Entities[0].ErrorFlag = 1;
                            res.Entities[0].ErrorCode = 2;
                            res.Entities[0].ErrorDescription = ex.Message;
                        }
                        catch (Exception ex)
                        {
                            res.Entities = request.Entities;
                            res.Entities[0].ErrorFlag = 1;
                            res.Entities[0].ErrorCode = 2;
                            res.Entities[0].ErrorDescription = ex.Message;
                        }


                    }
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }

        //public Response<TransactionHeader> SubmitReport(Request<TransactionHeader> request)
        //{
        //    Response<TransactionHeader> res = new Response<TransactionHeader>();
        //    NexContext ctx = null;

        //    try
        //    {
        //        string authString = VerifyAuthenticationParameters(request.Authentication);
        //        string errorMsg = "The following Report(s) could not be submitted: \n";
        //        bool isError = false;
        //        List<string> tempRecIDs = new List<string>();

        //        if (string.IsNullOrEmpty(authString))
        //        {
        //            string tempPass = request.Authentication.Password;
        //            //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
        //            //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

        //            //request.Authentication.Password = tempPass;

        //            tempPass = request.Authentication.AuthenticationKey;
        //            TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
        //            tempPass = TwofishAlgorithm.eEncrypt(tempPass);

        //            request.Authentication.AuthenticationKey = tempPass;

        //            ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));

        //            //Save the transactions here..
        //            foreach (TransactionHeader trxHdr in request.Entities)
        //            {
        //                TransactionHeaderDAO<TransactionHeader> trxHdrDAO = new TransactionHeaderDAO<TransactionHeader>(ctx);
        //                TransactionHeader retHdr = trxHdrDAO.SubmitReport(trxHdr);

        //                if (retHdr.error_flag > 0)
        //                {
        //                    errorMsg = "'" + retHdr.report_name + "',";
        //                }
        //                else
        //                {
        //                    tempRecIDs.Add(retHdr.record_id);
        //                }

        //            }

        //            if (isError)
        //            {
        //                res.Message = errorMsg;
        //                res.Entities = request.Entities;
        //                res.ResponseType = Enums.ResponseType.SQLError;                        
        //            }
        //            else
        //            {
        //                res.Entities = trxDAO.Select(trxHdrCrit);
        //                res.Message = "Data Saved Successfully.";
        //                res.ResponseType = Enums.ResponseType.Success;
        //            }
        //        }
        //        else
        //        {
        //            res.Message = authString;
        //            res.ResponseType = Enums.ResponseType.GeneralError;
        //        }
        //    }
        //    catch (AppException ex)
        //    {
        //        ctx.DBConnection.RollbackTransaction();
        //        if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
        //        {
        //            res.ResponseType = Enums.ResponseType.SQLError;
        //            if (!ex.Message.ToLower().Contains("error"))
        //            {
        //                res.Message = "An SQL error occured: " + ex.Message;
        //            }
        //            else
        //            {
        //                res.Message = ex.Message;
        //            }
        //        }
        //        else
        //        {
        //            res.ResponseType = Enums.ResponseType.GeneralError;

        //            if (!ex.Message.ToLower().Contains("error"))
        //            {
        //                res.Message = "An error occured: " + ex.Message;
        //            }
        //            else
        //            {
        //                res.Message = ex.Message;
        //            }
        //        }


        //    }
        //    catch (Exception ex)
        //    {
        //        ctx.DBConnection.RollbackTransaction();
        //        res.ResponseType = Enums.ResponseType.GeneralError;
        //        if (!ex.Message.ToLower().Contains("error"))
        //        {
        //            res.Message = "An error occured: " + ex.Message;
        //        }
        //        else
        //        {
        //            res.Message = ex.Message;
        //        }
        //    }

        //    return res;
        //}

        /// <summary>
        /// Verify the Authentication parameters sent from Request
        /// </summary>
        /// <param name="auth">Authentication object</param>
        /// <returns>Error Message</returns>
        private string VerifyAuthenticationParameters(Authentication auth)
        {
            string retVal = "";

            if (!string.IsNullOrEmpty(auth.AuthenticationKey))
            {
                if (!string.IsNullOrEmpty(auth.LoginID))
                {
                    if (string.IsNullOrEmpty(auth.Password))
                    {
                        retVal = "Please provide the password to continue.";
                    }
                }
                else
                {
                    retVal = "Please provide the Login ID to continue.";
                }

            }
            else
            {
                retVal = "Please provide the Authentication Key to continue.";
            }

            return retVal;
        }

        private SubscriberInfo GetSubscriberInfo(string deviceInfo)
        {
            SubscriberInfo subInfo = new SubscriberInfo();

            try
            {
                if (deviceInfo != "")
                {
                    string[] subInfoStr = deviceInfo.Split('|');

                    //// HAMZA -- 20151217 -- APP Version added in the subscriber info.
                    //if (subInfoStr.Length != 7)
                    //{
                    //    throw new Exception(string.Format("Invalid device info \"{0}\", it should be \"make|model|OSVersion|Product number|Locale|timezone|AppVersion\".", deviceInfo));
                    //}
                    subInfo.Make = subInfoStr[0];
                    subInfo.Model = subInfoStr[1];
                    subInfo.OSVersion = subInfoStr[2];
                    subInfo.ProductNumber = subInfoStr[3];
                    subInfo.Locale = subInfoStr[4];
                    subInfo.TimeZone = subInfoStr[5];
                    subInfo.AppVersion = subInfoStr.Length > 6 ? subInfoStr[6] : "";
                }
            }
            catch (Exception ex)
            {
                Logger.Log(ex.StackTrace, LogLevelType.DEBUG);
                throw ex;
            }

            return subInfo;
        }


        public Response<T> SetCCExpenseTransaction(Request<T> request)
        {


            Response<T> res = new Response<T>();
            NexContext ctx = null;
            //bool isUpdated = false;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));


                    Repository<T> resRepository = new Repository<T>(ctx);

                    List<T> responseEntitites = resRepository.SaveAndGet(request.Entities);

                    res.Entities = responseEntitites;

                    if (responseEntitites.Where(x => x.ErrorCode == 0).Count() > 0)
                    {
                        res.Message = "Data saved successfully.";
                        res.ResponseType = Enums.ResponseType.Success;
                    }
                    else if(responseEntitites.Where(x => x.ErrorCode == -1).Count() > 0)
                    {
                        res.Message = "Data was already changed.";
                        res.ResponseType = Enums.ResponseType.Success;
                    }
                    else if(responseEntitites.Where(x => x.ErrorCode == -1).Count() > 0)
                    {
                        res.Message = "Failed to save the CC Expense Transaction.";
                        res.ResponseType = Enums.ResponseType.Success;
                    }


                }
                else
                {
                    res.Message = authString.Trim();
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    res.Message = ex.Message.Trim();

                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;
                    res.Message = ex.Message.Trim();

                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                res.Message = ex.Message.Trim();

            }

            return res;
        }

        public Response<T> SetTimeExpenseApproval(Request<T> request)
        {
            Response<T> res = new Response<T>();
            NexContext ctx = null;
            //bool isUpdated = false;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;
                    //TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    //tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    //request.Authentication.Password = tempPass;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    ctx = NexContext.AuthenticateUser(request.Authentication, GetSubscriberInfo(request.DeviceInfo));


                    Repository<T> resRepository = new Repository<T>(ctx);

                    List<T> responseEntitites = resRepository.SaveAndGet(request.Entities);
                    res.Entities = responseEntitites;

                    if (responseEntitites.Where(x => x.ErrorFlag == 1).Count() == 0)
                    {
                        res.Message = "Data saved successfully.";
                        res.ResponseType = Enums.ResponseType.Success;
                    }
                    else
                    {
                        res.Message = "Data was already changed.";
                        res.ResponseType = Enums.ResponseType.Success;
                    }


                }
                else
                {
                    res.Message = authString.Trim();
                    res.ResponseType = Enums.ResponseType.GeneralError;
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    res.Message = ex.Message.Trim();

                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;
                    res.Message = ex.Message.Trim();

                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                res.Message = ex.Message.Trim();

            }

            return res;
        }

        public Response<T> TestImageSaving(Request<T> request)
        {
            Response<T> res = new Response<T>();
            res.Message = request.SearchCriteria.ToString();
            List<T> resList = null;
            res.Entities = resList;
            res.ResponseType = Enums.ResponseType.Success;



            return res;
        }


        public Response<PushNotification> SaveDeviceToken(Request<PushNotification> request)
        {
            Response<PushNotification> res = new Response<PushNotification>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    SubscriberInfo subscriberInfo = GetSubscriberInfo(request.DeviceInfo);
                    ctx = NexContext.AuthenticateUser(request.Authentication, subscriberInfo);

                    List<PushNotification> responseList = new List<PushNotification>();
                    PushNotificationDAO<PushNotification> trxDAO = new PushNotificationDAO<PushNotification>(ctx);

                    try
                    {
                        request.Entities[0].product_number = subscriberInfo.ProductNumber;
                        bool retVal = trxDAO.Save(request.Entities[0]);
                        if (retVal)
                        {
                            res.Entities = request.Entities;
                        }
                        else
                        {
                            res.Entities = request.Entities;
                            res.Entities[0].ErrorFlag = 1;
                            res.Entities[0].ErrorCode = 2;
                            res.Entities[0].ErrorDescription = "Could not save device token";
                        }
                    }
                    catch (AppException ex)
                    {
                        res.Entities = request.Entities;
                        res.Entities[0].ErrorFlag = 1;
                        res.Entities[0].ErrorCode = 2;
                        res.Entities[0].ErrorDescription = ex.Message;
                    }
                    catch (Exception ex)
                    {
                        res.Entities = request.Entities;
                        res.Entities[0].ErrorFlag = 1;
                        res.Entities[0].ErrorCode = 2;
                        res.Entities[0].ErrorDescription = ex.Message;
                    }
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }

        public Response<Notification> GetLatestPushNotifications(Request<Notification> request)
        {
            Response<Notification> res = new Response<Notification>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    SubscriberInfo subscriberInfo = GetSubscriberInfo(request.DeviceInfo);
                    ctx = NexContext.AuthenticateUser(request.Authentication, subscriberInfo);

                    NotificationCriteria<Notification> notificationCriteria = new NotificationCriteria<Notification>();
                    List<Notification> responseList = new List<Notification>();
                    NotificationDAO<Notification> notificationDAO = new NotificationDAO<Notification>(ctx);
                    if (request.Entities == null)
                        throw new Exception("Entities not defined.");

                    if(request.Entities[0].resource_id != null)
                    {
                        notificationCriteria.ResourceID = request.Entities[0].resource_id;
                    }else
                    {
                        notificationCriteria.ResourceID = "";
                    }

                    if (request.Entities[0].mode != null)
                    {
                        notificationCriteria.Mode = request.Entities[0].mode;
                    }
                    else
                    {
                        notificationCriteria.Mode = "";
                    }

                    if (request.Entities[0].notification_id != null)
                    {
                        notificationCriteria.NotificationID = request.Entities[0].notification_id;
                    }
                    else
                    {
                        notificationCriteria.NotificationID = "";
                    }

                    try
                    {
                        List<Notification> resList = notificationDAO.GetNotificationsList(notificationCriteria);

                        if (resList != null)
                        {
                            res.Entities = resList;
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                        else
                        {
                            res.Entities = resList;
                            res.Message = "Something went wrong, please contact administrator";
                            res.ResponseType = Enums.ResponseType.GeneralError;
                        }
                    }
                    catch (AppException ex)
                    {
                        res.Entities = request.Entities;
                        res.Entities[0].ErrorFlag = 1;
                        res.Entities[0].ErrorCode = 2;
                        res.Entities[0].ErrorDescription = ex.Message;
                    }
                    catch (Exception ex)
                    {
                        res.Entities = request.Entities;
                        res.Entities[0].ErrorFlag = 1;
                        res.Entities[0].ErrorCode = 2;
                        res.Entities[0].ErrorDescription = ex.Message;
                    }
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }

        public Response<Notification> UpdatePushNotification(Request<Notification> request)
        {
            Response<Notification> res = new Response<Notification>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    SubscriberInfo subscriberInfo = GetSubscriberInfo(request.DeviceInfo);
                    ctx = NexContext.AuthenticateUser(request.Authentication, subscriberInfo);

                    NotificationCriteria<Notification> notificationCriteria = new NotificationCriteria<Notification>();
                    List<Notification> responseList = new List<Notification>();
                    NotificationDAO<Notification> notificationDAO = new NotificationDAO<Notification>(ctx);
                    if (request.Entities == null)
                        throw new Exception("Entities not defined.");

                    if (request.Entities[0].resource_id != null)
                    {
                        notificationCriteria.ResourceID = request.Entities[0].resource_id;
                    }
                    else
                    {
                        notificationCriteria.ResourceID = "";
                    }

                    if (request.Entities[0].mode != null)
                    {
                        notificationCriteria.Mode = request.Entities[0].mode;
                    }
                    else
                    {
                        notificationCriteria.Mode = "";
                    }

                    if (request.Entities[0].notification_id != null)
                    {
                        notificationCriteria.NotificationID = request.Entities[0].notification_id;
                    }
                    else
                    {
                        notificationCriteria.NotificationID = "";
                    }

                    notificationCriteria.Keys = request.Entities[0].Keys;

                    try
                    {
                        List<Notification> resList = notificationDAO.UpdatePushNotification(notificationCriteria);

                        if (resList != null)
                        {
                            res.Entities = resList;
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                        else
                        {
                            res.Entities = resList;
                            res.Message = "Something went wrong, please contact administrator";
                            res.ResponseType = Enums.ResponseType.GeneralError;
                        }
                    }
                    catch (AppException ex)
                    {
                        res.Entities = request.Entities;
                        res.Entities[0].ErrorFlag = 1;
                        res.Entities[0].ErrorCode = 2;
                        res.Entities[0].ErrorDescription = ex.Message;
                    }
                    catch (Exception ex)
                    {
                        res.Entities = request.Entities;
                        res.Entities[0].ErrorFlag = 1;
                        res.Entities[0].ErrorCode = 2;
                        res.Entities[0].ErrorDescription = ex.Message;
                    }
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }
        public Response<Rule> SetRule(Request<Rule> request)
        {
            Response<Rule> res = new Response<Rule>();
            NexContext ctx = null;

            try
            {
                string authString = VerifyAuthenticationParameters(request.Authentication);

                if (string.IsNullOrEmpty(authString))
                {
                    string tempPass = request.Authentication.Password;

                    tempPass = request.Authentication.AuthenticationKey;
                    TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                    tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                    request.Authentication.AuthenticationKey = tempPass;

                    SubscriberInfo subscriberInfo = GetSubscriberInfo(request.DeviceInfo);
                    ctx = NexContext.AuthenticateUser(request.Authentication, subscriberInfo);
                    
                    List<Rule> responseList = new List<Rule>();

                    RuleDAO<Rule> ruleDAO = new RuleDAO<Rule>(ctx);

                    try
                    {
                        var response = ruleDAO.Save(request.Entities.FirstOrDefault());

                        if (response)
                        {
                            res.Entities = request.Entities;
                            res.ResponseType = Enums.ResponseType.Success;
                        }
                        else
                        {
                            res.Entities = request.Entities;
                            res.Message = "Something went wrong, please contact administrator";
                            res.ResponseType = Enums.ResponseType.GeneralError;
                        }
                    }
                    catch (AppException ex)
                    {
                        res.Entities = request.Entities;
                        res.Entities[0].ErrorFlag = 1;
                        res.Entities[0].ErrorCode = 2;
                        res.Entities[0].ErrorDescription = ex.Message;
                    }
                    catch (Exception ex)
                    {
                        res.Entities = request.Entities;
                        res.Entities[0].ErrorFlag = 1;
                        res.Entities[0].ErrorCode = 2;
                        res.Entities[0].ErrorDescription = ex.Message;
                    }
                }
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.SQLERROR)
                {
                    res.ResponseType = Enums.ResponseType.SQLError;
                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An SQL error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }
                else
                {
                    res.ResponseType = Enums.ResponseType.GeneralError;

                    if (!ex.Message.ToLower().Contains("error"))
                    {
                        res.Message = "An error occured: " + ex.Message;
                    }
                    else
                    {
                        res.Message = ex.Message;
                    }
                }


            }
            catch (Exception ex)
            {
                res.ResponseType = Enums.ResponseType.GeneralError;
                if (!ex.Message.ToLower().Contains("error"))
                {
                    res.Message = "An error occured: " + ex.Message;
                }
                else
                {
                    res.Message = ex.Message;
                }
            }

            return res;
        }
        public void CheckForNotificationsInDatabase()
        {
            //PushNotificationDAO<PushNotification> trxDAO = new PushNotificationDAO<PushNotification>(ctx);
        }
    }
}
