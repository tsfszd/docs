using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Resource : EntityBase
    {

        #region Private Properties

        private string _ResourceID = "";
        private string _NameFirst = "";
        private string _NameLast = "";
        private string _ResUsageCode = "";
        private string _OrgUnitCode = "";
        private string _ParentOrgUnitCode = "";
        private string _LocationCode = "";
        private int _ShowTask;
        private int _ShowWorkFunction;
        private int _trx_type;
        private int _IsUsingAD;
        private string _OldPassword = "";
        private string _NewPassword = "";
        // New Fields start here.
        private int _IsExpenseReportAvailable;
        private int _IsTimeSheetAvalaible;
        private string _CurrencyCode = "";
        private string _location_name;
        private string _org_unit_name;
        private string _parent_org_unit_name;
        private int _IsExpenseApprovalAvailable;
        private int _IsTimeApprovalAvailable;
        private int _IsSelfApprover;
        private int _IsPendingFinanceApprovalAvailable;
        private int _IsFinanceApprovedAvailable;
        private string _reports_to;
        bool _isFirstTimeLogin = false;


        #endregion

        #region Public Properties

        [DataMember]
        public bool isFirstTimeLogin
        {
            get { return _isFirstTimeLogin; }
            set { _isFirstTimeLogin = value; }
        }

        [DataMember]
        public string reports_to
        {
            get { return _reports_to; }
            set { _reports_to = value; }
        }

        [DataMember]
        public int is_pending_finance_approval_available
        {
            get { return _IsPendingFinanceApprovalAvailable; }
            set { _IsPendingFinanceApprovalAvailable = value; }
        }
        [DataMember]
        public int is_finance_approved_available
        {
            get { return _IsFinanceApprovedAvailable; }
            set { _IsFinanceApprovedAvailable = value; }
        }

        [DataMember]
        public string org_unit_name
        {
            get { return _org_unit_name; }
            set { _org_unit_name = value; }
        }

        [DataMember]
        public string location_name
        {
            get { return _location_name; }
            set { _location_name = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        [DataMember]
        public string NameFirst
        {
            get { return _NameFirst; }
            set { _NameFirst = value; }
        }
        [DataMember]
        public string NameLast
        {
            get { return _NameLast; }
            set { _NameLast = value; }
        }
        [DataMember]
        public string ResUsageCode
        {
            get { return _ResUsageCode; }
            set { _ResUsageCode = value; }
        }
        [DataMember]
        public string OrgUnitCode
        {
            get { return _OrgUnitCode; }
            set { _OrgUnitCode = value; }
        }

       
        [DataMember]
        public string LocationCode
        {
            get { return _LocationCode; }
            set { _LocationCode = value; }
        }        
        [DataMember]
        public int ShowTask
        {
            get { return _ShowTask; }
            set { _ShowTask = value; }
        }
        [DataMember]
        public int ShowWorkFunction
        {
            get { return _ShowWorkFunction; }
            set { _ShowWorkFunction = value; }
        }

        [DataMember]
        public int trx_type
        {
            get { return _trx_type; }
            set { _trx_type = value; }
        }
        [DataMember]
        public int IsUsingAD
        {
            get { return _IsUsingAD; }
            set { _IsUsingAD = value; }
        }
        [DataMember]
        public string OldPassword
        {
            get { return _OldPassword; }
            set { _OldPassword = value; }
        }
        [DataMember]
        public string NewPassword
        {
            get { return _NewPassword; }
            set { _NewPassword = value; }
        }
        [DataMember]
        public int is_expense_report_available
        {
            get { return _IsExpenseReportAvailable; }
            set { _IsExpenseReportAvailable = value; }
        }
        [DataMember]
        public int is_timeSheet_available
        {
            get { return _IsTimeSheetAvalaible; }
            set { _IsTimeSheetAvalaible = value; }
        }
        [DataMember]
        public string currency_code
        {
            get { return _CurrencyCode; }
            set { _CurrencyCode = value; }
        }

        [DataMember]
        public int is_time_approval_available
        {
            get { return _IsTimeApprovalAvailable; }
            set { _IsTimeApprovalAvailable = value; }
        }

        [DataMember]
        public int is_expense_approval_available
        {
            get { return _IsExpenseApprovalAvailable; }
            set { _IsExpenseApprovalAvailable = value; }
        }

        [DataMember]
        public int is_self_approver
        {
            get { return _IsSelfApprover; }
            set { _IsSelfApprover = value; }
        }


        [DataMember]
        public string parent_org_unit_name
        {
            get { return _parent_org_unit_name; }
            set { _parent_org_unit_name = value; }
        }

        [DataMember]
        public string parent_org_unit_code
        {
            get { return _ParentOrgUnitCode; }
            set { _ParentOrgUnitCode = value; }
        }

        #endregion

        #region Constructors

        public Resource()
        {

        }

        #endregion
        
        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
