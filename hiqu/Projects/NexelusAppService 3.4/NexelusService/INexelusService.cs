using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using static NexelusService.NexelusService;

namespace NexelusService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]        
    public interface INexelusService
    {
        /// <summary>
        /// Ping to check if the service is running
        /// </summary>
        /// <returns>String "Success"</returns>
        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "Ping", ResponseFormat = WebMessageFormat.Json)]
        string Ping(); 
        
        /// <summary>
        /// Login and return the resource
        /// </summary>
        /// <param name="request">Request of type Resource</param>
        /// <returns>Response of type Resource</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Login", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Resource> Login(Request<Resource> request);

        //[OperationContract]
        //[WebInvoke(Method = "GET", UriTemplate = "Test", ResponseFormat = WebMessageFormat.Json)]
        //Test Test();

        /// <summary>
        /// Change the password
        /// </summary>
        /// <param name="request">Request of type Resource</param>
        /// <returns>Response of type Resource</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ChangePassword", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Resource> ChangePassword(Request<Resource> request);
        
        /// <summary>
        /// Load all the Level2s
        /// </summary>
        /// <param name="request">Request of type Level2</param>
        /// <returns>Response of type Level2</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Level2/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Level2> LoadLevel2(Request<Level2> request);

        /// <summary>
        /// Load all the Level3s of corresponding Level2s
        /// </summary>
        /// <param name="request">Request of type Level3</param>
        /// <returns>Response of type Level3</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Level3/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Level3> LoadLevel3(Request<Level3> request);

        /// <summary>
        /// Load the Level2 Customers
        /// </summary>
        /// <param name="request">Request of type Level2Customer</param>
        /// <returns>Response of type Level2Customer</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Level2Customer/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Level2Customer> LoadLevel2Customer(Request<Level2Customer> request);

        /// <summary>
        /// Load all the Locations
        /// </summary>
        /// <param name="request">Request of type Location</param>
        /// <returns>Response of type Location</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Location/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Location> LoadLocation(Request<Location> request);

        /// <summary>
        /// Load all the OrgUnits
        /// </summary>
        /// <param name="request">Request of type OrgUnit</param>
        /// <returns>Response of type OrgUnit</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "OrgUnit/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<OrgUnit> LoadOrgUnit(Request<OrgUnit> request);

        /// <summary>
        /// Load the Permanent Lines
        /// </summary>
        /// <param name="request">Request of type PermanantLine</param>
        /// <returns>Response of type PermanentLine</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "PermanentLine/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<PermanentLine> LoadPermanentLine(Request<PermanentLine> request);

        /// <summary>
        /// Set the Permanent Lines
        /// </summary>
        /// <param name="request">Request of type PermanantLine</param>
        /// <returns>Response of type PermanentLine</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "PermanentLine/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<PermanentLine> SetPermanentLine(Request<PermanentLine> request);

        /// <summary>
        /// Set the Resource
        /// </summary>
        /// <param name="request">Request of type Resource</param>
        /// <returns>Response of type Resource</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Resource/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Resource> SetResource(Request<Resource> request);

        /// <summary>
        /// Get all the Work Functions
        /// </summary>
        /// <param name="request">Request of type ResUsage</param>
        /// <returns>Response of type ResUsage</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ResUsage/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ResUsage> LoadResUsage(Request<ResUsage> request);

        /// <summary>
        /// Load all the tasks
        /// </summary>
        /// <param name="request">Request of type Task</param>
        /// <returns>Response of type Task</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Task/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Task> LoadTask(Request<Task> request);

        
        /// <summary>
        /// Load the Transactions
        /// </summary>
        /// <param name="request">Request of type Transaction</param>
        /// <returns>Response of type Transaction</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Transaction/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Transaction> LoadTransaction(Request<Transaction> request);

        /// <summary>
        /// Set the transactions
        /// </summary>
        /// <param name="request">Request of type Transaction</param>
        /// <returns>Response of type Transaction</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Transaction/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Transaction> SetTransaction(Request<Transaction> request);

        /// <summary>
        /// Load the SysNames
        /// </summary>
        /// <param name="request">Request of type SysNames</param>
        /// <returns>Response of type SysNames</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "SysNames/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<SysNames> LoadSysNames(Request<SysNames> request);

        /// <summary>
        /// Load the User Settings
        /// </summary>
        /// <param name="request">Request of type UserSettings</param>
        /// <returns>Response of type UserSetting</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "UserSetting/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<UserSetting> LoadUserSetting(Request<UserSetting> request);

        ////////////////////////////////// NEW METHODS FOR EXPENSE REPORT STARTS HERE ///////////////////////////////////

        /// <summary>
        /// Load the Exp Rpt Approvers
        /// </summary>
        /// <param name="request">Request of type Approvers</param>
        /// <returns>Response of type Approvers</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Approvers/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Approver> LoadApprovers(Request<Approver> request);

        /// <summary>
        /// Load the CostCodes
        /// </summary>
        /// <param name="request">Request of type CostCodes</param>
        /// <returns>Response of type CostCodes</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "CostCodes/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<CostCodes> LoadCostCodes(Request<CostCodes> request);

        /// <summary>
        /// Load the CreditCard Expenses
        /// </summary>
        /// <param name="request">Request of type CreditCardExpense</param>
        /// <returns>Response of type CreditCardExpense</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "CreditCardExpense/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<CreditCardExpense> LoadCreditCardExpense(Request<CreditCardExpense> request);


        /// <summary>
        /// Split/Merge/Remove CC Trx
        /// </summary>
        /// <param name="request">Request of type CreditCardExpense</param>
        /// <returns>Response of type CreditCardExpense</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "CreditCardExpense/Save", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<CreditCardExpense> SaveCCTransaction(Request<CreditCardExpense> request);

        /// <summary>
        /// Load the Currencies
        /// </summary>
        /// <param name="request">Request of type Currencies</param>
        /// <returns>Response of type Currencies</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Currencies/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Currencies> LoadCurrencies(Request<Currencies> request);

        /// <summary>
        /// Load the Expense Report Fields
        /// </summary>
        /// <param name="request">Request of type ExpenseReportFields</param>
        /// <returns>Response of type ExpenseReportFields</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ExpenseReportFields/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ExpenseReportFields> LoadExpenseReportFields(Request<ExpenseReportFields> request);

        /// <summary>
        /// Load the Expense Report Rates
        /// </summary>
        /// <param name="request">Request of type ExpenseReportRates</param>
        /// <returns>Response of type ExpenseReportRates</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ExpenseReportRates/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ExpenseReportRates> LoadExpenseReportRates(Request<ExpenseReportRates> request);

        /// <summary>
        /// Load the Multi Currency RateTyp eHeader
        /// </summary>
        /// <param name="request">Request of type MultiCurrencyRateTypeHeader</param>
        /// <returns>Response of type MultiCurrencyRateTypeHeader</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "MultiCurrencyRateTypeHeader/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<MultiCurrencyRateTypeHeader> LoadMultiCurrencyRateTypeHeader(Request<MultiCurrencyRateTypeHeader> request);

        /// <summary>
        /// Load the Multi Currency RateType Detail
        /// </summary>
        /// <param name="request">Request of type MultiCurrencyRateTypeDetail</param>
        /// <returns>Response of type MultiCurrencyRateTypeDetail</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "MultiCurrencyRateTypeDetail/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<MultiCurrencyRateTypeDetail> LoadMultiCurrencyRateTypeDetail(Request<MultiCurrencyRateTypeDetail> request);

        /// <summary>
        /// Load the Transaction Expenses
        /// </summary>
        /// <param name="request">Request of type TransactionExpense</param>
        /// <returns>Response of type TransactionExpense</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "TransactionExpense/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<TransactionExpense> LoadTransactionExpense(Request<TransactionExpense> request);

        /// <summary>
        /// Load the Expense Report
        /// </summary>
        /// <param name="request">Request of type ExpenseReport</param>
        /// <returns>Response of type ExpenseReport</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "TransactionHeader/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<TransactionHeader> LoadExpenseReport(Request<TransactionHeader> request);

        /// <summary>
        /// Load the Expense Report
        /// </summary>
        /// <param name="request">Request of type ExpenseReport</param>
        /// <returns>Response of type ExpenseReport</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "TransactionHeader/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<TransactionHeader> SaveExpenseReport(Request<TransactionHeader> request);

        ///// <summary>
        ///// Save ExpenseReportForAndroid Only, The IOs version was implemented differently then the android version.
        ///// </summary>
        ///// <param name="request">Request of type ExpenseReport</param>
        ///// <returns>Response of type ExpenseReport</returns>
        //[OperationContract]
        //[WebInvoke(Method = "POST", UriTemplate = "TransactionHeaderAndroid/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        //Response<TransactionHeader> SaveExpenseReportForAndroid(Request<TransactionHeader> request);

        /// <summary>
        /// Load the Expense Report
        /// </summary>
        /// <param name="request">Request of type ExpenseReport</param>
        /// <returns>Response of type ExpenseReport</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ExpenseTransaction/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ExpenseTransaction> GetExpenseTransactions(Request<ExpenseTransaction> request);

        /// <summary>
        /// Set the Expense Transaction
        /// </summary>
        /// <param name="request">Request of type ExpenseTransaction</param>
        /// <returns>Response of type ExpenseTransaction</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ExpenseTransaction/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<TransactionHeader> SetExpenseTransaction(Request<ExpenseTransaction> request);

        /// <summary>
        /// Set the Expense Transaction (Especially for Android as it expects the same response type as of request)
        /// </summary>
        /// <param name="request">Request of type ExpenseTransaction</param>
        /// <returns>Response of type ExpenseTransaction</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ExpenseTransactionSpecial/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ExpenseTransaction> SetExpenseTransactionForAndroid(Request<ExpenseTransaction> request);

        /// <summary>
        /// Load the Parser Keyword
        /// </summary>
        /// <param name="request">Request of type ParserKeyword</param>
        /// <returns>Response of type ParserKeyword</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ParserKeywords/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ParserKeyword> LoadParserKeywords(Request<ParserKeyword> request);

        /// <summary>
        /// Set the Parser Keyword
        /// </summary>
        /// <param name="request">Request of type ParserKeyword</param>
        /// <returns>Response of type ParserKeyword</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ParserKeywords/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ParserKeyword> SetParserKeywords(Request<ParserKeyword> request);

        /// <summary>
        /// Get the EntityChange 
        /// </summary>
        /// <param name="request">Request of type EntityChange</param>
        /// <returns>Response of type EntityChange</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "EntityChange/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<EntityChange> GetEntityChange(Request<EntityChange> request);

        /// <summary>
        /// Set the EntityChange
        /// </summary>
        /// <param name="request">Request of type EntityChange</param>
        /// <returns>Response of type EntityChange</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "EntityChange/Set", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<EntityChange> SetEntityChange(Request<EntityChange> request);

        /// <summary>
        /// Set the Rules
        /// </summary>
        /// <param name="request">Request of type Rules</param>
        /// <returns>Response of type Rules</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Rules/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Rules> GetRules(Request<Rules> request);

        /// <summary>
        /// Get the ResourceTypes
        /// </summary>
        /// <param name="request">Request of type ResourceType</param>
        /// <returns>Response of type ResourceType</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ResourceTypes/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ResourceType> GetResourceType(Request<ResourceType> request);

        /// <returns>Response of type ResourceType</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "PaymentTypes/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<PaymentTypes> GetPaymentTypes(Request<PaymentTypes> request);

        /// <summary>
        /// Get the Image of transaction
        /// </summary>
        /// <param name="request">Request of type ExpenseTransaction</param>
        /// <returns>Response of type ExpenseTransaction</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ExpenseImage/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ExpenseTransaction> GetExpenseImage(Request<ExpenseTransaction> request);

        //////////////////////////////////////////// NEW METHODS FOR EXPENSE REPORT ENDS HERE /////////////////////////////////////////////

        /// <summary>
        /// Just for the testing purpose (No real use)
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "RequestTest", ResponseFormat = WebMessageFormat.Json)]
        Request<Level2> TestMethod();

        /// <summary>
        /// Just for the testing purpose (No real use)
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "ResponseTest", ResponseFormat = WebMessageFormat.Json)]        
        Response<Level2> TestMethodGetLevel2();


        /// <summary>
        /// Set Expense transaction Aprroval
        /// </summary>
        /// <param name="request">Request of type Approval</param>
        /// <returns>Response of type Approval</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Expense/Approval", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ExpenseApproval> SetExpenseApproval(Request<ExpenseApproval> request);


        /// <summary>
        /// Set time transaction Aprroval
        /// </summary>
        /// <param name="request">Request of type Approval</param>
        /// <returns>Response of type Approval</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "Time/Approval", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<TimeApproval> SetTimeApproval(Request<TimeApproval> request);





        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "TestSaveImage", ResponseFormat = WebMessageFormat.Json)]

        Response<Resource> TestSaveImage(Request<Resource> request);

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "TestSaveImage1", ResponseFormat = WebMessageFormat.Json)]

        string TestSaveImage1(TempTestingClass s);

        //Mati Change--- Get the image of expense report
        /// </summary>
        /// <param name="request">Request of type Expense Repo</param>
        /// <returns>Response of type ExpenseTransaction</returns>
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "GetExpenseReportAttachment/Get", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<ExpenseReportAttachment> GetExpenseReportAttachment(Request<ExpenseReportAttachment> request);

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "SaveDeviceToken", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<PushNotification> SaveDeviceToken(Request<PushNotification> request);

       
        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "PingNotificationService", ResponseFormat = WebMessageFormat.Json)]
        string PingNotificationService();

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "GetLatestPushNotifications", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Notification> GetLatestPushNotifications(Request<Notification> request);

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "UpdatePushNotification", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Notification> UpdatePushNotification(Request<Notification> request);
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "SetRule", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<Rule> SetRule(Request<Rule> request);

        #region OKTA
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "ValidateAuthenticationKey", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<CompanyAuthentication> ValidateAuthenticationKey(Request<CompanyAuthentication> request);

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "GetLoginCredentials", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Response<LoginInfo> GetLoginCredentials(Request<LoginInfo> request);
        #endregion
    }
}
