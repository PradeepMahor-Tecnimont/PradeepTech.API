using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class MovemastImportOutput : DBProcMessageOutput
    {        
        public IEnumerable<ExcelError> PMovemastErrors { get; set; }
    }

    public class ExcelError
    {
        public int Id { get; set; }

        public string Section { get; set; }

        public int ExcelRowNumber { get; set; }

        public string FieldName { get; set; }

        public short ErrorType { get; set; }

        public string ErrorTypeString { get; set; }

        public string Message { get; set; }
    }


}
