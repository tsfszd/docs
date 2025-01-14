using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using com.paradigm.esm.general;
using System.Globalization;
using System.Collections;
using NexelusApp.Service.Enums;


namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class EntityChange : EntityBase
    {
        #region Private Properties

        private int _EntityChangeID;
        private string _PrimaryKey;
        private enumEntityAction _EntityAction;
        private enumEntityType _EntityType;
        private string _SubscriberID;
        private string _CurrentSyncDate;

        #endregion

        #region Public Properties

        [DataMember]
        public string CurrentSyncDate
        {
            get { return _CurrentSyncDate; }
            set { _CurrentSyncDate = value; }
        }

        [DataMember]
        public string SubscriberID
        {
            get { return _SubscriberID; }
            set { _SubscriberID = value; }
        }
        [DataMember]
        public enumEntityAction EntityAction
        {
            get { return _EntityAction; }
            set { _EntityAction = value; }
        }
        [DataMember]
        public string PrimaryKey
        {
            get { return _PrimaryKey; }
            set { _PrimaryKey = value; }
        }
        [DataMember]
        public int EntityChangeID
        {
            get { return _EntityChangeID; }
            set { _EntityChangeID = value; }
        }
        [DataMember]
        public enumEntityType EntityType
        {
            get { return _EntityType; }
            set { _EntityType = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
