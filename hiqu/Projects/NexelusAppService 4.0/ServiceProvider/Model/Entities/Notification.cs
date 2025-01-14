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
    public class Notification : EntityBase
    {
        #region Private Properties

        private string _company_code;
        private string _notification_id;
        private string _resource_id;
        private string _subscriber_id;
        private string _notification_body;
        private string _notification_type;
        private int _delete_flag = 0;
        //private DateTime _delete_date = default(DateTime);
        private int _read_flag = 0;
        //private DateTime _read_date = default(DateTime);
        //private string _create_id;
        //private DateTime _create_date = default(DateTime);
        //private string _modify_id;
        //private DateTime _modify_date = default(DateTime);
        private string _record_id;
        private string _transaction_id;
        private string _mode;
        private List<string> _Keys;

        #endregion

        #region Public Properties
        [DataMember]
        public List<string> Keys
        {
            get { return _Keys; }
            set { _Keys = value; }
        }

        [DataMember]
        public string mode
        {
            get { return _mode; }
            set { _mode = value; }
        }

        [DataMember]
        public string company_code
        {
            get { return _company_code; }
            set { _company_code = value; }
        }
        [DataMember]
        public string notification_id
        {
            get { return _notification_id; }
            set { _notification_id = value; }
        }
        [DataMember]
        public string resource_id
        {
            get { return _resource_id; }
            set { _resource_id = value; }
        }
        [DataMember]
        public string subscriber_id
        {
            get { return _subscriber_id; }
            set { _subscriber_id = value; }
        }
        [DataMember]
        public string notification_body
        {
            get { return _notification_body; }
            set { _notification_body = value; }
        }
        [DataMember]
        public string notification_type
        {
            get { return _notification_type; }
            set { _notification_type = value; }
        }
        [DataMember]
        public int delete_flag
        {
            get { return _delete_flag; }
            set { _delete_flag = value; }
        }
        //[DataMember]
        //public DateTime delete_date
        //{
        //    get { return _delete_date; }
        //    set { _delete_date = value; }
        //}
        [DataMember]
        public int read_flag
        {
            get { return _read_flag; }
            set { _read_flag = value; }
        }
        //[DataMember]
        //public DateTime read_date
        //{
        //    get { return _read_date; }
        //    set { _read_date = value; }
        //}
        //[DataMember]
        //public string create_id
        //{
        //    get { return _create_id; }
        //    set { _create_id = value; }
        //}
        //[DataMember]
        //public DateTime create_date
        //{
        //    get { return _create_date; }
        //    set { _create_date = value; }
        //}
        //[DataMember]
        //public string modify_id
        //{
        //    get { return _modify_id; }
        //    set { _modify_id = value; }
        //}
        //[DataMember]
        //public DateTime modify_date
        //{
        //    get { return _modify_date; }
        //    set { _modify_date = value; }
        //}
        [DataMember]
        public string record_id
        {
            get { return _record_id; }
            set { _record_id = value; }
        }
        [DataMember]
        public string transaction_id
        {
            get { return _transaction_id; }
            set { _transaction_id = value; }
        }        

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
