using System;

namespace TCMPLApp.DataAccess.Models
{
    [Serializable]
    public class DataField
    {
        public string DataValueField { get; set; }
        public string DataTextField { get; set; }
        public string DataGroupField { get; set; }
    }

    [Serializable]
    public class DataFieldPaging
    {
        public string DataValueField { get; set; }
        public string DataTextField { get; set; }
        public string DataGroupField { get; set; }
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

    }

}
