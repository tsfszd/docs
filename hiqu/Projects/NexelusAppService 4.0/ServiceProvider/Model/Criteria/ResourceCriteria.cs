﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "ResourceCriteria", Namespace = "")]
    class ResourceCriteria<T> : CriteriaBase<T> where T : Resource, new()
    {
    }
}
