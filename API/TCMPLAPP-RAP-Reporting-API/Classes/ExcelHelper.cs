using DocumentFormat.OpenXml.Drawing.Spreadsheet;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Presentation;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Linq;

namespace RapReportingApi.Controllers.Rpt
{
    public class ExcelHelper
    {


        public static void PositionCharts(string FilePath, IEnumerable<WorkbookCharts> chartsList)
        {
            using (SpreadsheetDocument myWorkbook = SpreadsheetDocument.Open(FilePath, true))
            {
                foreach(WorkbookCharts chartMetaData in chartsList)
                {
                    SetChartPosition(myWorkbook, chartMetaData);
                }
            }
        }

        protected static void SetChartPosition(SpreadsheetDocument XLWorkbook, WorkbookCharts chartMetaData)
        {
                string sheetId = XLWorkbook.WorkbookPart?.Workbook?.Descendants<Sheet>().First(s => s.Name?.Equals(chartMetaData.SheetName) ?? false).Id?.Value ?? "";

                WorksheetPart wsp = (WorksheetPart)(XLWorkbook.WorkbookPart?.GetPartById(sheetId));
                if (wsp.DrawingsPart != null)
                {
                    foreach (ChartPart chart in wsp.DrawingsPart.ChartParts)
                    {
                        TwoCellAnchor tca = wsp.DrawingsPart.WorksheetDrawing.Descendants<TwoCellAnchor>().FirstOrDefault();
                        if (tca != null)
                        {
                            tca.FromMarker.ColumnId.Text = chartMetaData.FromPosition.Col.ToString();
                            tca.FromMarker.ColumnOffset.Text = "0";
                            tca.FromMarker.RowId.Text = chartMetaData.FromPosition.Row.ToString();
                            tca.FromMarker.RowOffset.Text = "0";

                            tca.ToMarker.ColumnId.Text = chartMetaData.ToPosition.Col.ToString();
                            tca.ToMarker.ColumnOffset.Text = "0";
                            tca.ToMarker.RowId.Text = chartMetaData.ToPosition.Row.ToString();
                            tca.ToMarker.RowOffset.Text = "0";
                        }
                        else
                        {
                            Console.WriteLine("Couldn't find position of chart {0}", chart.ChartSpace.LocalName.ToString());
                        }
                    }
                }


        }

        public static void SetChartPosition(string FilePath, string SheetName, ExcelCoOrdinate FromPosition, ExcelCoOrdinate ToPosition)
        {
            using (SpreadsheetDocument myWorkbook = SpreadsheetDocument.Open(FilePath, true))
            {
                string sheetId = myWorkbook.WorkbookPart?.Workbook?.Descendants<Sheet>().First(s => s.Name?.Equals(SheetName) ?? false).Id?.Value ?? "";

                WorksheetPart wsp = (WorksheetPart)(myWorkbook.WorkbookPart?.GetPartById(sheetId));
                if (wsp.DrawingsPart != null)
                {
                    foreach (ChartPart chart in wsp.DrawingsPart.ChartParts)
                    {
                        TwoCellAnchor tca = wsp.DrawingsPart.WorksheetDrawing.Descendants<TwoCellAnchor>().FirstOrDefault();
                        if (tca != null)
                        {
                            //tca.FromMarker.RowId = new RowId(FromPosition.Row.ToString());
                            //tca.FromMarker.ColumnId = new ColumnId(FromPosition.Col.ToString());
                            //tca.FromMarker.RowId.Text = "0";

                            //tca.ToMarker.RowId = new RowId(ToPosition.Row.ToString());
                            //tca.ToMarker.ColumnId = new ColumnId(ToPosition.Col.ToString());

                            tca.FromMarker.ColumnId.Text = FromPosition.Col.ToString();
                            tca.FromMarker.ColumnOffset.Text = "0";
                            tca.FromMarker.RowId.Text = FromPosition.Row.ToString();
                            tca.FromMarker.RowOffset.Text = "0";

                            tca.ToMarker.ColumnId.Text = ToPosition.Col.ToString();
                            tca.ToMarker.ColumnOffset.Text = "0";
                            tca.ToMarker.RowId.Text = ToPosition.Row.ToString();
                            tca.ToMarker.RowOffset.Text = "0";


                            Console.WriteLine("A Chart starts at Column {0} ({1}), Row {2} ({3}) and ends at Column {4} ({5}), Row {6} ({7})",
                                                tca.FromMarker.ColumnId.Text,
                                                tca.FromMarker.ColumnOffset.Text,
                                                tca.FromMarker.RowId.Text,
                                                tca.FromMarker.RowOffset.Text,
                                                tca.ToMarker.ColumnId.Text,
                                                tca.ToMarker.ColumnOffset.Text,
                                                tca.ToMarker.RowId.Text,
                                                tca.ToMarker.RowOffset.Text
                                                );
                        }
                        else
                        {
                            Console.WriteLine("Couldn't find position of chart {0}", chart.ChartSpace.LocalName.ToString());
                        }
                    }
                }

            }

        }

        public class ExcelCoOrdinate
        {
            public decimal Row { get; set; }

            public decimal Col { get; set; }
        }

        public class WorkbookCharts
        {
            public string SheetName {get;set;}


            public ExcelCoOrdinate FromPosition { get; set;}
            public ExcelCoOrdinate ToPosition { get; set; }
        }

    }
}
