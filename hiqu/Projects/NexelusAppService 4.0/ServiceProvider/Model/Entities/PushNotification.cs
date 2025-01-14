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
    public class PushNotification : EntityBase
    {
        #region Private Properties

        private int _company_code;
        private string _resource_id = "";
        private string _product_number = "";
        private string _device_token="";

        #endregion

        #region Public Properties

        [DataMember]
        public int company_code
        {
            get { return _company_code; }
            set { _company_code = value; }
        }

        [DataMember]
        public string resource_id
        {
            get { return _resource_id; }
            set { _resource_id = value; }
        }

        [DataMember]
        public string product_number
        {
            get { return _product_number; }
            set { _product_number = value; }
        }

        [DataMember]
        public string device_token
        {
            get { return _device_token; }
            set { _device_token = value; }
        }

       
        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
