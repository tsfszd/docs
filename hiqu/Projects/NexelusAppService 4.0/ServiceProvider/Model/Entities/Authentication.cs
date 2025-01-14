using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using com.paradigm.esm.general;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Authentication : EntityBase
    {

        #region Private Properties

        private string _StrTestDate;

        [DataMember]
        public string TestDate
        {
            get { return _StrTestDate; }
            set { _StrTestDate = value; }
        }

        private string _AuthenticationKey;       
        private string _LoginID;
        private string _Password;
        bool _isFirstTimeLogin = false;

        //private DateTime TempDate;

        #endregion

        #region Public Properties
        [DataMember]
        public bool isFirstTimeLogin
        {
            get { return _isFirstTimeLogin; }
            set { _isFirstTimeLogin = value; }
        }

        [DataMember]
        public string AuthenticationKey
        {
            get { return _AuthenticationKey; }
            set { _AuthenticationKey = value; }
        }
        [DataMember]
        public string LoginID
        {
            get { return _LoginID; }
            set { _LoginID = value; }
        }
        [DataMember]
        public string Password
        {
            get { return _Password; }
            set { _Password = value; }
        }

        #endregion
        
        #region Constructors

        public Authentication()
        {

        }
        
        public Authentication(string authKey, string loginID, string pass)
        {
            this.AuthenticationKey = authKey;
            this.LoginID = loginID;
            this.Password = pass;
        }

        

        #endregion

        //[OnSerializing()]
        //internal void OnSerializingMethod(StreamingContext context)
        //{
        //    string asd = "";
        //}

        //[OnSerialized()]
        //internal void OnSerializedMethod(StreamingContext context)
        //{
        //    string asd = "";
        //}

        //[OnDeserializing()]
        //internal void OnDeserializingMethod(StreamingContext context)
        //{
        //    string asd = "";
        //}

        //[OnDeserialized()]
        //internal void OnDeserializedMethod(StreamingContext context)
        //{
            
        //    TempDate = Converter.ToDate(_StrTestDate);

        //    string asd = "";
        //}

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
