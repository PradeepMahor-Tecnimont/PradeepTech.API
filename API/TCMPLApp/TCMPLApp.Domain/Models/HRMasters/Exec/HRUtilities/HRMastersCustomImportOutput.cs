using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class HRMastersCustomImportOutput : DBProcMessageOutput
    {        
        public IEnumerable<ExcelError> PEmployeesErrors { get; set; }
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
