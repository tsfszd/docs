using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using com.paradigm.esm.general;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract]
    public class CriteriaBase<T> where T: EntityBase, new()
    {
        private DateTime _LastSyncDate = DateTime.Now ;
        private string _StrSyncDate = "";
        private int _ActionFlag;
        private bool _isFirstTime;
        private List<string> _Keys;
        // This is used only for the multicurrency change
        private int _useDummyData = 0;


        [DataMember]
        public int UseDummyData
        {
            get { return _useDummyData; }
            set { _useDummyData = value; }
        }

        [DataMember]
        public List<string> Keys
        {
            get { return _Keys; }
            set { _Keys = value; }
        }

        [DataMember]
        public bool isFirstTime
        {
            get { return _isFirstTime; }
            set { _isFirstTime = value; }
        }

        [DataMember]
        public int ActionFlag
        {
            get { return _ActionFlag; }
            set { _ActionFlag = value; }
        }

        public DateTime LastSyncDate
        {
            get { return _LastSyncDate; }
            set { _LastSyncDate = value; }
        }

        [DataMember]
        public string StrSyncDate
        {
            get { return _StrSyncDate; }
            set 
            { 
                _StrSyncDate = value;

                if (value != "")
                {
                    LastSyncDate = Converter.ToDate(value, "yyyy-MM-dd HH:mm:ss");
                }                
            }
        }

        public CriteriaBase()
        {

        }
    }
}
