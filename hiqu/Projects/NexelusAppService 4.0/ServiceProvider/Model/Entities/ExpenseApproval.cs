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

   //Changed inheritance to EntityBase from none, to make error code, error description etc.. avaialble in class... Mati
    public class NewExpenseTransaction :EntityBase
    {

        [DataMember]
        public string ReportID { get; set; }
        [DataMember]
        public string TransactionID { get; set; }
        [DataMember]
        public string ReportName { get; set; }
        [DataMember]
        public float AmountBillable { get; set; }
        [DataMember]
        public int IsFinalisedFlag { get; set; }
        [DataMember]
        public string ResourceID { get; set; }
        [DataMember]
        public float TotalAmount { get; set; }
        [DataMember]
        public int ApprovalFlag { get; set; }
        [DataMember]
        public float AmountTax { get; set; }
        [DataMember]
        public int NonBillableFlag { get; set; }
        [DataMember]
        public float AmountNet { get; set; }
        [DataMember]
        public string StrTimeStamp { get; set; }
        [DataMember]
        public float TransactionAmount { get; set; }
        [DataMember]
        public string approval_comments { get; set; }
        [DataMember]
        public float AmountHome { get; set; }
        [DataMember]
        public int UploadFlag { get; set; }

        //Added this function to make inheritance enable for this class... Mati
        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }

    [DataContract]
    public class ExpenseApproval : EntityBase
    {
      

        #region Private Properties

      
        private string _TimeStamp;
        private byte[] _ByteTS;
        #endregion

        #region Public Properties

        //[DataMember]
        //public int CompanyCode
        //{
        //    get { return _CompanyCode; }
        //    set { _CompanyCode = value; }
        //}


        [DataMember]
        public int company_code { get; set; }
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
        [DataMember]
        public string report_name { get; set; }
        [DataMember]
        public string record_id { get; set; }
        [DataMember]
        public float AmountNet { get; set; }
        [DataMember]
        public string modify_id { get; set; }
        [DataMember]
        public int re_approval_flag { get; set; }
        [DataMember]
        public NewExpenseTransaction[] transactions { get; set; }

        public byte[] ByteTS
        {
            get { return _ByteTS; }
            set { _ByteTS = value; }
        }

        #endregion

        public byte[] ConvertFromStringToBytes(string str, string delim)
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
