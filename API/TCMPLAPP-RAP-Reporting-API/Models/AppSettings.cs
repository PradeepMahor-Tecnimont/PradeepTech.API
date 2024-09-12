using System.Collections.Generic;
using System.IO;

namespace RapReportingApi.Models
{
    public class AppSettings
    {
        //public string TCMPLAppBaseRepository { get; set; }

        public string TCMPLAppTemplatesRepository { get; set; }

        public string TCMPLAppTempRepository { get; set; }

        public string TCMPLAppDownloadRepository { get; set; }

        public Settings4App RAPAppSettings { get; set; }
    }

    public class Settings4App
    {

        public string[] CorsOrigins { get; set; }

        public string RAPApiConnectionString { get; set; }

        public string DevConnectionString { get; set; }
        public string ProdConnectionString { get; set; }
        public string QualConnectionString { get; set; }

        public string RAPRepository { get; set; }
        public string RAPTempRepository { get; set; }

        public string ApplicationLogFile { get; set; }
        public string ODataQueryOptionsSettingFile { get; set; }
        public string ClosedXMLContentType { get; set; }
        public string ZipContentType { get; set; }
        public string RapXLTemplate { get; set; }

        public string[] SkipDecryptParamsUrls { get; set; }
        public string[] SkipResponseHandlerUrls { get; set; }
        public string[] SkipResponseEncryptUrls { get; set; }

        public IdentityConfiguration Identity { get; set; }

        public bool IsEncryptionEnable { get; set; }

        public string ConsoleRepository { get; set; }

        public Dictionary<string, MailBoxProfile> MailBoxProperties { get; set; }
    }

    public class IdentityConfiguration
    {
        public string Authority { get; set; }
        public string Audience { get; set; }
    }

    public class MailBoxProfile
    {
        public string UserID { get; set; }
        public string PWD { get; set; }
    }

    public class LogLevel
    {
        public string Default { get; set; }
    }
}