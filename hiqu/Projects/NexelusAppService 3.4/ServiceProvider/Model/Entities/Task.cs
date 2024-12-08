using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Task : EntityBase
    {

        #region Private Properties

        private int _TaskType;
        private string _TaskTypeDescription = "";
        private string _TaskCode = "";
        private string _TaskDescription = "";

        #endregion
        
        #region Public Members

        [DataMember]
        public int TaskType
        {
            get { return _TaskType; }
            set { _TaskType = value; }
        }
        [DataMember]
        public string TaskTypeDescription
        {
            get { return _TaskTypeDescription; }
            set { _TaskTypeDescription = value; }
        }
        [DataMember]
        public string TaskCode
        {
            get { return _TaskCode; }
            set { _TaskCode = value; }
        }
        [DataMember]
        public string TaskDescription
        {
            get { return _TaskDescription; }
            set { _TaskDescription = value; }
        }

        #endregion

        #region Constructors

        public Task()
        {

        }

        #endregion


        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
