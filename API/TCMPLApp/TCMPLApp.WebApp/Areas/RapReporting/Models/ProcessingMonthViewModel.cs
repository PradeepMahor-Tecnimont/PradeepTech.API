using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Models
{

    public class ProcessingMonthViewModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ProcessingMonthData Data { get; set; }
    }

    public class ProcessingMonthData
    {
        public string value { get; set; }
    }    
}
