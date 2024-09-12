using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Library.Excel.Writer.Model
{



    public class XLTableCoOrdinates
    {
        public string ReferenceName { get; set; } = string.Empty;

        public int StartCol { get; set; }
        public int EndCol { get; set; }

        public int StartRow { get; set; }
        public int EndRow { get; set; }
    }

    public class DummyModel
    {
        public string Dummycode { get; set; } = string.Empty;

        public int Dummyid { get; set; }

        public DateTime Dummydate { get; set; }
    }
}
