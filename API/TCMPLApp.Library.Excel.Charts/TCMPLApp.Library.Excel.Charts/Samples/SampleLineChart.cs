using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Drawing.Spreadsheet;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Index = DocumentFormat.OpenXml.Drawing.Charts.Index;

namespace TCMPLApp.Library.Excel.Charts
{
    public class SampleLineChart
    {
        public void GenerateDoc(string FilePath)
        {
            List<Student> students = new List<Student>();
            Initizalize(students);

            using (SpreadsheetDocument myWorkbook = SpreadsheetDocument.Open(FilePath, true))
            {
                string workSheetName = "CHA1E";


                string? sheetId = myWorkbook.WorkbookPart?.Workbook.Descendants<Sheet>()?.First(s => (s.Name ?? "").Equals(workSheetName)).Id;


                WorksheetPart? worksheetPart = (WorksheetPart?)(myWorkbook.WorkbookPart?.GetPartById(sheetId ?? ""));

                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


                // Add drawing part to WorksheetPart
                DrawingsPart? drawingsPart = worksheetPart?.AddNewPart<DrawingsPart>();
                if (drawingsPart != null)
                    worksheetPart?.Worksheet.Append(new Drawing() { Id = worksheetPart.GetIdOfPart(drawingsPart) });
                worksheetPart?.Worksheet.Save();

                if (drawingsPart != null)
                    drawingsPart.WorksheetDrawing = new WorksheetDrawing();

                myWorkbook?.WorkbookPart?.Workbook.Save();


                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                // Add a new chart and set the chart language
                ChartPart? chartPart = drawingsPart?.AddNewPart<ChartPart>();
                if (chartPart != null)
                    chartPart.ChartSpace = new ChartSpace();
                chartPart?.ChartSpace.AppendChild(new EditingLanguage() { Val = "en-US" });
                Chart? chart = chartPart?.ChartSpace.AppendChild(new Chart());
                chart?.AppendChild(new AutoTitleDeleted() { Val = true }); // We don't want to show the chart title

                // Create a new Clustered Column Chart
                PlotArea? plotArea = chart?.AppendChild(new PlotArea());
                Layout? layout = plotArea?.AppendChild(new Layout());

                //BarChart lineChart = plotArea.AppendChild(new BarChart(
                //        new BarDirection() { Val = new EnumValue<BarDirectionValues>(BarDirectionValues.Column) },
                //        new BarGrouping() { Val = new EnumValue<BarGroupingValues>(BarGroupingValues.Clustered) },
                //        new VaryColors() { Val = false }
                //    ));

                LineChart? lineChart = plotArea?.AppendChild(new LineChart());
                Grouping grouping1 = new Grouping() { Val = GroupingValues.Standard };
                VaryColors varyColors1 = new VaryColors() { Val = false };

                lineChart?.AppendChild(grouping1);
                lineChart?.AppendChild(varyColors1);
                // Create chart series
                int rowIndex = 9;

                for (int i = 0; i < students.Count; i++)
                {
                    LineChartSeries? lineChartSeries = lineChart?.AppendChild(new LineChartSeries(
                        new Index() { Val = (uint)i },
                        new Order() { Val = (uint)i },
                        new SeriesText(new NumericValue() { Text = students[i].Name })
                    ));

                    // Adding category axis to the chart
                    CategoryAxisData? categoryAxisData = lineChartSeries?.AppendChild(new CategoryAxisData());

                    // Category
                    // Constructing the chart category
                    string formulaCat = string.Format("CHA1E!$E${0}:$V${0}", rowIndex);

                    StringReference? stringReference = categoryAxisData?.AppendChild(new StringReference()
                    {
                        Formula = new DocumentFormat.OpenXml.Drawing.Charts.Formula() { Text = formulaCat }
                    });

                    //StringCache stringCache = stringReference.AppendChild(new StringCache());
                    //stringCache.Append(new PointCount() { Val = (uint)Months.Short.Length });

                    //for (int j = 0; j < Months.Short.Length; j++)
                    //{
                    //    stringCache.AppendChild(new NumericPoint() { Index = (uint)j }).Append(new NumericValue(Months.Short[j]));
                    //}
                }

                var chartSeries = lineChart?.Elements<LineChartSeries>().GetEnumerator();
                rowIndex = 1;
                for (int i = 0; i < students.Count; i++)
                {
                    rowIndex++;

                    //row = new Row();

                    //row.AppendChild(ConstructCell(students[i].Name, CellValues.String));

                    chartSeries?.MoveNext();

                    string formulaVal = string.Format("CHA1E!$E${0}:$V${0}", rowIndex);
                    DocumentFormat.OpenXml.Drawing.Charts.Values? values = chartSeries?.Current.AppendChild(new DocumentFormat.OpenXml.Drawing.Charts.Values());

                    NumberReference? numberReference = values?.AppendChild(new NumberReference()
                    {
                        Formula = new DocumentFormat.OpenXml.Drawing.Charts.Formula() { Text = formulaVal }
                    });

                    //NumberingCache numberingCache = numberReference.AppendChild(new NumberingCache());
                    //numberingCache.Append(new PointCount() { Val = (uint)Months.Short.Length });

                    //for (uint j = 0; j < students[i].Values.Length; j++)
                    //{
                    //    var value = students[i].Values[j];

                    //    //row.AppendChild(ConstructCell(value.ToString(), CellValues.Number));

                    //    numberingCache.AppendChild(new NumericPoint() { Index = j }).Append(new NumericValue(value.ToString()));
                    //}

                    //sheetData.AppendChild(row);
                }

                lineChart?.AppendChild(new DataLabels(
                                    new ShowLegendKey() { Val = false },
                                    new ShowValue() { Val = false },
                                    new ShowCategoryName() { Val = false },
                                    new ShowSeriesName() { Val = false },
                                    new ShowPercent() { Val = false },
                                    new ShowBubbleSize() { Val = false }
                                ));

                lineChart?.Append(new AxisId() { Val = 48650112u });
                lineChart?.Append(new AxisId() { Val = 48672768u });

                // Adding Category Axis
                plotArea?.AppendChild(
                    new CategoryAxis(
                        new AxisId() { Val = 48650112u },
                        new Scaling(new Orientation() { Val = new EnumValue<DocumentFormat.OpenXml.Drawing.Charts.OrientationValues>(DocumentFormat.OpenXml.Drawing.Charts.OrientationValues.MinMax) }),
                        new Delete() { Val = false },
                        new AxisPosition() { Val = new EnumValue<AxisPositionValues>(AxisPositionValues.Bottom) },
                        new TickLabelPosition() { Val = new EnumValue<TickLabelPositionValues>(TickLabelPositionValues.NextTo) },
                        new CrossingAxis() { Val = 48672768u },
                        new Crosses() { Val = new EnumValue<CrossesValues>(CrossesValues.AutoZero) },
                        new AutoLabeled() { Val = true },
                        new LabelAlignment() { Val = new EnumValue<LabelAlignmentValues>(LabelAlignmentValues.Center) }
                    ));

                // Adding Value Axis
                plotArea?.AppendChild(
                    new ValueAxis(
                        new AxisId() { Val = 48672768u },
                        new Scaling(new Orientation() { Val = new EnumValue<DocumentFormat.OpenXml.Drawing.Charts.OrientationValues>(DocumentFormat.OpenXml.Drawing.Charts.OrientationValues.MinMax) }),
                        new Delete() { Val = false },
                        new AxisPosition() { Val = new EnumValue<AxisPositionValues>(AxisPositionValues.Left) },
                        new MajorGridlines(),
                        new DocumentFormat.OpenXml.Drawing.Charts.NumberingFormat()
                        {
                            FormatCode = "General",
                            SourceLinked = true
                        },
                        new TickLabelPosition() { Val = new EnumValue<TickLabelPositionValues>(TickLabelPositionValues.NextTo) },
                        new CrossingAxis() { Val = 48650112u },
                        new Crosses() { Val = new EnumValue<CrossesValues>(CrossesValues.AutoZero) },
                        new CrossBetween() { Val = new EnumValue<CrossBetweenValues>(CrossBetweenValues.Between) }
                    ));

                chart?.Append(
                        new PlotVisibleOnly() { Val = true },
                        new DisplayBlanksAs() { Val = new EnumValue<DisplayBlanksAsValues>(DisplayBlanksAsValues.Gap) },
                        new ShowDataLabelsOverMaximum() { Val = false }
                    );

                chartPart?.ChartSpace.Save();

                // Positioning the chart on the spreadsheet
                TwoCellAnchor? twoCellAnchor = drawingsPart?.WorksheetDrawing.AppendChild(new TwoCellAnchor());

                twoCellAnchor?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.FromMarker(
                        new ColumnId("0"),
                        new ColumnOffset("0"),
                        new RowId((rowIndex + 2).ToString()),
                        new RowOffset("0")
                    ));

                twoCellAnchor?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.ToMarker(
                        new ColumnId("10"),
                        new ColumnOffset("0"),
                        new RowId((rowIndex + 12).ToString()),
                        new RowOffset("0")
                    ));

                // Append GraphicFrame to TwoCellAnchor
                GraphicFrame? graphicFrame = twoCellAnchor?.AppendChild(new GraphicFrame());
                if (graphicFrame != null)
                    graphicFrame.Macro = string.Empty;

                graphicFrame?.Append(new NonVisualGraphicFrameProperties(
                        new NonVisualDrawingProperties()
                        {
                            Id = 2u,
                            Name = "Sample Chart"
                        },
                        new NonVisualGraphicFrameDrawingProperties()
                    ));

                graphicFrame?.Append(new Transform(
                        new DocumentFormat.OpenXml.Drawing.Offset() { X = 0L, Y = 0L },
                        new DocumentFormat.OpenXml.Drawing.Extents() { Cx = 0L, Cy = 0L }
                    ));
                if (chartPart != null)
                    graphicFrame?.Append(new DocumentFormat.OpenXml.Drawing.Graphic(
                            new DocumentFormat.OpenXml.Drawing.GraphicData(
                                    new ChartReference() { Id = drawingsPart?.GetIdOfPart(chartPart) }
                                )
                            { Uri = "http://schemas.openxmlformats.org/drawingml/2006/chart" }
                        ));

                twoCellAnchor?.Append(new ClientData());

                drawingsPart?.WorksheetDrawing.Save();

                worksheetPart?.Worksheet.Save();
            }
        }


        private Cell ConstructCell(string value, CellValues dataType)
        {
            return new Cell()
            {
                CellValue = new CellValue(value),
                DataType = new EnumValue<CellValues>(dataType),
            };
        }

        private void Initizalize(List<Student> students)
        {
            students.AddRange(new Student[] {
                new Student
                {
                    Name = "Liza",
                    Values = new byte[] { 10, 25, 30, 15, 20, 19 }
                },
                new Student
                {
                    Name = "Macy",
                    Values = new byte[] { 20, 15, 26, 30, 10, 15 }
                }
            });
        }

    }

}
