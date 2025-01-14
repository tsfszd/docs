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
    public class Transaction : EntityBase
    {

        #region Private Properties

        private int _LineID;
        private int _ActionFlag;
        private int _DBActionFlag;
        private string _TransactionID = "";
        private string _Level2Key = "";
        private string _Level3Key = "";
        private DateTime _AppliedDate;
        private string _StrAppliedDate = "";
        private int _TrxType;
        private string _ResourceID = "";
        private string _ResUsageCode = "";
        private double _Units;
        private string _LocationCode = "";
        private string _OrgUnit = "";
        private string _TaskCode = "";
        private string _Comments = "";
        private int _NonBillableFlag;
        private int _SubmittedFlag;
        private DateTime _SubmittedDate;
        private int _ApprovalFlag;
        private byte[] _TimeStamp;
        private string _StrTimeStamp = "";
        private DateTime _ModifyDate = default(DateTime);
        private string _StrModifyDate = "";
        //private int _ErrorFlag = 0;
        //private int _ErrorCode;
        //private string _ErrorDescription = "";
        private string _DeviceInfo = "";

        //Aprroval Changes
        private string _FirstName;
        private string _LastName;
        private string _approvalComments;
        private int _uploadFlag;

        private int _is_approver;
        private int _is_finance_approver;




        #endregion

        #region Public Properties


        [DataMember]
        public int is_approver
        {
            get { return _is_approver; }
            set { _is_approver = value; }
        }

        [DataMember]
        public int is_finance_approver
        {
            get { return _is_finance_approver; }
            set { _is_finance_approver = value; }
        }


        [DataMember]
        public string ApprovalComments
        {
            get { return _approvalComments; }
            set { _approvalComments = value; }
        }
        [DataMember]
        public int UploadFlag
        {
            get { return _uploadFlag; }
            set { _uploadFlag = value; }
        }

        [DataMember]
        public int line_id
        {
            get { return _LineID; }
            set { _LineID = value; }
        }
        [DataMember]
        public int ActionFlag
        {
            get { return _ActionFlag; }
            set { _ActionFlag = value; }
        }
        public int DBActionFlag
        {
            get { return _DBActionFlag; }
            set { _DBActionFlag = value; }
        }
        [DataMember]
        public string TransactionID
        {
            get { return _TransactionID; }
            set { _TransactionID = value; }
        }
        [DataMember]
        public string Level2Key
        {
            get { return _Level2Key; }
            set { _Level2Key = value; }
        }
        [DataMember]
        public string Level3Key
        {
            get { return _Level3Key; }
            set { _Level3Key = value; }
        }
        [DataMember]
        public DateTime AppliedDate
        {
            get { return _AppliedDate ; }
            set
            {
                _AppliedDate = value ;
                this._AppliedDate = DateTime.SpecifyKind(this._AppliedDate, DateTimeKind.Utc);//3A. 20180911: Fixed Date issue of increasing a day.
            }
        }

        [DataMember]
        public string StrAppliedDate
        {
            get { return _StrAppliedDate; }
            set
            {
                _StrAppliedDate = value;
                //this._AppliedDate = DateTime.ParseExact(_StrAppliedDate, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture)
                this._AppliedDate = Converter.ToDate( _StrAppliedDate, "yyyy-MM-dd HH:mm:ss");
                this._AppliedDate = DateTime.SpecifyKind(this._AppliedDate, DateTimeKind.Utc);
            }
        }

        [DataMember]
        public int TrxType
        {
            get { return _TrxType; }
            set { _TrxType = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        [DataMember]
        public string ResUsageCode
        {
            get { return _ResUsageCode; }
            set { _ResUsageCode = value; }
        }
        [DataMember]
        public double Units
        {
            get { return _Units; }
            set { _Units = value; }
        }
        [DataMember]
        public string LocationCode
        {
            get { return _LocationCode; }
            set { _LocationCode = value; }
        }
        [DataMember]
        public string OrgUnit
        {
            get { return _OrgUnit; }
            set { _OrgUnit = value; }
        }
        [DataMember]
        public string TaskCode
        {
            get { return _TaskCode; }
            set { _TaskCode = value; }
        }
        [DataMember]
        public string Comments
        {
            get { return _Comments; }
            set { _Comments = value; }
        }
        [DataMember]
        public int NonBillableFlag
        {
            get { return _NonBillableFlag; }
            set { _NonBillableFlag = value; }
        }
        [DataMember]
        public int SubmittedFlag
        {
            get { return _SubmittedFlag; }
            set { _SubmittedFlag = value; }
        }
        [DataMember]
        public DateTime SubmittedDate
        {
            get { return _SubmittedDate.ToUniversalTime(); }
            set { _SubmittedDate = value.ToUniversalTime(); }
        }
        [DataMember]
        public int ApprovalFlag
        {
            get { return _ApprovalFlag; }
            set { _ApprovalFlag = value; }
        }
        [DataMember]
        public DateTime ModifyDate
        {
            get { return _ModifyDate.ToUniversalTime(); }
            set { _ModifyDate = value.ToUniversalTime(); }
        }

        public string StrModifyDate
        {
            get { return _StrModifyDate; }
            set
            {
                _StrModifyDate = value;

                //DateTime convertedDate = DateTime.SpecifyKind(
                //    DateTime.Parse(StrAppliedDate),
                //    DateTimeKind.Utc);
                //DateTimeKind kind = convertedDate.Kind; // will equal DateTimeKind.Utc

                ModifyDate = ModifyDate.ToLocalTime();
            }
        }

        //[DataMember]
        //public int ErrorFlag
        //{
        //    get { return _ErrorFlag; }
        //    set { _ErrorFlag = value; }
        //}
        //[DataMember]
        //public int ErrorCode
        //{
        //    get { return _ErrorCode; }
        //    set { _ErrorCode = value; }
        //}
        //[DataMember]
        //public string ErrorDescription
        //{
        //    get { return _ErrorDescription; }
        //    set { _ErrorDescription = value; }
        //}
        [DataMember]
        public string StrTimeStamp
        {
            get { return _StrTimeStamp; }
            set
            {
                _StrTimeStamp = value;
                this.TimeStamp = ConvertFromStringToBytes(_StrTimeStamp, "|$|");
            }
        }
        [DataMember]
        public string DeviceInfo
        {
            get { return _DeviceInfo; }
            set { _DeviceInfo = value; }
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
        public string first_name
        {
            get { return _FirstName; }
            set { _FirstName = value; }
        }

        [DataMember]
        public string last_name
        {
            get { return _LastName; }
            set { _LastName = value; }
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

        [OnDeserialized]
        internal void OnDeserializedMethod(StreamingContext context)
        {


            if (ModifyDate != default(DateTime))
            {
                ModifyDate = ModifyDate.ToLocalTime();
            }
        }

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}

