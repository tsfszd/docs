using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using com.paradigm.esm.general;
using System.Globalization;
using System.Collections;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Rules : EntityBase
    {
        #region Private Properties

        private int Id;
        private int _IsCustomFieldsByExpenseGroup;
        private int _ExpCurrencyCodeRule;
        private int _NumberOfDaysPriorAllowed;
        private int _override_approver;

        private int _show_billable_check; // possible values 0, 1, 2
        private int _show_tax_code; // possible values 0, 1, 2
        private String _default_tax_code = "";
        private int _show_payment_type; // possible values 0, 1, 2
        private String _default_payment_type = "";
        private int _show_receipt_check; // possible values 0, 1, 2
        private int _show_location; // possible values 0, 1, 2
        private int _show_org_unit; // possible values 0, 1, 2
        private string _defualt_org_unit = "";
        private string _default_location = "";

        private int _allow_cc_report;
        private int _copy_cc_comments;
        private int _allow_submit;
        private int _allow_submit_timesheet;
        private int _is_mc;

        private int _level2FilterOrgUnitTime;
        private int _level3FilterOrgUnitTime;
        private int _level2FilterLocationTime;
        private int _level3FilterLocationTime;

        private int _level2FilterOrgUnitExpense;
        private int _level3FilterOrgUnitExpense;
        private int _level2FilterLocationExpense;
        private int _level3FilterLocationExpense;

        private int _customFieldsBasedOn;

        private int _expenseReportName; // 1 - Default, 2 - Custom
        private int _approvers_based_on; // 0 - Company, 1 - location, 2 - department

        private int _isChild; // Only for local use

        private int _exp_decimal_places;

        private List<RulesChild> _childs = new List<RulesChild>();

        //Approval Rule Fields
        private int _timeApprovalCommentRequiredOnRejection;
        private int _expenseApprovalCommentRequiredOnRejection;

        //for transaction editing allowed rule
        private int _Time_Transaction_Editing_Allowed;
        private int _TimeSheet_DefaultView;

        private int _Finance_Approval_Required;
        private int _show_reimburse_check;
        private int _create_voucher_on_finance_approval;

        private int _level2FilterLocationApprovals;
        private int _level3FilterLocationApprovals;
        private int _level2FilterOrgUnitApprovals;
        private int _level3FilterOrgUnitApprovals;

        #endregion

        #region Public Properties

        [DataMember]
        public int level2FilterLocationApprovals
        {
            get { return _level2FilterLocationApprovals; }
            set { _level2FilterLocationApprovals = value; }
        }
        [DataMember]
        public int level3FilterLocationApprovals
        {
            get { return _level3FilterLocationApprovals; }
            set { _level3FilterLocationApprovals = value; }
        }
        [DataMember]
        public int level2FilterOrgUnitApprovals
        {
            get { return _level2FilterOrgUnitApprovals; }
            set { _level2FilterOrgUnitApprovals = value; }
        }
        [DataMember]
        public int level3FilterOrgUnitApprovals
        {
            get { return _level3FilterOrgUnitApprovals; }
            set { _level3FilterOrgUnitApprovals = value; }
        }

        [DataMember]
        public int Create_Voucher_On_Finance_Approval
        {
            get { return _create_voucher_on_finance_approval; }
            set { _create_voucher_on_finance_approval = value; }
        }

        [DataMember]
        public int Show_Reimburse_Check
        {
            get { return _show_reimburse_check; }
            set { _show_reimburse_check = value; }
        }

        [DataMember]
        public int Finance_Approval_Required
        {
            get { return _Finance_Approval_Required; }
            set { _Finance_Approval_Required = value; }
        }

        [DataMember]
        public int Time_Transaction_Editing_Allowed
        {
            get { return _Time_Transaction_Editing_Allowed; }
            set { _Time_Transaction_Editing_Allowed = value; }
        }

        [DataMember]
        public int TimeSheet_DefaultView
        {
            get { return _TimeSheet_DefaultView; }
            set { _TimeSheet_DefaultView = value; }
        }

        public int IsChild
        {
            get { return _isChild; }
            set { _isChild = value; }
        }

        [DataMember]
        public int exp_decimal_places
        {
            get { return _exp_decimal_places; }
            set { _exp_decimal_places = value; }
        }

        [DataMember]
        public int approvers_based_on
        {
            get { return _approvers_based_on; }
            set { _approvers_based_on = value; }
        }
        [DataMember]
        public int expense_report_name
        {
            get { return _expenseReportName; }
            set { _expenseReportName = value; }
        }

        [DataMember]
        public int custom_fields_based_on
        {
            get { return _customFieldsBasedOn; }
            set { _customFieldsBasedOn = value; }
        }

        [DataMember]
        public int level3_filter_location_expense
        {
            get { return _level3FilterLocationExpense; }
            set { _level3FilterLocationExpense = value; }
        }
        [DataMember]
        public int level2_filter_location_expense
        {
            get { return _level2FilterLocationExpense; }
            set { _level2FilterLocationExpense = value; }
        }
        [DataMember]
        public int level3_filter_org_unit_expense
        {
            get { return _level3FilterOrgUnitExpense; }
            set { _level3FilterOrgUnitExpense = value; }
        }
        [DataMember]
        public int level2_filter_org_unit_expense
        {
            get { return _level2FilterOrgUnitExpense; }
            set { _level2FilterOrgUnitExpense = value; }
        }

        [DataMember]
        public int level3_filter_location_time
        {
            get { return _level3FilterLocationTime; }
            set { _level3FilterLocationTime = value; }
        }
        [DataMember]
        public int level2_filter_location_time
        {
            get { return _level2FilterLocationTime; }
            set { _level2FilterLocationTime = value; }
        }
        [DataMember]
        public int level3_filter_org_unit_time
        {
            get { return _level3FilterOrgUnitTime; }
            set { _level3FilterOrgUnitTime = value; }
        }
        [DataMember]
        public int level2_filter_org_unit_time
        {
            get { return _level2FilterOrgUnitTime; }
            set { _level2FilterOrgUnitTime = value; }
        }

        [DataMember]
        public int is_mc
        {
            get { return _is_mc; }
            set { _is_mc = value; }
        }

        [DataMember]
        public int allow_submit
        {
            get { return _allow_submit; }
            set { _allow_submit = value; }
        }

        [DataMember]
        public int allow_submit_timesheet
        {
            get { return _allow_submit_timesheet; }
            set { _allow_submit_timesheet = value; }
        }

        [DataMember]
        public int copy_cc_comments
        {
            get { return _copy_cc_comments; }
            set { _copy_cc_comments = value; }
        }

        [DataMember]
        public int allow_cc_report
        {
            get { return _allow_cc_report; }
            set { _allow_cc_report = value; }
        }

        [DataMember]
        public string default_location
        {
            get { return _default_location; }
            set { _default_location = value; }
        }

        [DataMember]
        public string default_org_unit
        {
            get { return _defualt_org_unit; }
            set { _defualt_org_unit = value; }
        }
        [DataMember]
        public int show_org_unit
        {
            get { return _show_org_unit; }
            set { _show_org_unit = value; }
        }

        [DataMember]
        public int show_location
        {
            get { return _show_location; }
            set { _show_location = value; }
        }

        [DataMember]
        public int show_receipt_check
        {
            get { return _show_receipt_check; }
            set { _show_receipt_check = value; }
        }

        [DataMember]
        public String default_payment_type
        {
            get { return _default_payment_type; }
            set { _default_payment_type = value; }
        }

        [DataMember]
        public int show_payment_type
        {
            get { return _show_payment_type; }
            set { _show_payment_type = value; }
        }

        [DataMember]
        public String default_tax_code
        {
            get { return _default_tax_code; }
            set { _default_tax_code = value; }
        }

        [DataMember]
        public int show_tax_code
        {
            get { return _show_tax_code; }
            set { _show_tax_code = value; }
        }

        [DataMember]
        public int show_billable_check
        {
            get { return _show_billable_check; }
            set { _show_billable_check = value; }
        }

        [DataMember]
        public List<RulesChild> childs
        {
            get { return _childs; }
            set { _childs = value; }
        }

        [DataMember]
        public int override_approver
        {
            get { return _override_approver; }
            set { _override_approver = value; }
        }

        [DataMember]
        public int number_Of_Days_Prior_Allowed
        {
            get { return _NumberOfDaysPriorAllowed; }
            set { _NumberOfDaysPriorAllowed = value; }
        }
        [DataMember]
        public int exp_currencyCode_rule
        {
            get { return _ExpCurrencyCodeRule; }
            set { _ExpCurrencyCodeRule = value; }
        }
        [DataMember]
        public int is_Customfields_By_ExpanseGroup
        {
            get { return _IsCustomFieldsByExpenseGroup; }
            set { _IsCustomFieldsByExpenseGroup = value; }
        }
        [DataMember]
        public int id
        {
            get { return Id; }
            set { Id = value; }
        }

        [DataMember]
        public int time_Approval_Comment_Required_On_Rejection
        {
            get { return _timeApprovalCommentRequiredOnRejection; }
            set { _timeApprovalCommentRequiredOnRejection = value; }
        }
        [DataMember]
        public int expense_Approval_Comment_Required_On_Rejection
        {
            get { return _expenseApprovalCommentRequiredOnRejection; }
            set { _expenseApprovalCommentRequiredOnRejection = value; }
        }
        [DataMember]
        public byte attachment_is_required { get; set; }

        [DataMember]
        public int show_cc_mark_as { get; set; }

        [DataMember]
        public byte attachment_level { get; set; }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
