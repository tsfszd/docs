using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Model.Entities
{
    public class ParserKeyword : EntityBase
    {
        #region Private Properties

        private string _keyword = "";
        private string _token = "";
        private int _priority;

        #endregion

        #region Public Propties

        public int priority
        {
            get { return _priority; }
            set { _priority = value; }
        }

        public string token
        {
            get { return _token; }
            set { _token = value; }
        }

        public string keyword
        {
            get { return _keyword; }
            set { _keyword = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
