using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class ReportStatusModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ReportStatusModelData Data { get; set; }
    }

    public class ReportStatusModelData
    {
        public Value Value { get; set; }
        public string[] formatters { get; set; }
        public string[] contentTypes { get; set; }
        public string declaredType { get; set; }
        public short? statusCode { get; set; }
    }

    public class Value
    { 
        public string CanDownload { get; set; }
        public string CanInitiateProcess { get; set; }
        public string Message { get; set; }
    }  
}