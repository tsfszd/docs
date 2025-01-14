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
    public class TimeApproval : EntityBase
    {
        #region Private Properties

        private string _ApprovedBy;
        private string _TransactionId;
        private int _ApprovalFlag;
        private string _ApprovalComments;
        private int _NonBillableFlag;
        private double _Units;
        private int _ApprovalMode;
        private string _ManagerID;
        private string _Level2Key;
        private string _Level3Key;
        private string _TaskCode;
        private string _ResourceID;
        private int _PageMode;
        private string _TimeStamp;
        private byte[] _ByteTS;
       

        #endregion

        #region Public Properties

        [DataMember]
        public string StrTimeStamp
        {
            get { return _TimeStamp; }
            set
            {
                _TimeStamp = value;
                ByteTS = ConvertFromStringToBytes(_TimeStamp, "|$|");
            }
        }
        public byte[] ByteTS
        {
            get { return _ByteTS; }
            set { _ByteTS = value; }
        }
        [DataMember]
        public string ApprovedBy
        {
            get { return _ApprovedBy; }
            set { _ApprovedBy = value; }
        }

        [DataMember]
        public int ApprovalMode
        {
            get { return _ApprovalMode; }
            set { _ApprovalMode = value; }
        }

        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }

        [DataMember]
        public string TransactionID
        {
            get { return _TransactionId; }
            set { _TransactionId = value; }
        }


        [DataMember]
        public int ApprovalFlag
        {
            get { return _ApprovalFlag; }
            set { _ApprovalFlag = value; }
        }

        [DataMember]
        public double Units
        {
            get { return _Units; }
            set { _Units = value; }
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
        public string TaskCode
        {
            get { return _TaskCode; }
            set { _TaskCode = value; }
        }

        [DataMember]
        public string ApprovalComments
        {
            get { return _ApprovalComments; }
            set { _ApprovalComments = value; }
        }

        [DataMember]
        public int NonBillableFlag
        {
            get { return _NonBillableFlag; }
            set { _NonBillableFlag = value; }
        }


        [DataMember]
        public int PageMode
        {
            get { return _PageMode; }
            set { _PageMode = value; }
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

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
