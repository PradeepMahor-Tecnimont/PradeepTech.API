using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{
    public class ExcelSheetAttributes
    {
        public DataTable SheetData { get; set; }
        public string SheetName {  get; set; }

        public string SheetReportTitle {  get; set; }
    }
}
