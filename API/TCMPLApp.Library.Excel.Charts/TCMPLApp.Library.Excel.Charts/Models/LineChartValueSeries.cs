using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Library.Excel.Charts.Models
{
    public class LineChartValueSeries
    {
        [Required]
        public string SeriesText { get; set; }

        [Required]
        public string CategoryFormula { get; set; }

        [Required]
        public string ValueFormula { get; set; }

    }

    public class LineChartValueSeriesNamedRange
    {
        [Required]
        public string SeriesText { get; set; }

        [Required]
        public string CategoryFormula { get; set; }

        [Required]
        public string ValueFormula { get; set; }

    }
}
