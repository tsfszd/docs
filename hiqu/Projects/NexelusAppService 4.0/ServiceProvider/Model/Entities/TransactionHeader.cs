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
    public class TransactionHeader : EntityBase
    {

        #region Private Properties

        private int _action_flag;
        private string _transaction_id = "";        
        private string _timstamp = "";
        private byte[] _ByteTS;        
        private string _report_name = "";
        private string _resource_id = "";
        private string _record_id = "";
        private string _comments = "";
        private string _date_from = ""; 
        private DateTime _DateFrom;
        private string _date_to = "";
        private DateTime _DateTo;
        private string _expense_num = "";        
        private double _amount;        
        private string _create_date = "";
        private string _create_id = "";        
        private string _modify_date = "";        
        private string _modify_id = "";        
        private string _approver_id = "";        
        private string _print_format = "";        
        private string _re_approval_flag = "";
        private string _submitter_id = "";
        private int _error_flag;
        private string _error_code = "";
        private string _error_description = "";
        private int _summary_flag;
        private int _approved_flag;
        private int _is_cc;
        private int _is_submitted;
        private List<ExpenseTransaction> _transactions;
        private string _name_first = "";
        private string _name_last = "";
        private string _report_owner_currency_code = "";

        #endregion

        #region Public Properties


        [DataMember]
        public string report_owner_currency_code
        {
            get { return _report_owner_currency_code; }
            set { _report_owner_currency_code = value; }
        }

        [DataMember]
        public string name_first
        {
            get { return _name_first; }
            set { _name_first = value; }
        }

        [DataMember]
        public string name_last
        {
            get { return _name_last; }
            set { _name_last = value; }
        }

        [DataMember]
        public int approved_flag
        {
            get { return _approved_flag; }
            set { _approved_flag = value; }
        }

        [DataMember]
        public int is_submitted
        {
            get { return _is_submitted; }
            set { _is_submitted = value; }
        }
        [DataMember]
        public int is_cc
        {
            get { return _is_cc; }
            set { _is_cc = value; }
        }
        [DataMember]
        public string transaction_id
        {
            get { return _transaction_id; }
            set { _transaction_id = value; }
        }
        [DataMember]
        public string timestamp
        {
            get { return _timstamp; }
            set 
            { 
                _timstamp = value;
                ByteTS = ConvertFromStringToBytes(_timstamp, "|$|");
            }
        }
        [DataMember]
        public string report_name
        {
            get { return _report_name; }
            set { _report_name = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _resource_id; }
            set { _resource_id = value; }
        }
        [DataMember]
        public string record_id
        {
            get { return _record_id; }
            set { _record_id = value; }
        }
        [DataMember]
        public string comments
        {
            get { return _comments; }
            set { _comments = value; }
        }
        [DataMember]
        public string str_date_from
        {
            get { return _date_from; }
            set 
            { 
                _date_from = value;
                DateFrom = DateTime.ParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            }
        }
        [DataMember]
        public string str_date_to
        {
            get { return _date_to; }
            set 
            { 
                _date_to = value;
                DateTo = DateTime.ParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            }
        }
        [DataMember]
        public string expense_num
        {
            get { return _expense_num; }
            set { _expense_num = value; }
        }
        [DataMember]
        public double amount
        {
            get { return _amount; }
            set { _amount = value; }
        }
        [DataMember]
        public string str_create_date
        {
            get { return _create_date; }
            set { _create_date = value; }
        }
        [DataMember]
        public string create_id
        {
            get { return _create_id; }
            set { _create_id = value; }
        }
        [DataMember]
        public string str_modify_date
        {
            get { return _modify_date; }
            set { _modify_date = value; }
        }
        [DataMember]
        public string modify_id
        {
            get { return _modify_id; }
            set { _modify_id = value; }
        }
        [DataMember]
        public string approver_id
        {
            get { return _approver_id; }
            set { _approver_id = value; }
        }
        [DataMember]
        public string print_format
        {
            get { return _print_format; }
            set { _print_format = value; }
        }
        [DataMember]
        public string re_approval_flag
        {
            get { return _re_approval_flag; }
            set { _re_approval_flag = value; }
        }
        [DataMember]
        public string submitter_id
        {
            get { return _submitter_id; }
            set { _submitter_id = value; }
        }
        [DataMember]
        public List<ExpenseTransaction> transactions
        {
            get { return _transactions; }
            set { _transactions = value; }
        }
        [DataMember]
        public int ActionFlag
        {
            get { return _action_flag; }
            set { _action_flag = value; }
        }
        [DataMember]
        public string error_description
        {
            get { return _error_description; }
            set { _error_description = value; }
        }
        [DataMember]
        public string error_code
        {
            get { return _error_code; }
            set { _error_code = value; }
        }
        [DataMember]
        public int error_flag
        {
            get { return _error_flag; }
            set { _error_flag = value; }
        }
        [DataMember]
        public int summary_flag
        {
            get { return _summary_flag; }
            set { _summary_flag = value; }
        }

       

        public DateTime DateFrom
        {
            get { return _DateFrom ; }
            set { _DateFrom = value ; }
        }
        public DateTime DateTo
        {
            get { return _DateTo; }
            set { _DateTo = value; }
        }
        public byte[] ByteTS
        {
            get { return _ByteTS; }
            set { _ByteTS = value; }
        }


        #endregion

        private string ConvertFromByteToString(byte[] bytesArray, string delim)
        {
            string str = "";
            if (bytesArray == null || bytesArray.Length < 1)
                return "";
            for (int i = 0; i < bytesArray.Length; i++)
            {
                str = str + bytesArray[i] + delim;
            }
            return str;

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

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
