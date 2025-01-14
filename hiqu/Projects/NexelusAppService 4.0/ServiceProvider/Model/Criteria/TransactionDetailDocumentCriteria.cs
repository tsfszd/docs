using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Model.Criteria
{
    public class TransactionDetailDocumentCriteria<T> : CriteriaBase<T> where T : TransactionDetailDocument, new()
    {
        #region Private Properties
        private string _transactionId;
        private string _documentPath;
        #endregion
        #region Public Properties
        public string TransactionId
        {
            get { return _transactionId; }
        }
        public string DocumentPath
        {
            get { return _documentPath; }
        }
        #endregion

        #region Constructor
        public TransactionDetailDocumentCriteria(T entity)
        {
            this._transactionId = entity.TransactionId;
            this._documentPath = entity.DocumentPath;
        }
        #endregion
    }
}
