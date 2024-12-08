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
    public class ExpenseReportAttachment : EntityBase
    {
        #region Private Properties

        private string _record_id = "";
        private string _image_data = "";
        private int _is_image_file = 1; //1 for image, 0 for non image file
        private string _file_url="";

        #endregion

        #region Public Properties

        [DataMember]
        public int is_image_file
        {
            get { return _is_image_file; }
            set { _is_image_file = value; }
        }

        [DataMember]
        public string file_url
        {
            get { return _file_url; }
            set { _file_url = value; }
        }

        [DataMember]
        public string image_data
        {
            get { return _image_data; }
            set { _image_data = value; }
        }

        [DataMember]
        public string record_id
        {
            get { return _record_id; }
            set { _record_id = value; }
        }

       
        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
