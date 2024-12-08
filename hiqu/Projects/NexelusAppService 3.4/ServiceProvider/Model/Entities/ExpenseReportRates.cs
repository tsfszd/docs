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
    public class ExpenseReportRates : EntityBase
    {
        #region Private Properties

        private string _StrTimeStamp = "";
        private int _CostType;
        private int _ResType;
        private string _OrgUnit = "";
        private string _LocationCode = "";
        private string _StrEffectiveDate = "";
        private double _Rate;
        private string _CreateId = "";
        private string _StrCreateDate = "";
        private string _ModifyId;
        private string _StrModifyDate = "";

        #endregion

        #region Public Properties

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
        public string str_create_date
        {
            get { return _StrCreateDate; }
            set { _StrCreateDate = value; }
        }
        [DataMember]
        public string create_id
        {
            get { return _CreateId; }
            set { _CreateId = value; }
        }
        [DataMember]
        public double rate
        {
            get { return _Rate; }
            set { _Rate = value; }
        }
        [DataMember]
        public string str_effective_date
        {
            get { return _StrEffectiveDate; }
            set { _StrEffectiveDate = value; }
        }
        [DataMember]
        public string location_code
        {
            get { return _LocationCode; }
            set { _LocationCode = value; }
        }
        [DataMember]
        public string org_unit
        {
            get { return _OrgUnit; }
            set { _OrgUnit = value; }
        }
        [DataMember]
        public int res_type
        {
            get { return _ResType; }
            set { _ResType = value; }
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
