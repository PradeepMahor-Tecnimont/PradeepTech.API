public class AppSettings
{
    public Settings4App WinServiceAppSettings { get; set; }
}

public class Settings4App
{
    //public string DevelopmentConnectionString { get; set; }
    //public string ProductionConnectionString { get; set; }

    public string FilePath { get; set; }

    public WebServiceMail AppMailing { get; set; }

    public UserCredentials WebApiUserCred { get; set; }


    public string urlYear { get; set; }
    public string urlInsertRptProcess { get; set; }

    public string urlMailDetails { get; set; }


    public string urlCHA1 { get; set; }
    public string urlDept { get; set; }

    public string urlCha1Sta6Tm02 { get; set; }
    public string urlCha1Sta6Tm02Dept { get; set; }

    public string urlTM01All { get; set; }
    public string urlCHA1Common { get; set; }
    public string urlTMACommon { get; set; }
    public string urlGetList4WorkerProcess { get; set; }
    public string urlProjectTCMJobsGrp { get; set; }
    public string uriTM11Data { get; set; }

}

public class UserCredentials
{
    public string WinUID { get; set; }
    public string Pwd { get; set; }
}

public class WebServiceMail
{
    public string Url { get; set; }
    public string Profile { get; set; }
}