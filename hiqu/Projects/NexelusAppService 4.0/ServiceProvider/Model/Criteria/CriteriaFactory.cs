using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{

    public static class CriteriaFactory<T> where T : EntityBase, new()
    {
        static readonly Dictionary<Type, Type> EntityMap = new Dictionary<Type, Type>();


        /// <summary>
        /// Map the Entityes with respective Critera in the constructor
        /// </summary>
        static CriteriaFactory()
        {
            EntityMap.Add(typeof(Approver), typeof(ApproverCriteria<Approver>));
            EntityMap.Add(typeof(CompanyAuthentication), typeof(CompanyAuthenticationCriteria<CompanyAuthentication>));
            EntityMap.Add(typeof(CostCodes), typeof(CostCodeCriteria<CostCodes>));
            EntityMap.Add(typeof(CreditCardExpense), typeof(CreditCardExpenseCriteria<CreditCardExpense>));
            EntityMap.Add(typeof(Currencies), typeof(CurrenciesCriteria<Currencies>));
            EntityMap.Add(typeof(EntityChange), typeof(EntityChangeCriteria<EntityChange>));
            EntityMap.Add(typeof(ExpenseReportAttachment), typeof(ExpenseReportAttachmentCriteria<ExpenseReportAttachment>));
            EntityMap.Add(typeof(ExpenseReport), typeof(ExpenseReportCriteria<ExpenseReport>));
            EntityMap.Add(typeof(ExpenseReportFields), typeof(ExpenseReportFieldsCriteria<ExpenseReportFields>));
            EntityMap.Add(typeof(ExpenseReportRates), typeof(ExpenseReportRatesCriteria<ExpenseReportRates>));
            EntityMap.Add(typeof(ExpenseTransaction), typeof(ExpenseTransactionCriteria<ExpenseTransaction>));
            EntityMap.Add(typeof(Level2), typeof(Level2Criteria<Level2>));
            EntityMap.Add(typeof(Level2Customer), typeof(Level2CustomerCriteria<Level2Customer>));
            EntityMap.Add(typeof(Level3), typeof(Level3Criteria<Level3>));
            EntityMap.Add(typeof(LoginInfo), typeof(LoginInfoCriteria<LoginInfo>));
            EntityMap.Add(typeof(MultiCurrencyRateTypeDetail), typeof(MultiCurrencyRatesTypeDetailCriteria<MultiCurrencyRateTypeDetail>));
            EntityMap.Add(typeof(MultiCurrencyRateTypeHeader), typeof(MultiCurrencyRateTypeHeaderCriteria<MultiCurrencyRateTypeHeader>));
            EntityMap.Add(typeof(Notification), typeof(NotificationCriteria<Notification>));
            EntityMap.Add(typeof(OrgUnit), typeof(OrgUnitCriteria<OrgUnit>));
            EntityMap.Add(typeof(ParserKeyword), typeof(ParserKeywordCriteria<ParserKeyword>));
            EntityMap.Add(typeof(PaymentTypes), typeof(PaymentTypesCriteria<PaymentTypes>));
            EntityMap.Add(typeof(PermanentLine), typeof(PermanentLinesCriteria<PermanentLine>));
            EntityMap.Add(typeof(Resource), typeof(ResourceCriteria<Resource>));
            EntityMap.Add(typeof(ResourceType), typeof(ResourceTypeCriteria<ResourceType>));
            EntityMap.Add(typeof(ResUsage), typeof(ResUsageCriteria<ResUsage>));
            EntityMap.Add(typeof(RulesChild), typeof(RulesChildCriteria<RulesChild>));
            EntityMap.Add(typeof(Rules), typeof(RulesCriteria<Rules>));
            EntityMap.Add(typeof(SysNames), typeof(SysNamesCriteria<SysNames>));
            EntityMap.Add(typeof(Task), typeof(TaskCriteria<Task>));
            EntityMap.Add(typeof(Transaction), typeof(TransactionCriteria<Transaction>));
            EntityMap.Add(typeof(TransactionDetailDocument), typeof(TransactionDetailDocumentCriteria<TransactionDetailDocument>));
            EntityMap.Add(typeof(TransactionExpense), typeof(TransactionExpenseCriteria<TransactionExpense>));
            EntityMap.Add(typeof(TransactionHeader), typeof(TransactionHeaderCriteria<TransactionHeader>));
            EntityMap.Add(typeof(TransactionHeaderDocument), typeof(TransactionHeaderDocumentCriteria<TransactionHeaderDocument>));
            
            EntityMap.Add(typeof(UserSetting), typeof(UserSettingCriteria<UserSetting>));



        }

        /// <summary>
        /// Return the instace of the respective Criteria
        /// </summary>
        /// <param name="ctx"></param>
        /// <returns></returns>
        public static CriteriaBase<T> GetEntityCriteria()
        {
            CriteriaBase<T> obj = null;

            if (EntityMap.ContainsKey(typeof(T)))
            {
                obj = (CriteriaBase<T>)Activator.CreateInstance(EntityMap[typeof(T)]);
            }


            return obj;
        }
    }
}
