using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "ExpenseReportRatesCriteria", Namespace = "")]
    public class ExpenseReportRatesCriteria<T> : CriteriaBase<T> where T : ExpenseReportRates, new()
    {
        #region Private Properties

        private int _cost_type;
        private int _res_type;
        private string _org_unit;
        private string _location_code;
        private string _effective_date;

        #endregion

        #region Public Properties

        [DataMember]
        public int cost_type
        {
            get { return _cost_type; }
            set { _cost_type = value; }
        }
        [DataMember]
        public int res_type
        {
            get { return _res_type; }
            set { _res_type = value; }
        }
        [DataMember]
        public string org_unit
        {
            get { return _org_unit; }
            set { _org_unit = value; }
        }
        [DataMember]
        public string location_code
        {
            get { return _location_code; }
            set { _location_code = value; }
        }
        [DataMember]
        public string effective_date
        {
            get { return _effective_date; }
            set { _effective_date = value; }
        }

        #endregion
    }
}
