using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Globalization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class PermanentLine : EntityBase
    {

        #region Private Properties

        private int _ActionFlag;
        private byte[] _Timestamp;
        private string _ResourceID = "";
        private string _Level2Key = "";
        private string _Level2Description = "";
        private string _Level3Key = "";
        private string _Level3Description = "";
        private string _CustomerCode = "";
        private string _TaskCode = "";
        private DateTime _StartDate = default(DateTime);
        private DateTime _EndDate = default(DateTime);
        private string _StrStartDate = "";
        private string _StrEndDate = "";

        #endregion

        #region Public Properties

        [DataMember]
        public int ActionFlag
        {
            get { return _ActionFlag; }
            set { _ActionFlag = value; }
        }
        [DataMember]
        public byte[] Timestamp
        {
            get { return _Timestamp; }
            set { _Timestamp = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        [DataMember]
        public string Level2Key
        {
            get { return _Level2Key; }
            set { _Level2Key = value; }
        }
        [DataMember]
        public string Level2Description
        {
            get { return _Level2Description; }
            set { _Level2Description = value; }
        }
        [DataMember]
        public string Level3Key
        {
            get { return _Level3Key; }
            set { _Level3Key = value; }
        }
        [DataMember]
        public string Level3Description
        {
            get { return _Level3Description; }
            set { _Level3Description = value; }
        }
        [DataMember]
        public string CustomerCode
        {
            get { return _CustomerCode; }
            set { _CustomerCode = value; }
        }
        [DataMember]
        public string TaskCode
        {
            get { return _TaskCode; }
            set { _TaskCode = value; }
        }
        [DataMember]
        public DateTime StartDate
        {
            get { return _StartDate ; }
            set 
            {
                _StartDate = value ;

                if (_StartDate != default(DateTime))
                {
                    _StrStartDate = _StartDate.ToString("yyyy-MM-dd HH:mm:ss");
                }
                    
            }
        }
        [DataMember]
        public DateTime EndDate
        {
            get { return _EndDate ; }
            set 
            { 
                _EndDate = value ;

                if (_EndDate != default(DateTime))
                {
                    _StrEndDate = _EndDate.ToString("yyyy-MM-dd HH:mm:ss");    
                }
                
            }
        }
        [DataMember]
        public string StrStartDate
        {
            get { return _StrStartDate; }
            set 
            { 
                _StrStartDate = value;

                this._StartDate = DateTime.ParseExact(_StrStartDate, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            }
        }
        [DataMember]
        public string StrEndDate
        {
            get { return _StrEndDate; }
            set 
            { 
                _StrEndDate = value;

                this._EndDate = DateTime.ParseExact(_StrEndDate, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            }
        }
        #endregion

        #region Constructors

        public PermanentLine()
        {

        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
