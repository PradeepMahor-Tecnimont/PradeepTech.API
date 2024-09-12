using System;
using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.Models.rpt.Cmplx
{
    public partial class Email
    {
        public class EmailModel
        {
            public String[] mailTo { get; set; }

            [Required]
            public String[] mailCC { get; set; }

            public String[] mailBCC { get; set; }
            public String mailSubject { get; set; }

            [Required]
            public String mailBody { get; set; }

            [Required]
            public String mailType { get; set; }

            [Required]
            public String mailFrom { get; set; }
        }

        public class ResponseModel
        {
            public string ResponseMessage { set; get; }
            public string ResponseStatus { set; get; }
            public object ResponseData { set; get; }
        }
    }
}