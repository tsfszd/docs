using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "ParserKeywordCriteria", Namespace = "")]
    public class ParserKeywordCriteria<T> : CriteriaBase<T> where T : ParserKeyword, new()
    {

    }
}
