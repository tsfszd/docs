using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using NexelusApp.Service.Model.Entities;

using NexelusApp.Service.Model.Criteria;

namespace NexelusApp.Service.Model
{
    [DataContract]
    [KnownType(typeof(Level2CustomerCriteria<Level2Customer>))]
    [KnownType(typeof(Level2Criteria<Level2>))]
    [KnownType(typeof(Level3Criteria<Level3>))]
    [KnownType(typeof(OrgUnitCriteria<OrgUnit>))]
    [KnownType(typeof(PermanentLinesCriteria<PermanentLine>))]
    [KnownType(typeof(ResourceCriteria<Resource>))]
    [KnownType(typeof(ResUsageCriteria<ResUsage>))]
    [KnownType(typeof(SysNamesCriteria<SysNames>))]
    [KnownType(typeof(TaskCriteria<Task>))]
    [KnownType(typeof(TransactionCriteria<Transaction>))]
    [KnownType(typeof(UserSettingCriteria<UserSetting>))]
    //New criterias start here...
    [KnownType(typeof(TransactionExpenseCriteria<TransactionExpense>))]
    [KnownType(typeof(ApproverCriteria<Approver>))]
    [KnownType(typeof(CostCodeCriteria<CostCodes>))]
    [KnownType(typeof(CreditCardExpenseCriteria<CreditCardExpense>))]
    [KnownType(typeof(CurrenciesCriteria<Currencies>))]
    [KnownType(typeof(ExpenseReportFieldsCriteria<ExpenseReportFields>))]
    [KnownType(typeof(ExpenseReportRatesCriteria<ExpenseReportRates>))]
    [KnownType(typeof(MultiCurrencyRatesTypeDetailCriteria<MultiCurrencyRateTypeDetail>))]
    [KnownType(typeof(MultiCurrencyRateTypeHeaderCriteria<MultiCurrencyRateTypeHeader>))]
    [KnownType(typeof(RulesCriteria<Rules>))]
    [KnownType(typeof(TransactionHeaderCriteria<TransactionHeader>))]
    [KnownType(typeof(ExpenseReportCriteria<ExpenseReport>))]
    [KnownType(typeof(ParserKeywordCriteria<ParserKeyword>))]
    [KnownType(typeof(EntityChangeCriteria<EntityChange>))]
    [KnownType(typeof(ResourceTypeCriteria<ResourceType>))]
    [KnownType(typeof(PaymentTypesCriteria<PaymentTypes>))]
    [KnownType(typeof(ExpenseTransactionCriteria<ExpenseTransaction>))]
    [KnownType(typeof(ExpenseReportAttachmentCriteria<ExpenseReportAttachment>))]
    [KnownType(typeof(CompanyAuthenticationCriteria<CompanyAuthentication>))]
    [KnownType(typeof(LoginInfoCriteria<LoginInfo>))]
    

    public class Request<T> where T : EntityBase, new()
    {
        #region Private Properties

        private Authentication _Authentication;
        private List<T> _Entities;
        private CriteriaBase<T> _SearchCriteria = null;
        private String _DeviceInfo;

        #endregion

        #region Public Properties

        [DataMember]
        public Authentication Authentication
        {
            get { return _Authentication; }
            set { _Authentication = value; }
        }        
        [DataMember]
        public List<T> Entities
        {
            get { return _Entities; }
            set { _Entities = value; }
        }
        
        [DataMember]
        public CriteriaBase<T> SearchCriteria
        {
            get { return _SearchCriteria; }
            set { _SearchCriteria = value; }
        }
        [DataMember]
        public String DeviceInfo
        {
            get { return _DeviceInfo; }
            set { _DeviceInfo = value; }
        }

        #endregion

        #region Constructors

        public Request()
        {

            _SearchCriteria = CriteriaFactory<T>.GetEntityCriteria();
          
            
        }

        #endregion

    }
}
