using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace RapReportingApi.Models.Middelware
{
    public class ControllerODataQueryAttributes
    {
        public Dictionary<string, ODataQueryAttributes> AppODataQueryAttributes { get; set; }
    }

    public class ODataQueryAttributes
    {
        public string[] ColumnsAllowed4Filter { get; set; }
        public string[] ColumnsAllowed4Sort { get; set; }
    }

    public class ApiResponseModel
    {
        //public ApiResponseModel(string status, string message, string data)
        //{
        //    Status = status;
        //    Message = message;
        //    Data = data;
        //}

        public ApiResponseModel(string status, string message, [Optional] string messageCode)
        {
            Status = status;
            MessageCode = messageCode;
            Message = message;
        }

        public ApiResponseModel(string status, object objData)
        {
            Status = status;
            Data = objData;
        }

        //public ApiResponseModel(string status, string data)
        //{
        //    Status = status;
        //    Data = data;
        //}

        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public object Data { get; set; }
    }

    public class AESEssentials
    {
        public string Passcode { get; set; }
        public string IV { get; set; }
    }
}