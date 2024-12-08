using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.DataAccess;
using NexelusApp.Service.DataAccess.DAOs;

namespace NexelusApp.Service.DataAccess
{
    public static class DAOFactory<T> where T : EntityBase, new()
    {
        static readonly Dictionary<Type, Type> EntityMap = new Dictionary<Type, Type>();


        /// <summary>
        /// Map the Entityes with respective DAOs in the constructor
        /// </summary>
        static DAOFactory()
        {
            EntityMap.Add(typeof(CompanySite), typeof(CompanySiteDAO<CompanySite>));
            EntityMap.Add(typeof(Level2), typeof(Level2DAO<Level2>));
            EntityMap.Add(typeof(Level3), typeof(Level3DAO<Level3>));
            EntityMap.Add(typeof(Authentication), typeof(AuthenticationDAO<Authentication>));
            EntityMap.Add(typeof(Resource), typeof(ResourceDAO<Resource>));
            EntityMap.Add(typeof(Level2Customer), typeof(Level2CustomerDAO<Level2Customer>));
            EntityMap.Add(typeof(Location), typeof(LocationDAO<Location>));
            EntityMap.Add(typeof(OrgUnit), typeof(OrgUnitDAO<OrgUnit>));
            EntityMap.Add(typeof(ResUsage), typeof(ResUsageDAO<ResUsage>));
            EntityMap.Add(typeof(Task), typeof(TaskDAO<Task>));
            EntityMap.Add(typeof(Transaction), typeof(TransactionsDAO<Transaction>));
            EntityMap.Add(typeof(PermanentLine), typeof(PermanentLineDAO<PermanentLine>));
            EntityMap.Add(typeof(SysNames), typeof(SysNamesDAO<SysNames>));
            EntityMap.Add(typeof(UserSetting), typeof(UserSettingDAO<UserSetting>));

            //NEW DAOS FOR EXPENSE REPORT
            EntityMap.Add(typeof(Approver), typeof(ApproversDAO<Approver>));
            EntityMap.Add(typeof(CostCodes), typeof(CostCodesDAO<CostCodes>));
            EntityMap.Add(typeof(CreditCardExpense), typeof(CreditCardExpenseDAO<CreditCardExpense>));
            EntityMap.Add(typeof(Currencies), typeof(CurrenciesDAO<Currencies>));
            EntityMap.Add(typeof(ExpenseReportFields), typeof(ExpenseReportFieldsDAO<ExpenseReportFields>));
            EntityMap.Add(typeof(ExpenseReportRates), typeof(ExpenseReportRatesDAO<ExpenseReportRates>));
            EntityMap.Add(typeof(MultiCurrencyRateTypeHeader), typeof(MultiCurrrencyRateTypeHeaderDAO<MultiCurrencyRateTypeHeader>));
            EntityMap.Add(typeof(MultiCurrencyRateTypeDetail), typeof(MultiCurrencyRatesTypeDetailDAO<MultiCurrencyRateTypeDetail>));
            EntityMap.Add(typeof(TransactionExpense), typeof(TransactionExpenseDAO<TransactionExpense>));
            EntityMap.Add(typeof(TransactionHeader), typeof(TransactionHeaderDAO<TransactionHeader>));
            EntityMap.Add(typeof(ExpenseTransaction), typeof(ExpenseTransactionDAO<ExpenseTransaction>));
            EntityMap.Add(typeof(ExpenseReport), typeof(ExpenseReportDAO<ExpenseReport>));
            EntityMap.Add(typeof(ParserKeyword), typeof(ParserKeywordDAO<ParserKeyword>));
            EntityMap.Add(typeof(Rules), typeof(RulesDAO<Rules>));
            EntityMap.Add(typeof(EntityChange), typeof(EntityChangeDAO<EntityChange>));
            EntityMap.Add(typeof(ResourceType), typeof(ResourceTypeDAO<ResourceType>));
            EntityMap.Add(typeof(PaymentTypes), typeof(PaymentTypesDAO<PaymentTypes>));
            EntityMap.Add(typeof(ExpenseApproval), typeof(ExpenseApprovalDAO<ExpenseApproval>));
            EntityMap.Add(typeof(TimeApproval), typeof(TimeApprovalDAO<TimeApproval>));

            //NEW DAOS FOR DOCUMENTS
            EntityMap.Add(typeof(TransactionDetailDocument), typeof(TransactionDetailDocumentDAO<TransactionDetailDocument>));
            EntityMap.Add(typeof(CompanyAuthentication), typeof(CompanyAuthenticationDAO<CompanyAuthentication>));
            EntityMap.Add(typeof(LoginInfo), typeof(LoginInfoDAO<LoginInfo>));
        }

        /// <summary>
        /// Return the instace of the respective DAO
        /// </summary>
        /// <param name="ctx"></param>
        /// <returns></returns>
        public static DAOBase<T> GetDAO(NexContext ctx)
        {
            DAOBase<T> obj = null;

            if (EntityMap.ContainsKey(typeof(T)))
            {
                obj = (DAOBase<T>)Activator.CreateInstance(EntityMap[typeof(T)], ctx);
            }
            else
            {
                throw new NotImplementedException(string.Format("DAO is not implemented for Entity type '{0}' ", typeof(T).Name));
            }
         
            return obj;
        }
    }
}
