using DocumentFormat.OpenXml;
using D = DocumentFormat.OpenXml.Drawing;
using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.Drawing.Spreadsheet;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.ComponentModel.DataAnnotations;
using Index = DocumentFormat.OpenXml.Drawing.Charts.Index;
using TCMPLApp.Library.Excel.Charts.Models;
using System.Runtime.CompilerServices;
using DocumentFormat.OpenXml.Office2016.Excel;

namespace TCMPLApp.Library.Excel.Charts
{
    public class OpenXMLExcelChart : IOpenXMLExcelChart
    {
        //Dictionary<String, String> _definedNames;
        public OpenXMLExcelChart()
        {

        }

        public void InsertChartNew(string FilePath, IEnumerable<WSLineChartNew> lineCharts)
        {

            using (SpreadsheetDocument myWorkbook = SpreadsheetDocument.Open(FilePath, true))
            {

                foreach (WSLineChartNew lineChart in lineCharts)
                {
                    if (myWorkbook != null)
                    {

                        StringValue stringValue = myWorkbook.WorkbookPart?.Workbook.Descendants<Sheet>().First(s => (s.Name ?? "").Equals(lineChart.WorksheetName)).Id ?? string.Empty;

                        InsertChartIntoWorksheetNew(myWorkbook, lineChart);
                    }
                    else
                        break;
                }
                IEnumerable<WorksheetPart> worksheetParts = myWorkbook?.WorkbookPart?.WorksheetParts ?? Enumerable.Empty<WorksheetPart>();


                foreach (WorksheetPart sheet in worksheetParts)
                {
                    List<TableDefinitionPart> TableDefinitionPartToDelete = new List<TableDefinitionPart>();
                    var TableParts = sheet.Worksheet.Descendants<TableParts>();




                    List<TableParts> TablePartToDelete = new List<TableParts>();

                    foreach (var Item in TableParts)
                    {
                        TablePartToDelete.Add(Item);
                    }
                    foreach (var tp in TablePartToDelete)
                    {
                        tp.Remove();
                    }

                    foreach (TableDefinitionPart Item in sheet.TableDefinitionParts)
                    {
                        TableDefinitionPartToDelete.Add(Item);
                    }

                    foreach (TableDefinitionPart Item in TableDefinitionPartToDelete)
                    {
                        sheet.DeletePart(Item);
                    }
                }

            }
        }



        private void GetChartType(string path)
        {
            using (SpreadsheetDocument doc = SpreadsheetDocument.Open(path, false))
            {
                WorkbookPart? bkPart = doc.WorkbookPart;
                DocumentFormat.OpenXml.Spreadsheet.Workbook? workbook = bkPart?.Workbook;
                DocumentFormat.OpenXml.Spreadsheet.Sheet? s = workbook?.Descendants<DocumentFormat.OpenXml.Spreadsheet.Sheet>().Where(sht => sht.Name == "CHA1E").FirstOrDefault();
                string wsPartId = s?.Id?.Value ?? "";
                WorksheetPart? wsPart = (WorksheetPart?)bkPart?.GetPartById(wsPartId);

                DocumentFormat.OpenXml.Packaging.DrawingsPart? dp = (DocumentFormat.OpenXml.Packaging.DrawingsPart?)wsPart?.DrawingsPart;
                DocumentFormat.OpenXml.Drawing.Spreadsheet.WorksheetDrawing? dWs = dp?.WorksheetDrawing;
                string? txt = dWs?.Descendants<D.Spreadsheet.NonVisualDrawingProperties>().FirstOrDefault()?.Name?.Value;
                DocumentFormat.OpenXml.Packaging.ChartPart? cp = dp?.ChartParts.FirstOrDefault();
                D.Charts.Chart? c = (D.Charts.Chart?)cp?.ChartSpace.Descendants<D.Charts.Chart>().FirstOrDefault();
                txt += "\r\n" + c?.PlotArea?.ChildElements[1].LocalName.ToString();
                //this.txtMessages.Text = txt;
            }
        }
        public void InsertChart(MemoryStream ExcelFileStream, IEnumerable<WSLineChart> lineCharts)
        {
            foreach (WSLineChart lineChartMetaDataItem in lineCharts)
            {

            }
        }


        private void InsertChartIntoWorksheetNew(SpreadsheetDocument workBook, WSLineChartNew lineChartMetaDataNamedRange)
        {
            // 1
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Add drawing part to WorksheetPart
            WorkbookPart? wbPart = workBook.WorkbookPart;

            string sheetId = workBook.WorkbookPart?.Workbook?.Descendants<Sheet>().First(s => s.Name?.Equals(lineChartMetaDataNamedRange.WorksheetName) ?? false).Id?.Value ?? "";

            WorksheetPart? worksheetPart = (WorksheetPart?)(workBook.WorkbookPart?.GetPartById(sheetId));


            DrawingsPart? drawingsPart = worksheetPart?.AddNewPart<DrawingsPart>();
            if (drawingsPart != null)
                worksheetPart?.Worksheet.Append(new Drawing() { Id = worksheetPart.GetIdOfPart(drawingsPart) });

            worksheetPart?.Worksheet.Save();

            if (drawingsPart != null)
                drawingsPart.WorksheetDrawing = new WorksheetDrawing();

            //workBook.WorkbookPart?.Workbook.Save();
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


            // 2
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Add a new chart and set the chart language
            ChartPart? chartPart = drawingsPart?.AddNewPart<ChartPart>();
            if (chartPart != null)
                chartPart.ChartSpace = new ChartSpace();

            chartPart?.ChartSpace.AppendChild(new EditingLanguage() { Val = "en-US" });
            chartPart?.ChartSpace.AppendChild(new RoundedCorners() { Val = false });

            Chart? chart = chartPart?.ChartSpace.AppendChild(new Chart());

            // We don't want to show the chart title
            chart?.AppendChild(new AutoTitleDeleted() { Val = true });
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


            // 3
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Init a LINE Chart and attributes
            PlotArea? plotArea = chart?.AppendChild(new PlotArea());
            Layout? layout = plotArea?.AppendChild(new Layout());
            LineChart? lineChart = plotArea?.AppendChild(new LineChart());

            Grouping grouping1 = new Grouping() { Val = GroupingValues.Standard };
            VaryColors varyColors1 = new VaryColors() { Val = false };

            lineChart?.AppendChild(grouping1);
            lineChart?.AppendChild(varyColors1);
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

            IList<LineChartValueSeries> seriesData = new List<LineChartValueSeries>();
            foreach (var rowNum in lineChartMetaDataNamedRange.SeriesRowNum)
            {
                string catgFormula = lineChartMetaDataNamedRange.WorksheetName + "!$" + lineChartMetaDataNamedRange.SeriesValueStartColumn + "$" + lineChartMetaDataNamedRange.CategoryAxisRow + ":$" + lineChartMetaDataNamedRange.SeriesValueEndColumn + "$" + lineChartMetaDataNamedRange.CategoryAxisRow;
                string valFormula = lineChartMetaDataNamedRange.WorksheetName + "!$" + lineChartMetaDataNamedRange.SeriesValueStartColumn + "$" + rowNum + ":$" + lineChartMetaDataNamedRange.SeriesValueEndColumn + "$" + rowNum;
                string seriesText = GetCellValue(wbPart, worksheetPart, lineChartMetaDataNamedRange.SeriesTextColumn + rowNum);
                seriesData.Add(
                    new LineChartValueSeries
                    {
                        CategoryFormula = catgFormula,

                        SeriesText = seriesText,

                        ValueFormula = valFormula
                    }); ;
            }

            // 4
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Assign Series data & Value data to linechart
            if (lineChart != null)
            {
                GenerateCategoryAxisSeries(lineChart, seriesData);
                GenerateValueAxisSeries(lineChart, seriesData);
            }
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


            // 5
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Append data labels
            lineChart?.AppendChild(new DataLabels(
                                new ShowLegendKey() { Val = false },
                                new ShowValue() { Val = false },
                                new ShowCategoryName() { Val = false },
                                new ShowSeriesName() { Val = false },
                                new ShowPercent() { Val = false },
                                new ShowBubbleSize() { Val = false }
                            ));
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



            // 6
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Append Category AXIS
            lineChart?.Append(new AxisId() { Val = 48650112u });
            lineChart?.Append(new AxisId() { Val = 48672768u });

            CategoryAxis categoryAxis = new CategoryAxis(
                    new AxisId() { Val = 48650112u },
                    new Scaling(new Orientation() { Val = new EnumValue<DocumentFormat.OpenXml.Drawing.Charts.OrientationValues>(DocumentFormat.OpenXml.Drawing.Charts.OrientationValues.MinMax) }),
                    new Delete() { Val = false },
                    new AxisPosition() { Val = new EnumValue<AxisPositionValues>(AxisPositionValues.Bottom) },
                    new TickLabelPosition() { Val = new EnumValue<TickLabelPositionValues>(TickLabelPositionValues.NextTo) },
                    new MajorTickMark() { Val = TickMarkValues.Cross },
                    new MinorTickMark() { Val = TickMarkValues.None },
                    new CrossingAxis() { Val = 48672768u },
                    new Crosses() { Val = new EnumValue<CrossesValues>(CrossesValues.AutoZero) },
                    new AutoLabeled() { Val = true },
                    new LabelAlignment() { Val = new EnumValue<LabelAlignmentValues>(LabelAlignmentValues.Center) }
                );
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



            // 7
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Generate GridLines
            categoryAxis.MajorGridlines = GenerateMajorGridlines();
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



            // 8
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Generate Chart Title
            categoryAxis.Title = GetTitleObject(lineChartMetaDataNamedRange.TitleTextCategoryAxis);
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


            // Adding Category Axis
            plotArea?.AppendChild(categoryAxis);
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


            // 9
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Append Value Axis
            ValueAxis valueAxis = new ValueAxis(
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
                    new MajorTickMark() { Val = TickMarkValues.Outside },
                    new MinorTickMark() { Val = TickMarkValues.None },
                    new TickLabelPosition() { Val = new EnumValue<TickLabelPositionValues>(TickLabelPositionValues.NextTo) },
                    new CrossingAxis() { Val = 48650112u },
                    new Crosses() { Val = new EnumValue<CrossesValues>(CrossesValues.AutoZero) },
                    new CrossBetween() { Val = new EnumValue<CrossBetweenValues>(CrossBetweenValues.MidpointCategory) }
                );
            valueAxis.Title = GetTitleObject(lineChartMetaDataNamedRange.TitleTextValueAxis);

            plotArea?.AppendChild(valueAxis);

            Legend? legend = chart?.AppendChild<Legend>(new Legend(new LegendPosition() { Val = new EnumValue<LegendPositionValues>(LegendPositionValues.Right) }, new Layout()));
            legend?.AppendChild(new Overlay() { Val = false });

            chart?.Append(
                    new PlotVisibleOnly() { Val = true },
                    new DisplayBlanksAs() { Val = new EnumValue<DisplayBlanksAsValues>(DisplayBlanksAsValues.Gap) },
                    new ShowDataLabelsOverMaximum() { Val = false }
                );
            if (chart != null)
                chart.Title = GetTitleObject(lineChartMetaDataNamedRange.TitleTextChart);

            chartPart?.ChartSpace.Save();

            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



            // 10
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Positioning the chart on the spreadsheet
            TwoCellAnchor? twoCellAnchor = drawingsPart?.WorksheetDrawing.AppendChild(new TwoCellAnchor());

            twoCellAnchor?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.FromMarker(
                    new ColumnId((lineChartMetaDataNamedRange.FromPosition.Col).ToString()),
                    new ColumnOffset("0"),
                    new RowId((lineChartMetaDataNamedRange.FromPosition.Row).ToString()),
                    new RowOffset("0")
                ));

            twoCellAnchor?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.ToMarker(
                    new ColumnId((lineChartMetaDataNamedRange.ToPosition.Col).ToString()),
                    new ColumnOffset("0"),
                    new RowId((lineChartMetaDataNamedRange.ToPosition.Row).ToString()),
                    new RowOffset("0")
                ));

            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


            // 11
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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

            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

            twoCellAnchor?.Append(new ClientData());



            // 12
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
            // Save sheet
            drawingsPart?.WorksheetDrawing.Save();

            worksheetPart?.Worksheet.Save();
            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


        }


        private void GenerateCategoryAxisSeries(LineChart lineChart, IEnumerable<LineChartValueSeries> lineChartValues)
        {

            int i = 0;
            foreach (var lineChartData in lineChartValues)
            {

                LineChartSeries lineChartSeries = lineChart.AppendChild(new LineChartSeries(
                    new Index() { Val = (uint)i },
                    new Order() { Val = (uint)i },
                    new SeriesText(new NumericValue() { Text = lineChartData.SeriesText }),
                    new Smooth { Val = false }
                ));

                // Adding category axis to the chart
                CategoryAxisData categoryAxisData = lineChartSeries.AppendChild(new CategoryAxisData());

                // Category
                // Constructing the chart category
                //string formulaCat = string.Format("CHA1E!$E${0}:$V${0}", rowIndex);
                string formulaCat = lineChartData.CategoryFormula;

                StringReference stringReference = categoryAxisData.AppendChild(new StringReference()
                {
                    Formula = new DocumentFormat.OpenXml.Drawing.Charts.Formula() { Text = formulaCat }
                });
                i++;
            }

        }

        private void GenerateValueAxisSeries(LineChart lineChart, IEnumerable<LineChartValueSeries> lineChartValues)
        {
            var chartSeries = lineChart.Elements<LineChartSeries>().GetEnumerator();


            foreach (var lineChartData in lineChartValues)
            {
                chartSeries.MoveNext();

                //string formulaVal = string.Format("CHA1E!$E${0}:$V${0}", rowIndex);
                string formulaVal = lineChartData.ValueFormula;
                DocumentFormat.OpenXml.Drawing.Charts.Values values = chartSeries.Current.AppendChild(new DocumentFormat.OpenXml.Drawing.Charts.Values());

                NumberReference numberReference = values.AppendChild(new NumberReference()
                {
                    Formula = new DocumentFormat.OpenXml.Drawing.Charts.Formula() { Text = formulaVal }
                });
            }

        }


        public static WorksheetPart? GetWorksheetPartByName(SpreadsheetDocument document, string sheetName)
        {
            IEnumerable<Sheet> sheets = document.WorkbookPart?.Workbook.GetFirstChild<Sheets>()?.Elements<Sheet>().Where(s => s.Name == sheetName) ?? Enumerable.Empty<Sheet>();

            if (sheets.Count() == 0)
            {
                // The specified worksheet does not exist.
                return null;
            }

            string relationshipId = sheets.First().Id?.Value ?? String.Empty;
            WorksheetPart? worksheetPart = (WorksheetPart?)(document.WorkbookPart?.GetPartById(relationshipId));

            return worksheetPart;
        }

        private Title GetTitleObject(string titleText)
        {
            Title objTitle = new Title();
            //var ctitle = t.AppendChild(new Title());
            var chartText = objTitle.AppendChild(new ChartText());
            var richText = chartText.AppendChild(new RichText());

            var bodyPr = richText.AppendChild(new D.BodyProperties());
            var lstStyle = richText.AppendChild(new D.ListStyle());
            var paragraph = richText.AppendChild(new D.Paragraph());

            var apPr = paragraph.AppendChild(new D.ParagraphProperties());
            apPr.AppendChild(new D.DefaultRunProperties());

            var run = paragraph.AppendChild(new D.Run());
            run.AppendChild(new D.RunProperties() { Language = "en-CA" });
            run.AppendChild(new D.Text() { Text = titleText });
            objTitle.AppendChild(new Overlay() { Val = new BooleanValue(false) });
            return objTitle;
        }

        public MajorGridlines GenerateMajorGridlines()
        {
            MajorGridlines majorGridlines1 = new MajorGridlines();

            ChartShapeProperties chartShapeProperties1 = new ChartShapeProperties();

            DocumentFormat.OpenXml.Drawing.Outline outline1 = new DocumentFormat.OpenXml.Drawing.Outline() { Width = 3175 };

            DocumentFormat.OpenXml.Drawing.SolidFill solidFill1 = new DocumentFormat.OpenXml.Drawing.SolidFill();
            DocumentFormat.OpenXml.Drawing.RgbColorModelHex rgbColorModelHex1 = new DocumentFormat.OpenXml.Drawing.RgbColorModelHex() { Val = "000000" };

            solidFill1.Append(rgbColorModelHex1);
            DocumentFormat.OpenXml.Drawing.PresetDash presetDash1 = new DocumentFormat.OpenXml.Drawing.PresetDash() { Val = DocumentFormat.OpenXml.Drawing.PresetLineDashValues.SystemDash };

            outline1.Append(solidFill1);
            outline1.Append(presetDash1);

            chartShapeProperties1.Append(outline1);

            majorGridlines1.Append(chartShapeProperties1);
            return majorGridlines1;
        }


        //public static Dictionary<String, String> GetDefinedNames(SpreadsheetDocument document)
        //{
        //    // Given a workbook name, return a dictionary of defined names.
        //    // The pairs include the range name and a string representing the range.
        //    var returnValue = new Dictionary<String, String>();

        //    // Open the spreadsheet document for read-only access.
        //    // Retrieve a reference to the workbook part.
        //    var wbPart = document.WorkbookPart;

        //    // Retrieve a reference to the defined names collection.
        //    DefinedNames definedNames = wbPart.Workbook.DefinedNames;

        //    // If there are defined names, add them to the dictionary.
        //    if (definedNames != null)
        //    {
        //        foreach (DefinedName dn in definedNames)
        //            returnValue.Add(dn.Name.Value, dn.Text);
        //    }
        //    return returnValue;
        //}


        public static string GetCellValue(WorksheetPart WSPart, string CellReference)
        {
            Cell? theCell = WSPart.Worksheet.Descendants<Cell>().Where(c => c.CellReference == CellReference).FirstOrDefault();

            return theCell?.CellValue?.Text ?? "";

        }


        //public void InsertChartUsingOpenSDKToolSample(string FilePath)
        //{
        //    using (SpreadsheetDocument myWorkbook = SpreadsheetDocument.Open(FilePath, true))
        //    {
        //        SampleOpenXMLSDKTool01 sampleOpenXMLSDKTool01 = new SampleOpenXMLSDKTool01();
        //        string sheetId = myWorkbook.WorkbookPart?.Workbook.Descendants<Sheet>().First(s => (s.Name ?? "").Equals("CHA1E")).Id?.Value ?? string.Empty;
        //        WorksheetPart? worksheetPart = (WorksheetPart?)(myWorkbook.WorkbookPart?.GetPartById(sheetId));
        //        if (worksheetPart != null)
        //        {
        //            sampleOpenXMLSDKTool01.CreateWorksheetPart(worksheetPart);
        //        }

        //    }
        //}


        public static string GetCellValue(WorkbookPart? wbPart, WorksheetPart? WSPart, string addressName)
        {
            string value = String.Empty;

            // Open the spreadsheet document for read-only access.

            // Retrieve a reference to the worksheet part.

            // Use its Worksheet property to get a reference to the cell 
            // whose address matches the address you supplied.
            Cell? theCell = WSPart?.Worksheet.Descendants<Cell>().Where(c => c.CellReference == addressName).FirstOrDefault();

            // If the cell does not exist, return an empty string.
            if (theCell?.InnerText.Length > 0)
            {
                value = theCell.InnerText;

                // If the cell represents an integer number, you are done. 
                // For dates, this code returns the serialized value that 
                // represents the date. The code handles strings and 
                // Booleans individually. For shared strings, the code 
                // looks up the corresponding value in the shared string 
                // table. For Booleans, the code converts the value into 
                // the words TRUE or FALSE.
                if (theCell.DataType != null)
                {
                    if (theCell.DataType.Value == CellValues.SharedString)
                    {

                        // For shared strings, look up the value in the
                        // shared strings table.
                        var stringTable = wbPart?.GetPartsOfType<SharedStringTablePart>().FirstOrDefault();

                        // If the shared string table is missing, something 
                        // is wrong. Return the index that is in
                        // the cell. Otherwise, look up the correct text in 
                        // the table.
                        if (stringTable != null)
                        {
                            value =
                                stringTable.SharedStringTable
                                .ElementAt(int.Parse(value)).InnerText;
                        }

                    }
                    else if (theCell.DataType.Value == CellValues.Boolean)
                    {
                        switch (value)
                        {
                            case "0":
                                value = "FALSE";
                                break;
                            default:
                                value = "TRUE";
                                break;
                        }
                    }
                }
            }
            return value;
        }

    }
}
