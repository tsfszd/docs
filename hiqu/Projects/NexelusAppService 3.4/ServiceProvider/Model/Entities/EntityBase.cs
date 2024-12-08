using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.ComponentModel;
using NexelusApp.Service.Enums;


namespace NexelusApp.Service.Model.Entities
{

    /// <summary>
    /// Base entity. All Business entities must be drived from this class
    /// and for evey drived class do the following
    /// 1. Provide Criteria classs implementaion for the bus iness entity
    /// 2. Provide DAO implementation for the entity
    /// 3. Add entity map in DAO factory
    /// 4. Add entity map in Criteria Factory
    /// </summary>
    [DataContract]
    public abstract class EntityBase : INotifyPropertyChanged
    {

        private bool _IsValid;
        private bool _IsDirety;
        private int _CompanyCode;
        private DateTime _LastSyncDate;
        private int _ErrorFlag = 0;
        private int _ErrorCode;
        private string _ErrorDescription = "";

       
        /// <summary>
        /// Property chage event
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        #region Public Properties

        /// <summary>
        /// If the values are changed, it will set the flag Dirty
        /// </summary>
        public bool IsDirety
        {
            get { return _IsDirety; }
            set { _IsDirety = value; }
        }

        public bool IsValid
        {
            get { return _IsValid; }
            set { _IsValid = value; }
        }
        [DataMember]  
        public int ErrorFlag
        {
            get { return _ErrorFlag; }
            set { _ErrorFlag = value; }
        }
        [DataMember]  
        public int ErrorCode
        {
            get { return _ErrorCode; }
            set { _ErrorCode = value; }
        }
        [DataMember]  
        public string ErrorDescription
        {
            get { return _ErrorDescription; }
            set { _ErrorDescription = value; }
        }
        [DataMember]        
        public int CompanyCode
        {
            get { return _CompanyCode; }
            set { _CompanyCode = value; }
        }

        [DataMember]
        public DateTime LastSyncDate
        {
            get { return _LastSyncDate.ToUniversalTime(); }
            set { _LastSyncDate = value.ToUniversalTime(); }
        }

        #endregion

        #region Constructors

        public EntityBase()
        {

        }

        #endregion

        #region Abstract Methods

        /// <summary>
        /// validate method
        /// </summary>
        /// <param name="message">String builder to get the validation message</param>
        /// <returns></returns>
        public abstract bool Validate(StringBuilder message);

        #endregion

        // Create the OnPropertyChanged method to raise the event 
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
                _IsDirety = true;
            }
        }

    }
}
