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
    public class CreditCardExpense : EntityBase
    {
        #region Private Properties

        private string _StrTimeStamp;
        private byte[] _TimeStamp;
        private int _CCExpId;
        private string _ResourceId;
        private string _StrAppliedDate;
        private double _Amount;
        private string _ExtReferenceNo;
        private string _Comments;
        private string _CreateId;
        private string _StrCreateDate;
        private string _ModifyId;
        private string _StrModifyDate;
        private int _SplitFlag;
        private int _CompanyOrPersonalFlag;
        private DateTime _AppliedDate;
        private string _CCNum;
        private int _PaymentCode;
        private string _PaymentName;
        private string _VendorName;
        private int _CCTypeId;
        private CCOperationTrxDetail _cCOperationTrxDetail;

        #endregion

        #region Public Properties

        [DataMember]
        public int cc_type_id
        {
            get { return _CCTypeId; }
            set { _CCTypeId = value; }
        }
        [DataMember]
        public string vendor_name
        {
            get { return _VendorName; }
            set { _VendorName = value; }
        }
        [DataMember]
        public string payment_name
        {
            get { return _PaymentName; }
            set { _PaymentName = value; }
        }
        [DataMember]
        public int payment_code
        {
            get { return _PaymentCode; }
            set { _PaymentCode = value; }
        }
        [DataMember]
        public string cc_num
        {
            get { return _CCNum; }
            set { _CCNum = value; }
        }
        [DataMember]
        public int company_or_personal_flag
        {
            get { return _CompanyOrPersonalFlag; }
            set { _CompanyOrPersonalFlag = value; }
        }
        [DataMember]
        public int split_flag
        {
            get { return _SplitFlag; }
            set { _SplitFlag = value; }
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
        public string comments
        {
            get { return _Comments; }
            set { _Comments = value; }
        }
        [DataMember]
        public string ext_reference_no
        {
            get { return _ExtReferenceNo; }
            set { _ExtReferenceNo = value; }
        }
        [DataMember]
        public double amount
        {
            get { return _Amount; }
            set { _Amount = value; }
        }
        [DataMember]
        public string str_applied_date
        {
            get { return _StrAppliedDate; }
            set
            {
                _StrAppliedDate = value;

                this.applied_date = DateTime.ParseExact(_StrAppliedDate, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            }
        }
        [DataMember]
        public DateTime applied_date
        {
            get { return _AppliedDate ; }
            set { _AppliedDate = value ; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceId; }
            set { _ResourceId = value; }
        }
        [DataMember]
        public int cc_exp_id
        {
            get { return _CCExpId; }
            set { _CCExpId = value; }
        }
        [DataMember]
        public string timestamp
        {
            get { return _StrTimeStamp; }
            set
            {
                _StrTimeStamp = value;
                this.TimeStamp = ConvertFromStringToBytes(_StrTimeStamp, "|$|");
            }
        }

        public byte[] TimeStamp
        {
            get { return _TimeStamp; }
            set
            {
                _TimeStamp = value;
            }
        }
        [DataMember]
        public CCOperationTrxDetail ccOperationTrxDetail
        {
            get { return _cCOperationTrxDetail; }
            set { _cCOperationTrxDetail = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }

        private byte[] ConvertFromStringToBytes(string str, string delim)
        {
            byte[] bytesArray = { 0, 0, 0, 0, 0, 0, 0, 0 };
            ArrayList arr = new ArrayList();
            arr = Utility.SplitString(str, delim);
            for (int i = 0; i < arr.Count; i++)
            {

                bytesArray[i] = Convert.ToByte(arr[i]);

            }
            return bytesArray;

        }
    }


    [DataContract]
    public class CCOperationTrxDetail
    {
        #region Private Properties
        private List<CCTranxDetails> _cCTranxDetails;
        private List<Double> _split_amount_list;
        private String _create_id;
        private string _action_flag;
        #endregion

        #region Public Properties

        [DataMember]
        public List<CCTranxDetails> cCTranxDetails
        {
            get { return _cCTranxDetails; }
            set { this._cCTranxDetails = value; }
        }

        [DataMember]
        public List<Double> split_amount_list
        {
            get { return _split_amount_list; }
            set { this._split_amount_list = value; }
        }

        [DataMember]
        public string create_id
        {
            get { return _create_id; }
            set { this._create_id = value; }
        }

        [DataMember]
        public string action_flag
        {
            get { return _action_flag; }
            set { this._action_flag = value; }
        }

        #endregion
    }

    [DataContract]
    public class CCTranxDetails
    {
        #region Private Properties
        private int _CCTrxID;
        private Double _CCTrxAmount;
        private string _CCTrxTimeStamp;
        private byte[] _TimeStamp;
        #endregion

        #region Public Properties
        [DataMember]
        public int CCTrxID
        {
            get { return _CCTrxID; }
            set { this._CCTrxID = value; }
        }

        [DataMember]
        public Double CCTrxAmount
        {
            get { return _CCTrxAmount; }
            set { this._CCTrxAmount = value; }
        }

        [DataMember]
        public string CCTrxTimeStamp
        {
               get { return _CCTrxTimeStamp; }
            set
            {
                _CCTrxTimeStamp = value;
                this.TimeStamp = ConvertFromStringToBytes(_CCTrxTimeStamp, "|$|");
            }
        }

        public byte[] TimeStamp
        {
            get { return _TimeStamp; }
            set
            {
                _TimeStamp = value;
            }
        }

        #endregion

        private byte[] ConvertFromStringToBytes(string str, string delim)
        {
            byte[] bytesArray = { 0, 0, 0, 0, 0, 0, 0, 0 };
            ArrayList arr = new ArrayList();
            arr = Utility.SplitString(str, delim);
            for (int i = 0; i < arr.Count; i++)
            {

                bytesArray[i] = Convert.ToByte(arr[i]);

            }
            return bytesArray;

        }
    }

}
