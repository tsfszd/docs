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
    public class Currencies : EntityBase
    {

        #region Private Properties

        private string _StrTimeStamp;
        private string _CurrencyCode;
        private string _CurrencyName;
        private string _CurrencySign;
        private int _DecimalPlaces;
        private string _PositiveFormat;
        private string _NegativeFormat;
        private int _StatusFlag;
        private string _CreateId;
        private string _StrCreateDate;

        #endregion

        #region Public Properties

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
        public int status_flag
        {
            get { return _StatusFlag; }
            set { _StatusFlag = value; }
        }
        [DataMember]
        public string negative_format
        {
            get { return _NegativeFormat; }
            set { _NegativeFormat = value; }
        }
        [DataMember]
        public string positive_format
        {
            get { return _PositiveFormat; }
            set { _PositiveFormat = value; }
        }
        [DataMember]
        public int decimal_places
        {
            get { return _DecimalPlaces; }
            set { _DecimalPlaces = value; }
        }
        [DataMember]
        public string currency_sign
        {
            get { return _CurrencySign; }
            set { _CurrencySign = value; }
        }
        [DataMember]
        public string currency_name
        {
            get { return _CurrencyName; }
            set { _CurrencyName = value; }
        }
        [DataMember]
        public string currency_code
        {
            get { return _CurrencyCode; }
            set { _CurrencyCode = value; }
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
