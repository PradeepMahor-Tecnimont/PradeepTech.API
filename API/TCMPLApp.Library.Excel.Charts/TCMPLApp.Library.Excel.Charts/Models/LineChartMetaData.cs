using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Library.Excel.Charts.Models
{
    public class WSLineChart
    {
        public string WorksheetName { get; set; }
        public string ChartTitleText { get; set; }

        public string CategoryAxisTitleText { get; set; }

        public string ValueAxisTitleText { get; set; }

        public IEnumerable<LineChartValueSeries> SeriesData { get; set; }

        public ExcelCoOrdinate FromPosition { get; set; }

        public ExcelCoOrdinate ToPosition { get; set; }
    }

    public class ExcelCoOrdinate
    {
        public decimal Row { get; set; }

        public decimal Col { get; set; }
    }

    public class WSLineChartNamedRange
    {
        public string WorksheetName { get; set; }
        public string ChartTitleText { get; set; }

        public string CategoryAxisTitleText { get; set; }

        public string ValueAxisTitleText { get; set; }

        public IEnumerable<LineChartValueSeriesNamedRange> SeriesData { get; set; }

        public string Position { get; set; }
    }


    public class WSLineChartNew
    {
        public string WorksheetName { get; set; }


        //Title
        public string TitleTextChart { get; set; }

        public string TitleTextCategoryAxis { get; set; }

        public string TitleTextValueAxis { get; set; }



        public string SeriesTextColumn { get; set; }



        public string SeriesValueStartColumn { get; set; }
        public string SeriesValueEndColumn { get; set; }


        public int CategoryAxisRow { get; set; }

        public IEnumerable<int> SeriesRowNum { get; set; }

        public ExcelCoOrdinate FromPosition { get; set; }

        public ExcelCoOrdinate ToPosition { get; set; }
    }


}
