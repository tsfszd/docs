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
    public class ResourceType : EntityBase
    {
        #region Private Properties

        //private byte[] _timestamp;
        private string _strTimestamp = "";
        private string _res_category_code = "";
        private byte reciept_exampted_flag = 0;
        private int _res_type;
        private string _rtype_name = "";
        private string _rtype_description = "";
        private string _uom_code = "";
        private int _rtype_status;
        private int _normalize_units_flag;
        private double _standard_units;
        private string _seg_value = "";
        private string _gl_account = "";
        private string _create_id = "";
        private DateTime _create_date;
        private string _str_create_date = "";
        private string _modify_id = "";
        private DateTime _modify_date;
        private string _str_modify_date = "";

        #endregion

        #region Public Properties
        [DataMember]
        public string str_modify_date
        {
            get { return _str_modify_date; }
            set { _str_modify_date = value; }
        }
        [DataMember]
        public DateTime modify_date
        {
            get { return _modify_date.ToUniversalTime(); }
            set { _modify_date = value.ToUniversalTime(); }
        }
        [DataMember]
        public string modify_id
        {
            get { return _modify_id; }
            set { _modify_id = value; }
        }
        [DataMember]
        public string str_create_date
        {
            get { return _str_create_date; }
            set { _str_create_date = value; }
        }
        [DataMember]
        public DateTime create_date
        {
            get { return _create_date.ToUniversalTime() ; }
            set { _create_date = value.ToUniversalTime(); }
        }
        [DataMember]
        public string create_id
        {
            get { return _create_id; }
            set { _create_id = value; }
        }
        [DataMember]
        public string gl_account
        {
            get { return _gl_account; }
            set { _gl_account = value; }
        }
        [DataMember]
        public string seg_value
        {
            get { return _seg_value; }
            set { _seg_value = value; }
        }
        [DataMember]
        public double standard_units
        {
            get { return _standard_units; }
            set { _standard_units = value; }
        }
        [DataMember]
        public int normalize_units_flag
        {
            get { return _normalize_units_flag; }
            set { _normalize_units_flag = value; }
        }
        [DataMember]
        public int rtype_status
        {
            get { return _rtype_status; }
            set { _rtype_status = value; }
        }
        [DataMember]
        public string uom_code
        {
            get { return _uom_code; }
            set { _uom_code = value; }
        }
        [DataMember]
        public string rtype_description
        {
            get { return _rtype_description; }
            set { _rtype_description = value; }
        }
        [DataMember]
        public string rtype_name
        {
            get { return _rtype_name; }
            set { _rtype_name = value; }
        }
        [DataMember]
        public int res_type
        {
            get { return _res_type; }
            set { _res_type = value; }
        }
        [DataMember]
        public string res_category_code
        {
            get { return _res_category_code; }
            set { _res_category_code = value; }
        }
        [DataMember]
        public string timestamp
        {
            get { return _strTimestamp; }
            set
            {
                _strTimestamp = value;
            }
        }
        [DataMember]
        public byte receiptExamptedFlag
        {
            get { return reciept_exampted_flag; }
            set { reciept_exampted_flag = value; }
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
