using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Model.Entities
{
    public class TransactionDetailDocument : BaseDocument
    {
        #region Properties
        public string TransactionId { get; set; }
        public string DocumentDescription { get; set; }
        public int DocSource { get; set; }
        public string CreateDate { get; set; }
        public int RecordCount { get; set; }
        public int Action { get; set; }
        #endregion

        #region Constructors
        public TransactionDetailDocument() { }
        #endregion
    }
}
