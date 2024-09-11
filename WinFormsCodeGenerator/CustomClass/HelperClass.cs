using System.Globalization;

namespace WinFormsCodeGenerator.CustomClass
{
    public static class HelperClass
    {
        public static string ToTitleCase(this string title)
        {
            title = RemoveUnderscore(title);
            title = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(title.ToLower());
            title = RemoveSpace(title);
            return title;
            //return CultureInfo.CurrentCulture.TextInfo.ToTitleCase(title.ToLower());
        }

        private static string RemoveUnderscore(this string title)
        {
            return title.Replace("_", " ");
        }

        private static string RemoveSpace(this string title)
        {
            return title.Replace(" ", "");
        }

        public static string SetDataType(this string title)
        {
            string retVal = "";
            if (title.Trim().ToUpper() == "NUMBER")
            {
                return " decimal? ";
            }
            if (title.Trim().ToUpper() == "VARCHAR2")
            {
                return " string ";
            }
            return title.Trim().ToUpper() == "CHAR" ? " string " : title.Trim().ToUpper() == "DATE" ? " DateTime? " : retVal;
        }
    }
}