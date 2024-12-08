using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Level3 : EntityBase
    {
        #region Private Properties

        private string _Level2Key = "";
        private string _Level2Description = "";
        private string _Level3Key = "";
        private string _Level3Description = "";
        private string _StrOpenDate = "";
        private string _StrClosedDate = "";
        private DateTime _OpenDate;
        private DateTime _ClosedDate;
        private bool _BillableFlag;
        private int _TaskTypeCode;
        private int _LaborFlag;
        //New Fields start here.
        private string _OrgUnit = "";
        private string _ParentOrgUnit = "";
        private string _LocationCode = "";
        private int _ExpenseFlag;
        private DateTime _DateDue;
        private string _StrDateDue = "";
        private int _CostType;
        private int _RateTable1;
        private int _RateTable2;
        private int _level3_status;
        private bool _self_approver;
        private bool _finance_approval;
        private bool _header_approver;

        private int _trx_approval_flag;
        //private string _manager_id = "";


        #endregion

        #region Public Properties


        [DataMember]
        public int trx_approval_flag
        {
            get { return _trx_approval_flag; }
            set { _trx_approval_flag = value; }
        }

        //[DataMember]
        //public string manager_id
        //{
        //    get { return _manager_id; }
        //    set { _manager_id = value; }
        //}


        [DataMember]
        public int level3_status
        {
            get { return _level3_status; }
            set { _level3_status = value; }
        }

        [DataMember]
        public string Level2Key
        {
            get { return _Level2Key; }
            set { _Level2Key = value; }
        }
        [DataMember]
        public string Level2Description
        {
            get { return _Level2Description; }
            set { _Level2Description = value; }
        }
        [DataMember]
        public string Level3Key
        {
            get { return _Level3Key; }
            set { _Level3Key = value; }
        }
        [DataMember]
        public string Level3Description
        {
            get { return _Level3Description; }
            set { _Level3Description = value; }
        }
        [DataMember]
        public string StrOpenDate
        {
            get { return _StrOpenDate; }
            set { _StrOpenDate = value; }
        }
        
        public DateTime OpenDate
        {
            get { return _OpenDate ; }
            set { _OpenDate = value ; }
        }
        [DataMember]
        public string StrClosedDate
        {
            get { return _StrClosedDate; }
            set { _StrClosedDate = value; }
        }
        
        public DateTime ClosedDate
        {
            get { return _ClosedDate ; }
            set { _ClosedDate = value ; }
        }
        [DataMember]
        public bool BillableFlag
        {
            get { return _BillableFlag; }
            set { _BillableFlag = value; }
        }
        [DataMember]
        public int TaskTypeCode
        {
            get { return _TaskTypeCode; }
            set { _TaskTypeCode = value; }
        }
        [DataMember]
        public int LaborFlag
        {
            get { return _LaborFlag; }
            set { _LaborFlag = value; }
        }
        [DataMember]
        public string org_unit
        {
            get { return _OrgUnit; }
            set { _OrgUnit = value; }
        }
        [DataMember]
        public string location_code
        {
            get { return _LocationCode; }
            set { _LocationCode = value; }
        }
        [DataMember]
        public int expense_flag
        {
            get { return _ExpenseFlag; }
            set { _ExpenseFlag = value; }
        }
        
        public DateTime date_due
        {
            get { return _DateDue ; }
            set { _DateDue = value ; }
        }
        [DataMember]
        public int cost_type
        {
            get { return _CostType; }
            set { _CostType = value; }
        }
        [DataMember]
        public int rate_table1
        {
            get { return _RateTable1; }
            set { _RateTable1 = value; }
        }
        [DataMember]
        public int rate_table2
        {
            get { return _RateTable2; }
            set { _RateTable2 = value; }
        }
        [DataMember]
        public string str_date_due
        {
            get { return _StrDateDue; }
            set { _StrDateDue = value; }
        }

        [DataMember]
        public bool self_approver
        {
            get { return _self_approver; }
            set { _self_approver = value; }
        }

        [DataMember]
        public bool finance_approval_flag
        {
            get { return _finance_approval; }
            set { _finance_approval = value; }
        }

        [DataMember]
        public bool header_approver_flag
        {
            get { return _header_approver; }
            set { _header_approver = value; }
        }

        [DataMember]
        public string parent_org_unit
        {
            get { return _ParentOrgUnit; }
            set { _ParentOrgUnit = value; }
        }

        #endregion

        #region Constructors

        public Level3()
        {

        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
