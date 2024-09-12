using TCMPLApp.Library.Excel.Charts.Models;

namespace TCMPLApp.Library.Excel.Charts
{
    public interface IOpenXMLExcelChart
    {
        //public void InsertChart(string FilePath, IEnumerable<WSLineChart> lineCharts);

        //public void InsertChart(MemoryStream ExcelFileStream, IEnumerable<WSLineChart> lineCharts);

        public void InsertChartNew(string FilePath, IEnumerable<WSLineChartNew> lineCharts);

    }
}
