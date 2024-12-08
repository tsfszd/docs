using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Model.Entities
{
    public class SubscriberInfo : EntityBase
    {
        private string _ResourceID = "";
        private string _OSVersion = "";
        private string _Model = "";
        private string _Make = "";
        private string _ProductNumber = "";
        private string _Locale = "";
        private string _TimeZome = "";
        //HAMZA -- 20151217 -- Added AppVersion.
        private string _AppVersion = "";


        public string AppVersion
        {
            get { return _AppVersion; }
            set { _AppVersion = value; }
        }        
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        public string OSVersion
        {
            get { return _OSVersion; }
            set { _OSVersion = value; }
        }
        public string Model
        {
            get { return _Model; }
            set { _Model = value; }
        }
        public string Make
        {
            get { return _Make; }
            set { _Make = value; }
        }
        public string ProductNumber
        {
            get { return _ProductNumber; }
            set { _ProductNumber = value; }
        }
        public string Locale
        {
            get { return _Locale; }
            set { _Locale = value; }
        }
        public string TimeZone
        {
            get { return _TimeZome; }
            set { _TimeZome = value; }
        }

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
