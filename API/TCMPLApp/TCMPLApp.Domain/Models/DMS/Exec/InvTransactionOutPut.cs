using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvTransactionOutPut : DBProcMessageOutput
    {
        public string PGetTransId { get; set; } = null;
    }
}