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
    public class TransactionExpense : EntityBase
    {

        #region Private Properties

        private string _StrTimeStamp = "";
        private string _TransactionId = "";
        private string _RecordId = "";
        private string _Text1 = "";
        private string _Text2 = "";
        private string _Text3 = "";
        private string _Text4 = "";
        private string _Text5 = "";
        private string _Text6 = "";
        private string _Text7 = "";
        private string _Text8 = "";
        private string _Text9 = "";
        private string _Text10 = "";
        private double _Number11;
        private double _Number12;
        private double _Number13;
        private double _Number14;
        private double _Number15;
        private double _Number16;
        private double _Number17;
        private double _Number18;
        private double _Number19;
        private double _Number20;
        private string _Create_id;
        private string _create_date;

        
        #endregion

        #region Public Properties

        [DataMember]
        public string str_create_date
        {
            get { return _create_date; }
            set { _create_date = value; }
        }
        [DataMember]
        public string create_id
        {
            get { return _Create_id; }
            set { _Create_id = value; }
        }

        [DataMember]
        public double number20
        {
            get { return _Number20; }
            set { _Number20 = value; }
        }
        [DataMember]
        public double number19
        {
            get { return _Number19; }
            set { _Number19 = value; }
        }
        [DataMember]
        public double number18
        {
            get { return _Number18; }
            set { _Number18 = value; }
        }
        [DataMember]
        public double number17
        {
            get { return _Number17; }
            set { _Number17 = value; }
        }
        [DataMember]
        public double number16
        {
            get { return _Number16; }
            set { _Number16 = value; }
        }
        [DataMember]
        public double number15
        {
            get { return _Number15; }
            set { _Number15 = value; }
        }
        [DataMember]
        public double number14
        {
            get { return _Number14; }
            set { _Number14 = value; }
        }
        [DataMember]
        public double number13
        {
            get { return _Number13; }
            set { _Number13 = value; }
        }
        [DataMember]
        public double number12
        {
            get { return _Number12; }
            set { _Number12 = value; }
        }
        [DataMember]
        public double number11
        {
            get { return _Number11; }
            set { _Number11 = value; }
        }
        [DataMember]
        public string text10
        {
            get { return _Text10; }
            set { _Text10 = value; }
        }
        [DataMember]
        public string text9
        {
            get { return _Text9; }
            set { _Text9 = value; }
        }
        [DataMember]
        public string text8
        {
            get { return _Text8; }
            set { _Text8 = value; }
        }
        [DataMember]
        public string text7
        {
            get { return _Text7; }
            set { _Text7 = value; }
        }
        [DataMember]
        public string text6
        {
            get { return _Text6; }
            set { _Text6 = value; }
        }
        [DataMember]
        public string text5
        {
            get { return _Text5; }
            set { _Text5 = value; }
        }
        [DataMember]
        public string text4
        {
            get { return _Text4; }
            set { _Text4 = value; }
        }
        [DataMember]
        public string text3
        {
            get { return _Text3; }
            set { _Text3 = value; }
        }
        [DataMember]
        public string text2
        {
            get { return _Text2; }
            set { _Text2 = value; }
        }
        [DataMember]
        public string text1
        {
            get { return _Text1; }
            set { _Text1 = value; }
        }
        [DataMember]
        public string record_id
        {
            get { return _RecordId; }
            set { _RecordId = value; }
        }
        [DataMember]
        public string transaction_id
        {
            get { return _TransactionId; }
            set { _TransactionId = value; }
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
