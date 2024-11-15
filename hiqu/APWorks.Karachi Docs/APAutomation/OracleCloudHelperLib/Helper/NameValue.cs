using System;

namespace nexelus.oraclehelper
{
    public class NameValue
    {
        private string name;
        private string value;
        private object valueObject;
        private string exValue1;
        private string exValue2;
        private string exValue3;
        private string exValue4;
        private string exValue5;
        private string exValue6;
        private object exObjectValue1;
        private object exObjectValue2;
        private object exObjectValue3;
        private object exObjectValue4;
        private object exObjectValue5;
        private object exObjectValue6;

        public NameValue(string name, string value)
        {
            this.name = name;
            this.value = value;
        }

        public NameValue(string name, object valueObject)
        {
            this.name = name;
            this.valueObject = valueObject;
        }

        public string Name
        {
            get { return name; }
        }

        public string Value
        {
            get { return value; }
        }

        public object ValueObject
        {
            get { return valueObject; }
        }

        public string ExValue1
        {
            get { return exValue1; }
            set { exValue1 = value; }
        }

        public string ExValue2
        {
            get { return exValue2; }
            set { exValue2 = value; }
        }

        public string ExValue3
        {
            get { return exValue3; }
            set { exValue3 = value; }
        }
        public string ExValue4
        {
            get { return exValue4; }
            set { exValue4 = value; }
        }

        public string ExValue5
        {
            get { return exValue5; }
            set { exValue5 = value; }
        }

        public string ExValue6
        {
            get { return exValue6; }
            set { exValue6 = value; }
        }

        public object ExObjectValue1
        {
            get { return exObjectValue1; }
            set { exObjectValue1 = value; }
        }

        public object ExObjectValue2
        {
            get { return exObjectValue2; }
            set { exObjectValue2 = value; }
        }

        public object ExObjectValue3
        {
            get { return exObjectValue3; }
            set { exObjectValue3 = value; }
        }
        public object ExObjectValue4
        {
            get { return exObjectValue4; }
            set { exObjectValue4 = value; }
        }

        public object ExObjectValue5
        {
            get { return exObjectValue5; }
            set { exObjectValue5 = value; }
        }

        public object ExObjectValue6
        {
            get { return exObjectValue6; }
            set { exObjectValue6 = value; }
        }

    }
}
