using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Level2 : EntityBase
    {

        #region Private Properties

        private string _Level2Key = "";
        private string _Level2Description = "";
        private int _Level2Status;
        private string _StrOpenDate = "";
        private string _StrCloseDate = "";
        //New fields start here.
        private int _CommentsReqForTimeSheet;
        private int _CommentsReqForExpenseReport;
        private string _org_unit = "";
        private string _parent_org_unit = "";
        private string _location_code = "";

        private string _level2RateType;

        private int _billableFlag;
        private int _selfApprover;
        //private int _trx_approval_flag;
        private string _manager_id = "";

        #endregion

        #region Public Properties
        //[DataMember]
        //public int trx_approval_flag
        //{
        //    get { return _trx_approval_flag; }
        //    set { _trx_approval_flag = value; }
        //}

        [DataMember]
        public string manager_id
        {
            get { return _manager_id; }
            set { _manager_id = value; }
        }


        [DataMember]
        public int self_approver
        {
            get { return _selfApprover; }
            set { _selfApprover = value; }
        }

        [DataMember]
        public int BillableFlag
        {
            get { return _billableFlag; }
            set { _billableFlag = value; }
        }
        [DataMember]
        public string Level2RateType
        {
            get { return _level2RateType; }
            set { _level2RateType = value; }
        }
        [DataMember]
        public string location_code
        {
            get { return _location_code; }
            set { _location_code = value; }
        }
        [DataMember]
        public string org_unit
        {
            get { return _org_unit; }
            set { _org_unit = value; }
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
        public int Level2Status
        {
            get { return _Level2Status; }
            set { _Level2Status = value; }
        }
        [DataMember]
        public string StrOpenDate
        {
            get { return _StrOpenDate; }
            set { _StrOpenDate = value; }
        }
        [DataMember]
        public string StrCloseDate
        {
            get { return _StrCloseDate; }
            set { _StrCloseDate = value; }
        }
        [DataMember]
        public int comments_required_for_timesheet
        {
            get { return _CommentsReqForTimeSheet; }
            set { _CommentsReqForTimeSheet = value; }
        }
        [DataMember]
        public int comments_required_for_expense
        {
            get { return _CommentsReqForExpenseReport; }
            set { _CommentsReqForExpenseReport = value; }
        }


        [DataMember]
        public string parent_org_unit
        {
            get { return _parent_org_unit; }
            set { _parent_org_unit = value; }
        }

        #endregion

        #region Constructors

        public Level2()
        {

        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
