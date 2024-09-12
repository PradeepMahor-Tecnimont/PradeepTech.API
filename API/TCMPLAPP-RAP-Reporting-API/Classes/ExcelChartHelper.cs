using System.Collections.Generic;
using TCMPLApp.Library.Excel.Charts.Models;
using TCMPLApp.Library.Excel.Charts;
using ClosedXML.Excel;

namespace RapReportingApi.Controllers.Rpt
{
    public static class ExcelChartHelper
    {
        public static WSLineChartNew GetChartMetaData(string sheetName, int FutureJobsBlockEndRow)
        {
            int FutureJobsBlockEndRowTemplate = 33;

            int[] SeriesRows = { 58, 59, 60, 62, 63, 47, 61 };

            for (int i = 0; i < SeriesRows.Length; i++)
            {
                SeriesRows[i] = SeriesRows[i] + (FutureJobsBlockEndRow - FutureJobsBlockEndRowTemplate);
            }

            int rowsConsumedByGrids = FutureJobsBlockEndRow - FutureJobsBlockEndRowTemplate;

            ExcelCoOrdinate chartStartPos = new ExcelCoOrdinate { Col = 1, Row = 67 + rowsConsumedByGrids };
            ExcelCoOrdinate chartEndPos = new ExcelCoOrdinate { Col = 23, Row = 107 + rowsConsumedByGrids };

            WSLineChartNew lineChartMetaData = new WSLineChartNew
            {
                TitleTextChart = "Cost Centre Work Load Projections",
                TitleTextValueAxis = "Manhours",
                TitleTextCategoryAxis = "Months",
                SeriesRowNum = SeriesRows,
                CategoryAxisRow = 9,
                SeriesTextColumn = "A",
                FromPosition = chartStartPos,
                ToPosition = chartEndPos,
                SeriesValueStartColumn = "E",
                SeriesValueEndColumn = "V",
                WorksheetName = sheetName
            };

            return lineChartMetaData;

        }

        public static WSLineChartNew GetChartMetaData24(string sheetName, int FutureJobsBlockEndRow)
        {
            int FutureJobsBlockEndRowTemplate = 33;

            int[] SeriesRows = { 58, 59, 60, 62, 63, 47, 61 };

            for (int i = 0; i < SeriesRows.Length; i++)
            {
                SeriesRows[i] = SeriesRows[i] + (FutureJobsBlockEndRow - FutureJobsBlockEndRowTemplate);
            }

            int rowsConsumedByGrids = FutureJobsBlockEndRow - FutureJobsBlockEndRowTemplate;

            ExcelCoOrdinate chartStartPos = new ExcelCoOrdinate { Col = 1, Row = 67 + rowsConsumedByGrids };
            ExcelCoOrdinate chartEndPos = new ExcelCoOrdinate { Col = 29, Row = 107 + rowsConsumedByGrids };

            WSLineChartNew lineChartMetaData = new WSLineChartNew
            {
                TitleTextChart = "Cost Centre Work Load Projections",
                TitleTextValueAxis = "Manhours",
                TitleTextCategoryAxis = "Months",
                SeriesRowNum = SeriesRows,
                CategoryAxisRow = 9,
                SeriesTextColumn = "A",
                FromPosition = chartStartPos,
                ToPosition = chartEndPos,
                SeriesValueStartColumn = "E",
                SeriesValueEndColumn = "AB",
                WorksheetName = sheetName
            };

            return lineChartMetaData;

        }


    }
}
