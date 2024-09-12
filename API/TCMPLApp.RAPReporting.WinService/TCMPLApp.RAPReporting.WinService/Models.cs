using Newtonsoft.Json.Linq;

namespace TCMPLApp.RAPReporting.WinService
{
    public class Yearobject
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public List<Year> data { get; set; }

    }

    public class Year
    {
        public string yyyy { get; set; }
        public decimal iscurrent { get; set; }
    }

    public class Costcodeobject
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public List<Dept> data { get; set; }
    }

    public class Dept
    {
        public string costcode { get; set; }
    }

    public class EmailModelTemp
    {
        public string mailTo { get; set; }
        public string mailCC { get; set; }
        public string mailBCC { get; set; }
        public string mailSubject { get; set; }
        public string mailBody { get; set; }
        public string mailType { get; set; }
        public string mailFrom { get; set; }
    }

    public class EmailModel
    {
        public string[] mailTo { get; set; }
        public string[] mailCC { get; set; }
        public string[] mailBCC { get; set; }
        public string mailSubject { get; set; }
        public string mailBody { get; set; }
        public string mailType { get; set; }
        public string mailFrom { get; set; }
    }

    public class EmailModelobject
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public List<EmailModelTemp> data { get; set; }
    }

    public class ResponseModel
    {
        public string ResponseMessage { set; get; }
        public string ResponseStatus { set; get; }
        public object ResponseData { set; get; }
    }

    public class RapRptProcessObj
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public RapRptProcessObjData data { get; set; }
    }

    public class RapRptProcessObjData
    {
        public List<value> Value { get; set; }
        public string[] formatters { get; set; }
        public string[] contentTypes { get; set; }
        public string declaredType { get; set; }
        public short? statusCode { get; set; }
    }

    public class value
    {
        public string keyid { set; get; }
        public string reportid { set; get; }
        public string userid { set; get; }
        public string email { set; get; }
        public string yyyy { set; get; }
        public string yymm { set; get; }
        public string yearmode { set; get; }
        public short iscomplete { set; get; }
        public DateTime sdate { set; get; }
        public DateTime? edate { set; get; }
        public string category { set; get; }
        public string reporttype { set; get; }
        public string simul { set; get; }

    }

    public class ProjnoObject
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }        
        public ProjnoObjectData data { get; set; }
    }

    public class ProjnoObjectData
    {
        public List<projValue> Value { get; set; }
        public string[] formatters { get; set; }
        public string[] contentTypes { get; set; }
        public string declaredType { get; set; }
        public short? statusCode { get; set; }
    }

    public class projValue
    {
        public string projno { get; set; }
    }
}
