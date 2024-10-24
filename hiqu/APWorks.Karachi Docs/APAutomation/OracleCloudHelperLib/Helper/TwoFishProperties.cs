using System;
using System.IO;
using System.Collections;

namespace nexelus.oraclehelper
{
	public sealed class TwoFishProperties 
	{
		
		public const bool GLOBAL_DEBUG = false;
		public const string ALGORITHM   = "Twofish";
		public const double VERSION     = 0.2;
		public static readonly string FULL_NAME   = ALGORITHM + " ver. " + VERSION;
		const string NAME        = "Twofish_Properties";

		private static readonly Hashtable properties = new Hashtable();


		private TwoFishProperties()
		{
		}

		static void InitDefault()
		{
			properties.Add("Trace.Twofish_Algorithm","true");
			properties.Add("Debug.Level.*","1");
			properties.Add("Debug.Level.Twofish_Algorithm","1");
		}
	
		static void InitProperties()
		{
			string it = ALGORITHM + ".properties";
			Stream input  = File.OpenRead(it);
			if (input != null)
			{
				// properties.load(input);
				input.Close(); 	
			}
			else
			{
				InitDefault();
			}
		}

		public static String GetProperty (String key){
			return (String) properties[key];
		}

		public static String GetProperty (String key, String value){
			if(properties.ContainsKey(key))
				return GetProperty(key);
			return value;
		}

		public static void List (Stream output){
			List(new StreamWriter(output));
		}


		public static void List (StreamWriter output){
			output.WriteLine("#");
			output.WriteLine("# ----- Begin "+ALGORITHM+" properties -----");
			output.WriteLine("#");
			string key, valueData;
			IDictionaryEnumerator enumerator = properties.GetEnumerator();

			while (enumerator.MoveNext()){
				DictionaryEntry entry = enumerator.Entry;
				key = (string) entry.Key;
				valueData = (string) entry.Value;
				output.WriteLine(key + " = " + valueData);
			}
			output.WriteLine("#");
			output.WriteLine("# ----- End "+ALGORITHM+" properties -----");
		}

		public static IEnumerator PropertyNames(){
			return properties.GetEnumerator();
		}


	public static bool IsTraceable (String label){
		string s = GetProperty("Trace." + label);
		if (s == null)
			return false;
		return (s.ToLower().Equals("true"));
}

	public static int GetLevel (String label){
		string s = GetProperty("Debug.Level." + label);
		if (s == null){
			s = GetProperty("Debug.Level.*");
			if (s == null)
				return 0;
		}
			return Int32.Parse(s);
	}

		public static TextWriter GetOutput(){
			TextWriter sw;
			string name = GetProperty("Output");
			if (name != null && name.Equals("out"))
				sw = Console.Out;
			else
				sw = Console.Error;
			return sw;
		}
	}
}
