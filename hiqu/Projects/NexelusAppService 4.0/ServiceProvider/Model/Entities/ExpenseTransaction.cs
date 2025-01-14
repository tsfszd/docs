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
    public class ExpenseTransaction : Transaction
    {

        #region Private Properties

        private int _ResType;
        private int _PaymentCode;
        private string _PaymentName = "";
        private string _CurrencyCode = "";
        private double _CurrencyConversionRate;
        private double _Amount;
        private double _AmountHome;
        private double _AmountBillable;
        private int _ReciptFlag;
        private int _ReimbursmentFlag;
        private string _RecordId = "";
        private string _GSTTaxCode = "";
        private double _NetAmount;
        private int _CCExpId;
        private byte[] _CCTimeStamp;
        private string _StrCCTimeStamp;
        private string _CCNum = "";
        private int _CCTypeId;
        private string _image_path = "";
        private string _approval_comments = "";

        private string _image_data = "";
        private int _isFileAttached;
        private int _isImageChanged;
        private int _consider_image;
        private string _attachmentURL;

        private TransactionExpense _customFields;

        // These are only for Android (for when it is sent for delete the exp transaction, it expects the response of expense transaction). 
        // These fields will only contain the header things.
        private string _hdr_timestamp;
        private double _hdr_amount;
        private string _hdr_date_from;
        private string _hdr_date_to;

        //New Fields for Approvals
        private int _finalise_flag;

        //private int _is_approver;
        //private int _is_finance_approver;
        private int _trx_approval_flag;
        private int _trx_approval_required_flag;
        private string _approvers;


        #endregion

        #region Public Properties



        //[DataMember]
        //public int is_approver
        //{
        //    get { return _is_approver; }
        //    set { _is_approver = value; }
        //}

        //[DataMember]
        //public int is_finance_approver
        //{
        //    get { return _is_finance_approver; }
        //    set { _is_finance_approver = value; }
        //}


        [DataMember]
        public int trx_approval_flag
        {
            get { return _trx_approval_flag; }
            set { _trx_approval_flag = value; }
        }

        [DataMember]
        public int trx_approval_required_flag
        {
            get { return _trx_approval_required_flag; }
            set { _trx_approval_required_flag = value; }
        }


        [DataMember]
        public int finalise_flag
        {
            get { return _finalise_flag; }
            set { _finalise_flag = value; }
        }

        [DataMember]
        public string hdr_date_to
        {
            get { return _hdr_date_to; }
            set { _hdr_date_to = value; }
        }
        [DataMember]
        public string hdr_date_from
        {
            get { return _hdr_date_from; }
            set { _hdr_date_from = value; }
        }
        [DataMember]
        public double hdr_amount
        {
            get { return _hdr_amount; }
            set { _hdr_amount = value; }
        }
        [DataMember]
        public string hdr_timestamp
        {
            get { return _hdr_timestamp; }
            set { _hdr_timestamp = value; }
        }

        [DataMember]
        public int consider_image
        {
            get { return _consider_image; }
            set { _consider_image = value; }
        }

        [DataMember]
        public int IsImageChanged
        {
            get { return _isImageChanged; }
            set { _isImageChanged = value; }
        }
        [DataMember]
        public string approval_comments
        {
            get { return _approval_comments; }
            set { _approval_comments = value; }
        }
        [DataMember]
        public int IsFileAttached
        {
            get { return _isFileAttached; }
            set { _isFileAttached = value; }
        }

        [DataMember]
        public string image_path
        {
            get { return _image_path; }
            set { _image_path = value; }
        }
        [DataMember]
        public string image_data
        {
            get { return _image_data; }
            set { _image_data = value; }
        }
        [DataMember]
        public int res_type
        {
            get { return _ResType; }
            set { _ResType = value; }
        }
        [DataMember]
        public int payment_code
        {
            get { return _PaymentCode; }
            set { _PaymentCode = value; }
        }
        [DataMember]
        public string payment_name
        {
            get { return _PaymentName; }
            set { _PaymentName = value; }
        }
        [DataMember]
        public string currency_code
        {
            get { return _CurrencyCode; }
            set { _CurrencyCode = value; }
        }
        [DataMember]
        public double currency_conversion_rate
        {
            get { return _CurrencyConversionRate; }
            set { _CurrencyConversionRate = value; }
        }
        [DataMember]
        public double amount
        {
            get { return _Amount; }
            set { _Amount = value; }
        }
        [DataMember]
        public double amount_home
        {
            get { return _AmountHome; }
            set { _AmountHome = value; }
        }
        [DataMember]
        public double amount_billable
        {
            get { return _AmountBillable; }
            set { _AmountBillable = value; }
        }
        [DataMember]
        public int recipt_Flag
        {
            get { return _ReciptFlag; }
            set { _ReciptFlag = value; }
        }
        [DataMember]
        public int reimbursment_flag
        {
            get { return _ReimbursmentFlag; }
            set { _ReimbursmentFlag = value; }
        }
        [DataMember]
        public string record_id
        {
            get { return _RecordId; }
            set { _RecordId = value; }
        }
        [DataMember]
        public string gst_tax_code
        {
            get { return _GSTTaxCode; }
            set { _GSTTaxCode = value; }
        }
        [DataMember]
        public double net_amount
        {
            get { return _NetAmount; }
            set { _NetAmount = value; }
        }
        [DataMember]
        public int cc_exp_id
        {
            get { return _CCExpId; }
            set { _CCExpId = value; }
        }
        
        public byte[] cc_time_stamp
        {
            get { return _CCTimeStamp; }
            set { _CCTimeStamp = value; }
        }

        [DataMember]
        public string str_cc_time_stamp
        {
            get { return _StrCCTimeStamp; }
            set
            {
                _StrCCTimeStamp = value;
                this.cc_time_stamp = ConvertFromStringToBytes(_StrCCTimeStamp, "|$|");
            }
        }

       
        [DataMember]
        public string cc_num
        {
            get { return _CCNum; }
            set { _CCNum = value; }
        }
        [DataMember]
        public int cc_type_id
        {
            get { return _CCTypeId; }
            set { _CCTypeId = value; }
        }
        [DataMember]
        public TransactionExpense custom_fields
        {
            get { return _customFields; }
            set { _customFields = value; }
        }

        [DataMember]
        public string Approvers
        {
            get { return _approvers; }
            set { _approvers = value; }
        }
        [DataMember]
        public string attachment_url
        {
            get { return _attachmentURL; }
            set { _attachmentURL = value; }
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
}
