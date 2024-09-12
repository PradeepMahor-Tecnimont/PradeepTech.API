using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Classes
{

    public static class StringHelper
    {
        public static string CleanExceptionMessage(string message)
        {
            string response = message;

            int index = message.LastIndexOf(" --- ");

            if (index != -1)
            {
                response = message.Substring(index + 3);
            };

            return response;
        }

        public static string MinutesToHrs(Int32 minutes)
        {
            if (minutes == 0)
                return "";

            bool isNegative = minutes < 0;
            Int32 positiveMinutes = isNegative ? minutes * -1 : minutes;


            string retVal = positiveMinutes < 6000 ? string.Format("{0:00}", (positiveMinutes / 60)) : string.Format("{0:000}", (positiveMinutes / 60));
            retVal = retVal + ":" + string.Format("{0:00}", (positiveMinutes % 60));
            if (isNegative)
                retVal = "-" + retVal;
            return retVal;
        }

        public static string TitleCase(string paramText)
        {
            TextInfo myTI = new CultureInfo("en-US", false).TextInfo;
            var lowerText = myTI.ToLower(paramText);
            return myTI.ToTitleCase(lowerText);

        }
    }

}
