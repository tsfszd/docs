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
    public class MultiCurrencyRateTypeDetail : EntityBase
    {
        #region Private Properties

        private string _rateType = "";
        private string _FromCurrency = "";
        private string _ToCurrency = "";
        private double _Factor;
        private string _StrEffectiveDate = "";

        #endregion

        #region Public Properties
        [DataMember]
        public string rate_type
        {
            get { return _rateType; }
            set { _rateType = value; }
        }
        [DataMember]
        public string str_effective_date
        {
            get { return _StrEffectiveDate; }
            set { _StrEffectiveDate = value; }
        }
        [DataMember]
        public double factor
        {
            get { return _Factor; }
            set { _Factor = value; }
        }
        [DataMember]
        public string to_currency   
        {
            get { return _ToCurrency; }
            set { _ToCurrency = value; }
        }
        [DataMember]
        public string from_currency 
        {
            get { return _FromCurrency; }
            set { _FromCurrency = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
