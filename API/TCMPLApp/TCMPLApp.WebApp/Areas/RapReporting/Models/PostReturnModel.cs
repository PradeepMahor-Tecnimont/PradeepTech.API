using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class PostReturnModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public PostReturnData Data { get; set; }
    }

    public class PostReturnData
    {
        public string Value { set; get; }
    }
}