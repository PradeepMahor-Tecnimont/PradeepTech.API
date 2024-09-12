using System;

namespace TCMPLAPP.SendMail.WinService.Models
{
    public class ParameterSpTcmPL
    {
        public string? PQueueKeyId { get; set; }
        public string? PLogMessage { get; set; }
        public decimal? PRowNumber { get; set; }
        public decimal? PPageLength { get; set; }


    }
}