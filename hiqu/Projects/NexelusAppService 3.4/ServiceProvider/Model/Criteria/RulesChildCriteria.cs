using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{
    public class RulesChildCriteria<T> : CriteriaBase<T> where T : RulesChild, new()
    {
        public String ResourceID { get; set; }
    }
}
