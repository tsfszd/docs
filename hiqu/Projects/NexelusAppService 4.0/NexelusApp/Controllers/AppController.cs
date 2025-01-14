using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Service;
using NexelusApp.Service.Utilities;

namespace NexelusApp.Controllers
{
    public class AppController : ApiController
    {
        // GET: API

        [HttpGet]
        [ActionName("Ping")]
        public string Ping()
        {
            return "Success";
        }

        [HttpPost]
        [ActionName("Login")]
        public Response<Resource> Login(Request<Resource> request)
        {

            TimesheetService<Resource> ts = new TimesheetService<Resource>();
            Response<Resource> response = ts.Load(request);
            //return JsonConvert.SerializeObject(response);
            return response;
        }

        [HttpPost]
        [ActionName("ChangePassword")]
        public Response<Resource> ChangePassword(Request<Resource> request)
        {
            TimesheetService<Resource> ts = new TimesheetService<Resource>();
            Response<Resource> response = ts.ChangePassword(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadLevel2")]

        public Response<Level2> LoadLevel2(Request<Level2> request)
        {
            try
            {
                TimesheetService<Level2> ts = new TimesheetService<Level2>();
                Response<Level2> response = ts.Load(request);

                return response;
            }
            catch (Exception)
            {

                return null;
            }


        }

        //public Test Test()
        //{
        //    Test lvl2 = new Test();

        //    return lvl2;

        //}

        [HttpPost]
        [ActionName("LoadLevel3")]
        public Response<Level3> LoadLevel3(Request<Level3> request)
        {
            TimesheetService<Level3> ts = new TimesheetService<Level3>();
            Response<Level3> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadLevel2Customer")]
        public Response<Level2Customer> LoadLevel2Customer(Request<Level2Customer> request)
        {
            TimesheetService<Level2Customer> ts = new TimesheetService<Level2Customer>();
            Response<Level2Customer> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadLocation")]
        public Response<Location> LoadLocation(Request<Location> request)
        {
            TimesheetService<Location> ts = new TimesheetService<Location>();
            Response<Location> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadOrgUnit")]
        public Response<OrgUnit> LoadOrgUnit(Request<OrgUnit> request)
        {
            TimesheetService<OrgUnit> ts = new TimesheetService<OrgUnit>();
            Response<OrgUnit> respnonse = ts.Load(request);

            return respnonse;
        }

        [HttpPost]
        [ActionName("LoadPermanentLine")]
        public Response<PermanentLine> LoadPermanentLine(Request<PermanentLine> request)
        {
            TimesheetService<PermanentLine> ts = new TimesheetService<PermanentLine>();
            Response<PermanentLine> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("SetPermanentLine")]
        public Response<PermanentLine> SetPermanentLine(Request<PermanentLine> request)
        {
            TimesheetService<PermanentLine> ts = new TimesheetService<PermanentLine>();
            Response<PermanentLine> respnonse = ts.Set(request);

            return respnonse;
        }

        [HttpPost]
        [ActionName("SetResource")]
        public Response<Resource> SetResource(Request<Resource> request)
        {
            TimesheetService<Resource> ts = new TimesheetService<Resource>();
            Response<Resource> respnonse = ts.Set(request);

            return respnonse;
        }

        [HttpPost]
        [ActionName("LoadResUsage")]
        public Response<ResUsage> LoadResUsage(Request<ResUsage> request)
        {
            TimesheetService<ResUsage> ts = new TimesheetService<ResUsage>();
            Response<ResUsage> respnonse = ts.Load(request);

            return respnonse;
        }

        [HttpPost]
        [ActionName("LoadTask")]
        public Response<Task> LoadTask(Request<Task> request)
        {
            TimesheetService<Task> ts = new TimesheetService<Task>();
            Response<Task> respnonse = ts.Load(request);

            return respnonse;
        }

        [HttpPost]
        [ActionName("LoadTransaction")]
        public Response<Transaction> LoadTransaction(Request<Transaction> request)
        {
            TimesheetService<Transaction> ts = new TimesheetService<Transaction>();
            Response<Transaction> respnonse = ts.Load(request);

            return respnonse;
        }

        [HttpPost]
        [ActionName("SetTransaction")]
        public Response<Transaction> SetTransaction(Request<Transaction> request)
        {
            //TimesheetService<Transaction> ts = new TimesheetService<Transaction>();
            //Response<Transaction> respnonse = ts.Set(request);

            //return respnonse;
            TimesheetService<Transaction> ts = new TimesheetService<Transaction>();
            Response<Transaction> respnonse = ts.SaveTransactions(request);

            return respnonse;
        }

        [HttpPost]
        [ActionName("LoadSysNames")]
        public Response<SysNames> LoadSysNames(Request<SysNames> request)
        {
            TimesheetService<SysNames> ts = new TimesheetService<SysNames>();
            Response<SysNames> respnonse = ts.Load(request);

            return respnonse;
        }

        [HttpPost]
        [ActionName("LoadUserSetting")]
        public Response<UserSetting> LoadUserSetting(Request<UserSetting> request)
        {
            TimesheetService<UserSetting> ts = new TimesheetService<UserSetting>();
            Response<UserSetting> response = ts.Load(request);

            return response;
        }

        ////////////////////////////////// NEW METHODS FOR EXPENSE REPORT STARTS HERE ///////////////////////////////////

        [HttpPost]
        [ActionName("LoadApprovers")]
        public Response<Approver> LoadApprovers(Request<Approver> request)
        {
            TimesheetService<Approver> ts = new TimesheetService<Approver>();
            Response<Approver> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadCostCodes")]
        public Response<CostCodes> LoadCostCodes(Request<CostCodes> request)
        {
            TimesheetService<CostCodes> ts = new TimesheetService<CostCodes>();
            Response<CostCodes> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadCreditCardExpense")]
        public Response<CreditCardExpense> LoadCreditCardExpense(Request<CreditCardExpense> request)
        {
            TimesheetService<CreditCardExpense> ts = new TimesheetService<CreditCardExpense>();
            Response<CreditCardExpense> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("SaveCCTransaction")]
        public Response<CreditCardExpense> SaveCCTransaction(Request<CreditCardExpense> request)
        {
            TimesheetService<CreditCardExpense> ts = new TimesheetService<CreditCardExpense>();
            Response<CreditCardExpense> response = ts.SetCCExpenseTransaction(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadCurrencies")]
        public Response<Currencies> LoadCurrencies(Request<Currencies> request)
        {
            TimesheetService<Currencies> ts = new TimesheetService<Currencies>();
            Response<Currencies> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadExpenseReportFields")]
        public Response<ExpenseReportFields> LoadExpenseReportFields(Request<ExpenseReportFields> request)
        {
            TimesheetService<ExpenseReportFields> ts = new TimesheetService<ExpenseReportFields>();
            Response<ExpenseReportFields> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadExpenseReportRates")]
        public Response<ExpenseReportRates> LoadExpenseReportRates(Request<ExpenseReportRates> request)
        {
            TimesheetService<ExpenseReportRates> ts = new TimesheetService<ExpenseReportRates>();
            Response<ExpenseReportRates> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadMultiCurrencyRateTypeHeader")]
        public Response<MultiCurrencyRateTypeHeader> LoadMultiCurrencyRateTypeHeader(Request<MultiCurrencyRateTypeHeader> request)
        {
            TimesheetService<MultiCurrencyRateTypeHeader> ts = new TimesheetService<MultiCurrencyRateTypeHeader>();
            Response<MultiCurrencyRateTypeHeader> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadMultiCurrencyRateTypeDetail")]
        public Response<MultiCurrencyRateTypeDetail> LoadMultiCurrencyRateTypeDetail(Request<MultiCurrencyRateTypeDetail> request)
        {
            TimesheetService<MultiCurrencyRateTypeDetail> ts = new TimesheetService<MultiCurrencyRateTypeDetail>();
            Response<MultiCurrencyRateTypeDetail> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadTransactionExpense")]
        public Response<TransactionExpense> LoadTransactionExpense(Request<TransactionExpense> request)
        {
            TimesheetService<TransactionExpense> ts = new TimesheetService<TransactionExpense>();
            Response<TransactionExpense> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadExpenseReport")]
        public Response<TransactionHeader> LoadExpenseReport(Request<TransactionHeader> request)
        {
            TimesheetService<TransactionHeader> ts = new TimesheetService<TransactionHeader>();
            Response<TransactionHeader> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadParserKeywords")]
        public Response<ParserKeyword> LoadParserKeywords(Request<ParserKeyword> request)
        {
            TimesheetService<ParserKeyword> ts = new TimesheetService<ParserKeyword>();
            Response<ParserKeyword> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("SetParserKeywords")]
        public Response<ParserKeyword> SetParserKeywords(Request<ParserKeyword> request)
        {
            TimesheetService<ParserKeyword> ts = new TimesheetService<ParserKeyword>();
            Response<ParserKeyword> response = ts.Set(request);

            return response;
        }

        [HttpPost]
        [ActionName("LoadRules")]
        public Response<Rules> GetRules(Request<Rules> request)
        {
            TimesheetService<Rules> ts = new TimesheetService<Rules>();
            Response<Rules> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("GetEntityChange")]
        public Response<EntityChange> GetEntityChange(Request<EntityChange> request)
        {
            TimesheetService<EntityChange> ts = new TimesheetService<EntityChange>();
            Response<EntityChange> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("SetEntityChange")]
        public Response<EntityChange> SetEntityChange(Request<EntityChange> request)
        {
            TimesheetService<EntityChange> ts = new TimesheetService<EntityChange>();
            Response<EntityChange> response = ts.Set(request);

            return response;
        }

        [HttpPost]
        [ActionName("SaveExpenseReport")]
        public Response<TransactionHeader> SaveExpenseReport(Request<TransactionHeader> request)
        {
            TimesheetService<TransactionHeader> ts = new TimesheetService<TransactionHeader>();
            Response<TransactionHeader> response = ts.SaveExpenseReport(request);

            return response;
        }

        [HttpPost]
        [ActionName("GetExpenseTransactions")]
        public Response<ExpenseTransaction> GetExpenseTransactions(Request<ExpenseTransaction> request)
        {
            TimesheetService<ExpenseTransaction> ts = new TimesheetService<ExpenseTransaction>();
            Response<ExpenseTransaction> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("SetExpenseTransaction")]
        public Response<TransactionHeader> SetExpenseTransaction(Request<ExpenseTransaction> request)
        {
            TimesheetService<ExpenseTransaction> ts = new TimesheetService<ExpenseTransaction>();
            Response<TransactionHeader> response = ts.SetExpenseTransaction(request);

            return response;
        }


        [HttpPost]
        [ActionName("SetExpenseTransactionForAndroid")]
        public Response<ExpenseTransaction> SetExpenseTransactionForAndroid(Request<ExpenseTransaction> request)
        {
            TimesheetService<ExpenseTransaction> ts = new TimesheetService<ExpenseTransaction>();
            Response<ExpenseTransaction> response = ts.SetExpenseTransactionForAndroid(request);

            return response;
        }

        [HttpPost]
        [ActionName("GetResourceType")]
        public Response<ResourceType> GetResourceType(Request<ResourceType> request)
        {
            TimesheetService<ResourceType> ts = new TimesheetService<ResourceType>();
            Response<ResourceType> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("GetPaymentTypes")]
        public Response<PaymentTypes> GetPaymentTypes(Request<PaymentTypes> request)
        {
            TimesheetService<PaymentTypes> ts = new TimesheetService<PaymentTypes>();
            Response<PaymentTypes> response = ts.Load(request);

            return response;
        }

        [HttpPost]
        [ActionName("GetExpenseImage")]
        public Response<ExpenseTransaction> GetExpenseImage(Request<ExpenseTransaction> request)
        {
            // Two flags are used, IsFileAttached and IsImageChanged
            // IsFileAttached = 0/1 
            // IsImageChanged = 0/1
            //      After sending the file, change the flag IsImageChanged = 0 in eSM.
            // In eSM, whenever the file is changed or attached, set IsFileAttached = 1 and IsImageChanged = 1

            TimesheetService<ExpenseTransaction> ts = new TimesheetService<ExpenseTransaction>();
            Response<ExpenseTransaction> response = ts.GetExpenseImage(request);

            return response;
        }

        ////////////////////////////////// NEW METHODS FOR EXPENSE REPORT ENDS HERE ////////////////////////////////////////        

        ////////////////////////////////// Approval Section time Expense ///////////////////////////////////////////////////

        [HttpPost]
        [ActionName("SetExpenseApproval")]
        public Response<ExpenseApproval> SetExpenseApproval(Request<ExpenseApproval> request)
        {
            TimesheetService<ExpenseApproval> ts = new TimesheetService<ExpenseApproval>();
            Response<ExpenseApproval> response = ts.SetTimeExpenseApproval(request);
            return response;
        }


        [HttpPost]
        [ActionName("SetTimeApproval")]
        public Response<TimeApproval> SetTimeApproval(Request<TimeApproval> request)
        {
            TimesheetService<TimeApproval> ts = new TimesheetService<TimeApproval>();
            Response<TimeApproval> response = ts.SetTimeExpenseApproval(request);
            return response;
        }


        ///////////////////////////////// end approval section     ////////////////////////////////////////////////////////


        [HttpPost]
        [ActionName("TestSaveImage")]
        public Response<Resource> TestSaveImage(Request<Resource> request)//(string imageData)
        {
            TimesheetService<Resource> ts = new TimesheetService<Resource>();
            Response<Resource> response = ts.TestImageSaving(request);

            return response;
        }


        [HttpPost]
        [ActionName("GetExpenseReportAttachment")]
        public Response<ExpenseReportAttachment> GetExpenseReportAttachment(Request<ExpenseReportAttachment> request)
        {
            // Two flags are used, IsFileAttached and IsImageChanged
            // IsFileAttached = 0/1 
            // IsImageChanged = 0/1
            //      After sending the file, change the flag IsImageChanged = 0 in eSM.
            // In eSM, whenever the file is changed or attached, set IsFileAttached = 1 and IsImageChanged = 1

            TimesheetService<ExpenseReportAttachment> ts = new TimesheetService<ExpenseReportAttachment>();
            Response<ExpenseReportAttachment> response = ts.GetExpenseReportAttachment(request);

            return response;
        }

        [HttpPost]
        [ActionName("SaveDeviceToken")]
        public Response<PushNotification> SaveDeviceToken(Request<PushNotification> request)
        {
            TimesheetService<PushNotification> ts = new TimesheetService<PushNotification>();
            Response<PushNotification> response = ts.SaveDeviceToken(request);
            return response;
        }

        [HttpPost]
        [ActionName("GetLatestPushNotifications")]
        public Response<Notification> GetLatestPushNotifications(Request<Notification> request)
        {
            TimesheetService<Notification> ts = new TimesheetService<Notification>();
            Response<Notification> response = ts.GetLatestPushNotifications(request);
            return response;
        }

        [HttpPost]
        [ActionName("UpdatePushNotification")]
        public Response<Notification> UpdatePushNotification(Request<Notification> request)
        {
            TimesheetService<Notification> ts = new TimesheetService<Notification>();
            Response<Notification> response = ts.UpdatePushNotification(request);
            return response;
        }

        [HttpPost]
        [ActionName("SetRule")]
        public Response<Rule> SetRule(Request<Rule> request)
        {
            TimesheetService<Rule> ts = new TimesheetService<Rule>();
            Response<Rule> response = ts.SetRule(request);
            return response;
        }

        [HttpPost]
        [ActionName("PingNotificationService")]
        public string PingNotificationService()
        {
            TimesheetService<PushNotification> ts = new TimesheetService<PushNotification>();
            ts.CheckForNotificationsInDatabase();
            return "Success";
        }

        #region OKTA
        [HttpPost]
        [ActionName("ValidateAuthenticationKey")]
        public Response<CompanyAuthentication> ValidateAuthenticationKey(Request<CompanyAuthentication> request)
        {
            NexContext ctx = NexelusApp.Service.Model.NexContext.GetContext();
            CriteriaBase<CompanyAuthentication> criteria = request.SearchCriteria;
            AuthenticationService<CompanyAuthentication> service = new AuthenticationService<CompanyAuthentication>(ctx);

            var response = service.ValidateAuthenticationKey(criteria);
            return response;
        }

        [HttpPost]
        [ActionName("GetLoginCredentials")]
        public Response<LoginInfo> GetLoginCredentials(Request<LoginInfo> request)
        {
            NexContext ctx = NexContext.AuthenticateUser(request.Authentication);
            AuthenticationService<LoginInfo> service = new AuthenticationService<LoginInfo>(ctx);
            var response = service.GetLoginCredentials(request.SearchCriteria);
            return response;
        }
        #endregion
    }
}
