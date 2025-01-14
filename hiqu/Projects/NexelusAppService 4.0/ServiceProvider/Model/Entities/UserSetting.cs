using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class UserSetting : EntityBase
    {
        #region Private Members

        private string _ResourceID;
        private string _StartUpPage;
        private string _TimesheetPeriod;
        private string _DateFormat;
        private int _SortBy;
        private string _NewPassword;
        private string _SearchCustomerBy;
        private string _SearchProjectBy;
        private int _MaxHrsDay;
        private int _MaxHrsMonth;
        private int _MaxHrsWeek;
        private int _WeekStarts;
        private int _SortActivityBy;
        private int _Level2Level3ColumnLength;

        #endregion

        #region Public Members
        [DataMember]
        public int Level2Level3ColumnLength
        {
            get { return _Level2Level3ColumnLength; }
            set { _Level2Level3ColumnLength = value; }
        }

        [DataMember]
        public int SortActivityBy
        {
            get { return _SortActivityBy; }
            set { _SortActivityBy = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        [DataMember]
        public string StartUpPage
        {
            get { return _StartUpPage; }
            set { _StartUpPage = value; }
        }
        [DataMember]
        public string TimesheetPeriod
        {
            get { return _TimesheetPeriod; }
            set { _TimesheetPeriod = value; }
        }
        [DataMember]
        public string DateFormat
        {
            get { return _DateFormat; }
            set { _DateFormat = value; }
        }
        [DataMember]
        public int SortBy
        {
            get { return _SortBy; }
            set { _SortBy = value; }
        }
        [DataMember]
        public string NewPassword
        {
            get { return _NewPassword; }
            set { _NewPassword = value; }
        }
        
        [DataMember]
        public string SearchCustomerBy
        {
            get { return _SearchCustomerBy; }
            set { _SearchCustomerBy = value; }
        }
        [DataMember]
        public string SearchProjectBy
        {
            get { return _SearchProjectBy; }
            set { _SearchProjectBy = value; }
        }        
        [DataMember]
        public int MaxHrsDay
        {
            get { return _MaxHrsDay; }
            set { _MaxHrsDay = value; }
        }
        [DataMember]
        public int MaxHrsMonth
        {
            get { return _MaxHrsMonth; }
            set { _MaxHrsMonth = value; }
        }
        [DataMember]
        public int MaxHrsWeek
        {
            get { return _MaxHrsWeek; }
            set { _MaxHrsWeek = value; }
        }
        [DataMember]
        public int WeekStarts
        {
            get { return _WeekStarts; }
            set { _WeekStarts = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
