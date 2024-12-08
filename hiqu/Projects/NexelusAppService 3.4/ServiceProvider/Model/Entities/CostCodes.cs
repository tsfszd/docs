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
    public class CostCodes : EntityBase
    {
        #region Private Properties

        private string _StrTimeStamp;
        private int _CostType;
        private string _ResCategoryCode;
        private int _ResType;
        private string _StrEffectiveDate;
        private int _Markup;
        private string _CreateId;
        private string _StrCreateDate;
        private string _ModifyId;
        private string _StrModifyDate;
        private string _TaxCode;
        private int _ExpenseReportFlag;

        #endregion

        #region Public Properties

        [DataMember]
        public int expense_report_flag
        {
            get { return _ExpenseReportFlag; }
            set { _ExpenseReportFlag = value; }
        }
        [DataMember]
        public string tax_code
        {
            get { return _TaxCode; }
            set { _TaxCode = value; }
        }
        [DataMember]
        public string str_modify_date
        {
            get { return _StrModifyDate; }
            set { _StrModifyDate = value; }
        }
        [DataMember]
        public string modify_id
        {
            get { return _ModifyId; }
            set { _ModifyId = value; }
        }
        [DataMember]
        public string create_id
        {
            get { return _CreateId; }
            set { _CreateId = value; }
        }
        [DataMember]
        public string str_create_date
        {
            get { return _StrCreateDate; }
            set { _StrCreateDate = value; }
        }
        [DataMember]
        public int markup
        {
            get { return _Markup; }
            set { _Markup = value; }
        }
        [DataMember]
        public string str_effective_date
        {
            get { return _StrEffectiveDate; }
            set { _StrEffectiveDate = value; }
        }
        [DataMember]
        public int res_type
        {
            get { return _ResType; }
            set { _ResType = value; }
        }
        [DataMember]
        public string res_category_code
        {
            get { return _ResCategoryCode; }
            set { _ResCategoryCode = value; }
        }
        [DataMember]
        public int cost_type
        {
            get { return _CostType; }
            set { _CostType = value; }
        }
        [DataMember]
        public string timestamp
        {
            get { return _StrTimeStamp; }
            set { _StrTimeStamp = value; }
        }

        #endregion


        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
