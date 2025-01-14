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
    public class MultiCurrencyRateTypeHeader : EntityBase
    {

        #region Private Properties

        private string _StrTimeStamp = "";
        private string _MCRateType = "";
        private string _RateTypeName = "";
        private string _StrStartDate = "";
        private string _StrEndDate = "";
        private int _ActiveFlag;
        private List<MultiCurrencyRateTypeDetail> _rates = new List<MultiCurrencyRateTypeDetail>();


        #endregion

        #region Public Properties

        [DataMember]
        public List<MultiCurrencyRateTypeDetail> Rates
        {
            get { return _rates; }
            set { _rates = value; }
        }

        [DataMember]
        public int active_flag
        {
            get { return _ActiveFlag; }
            set { _ActiveFlag = value; }
        }
        [DataMember]
        public string str_end_date
        {
            get { return _StrEndDate; }
            set { _StrEndDate = value; }
        }
        [DataMember]
        public string str_start_date
        {
            get { return _StrStartDate; }
            set { _StrStartDate = value; }
        }
        [DataMember]
        public string rate_type_name
        {
            get { return _RateTypeName; }
            set { _RateTypeName = value; }
        }
        [DataMember]
        public string mc_rate_type
        {
            get { return _MCRateType; }
            set { _MCRateType = value; }
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
