using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    class CCSplitTransaction : EntityBase
    {
        #region Private Properties
        private String _action;
        private List<CreditCardExpense> _CCModelList;
        #endregion

        #region Public Properties

        [DataMember]
        public List<CreditCardExpense> Action
        {
            get { return _CCModelList; }
            set { _CCModelList = value; }
        }


        [DataMember]
        public String CCModelList
        {
            get { return _action; }
            set { _action = value; }
        }

        #endregion


        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
