using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Model.Entities
{
    public class BaseDocument : EntityBase
    {
        #region Properties
        public string DocumentName { get; set; }
        public string UploadedBy { get; set; }
        public string DocumentLink { get; set; }
        public string DocumentPath { get; set; }
        public string ExtDriveID { get; set; }
        public double FileSize { get; set; }
        #endregion
        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
