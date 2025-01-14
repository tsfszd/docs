using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Model.Criteria
{
    public class TransactionHeaderDocumentCriteria<T> : CriteriaBase<T> where T : TransactionHeaderDocument, new()
    {
        #region Private Properties
        private string _recordId;
        //private string _documentPath;
        #endregion
        #region Public Properties
        public string RecordId
        {
            get { return _recordId; }
        }
        #endregion

        #region Constructor
        public TransactionHeaderDocumentCriteria(T entity)
        {
            this._recordId = entity.RecordId;
        }
        #endregion
    }
}
