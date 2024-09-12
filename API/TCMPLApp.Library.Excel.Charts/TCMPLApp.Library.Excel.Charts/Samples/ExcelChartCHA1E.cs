using DocumentFormat.OpenXml;
using D = DocumentFormat.OpenXml.Drawing;
using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.Drawing.Spreadsheet;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.ComponentModel.DataAnnotations;
using Index = DocumentFormat.OpenXml.Drawing.Charts.Index;
using TCMPLApp.Library.Excel.Charts.Models;

namespace TCMPLApp.Library.Excel.Charts
{

    public class ExcelChartCHA1E
    {

        private DrawingsPart? _drawingsPart = null;
        private ChartPart? _chartPart = null;



        public void GenerateReport(string FilePath)
        {
            LineChartData[] lineChartData = new LineChartData[] {
                new LineChartData{ SeriesText="Available hours (A)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$104:$V$104"},
                new LineChartData{ SeriesText="Available hours after MOW (C)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$105:$V$105"   },
                new LineChartData{ SeriesText="Available hours after MOW with Overtime(G) =C+(F*C)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$107:$V$107"   },
                new LineChartData{ SeriesText="Committed hours (D)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$108:$V$108"   },
                new LineChartData{ SeriesText="Committed hours with Expected Projects (H) = D+E ", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$109:$V$109"   },
                new LineChartData{ SeriesText="Committed hours with Expected proj, Active (K) = D+J", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$110:$V$110"   },
                new LineChartData{ SeriesText="Available hours after MOW with OT + Subcont (N)=G+L", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$123:$V$123"   }
            };




            using (SpreadsheetDocument myWorkbook = SpreadsheetDocument.Open(FilePath, true))
            {
                string workSheetName = "CHA1E";


                string sheetId = myWorkbook.WorkbookPart?.Workbook?.Descendants<Sheet>().First(s => s.Name?.Equals(workSheetName) ?? false).Id?.Value ?? "";

                //return;

                WorksheetPart? worksheetPart = (WorksheetPart?)(myWorkbook.WorkbookPart?.GetPartById(sheetId));


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
                if(chartPart != null)   
                chartPart.ChartSpace = new ChartSpace();

                chartPart?.ChartSpace.AppendChild(new EditingLanguage() { Val = "en-US" });
                chartPart?.ChartSpace.AppendChild(new RoundedCorners() { Val = false });

                Chart? chart = chartPart?.ChartSpace.AppendChild(new Chart());
                chart?.AppendChild(new AutoTitleDeleted() { Val = true }); // We don't want to show the chart title

                // Create a new Clustered Column Chart
                PlotArea? plotArea = chart?.AppendChild(new PlotArea());
                Layout? layout = plotArea?.AppendChild(new Layout());

                LineChart? lineChart = plotArea?.AppendChild(new LineChart());
                Grouping? grouping1 = new Grouping() { Val = GroupingValues.Standard };
                VaryColors varyColors1 = new VaryColors() { Val = false };

                lineChart?.AppendChild(grouping1);
                lineChart?.AppendChild(varyColors1);
                int rowIndex = 9;
                // add series to the lineChart
                //for (LineChartSeries s in series)
                for (int i = 0; i < lineChartData.Length; i++)
                {

                    LineChartSeries? lineChartSeries = lineChart?.AppendChild(new LineChartSeries(
                        new Index() { Val = (uint)i },
                        new Order() { Val = (uint)i },
                        new SeriesText(new NumericValue() { Text = lineChartData[i].SeriesText })
                    ));



                    // Adding category axis to the chart
                    CategoryAxisData? categoryAxisData = lineChartSeries?.AppendChild(new CategoryAxisData());
                     
                    // Category
                    // Constructing the chart category
                    //string formulaCat = string.Format("CHA1E!$E${0}:$V${0}", rowIndex);
                    string formulaCat = lineChartData[i].CategoryFormula;

                    StringReference? stringReference = categoryAxisData?.AppendChild(new StringReference()
                    {
                        Formula = new DocumentFormat.OpenXml.Drawing.Charts.Formula() { Text = formulaCat }
                    });
                }

                var chartSeries = lineChart?.Elements<LineChartSeries>().GetEnumerator();

                for (int i = 0; i < lineChartData.Length; i++)
                {
                    rowIndex++;

                    //row = new Row();

                    //row.AppendChild(ConstructCell(students[i].Name, CellValues.String));

                    chartSeries?.MoveNext();

                    //string formulaVal = string.Format("CHA1E!$E${0}:$V${0}", rowIndex);
                    string formulaVal = lineChartData[i].ValueFormula;
                    DocumentFormat.OpenXml.Drawing.Charts.Values? values = chartSeries?.Current.AppendChild(new DocumentFormat.OpenXml.Drawing.Charts.Values());


                    NumberReference? numberReference = values?.AppendChild(new NumberReference()
                    {
                        Formula = new DocumentFormat.OpenXml.Drawing.Charts.Formula() { Text = formulaVal }
                    });
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

                CategoryAxis categoryAxis = new CategoryAxis(
                        new AxisId() { Val = 48650112u },
                        new Scaling(new Orientation() { Val = new EnumValue<DocumentFormat.OpenXml.Drawing.Charts.OrientationValues>(DocumentFormat.OpenXml.Drawing.Charts.OrientationValues.MinMax) }),
                        new Delete() { Val = false },
                        new AxisPosition() { Val = new EnumValue<AxisPositionValues>(AxisPositionValues.Bottom) },
                        new TickLabelPosition() { Val = new EnumValue<TickLabelPositionValues>(TickLabelPositionValues.NextTo) },
                        new CrossingAxis() { Val = 48672768u },
                        new Crosses() { Val = new EnumValue<CrossesValues>(CrossesValues.AutoZero) },
                        new AutoLabeled() { Val = true },
                        new LabelAlignment() { Val = new EnumValue<LabelAlignmentValues>(LabelAlignmentValues.Center) }
                    );
                categoryAxis.MajorGridlines = GenerateMajorGridlines();
                categoryAxis.Title = GetTitleObject("Months");
                // Adding Category Axis
                plotArea?.AppendChild(categoryAxis);

                // Adding Value Axis

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
                        new TickLabelPosition() { Val = new EnumValue<TickLabelPositionValues>(TickLabelPositionValues.NextTo) },
                        new CrossingAxis() { Val = 48650112u },
                        new Crosses() { Val = new EnumValue<CrossesValues>(CrossesValues.AutoZero) },
                        new CrossBetween() { Val = new EnumValue<CrossBetweenValues>(CrossBetweenValues.Between) }
                    );
                valueAxis.Title = GetTitleObject("Manhours");

                plotArea?.AppendChild(valueAxis);

                Legend? legend = chart?.AppendChild<Legend>(new Legend(new LegendPosition() { Val = new EnumValue<LegendPositionValues>(LegendPositionValues.Right) }, new Layout()));
                legend?.AppendChild(new Overlay() { Val = false });

                chart?.Append(
                        new PlotVisibleOnly() { Val = true },
                        new DisplayBlanksAs() { Val = new EnumValue<DisplayBlanksAsValues>(DisplayBlanksAsValues.Gap) },
                        new ShowDataLabelsOverMaximum() { Val = false }
                    );
                if (chart != null)
                chart.Title = GetTitleObject("Cost Centre Work Load Projections");

                chartPart?.ChartSpace.Save();

                // Positioning the chart on the spreadsheet
                TwoCellAnchor? twoCellAnchor = drawingsPart?.WorksheetDrawing.AppendChild(new TwoCellAnchor());

                twoCellAnchor?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.FromMarker(
                        new ColumnId("0"),
                        new ColumnOffset("0"),
                        new RowId((127 + 1).ToString()),
                        new RowOffset("0")
                    ));

                twoCellAnchor?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.ToMarker(
                        new ColumnId("22"),
                        new ColumnOffset("0"),
                        new RowId((127 + 40).ToString()),
                        new RowOffset("0")
                    ));

                // Append GraphicFrame to TwoCellAnchor
                GraphicFrame? graphicFrame = twoCellAnchor?.AppendChild(new GraphicFrame());
                if(graphicFrame!=null)
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
                if(chartPart!=null)
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

        private void DoChartBuilding(LineChartData[] lineChartData)
        {
            Chart? chart = _chartPart?.ChartSpace.AppendChild<Chart>(new Chart());

            chart?.AppendChild(new AutoTitleDeleted() { Val = true }); // We don't want to show the chart title


            PlotArea? plotArea = chart?.AppendChild<PlotArea>(new PlotArea());
            Layout? layout = plotArea?.AppendChild<Layout>(new Layout());
            LineChart? lineChart = plotArea?.AppendChild<LineChart>(new LineChart());



            // add series to the lineChart
            //for (LineChartSeries s in series)
            for (int i = 0; i < lineChartData.Length; i++)
            {
                uint j = (uint)i;
                //var s = lineChart.AppendChild<LineChartSeries>(new LineChartSeries());
                //s.SeriesText = new SeriesText(new NumericValue() { Text = lineChartData[i].SeriesText });
                //s.Index = new Index() { Val = new UInt32Value(j) };
                //s.Order = new Order() { Val = new UInt32Value(j) };

                LineChartSeries? lineChartSeries = lineChart?.AppendChild(new LineChartSeries(
                    new Index() { Val = (uint)i },
                    new Order() { Val = (uint)i },
                    new SeriesText(new NumericValue() { Text = lineChartData[i].SeriesText })
                ));



                CategoryAxisData? categoryAxisData = lineChartSeries?.AppendChild(new CategoryAxisData());

                // Category
                // Constructing the chart category

                StringReference? stringReference = categoryAxisData?.AppendChild(new StringReference()
                {
                    Formula = new DocumentFormat.OpenXml.Drawing.Charts.Formula() { Text = lineChartData[i].CategoryFormula }
                });

                DocumentFormat.OpenXml.Drawing.Charts.Values? values = lineChartSeries?.AppendChild(new DocumentFormat.OpenXml.Drawing.Charts.Values());

                NumberReference? numberReference = values?.AppendChild(new NumberReference()
                {
                    Formula = new DocumentFormat.OpenXml.Drawing.Charts.Formula() { Text = lineChartData[i].ValueFormula }
                });



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

        }

        private void DoDrawingPartPositioning()
        {
            TwoCellAnchor? twoCellAnchor = _drawingsPart?.WorksheetDrawing.AppendChild<TwoCellAnchor>(new TwoCellAnchor());
            twoCellAnchor?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.FromMarker(
                        new ColumnId("0"),
                        new ColumnOffset("0"),
                        new RowId((127).ToString()),
                        new RowOffset("0")
                ));
            twoCellAnchor?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.ToMarker(
                new ColumnId("22"),
                new ColumnOffset("0"),
                new RowId("167"),
                new RowOffset("0")
                ));

            // Append a GraphicFrame to the TwoCellAnchor object.
            GraphicFrame? graphicFrame = twoCellAnchor?.AppendChild<GraphicFrame>(new GraphicFrame());
            if(graphicFrame != null)
            graphicFrame.Macro = "";

            graphicFrame?.Append(new DocumentFormat.OpenXml.Drawing.Spreadsheet.NonVisualGraphicFrameProperties(
                new DocumentFormat.OpenXml.Drawing.Spreadsheet.NonVisualDrawingProperties()
                {
                    Id = new UInt32Value(2u),
                    Name = "Chart 1"
                }, new DocumentFormat.OpenXml.Drawing.Spreadsheet.NonVisualGraphicFrameDrawingProperties()));

            graphicFrame?.Append(new Transform(new DocumentFormat.OpenXml.Drawing.Offset() { X = 0L, Y = 0L },
                                new DocumentFormat.OpenXml.Drawing.Extents() { Cx = 0L, Cy = 0L }));

            if (_chartPart != null)
                graphicFrame?.Append(new DocumentFormat.OpenXml.Drawing.Graphic(new DocumentFormat.OpenXml.Drawing.GraphicData(new ChartReference() { Id = _drawingsPart?.GetIdOfPart(_chartPart) })
                { Uri = "https://schemas.openxmlformats.org/drawingml/2006/chart" }));

            twoCellAnchor?.Append(new ClientData());

            // Save the WorksheetDrawing object.
            _drawingsPart?.WorksheetDrawing.Save();
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

        //public void InsertChart(string FilePath, IEnumerable<LineChartMetaData> lineCharts)
        //{
        //    using (SpreadsheetDocument myWorkbook = SpreadsheetDocument.Open(FilePath, true))
        //    {
        //        foreach (LineChartMetaData lineChart in lineCharts)
        //        {
        //            StringValue stringValue = myWorkbook?.WorkbookPart?.Workbook.Descendants<Sheet>().First(s => s.Name.Equals(lineChart.WorksheetName)).Id ?? string.Empty;

        //            WorksheetPart? worksheetPart = (WorksheetPart?)(myWorkbook?.WorkbookPart?.GetPartById(stringValue.ToString() ?? ""));


        //            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        //            // Add drawing part to WorksheetPart

        //            DrawingsPart? drawingsPart = worksheetPart?.AddNewPart<DrawingsPart>();

        //            if (drawingsPart != null)
        //                worksheetPart?.Worksheet.Append(new Drawing() { Id = worksheetPart.GetIdOfPart(drawingsPart) });

        //            worksheetPart?.Worksheet.Save();
        //            if (drawingsPart != null)
        //                drawingsPart.WorksheetDrawing = new WorksheetDrawing();

        //            myWorkbook?.WorkbookPart?.Workbook.Save();
        //            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


        //            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        //            // Add a new chart and set the chart language
        //            ChartPart? chartPart = drawingsPart?.AddNewPart<ChartPart>();
        //            if (chartPart != null)
        //                chartPart.ChartSpace = new ChartSpace();

        //            chartPart?.ChartSpace.AppendChild(new EditingLanguage() { Val = "en-US" });
        //            chartPart?.ChartSpace.AppendChild(new RoundedCorners() { Val = false });

        //            Chart? chart = chartPart?.ChartSpace.AppendChild(new Chart());
        //            chart?.AppendChild(new AutoTitleDeleted() { Val = true }); // We don't want to show the chart title
        //            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


        //        }
        //    }

        //}


        //public void InsertChart(MemoryStream ExcelFileStream, IEnumerable<LineChartMetaData> lineCharts)
        //{
        //    foreach (LineChartMetaData lineChartMetaDataItem in lineCharts)
        //    {

        //    }

        //}


    }


    public class LineChartData
    {
        [Required]
        public string SeriesText { get; set; }

        [Required]
        public string CategoryFormula { get; set; }

        [Required]
        public string ValueFormula { get; set; }

    }





}