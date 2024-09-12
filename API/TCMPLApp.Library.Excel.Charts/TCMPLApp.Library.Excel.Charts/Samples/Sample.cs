
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml;
using Xdr = DocumentFormat.OpenXml.Drawing.Spreadsheet;
using A = DocumentFormat.OpenXml.Drawing;
using C = DocumentFormat.OpenXml.Drawing.Charts;
using C14 = DocumentFormat.OpenXml.Office2010.Drawing.Charts;
using C15 = DocumentFormat.OpenXml.Office2013.Drawing.Chart;

namespace TCMPLApp.Library.Excel.Charts
{
    public class Sample
    {


        // Adds child parts and generates content of the specified part.
        public void CreateWorksheetPart(WorksheetPart part)
        {

            DrawingsPart drawingsPart1 = part.AddNewPart<DrawingsPart>("rId10");
            GenerateDrawingsPart1Content(drawingsPart1);

            ChartPart chartPart1 = drawingsPart1.AddNewPart<ChartPart>("rId11");
            GenerateChartPart1Content(chartPart1);


        }


        // Generates content of drawingsPart1.
        private void GenerateDrawingsPart1Content(DrawingsPart drawingsPart1)
        {
            Xdr.WorksheetDrawing worksheetDrawing1 = new Xdr.WorksheetDrawing();
            worksheetDrawing1.AddNamespaceDeclaration("xdr", "http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing");
            worksheetDrawing1.AddNamespaceDeclaration("a", "http://schemas.openxmlformats.org/drawingml/2006/main");

            Xdr.TwoCellAnchor twoCellAnchor1 = new Xdr.TwoCellAnchor();

            Xdr.FromMarker fromMarker1 = new Xdr.FromMarker();
            Xdr.ColumnId columnId1 = new Xdr.ColumnId();
            columnId1.Text = "0";
            Xdr.ColumnOffset columnOffset1 = new Xdr.ColumnOffset();
            columnOffset1.Text = "0";
            Xdr.RowId rowId1 = new Xdr.RowId();
            rowId1.Text = "126";
            Xdr.RowOffset rowOffset1 = new Xdr.RowOffset();
            rowOffset1.Text = "0";

            fromMarker1.Append(columnId1);
            fromMarker1.Append(columnOffset1);
            fromMarker1.Append(rowId1);
            fromMarker1.Append(rowOffset1);

            Xdr.ToMarker toMarker1 = new Xdr.ToMarker();
            Xdr.ColumnId columnId2 = new Xdr.ColumnId();
            columnId2.Text = "22";
            Xdr.ColumnOffset columnOffset2 = new Xdr.ColumnOffset();
            columnOffset2.Text = "445770";
            Xdr.RowId rowId2 = new Xdr.RowId();
            rowId2.Text = "167";
            Xdr.RowOffset rowOffset2 = new Xdr.RowOffset();
            rowOffset2.Text = "158115";

            toMarker1.Append(columnId2);
            toMarker1.Append(columnOffset2);
            toMarker1.Append(rowId2);
            toMarker1.Append(rowOffset2);

            Xdr.GraphicFrame graphicFrame1 = new Xdr.GraphicFrame() { Macro = "" };

            Xdr.NonVisualGraphicFrameProperties nonVisualGraphicFrameProperties1 = new Xdr.NonVisualGraphicFrameProperties();

            Xdr.NonVisualDrawingProperties nonVisualDrawingProperties1 = new Xdr.NonVisualDrawingProperties() { Id = (UInt32Value)22549U, Name = "Chart 1" };

            A.NonVisualDrawingPropertiesExtensionList nonVisualDrawingPropertiesExtensionList1 = new A.NonVisualDrawingPropertiesExtensionList();

            A.NonVisualDrawingPropertiesExtension nonVisualDrawingPropertiesExtension1 = new A.NonVisualDrawingPropertiesExtension() { Uri = "{FF2B5EF4-FFF2-40B4-BE49-F238E27FC236}" };

            OpenXmlUnknownElement openXmlUnknownElement1 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<a16:creationId xmlns:a16=\"http://schemas.microsoft.com/office/drawing/2014/main\" id=\"{00000000-0008-0000-0100-000015580000}\" />");

            nonVisualDrawingPropertiesExtension1.Append(openXmlUnknownElement1);

            nonVisualDrawingPropertiesExtensionList1.Append(nonVisualDrawingPropertiesExtension1);

            nonVisualDrawingProperties1.Append(nonVisualDrawingPropertiesExtensionList1);

            Xdr.NonVisualGraphicFrameDrawingProperties nonVisualGraphicFrameDrawingProperties1 = new Xdr.NonVisualGraphicFrameDrawingProperties();
            A.GraphicFrameLocks graphicFrameLocks1 = new A.GraphicFrameLocks();

            nonVisualGraphicFrameDrawingProperties1.Append(graphicFrameLocks1);

            nonVisualGraphicFrameProperties1.Append(nonVisualDrawingProperties1);
            nonVisualGraphicFrameProperties1.Append(nonVisualGraphicFrameDrawingProperties1);

            Xdr.Transform transform1 = new Xdr.Transform();
            A.Offset offset1 = new A.Offset() { X = 0L, Y = 0L };
            A.Extents extents1 = new A.Extents() { Cx = 0L, Cy = 0L };

            transform1.Append(offset1);
            transform1.Append(extents1);

            A.Graphic graphic1 = new A.Graphic();

            A.GraphicData graphicData1 = new A.GraphicData() { Uri = "http://schemas.openxmlformats.org/drawingml/2006/chart" };

            C.ChartReference chartReference1 = new C.ChartReference() { Id = "rId11" };
            chartReference1.AddNamespaceDeclaration("c", "http://schemas.openxmlformats.org/drawingml/2006/chart");
            chartReference1.AddNamespaceDeclaration("r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships");

            graphicData1.Append(chartReference1);

            graphic1.Append(graphicData1);

            graphicFrame1.Append(nonVisualGraphicFrameProperties1);
            graphicFrame1.Append(transform1);
            graphicFrame1.Append(graphic1);
            Xdr.ClientData clientData1 = new Xdr.ClientData();

            twoCellAnchor1.Append(fromMarker1);
            twoCellAnchor1.Append(toMarker1);
            twoCellAnchor1.Append(graphicFrame1);
            twoCellAnchor1.Append(clientData1);

            worksheetDrawing1.Append(twoCellAnchor1);

            drawingsPart1.WorksheetDrawing = worksheetDrawing1;
        }

        // Generates content of chartPart1.
        private void GenerateChartPart1Content(ChartPart chartPart1)
        {
            C.ChartSpace chartSpace1 = new C.ChartSpace();
            chartSpace1.AddNamespaceDeclaration("c", "http://schemas.openxmlformats.org/drawingml/2006/chart");
            chartSpace1.AddNamespaceDeclaration("a", "http://schemas.openxmlformats.org/drawingml/2006/main");
            chartSpace1.AddNamespaceDeclaration("r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships");
            chartSpace1.AddNamespaceDeclaration("c16r2", "http://schemas.microsoft.com/office/drawing/2015/06/chart");
            C.Date1904 date19041 = new C.Date1904() { Val = false };
            C.EditingLanguage editingLanguage1 = new C.EditingLanguage() { Val = "en-US" };
            C.RoundedCorners roundedCorners1 = new C.RoundedCorners() { Val = false };

            AlternateContent alternateContent1 = new AlternateContent();
            alternateContent1.AddNamespaceDeclaration("mc", "http://schemas.openxmlformats.org/markup-compatibility/2006");

            AlternateContentChoice alternateContentChoice1 = new AlternateContentChoice() { Requires = "c14" };
            alternateContentChoice1.AddNamespaceDeclaration("c14", "http://schemas.microsoft.com/office/drawing/2007/8/2/chart");
            C14.Style style1 = new C14.Style() { Val = 102 };

            alternateContentChoice1.Append(style1);

            AlternateContentFallback alternateContentFallback1 = new AlternateContentFallback();
            C.Style style2 = new C.Style() { Val = 2 };

            alternateContentFallback1.Append(style2);

            alternateContent1.Append(alternateContentChoice1);
            alternateContent1.Append(alternateContentFallback1);

            C.Chart chart1 = new C.Chart();

            C.Title title1 = new C.Title();

            C.ChartText chartText1 = new C.ChartText();

            C.RichText richText1 = new C.RichText();
            A.BodyProperties bodyProperties1 = new A.BodyProperties();
            A.ListStyle listStyle1 = new A.ListStyle();

            A.Paragraph paragraph1 = new A.Paragraph();

            A.ParagraphProperties paragraphProperties1 = new A.ParagraphProperties();

            A.DefaultRunProperties defaultRunProperties1 = new A.DefaultRunProperties() { FontSize = 1200, Bold = true, Italic = false, Underline = A.TextUnderlineValues.None, Strike = A.TextStrikeValues.NoStrike, Baseline = 0 };

            A.SolidFill solidFill1 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex1 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill1.Append(rgbColorModelHex1);
            A.LatinFont latinFont1 = new A.LatinFont() { Typeface = "Times New Roman" };
            A.EastAsianFont eastAsianFont1 = new A.EastAsianFont() { Typeface = "Times New Roman" };
            A.ComplexScriptFont complexScriptFont1 = new A.ComplexScriptFont() { Typeface = "Times New Roman" };

            defaultRunProperties1.Append(solidFill1);
            defaultRunProperties1.Append(latinFont1);
            defaultRunProperties1.Append(eastAsianFont1);
            defaultRunProperties1.Append(complexScriptFont1);

            paragraphProperties1.Append(defaultRunProperties1);

            A.Run run1 = new A.Run();
            A.RunProperties runProperties1 = new A.RunProperties() { Language = "en-IN" };
            A.Text text1 = new A.Text();
            text1.Text = "Cost Centre Work Load Projections\n\n";

            run1.Append(runProperties1);
            run1.Append(text1);

            paragraph1.Append(paragraphProperties1);
            paragraph1.Append(run1);

            richText1.Append(bodyProperties1);
            richText1.Append(listStyle1);
            richText1.Append(paragraph1);

            chartText1.Append(richText1);

            C.Layout layout1 = new C.Layout();

            C.ManualLayout manualLayout1 = new C.ManualLayout();
            C.LeftMode leftMode1 = new C.LeftMode() { Val = C.LayoutModeValues.Edge };
            C.TopMode topMode1 = new C.TopMode() { Val = C.LayoutModeValues.Edge };
            C.Left left1 = new C.Left() { Val = 0.37280721488761276D };
            C.Top top1 = new C.Top() { Val = 9.5890410958904115E-3D };

            manualLayout1.Append(leftMode1);
            manualLayout1.Append(topMode1);
            manualLayout1.Append(left1);
            manualLayout1.Append(top1);

            layout1.Append(manualLayout1);
            C.Overlay overlay1 = new C.Overlay() { Val = false };

            C.ChartShapeProperties chartShapeProperties1 = new C.ChartShapeProperties();
            A.NoFill noFill1 = new A.NoFill();

            A.Outline outline1 = new A.Outline() { Width = 25400 };
            A.NoFill noFill2 = new A.NoFill();

            outline1.Append(noFill2);

            chartShapeProperties1.Append(noFill1);
            chartShapeProperties1.Append(outline1);

            title1.Append(chartText1);
            title1.Append(layout1);
            title1.Append(overlay1);
            title1.Append(chartShapeProperties1);
            C.AutoTitleDeleted autoTitleDeleted1 = new C.AutoTitleDeleted() { Val = false };

            C.PlotArea plotArea1 = new C.PlotArea();

            C.Layout layout2 = new C.Layout();

            C.ManualLayout manualLayout2 = new C.ManualLayout();
            C.LayoutTarget layoutTarget1 = new C.LayoutTarget() { Val = C.LayoutTargetValues.Inner };
            C.LeftMode leftMode2 = new C.LeftMode() { Val = C.LayoutModeValues.Edge };
            C.TopMode topMode2 = new C.TopMode() { Val = C.LayoutModeValues.Edge };
            C.Left left2 = new C.Left() { Val = 4.2606542360871885E-2D };
            C.Top top2 = new C.Top() { Val = 0.11232884225762672D };
            C.Width width1 = new C.Width() { Val = 0.81265713885368873D };
            C.Height height1 = new C.Height() { Val = 0.79315121545324241D };

            manualLayout2.Append(layoutTarget1);
            manualLayout2.Append(leftMode2);
            manualLayout2.Append(topMode2);
            manualLayout2.Append(left2);
            manualLayout2.Append(top2);
            manualLayout2.Append(width1);
            manualLayout2.Append(height1);

            layout2.Append(manualLayout2);

            C.LineChart lineChart1 = new C.LineChart();
            C.Grouping grouping1 = new C.Grouping() { Val = C.GroupingValues.Standard };
            C.VaryColors varyColors1 = new C.VaryColors() { Val = false };

            C.LineChartSeries lineChartSeries1 = new C.LineChartSeries();
            C.Index index1 = new C.Index() { Val = (UInt32Value)0U };
            C.Order order1 = new C.Order() { Val = (UInt32Value)1U };

            C.SeriesText seriesText1 = new C.SeriesText();
            C.NumericValue numericValue1 = new C.NumericValue();
            numericValue1.Text = "Available hours (A)";

            seriesText1.Append(numericValue1);

            C.CategoryAxisData categoryAxisData1 = new C.CategoryAxisData();

            C.StringReference stringReference1 = new C.StringReference();
            C.Formula formula1 = new C.Formula();
            formula1.Text = "CHA1E!$E$9:$V$9";

            C.StringCache stringCache1 = new C.StringCache();
            C.PointCount pointCount1 = new C.PointCount() { Val = (UInt32Value)18U };

            C.StringPoint stringPoint1 = new C.StringPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue2 = new C.NumericValue();
            numericValue2.Text = "2022/10";

            stringPoint1.Append(numericValue2);

            C.StringPoint stringPoint2 = new C.StringPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue3 = new C.NumericValue();
            numericValue3.Text = "2022/11";

            stringPoint2.Append(numericValue3);

            C.StringPoint stringPoint3 = new C.StringPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue4 = new C.NumericValue();
            numericValue4.Text = "2022/12";

            stringPoint3.Append(numericValue4);

            C.StringPoint stringPoint4 = new C.StringPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue5 = new C.NumericValue();
            numericValue5.Text = "2023/01";

            stringPoint4.Append(numericValue5);

            C.StringPoint stringPoint5 = new C.StringPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue6 = new C.NumericValue();
            numericValue6.Text = "2023/02";

            stringPoint5.Append(numericValue6);

            C.StringPoint stringPoint6 = new C.StringPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue7 = new C.NumericValue();
            numericValue7.Text = "2023/03";

            stringPoint6.Append(numericValue7);

            C.StringPoint stringPoint7 = new C.StringPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue8 = new C.NumericValue();
            numericValue8.Text = "2023/04";

            stringPoint7.Append(numericValue8);

            C.StringPoint stringPoint8 = new C.StringPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue9 = new C.NumericValue();
            numericValue9.Text = "2023/05";

            stringPoint8.Append(numericValue9);

            C.StringPoint stringPoint9 = new C.StringPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue10 = new C.NumericValue();
            numericValue10.Text = "2023/06";

            stringPoint9.Append(numericValue10);

            C.StringPoint stringPoint10 = new C.StringPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue11 = new C.NumericValue();
            numericValue11.Text = "2023/07";

            stringPoint10.Append(numericValue11);

            C.StringPoint stringPoint11 = new C.StringPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue12 = new C.NumericValue();
            numericValue12.Text = "2023/08";

            stringPoint11.Append(numericValue12);

            C.StringPoint stringPoint12 = new C.StringPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue13 = new C.NumericValue();
            numericValue13.Text = "2023/09";

            stringPoint12.Append(numericValue13);

            C.StringPoint stringPoint13 = new C.StringPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue14 = new C.NumericValue();
            numericValue14.Text = "2023/10";

            stringPoint13.Append(numericValue14);

            C.StringPoint stringPoint14 = new C.StringPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue15 = new C.NumericValue();
            numericValue15.Text = "2023/11";

            stringPoint14.Append(numericValue15);

            C.StringPoint stringPoint15 = new C.StringPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue16 = new C.NumericValue();
            numericValue16.Text = "2023/12";

            stringPoint15.Append(numericValue16);

            C.StringPoint stringPoint16 = new C.StringPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue17 = new C.NumericValue();
            numericValue17.Text = "2024/01";

            stringPoint16.Append(numericValue17);

            C.StringPoint stringPoint17 = new C.StringPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue18 = new C.NumericValue();
            numericValue18.Text = "2024/02";

            stringPoint17.Append(numericValue18);

            C.StringPoint stringPoint18 = new C.StringPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue19 = new C.NumericValue();
            numericValue19.Text = "2024/03";

            stringPoint18.Append(numericValue19);

            stringCache1.Append(pointCount1);
            stringCache1.Append(stringPoint1);
            stringCache1.Append(stringPoint2);
            stringCache1.Append(stringPoint3);
            stringCache1.Append(stringPoint4);
            stringCache1.Append(stringPoint5);
            stringCache1.Append(stringPoint6);
            stringCache1.Append(stringPoint7);
            stringCache1.Append(stringPoint8);
            stringCache1.Append(stringPoint9);
            stringCache1.Append(stringPoint10);
            stringCache1.Append(stringPoint11);
            stringCache1.Append(stringPoint12);
            stringCache1.Append(stringPoint13);
            stringCache1.Append(stringPoint14);
            stringCache1.Append(stringPoint15);
            stringCache1.Append(stringPoint16);
            stringCache1.Append(stringPoint17);
            stringCache1.Append(stringPoint18);

            stringReference1.Append(formula1);
            stringReference1.Append(stringCache1);

            categoryAxisData1.Append(stringReference1);

            C.Values values1 = new C.Values();

            C.NumberReference numberReference1 = new C.NumberReference();
            C.Formula formula2 = new C.Formula();
            formula2.Text = "CHA1E!$E$104:$V$104";

            C.NumberingCache numberingCache1 = new C.NumberingCache();
            C.FormatCode formatCode1 = new C.FormatCode();
            formatCode1.Text = "#,##0.0";
            C.PointCount pointCount2 = new C.PointCount() { Val = (UInt32Value)18U };

            C.NumericPoint numericPoint1 = new C.NumericPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue20 = new C.NumericValue();
            numericValue20.Text = "59392";

            numericPoint1.Append(numericValue20);

            C.NumericPoint numericPoint2 = new C.NumericPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue21 = new C.NumericValue();
            numericValue21.Text = "74240";

            numericPoint2.Append(numericValue21);

            C.NumericPoint numericPoint3 = new C.NumericPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue22 = new C.NumericValue();
            numericValue22.Text = "74240";

            numericPoint3.Append(numericValue22);

            C.NumericPoint numericPoint4 = new C.NumericPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue23 = new C.NumericValue();
            numericValue23.Text = "70528";

            numericPoint4.Append(numericValue23);

            C.NumericPoint numericPoint5 = new C.NumericPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue24 = new C.NumericValue();
            numericValue24.Text = "70528";

            numericPoint5.Append(numericValue24);

            C.NumericPoint numericPoint6 = new C.NumericPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue25 = new C.NumericValue();
            numericValue25.Text = "70528";

            numericPoint6.Append(numericValue25);

            C.NumericPoint numericPoint7 = new C.NumericPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue26 = new C.NumericValue();
            numericValue26.Text = "70528";

            numericPoint7.Append(numericValue26);

            C.NumericPoint numericPoint8 = new C.NumericPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue27 = new C.NumericValue();
            numericValue27.Text = "70528";

            numericPoint8.Append(numericValue27);

            C.NumericPoint numericPoint9 = new C.NumericPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue28 = new C.NumericValue();
            numericValue28.Text = "70528";

            numericPoint9.Append(numericValue28);

            C.NumericPoint numericPoint10 = new C.NumericPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue29 = new C.NumericValue();
            numericValue29.Text = "70528";

            numericPoint10.Append(numericValue29);

            C.NumericPoint numericPoint11 = new C.NumericPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue30 = new C.NumericValue();
            numericValue30.Text = "70528";

            numericPoint11.Append(numericValue30);

            C.NumericPoint numericPoint12 = new C.NumericPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue31 = new C.NumericValue();
            numericValue31.Text = "70528";

            numericPoint12.Append(numericValue31);

            C.NumericPoint numericPoint13 = new C.NumericPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue32 = new C.NumericValue();
            numericValue32.Text = "70528";

            numericPoint13.Append(numericValue32);

            C.NumericPoint numericPoint14 = new C.NumericPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue33 = new C.NumericValue();
            numericValue33.Text = "70528";

            numericPoint14.Append(numericValue33);

            C.NumericPoint numericPoint15 = new C.NumericPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue34 = new C.NumericValue();
            numericValue34.Text = "70528";

            numericPoint15.Append(numericValue34);

            C.NumericPoint numericPoint16 = new C.NumericPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue35 = new C.NumericValue();
            numericValue35.Text = "70528";

            numericPoint16.Append(numericValue35);

            C.NumericPoint numericPoint17 = new C.NumericPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue36 = new C.NumericValue();
            numericValue36.Text = "70528";

            numericPoint17.Append(numericValue36);

            C.NumericPoint numericPoint18 = new C.NumericPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue37 = new C.NumericValue();
            numericValue37.Text = "70528";

            numericPoint18.Append(numericValue37);

            numberingCache1.Append(formatCode1);
            numberingCache1.Append(pointCount2);
            numberingCache1.Append(numericPoint1);
            numberingCache1.Append(numericPoint2);
            numberingCache1.Append(numericPoint3);
            numberingCache1.Append(numericPoint4);
            numberingCache1.Append(numericPoint5);
            numberingCache1.Append(numericPoint6);
            numberingCache1.Append(numericPoint7);
            numberingCache1.Append(numericPoint8);
            numberingCache1.Append(numericPoint9);
            numberingCache1.Append(numericPoint10);
            numberingCache1.Append(numericPoint11);
            numberingCache1.Append(numericPoint12);
            numberingCache1.Append(numericPoint13);
            numberingCache1.Append(numericPoint14);
            numberingCache1.Append(numericPoint15);
            numberingCache1.Append(numericPoint16);
            numberingCache1.Append(numericPoint17);
            numberingCache1.Append(numericPoint18);

            numberReference1.Append(formula2);
            numberReference1.Append(numberingCache1);

            values1.Append(numberReference1);
            C.Smooth smooth1 = new C.Smooth() { Val = false };

            C.LineSerExtensionList lineSerExtensionList1 = new C.LineSerExtensionList();

            C.LineSerExtension lineSerExtension1 = new C.LineSerExtension() { Uri = "{C3380CC4-5D6E-409C-BE32-E72D297353CC}" };
            lineSerExtension1.AddNamespaceDeclaration("c16", "http://schemas.microsoft.com/office/drawing/2014/chart");

            OpenXmlUnknownElement openXmlUnknownElement2 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<c16:uniqueId val=\"{00000000-41EF-4BE6-930B-1BD1D946748B}\" xmlns:c16=\"http://schemas.microsoft.com/office/drawing/2014/chart\" />");

            lineSerExtension1.Append(openXmlUnknownElement2);

            lineSerExtensionList1.Append(lineSerExtension1);

            lineChartSeries1.Append(index1);
            lineChartSeries1.Append(order1);
            lineChartSeries1.Append(seriesText1);
            lineChartSeries1.Append(categoryAxisData1);
            lineChartSeries1.Append(values1);
            lineChartSeries1.Append(smooth1);
            lineChartSeries1.Append(lineSerExtensionList1);

            C.LineChartSeries lineChartSeries2 = new C.LineChartSeries();
            C.Index index2 = new C.Index() { Val = (UInt32Value)1U };
            C.Order order2 = new C.Order() { Val = (UInt32Value)2U };

            C.SeriesText seriesText2 = new C.SeriesText();
            C.NumericValue numericValue38 = new C.NumericValue();
            numericValue38.Text = "Available hours after MOW  (C)";

            seriesText2.Append(numericValue38);

            C.CategoryAxisData categoryAxisData2 = new C.CategoryAxisData();

            C.StringReference stringReference2 = new C.StringReference();
            C.Formula formula3 = new C.Formula();
            formula3.Text = "CHA1E!$E$9:$V$9";

            C.StringCache stringCache2 = new C.StringCache();
            C.PointCount pointCount3 = new C.PointCount() { Val = (UInt32Value)18U };

            C.StringPoint stringPoint19 = new C.StringPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue39 = new C.NumericValue();
            numericValue39.Text = "2022/10";

            stringPoint19.Append(numericValue39);

            C.StringPoint stringPoint20 = new C.StringPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue40 = new C.NumericValue();
            numericValue40.Text = "2022/11";

            stringPoint20.Append(numericValue40);

            C.StringPoint stringPoint21 = new C.StringPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue41 = new C.NumericValue();
            numericValue41.Text = "2022/12";

            stringPoint21.Append(numericValue41);

            C.StringPoint stringPoint22 = new C.StringPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue42 = new C.NumericValue();
            numericValue42.Text = "2023/01";

            stringPoint22.Append(numericValue42);

            C.StringPoint stringPoint23 = new C.StringPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue43 = new C.NumericValue();
            numericValue43.Text = "2023/02";

            stringPoint23.Append(numericValue43);

            C.StringPoint stringPoint24 = new C.StringPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue44 = new C.NumericValue();
            numericValue44.Text = "2023/03";

            stringPoint24.Append(numericValue44);

            C.StringPoint stringPoint25 = new C.StringPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue45 = new C.NumericValue();
            numericValue45.Text = "2023/04";

            stringPoint25.Append(numericValue45);

            C.StringPoint stringPoint26 = new C.StringPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue46 = new C.NumericValue();
            numericValue46.Text = "2023/05";

            stringPoint26.Append(numericValue46);

            C.StringPoint stringPoint27 = new C.StringPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue47 = new C.NumericValue();
            numericValue47.Text = "2023/06";

            stringPoint27.Append(numericValue47);

            C.StringPoint stringPoint28 = new C.StringPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue48 = new C.NumericValue();
            numericValue48.Text = "2023/07";

            stringPoint28.Append(numericValue48);

            C.StringPoint stringPoint29 = new C.StringPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue49 = new C.NumericValue();
            numericValue49.Text = "2023/08";

            stringPoint29.Append(numericValue49);

            C.StringPoint stringPoint30 = new C.StringPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue50 = new C.NumericValue();
            numericValue50.Text = "2023/09";

            stringPoint30.Append(numericValue50);

            C.StringPoint stringPoint31 = new C.StringPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue51 = new C.NumericValue();
            numericValue51.Text = "2023/10";

            stringPoint31.Append(numericValue51);

            C.StringPoint stringPoint32 = new C.StringPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue52 = new C.NumericValue();
            numericValue52.Text = "2023/11";

            stringPoint32.Append(numericValue52);

            C.StringPoint stringPoint33 = new C.StringPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue53 = new C.NumericValue();
            numericValue53.Text = "2023/12";

            stringPoint33.Append(numericValue53);

            C.StringPoint stringPoint34 = new C.StringPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue54 = new C.NumericValue();
            numericValue54.Text = "2024/01";

            stringPoint34.Append(numericValue54);

            C.StringPoint stringPoint35 = new C.StringPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue55 = new C.NumericValue();
            numericValue55.Text = "2024/02";

            stringPoint35.Append(numericValue55);

            C.StringPoint stringPoint36 = new C.StringPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue56 = new C.NumericValue();
            numericValue56.Text = "2024/03";

            stringPoint36.Append(numericValue56);

            stringCache2.Append(pointCount3);
            stringCache2.Append(stringPoint19);
            stringCache2.Append(stringPoint20);
            stringCache2.Append(stringPoint21);
            stringCache2.Append(stringPoint22);
            stringCache2.Append(stringPoint23);
            stringCache2.Append(stringPoint24);
            stringCache2.Append(stringPoint25);
            stringCache2.Append(stringPoint26);
            stringCache2.Append(stringPoint27);
            stringCache2.Append(stringPoint28);
            stringCache2.Append(stringPoint29);
            stringCache2.Append(stringPoint30);
            stringCache2.Append(stringPoint31);
            stringCache2.Append(stringPoint32);
            stringCache2.Append(stringPoint33);
            stringCache2.Append(stringPoint34);
            stringCache2.Append(stringPoint35);
            stringCache2.Append(stringPoint36);

            stringReference2.Append(formula3);
            stringReference2.Append(stringCache2);

            categoryAxisData2.Append(stringReference2);

            C.Values values2 = new C.Values();

            C.NumberReference numberReference2 = new C.NumberReference();
            C.Formula formula4 = new C.Formula();
            formula4.Text = "CHA1E!$E$105:$V$105";

            C.NumberingCache numberingCache2 = new C.NumberingCache();
            C.FormatCode formatCode2 = new C.FormatCode();
            formatCode2.Text = "#,##0.0";
            C.PointCount pointCount4 = new C.PointCount() { Val = (UInt32Value)18U };

            C.NumericPoint numericPoint19 = new C.NumericPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue57 = new C.NumericValue();
            numericValue57.Text = "68608";

            numericPoint19.Append(numericValue57);

            C.NumericPoint numericPoint20 = new C.NumericPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue58 = new C.NumericValue();
            numericValue58.Text = "87040";

            numericPoint20.Append(numericValue58);

            C.NumericPoint numericPoint21 = new C.NumericPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue59 = new C.NumericValue();
            numericValue59.Text = "87360";

            numericPoint21.Append(numericValue59);

            C.NumericPoint numericPoint22 = new C.NumericPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue60 = new C.NumericValue();
            numericValue60.Text = "82992";

            numericPoint22.Append(numericValue60);

            C.NumericPoint numericPoint23 = new C.NumericPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue61 = new C.NumericValue();
            numericValue61.Text = "82992";

            numericPoint23.Append(numericValue61);

            C.NumericPoint numericPoint24 = new C.NumericPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue62 = new C.NumericValue();
            numericValue62.Text = "82992";

            numericPoint24.Append(numericValue62);

            C.NumericPoint numericPoint25 = new C.NumericPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue63 = new C.NumericValue();
            numericValue63.Text = "82992";

            numericPoint25.Append(numericValue63);

            C.NumericPoint numericPoint26 = new C.NumericPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue64 = new C.NumericValue();
            numericValue64.Text = "82992";

            numericPoint26.Append(numericValue64);

            C.NumericPoint numericPoint27 = new C.NumericPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue65 = new C.NumericValue();
            numericValue65.Text = "82992";

            numericPoint27.Append(numericValue65);

            C.NumericPoint numericPoint28 = new C.NumericPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue66 = new C.NumericValue();
            numericValue66.Text = "82992";

            numericPoint28.Append(numericValue66);

            C.NumericPoint numericPoint29 = new C.NumericPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue67 = new C.NumericValue();
            numericValue67.Text = "82992";

            numericPoint29.Append(numericValue67);

            C.NumericPoint numericPoint30 = new C.NumericPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue68 = new C.NumericValue();
            numericValue68.Text = "82992";

            numericPoint30.Append(numericValue68);

            C.NumericPoint numericPoint31 = new C.NumericPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue69 = new C.NumericValue();
            numericValue69.Text = "82992";

            numericPoint31.Append(numericValue69);

            C.NumericPoint numericPoint32 = new C.NumericPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue70 = new C.NumericValue();
            numericValue70.Text = "79192";

            numericPoint32.Append(numericValue70);

            C.NumericPoint numericPoint33 = new C.NumericPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue71 = new C.NumericValue();
            numericValue71.Text = "71592";

            numericPoint33.Append(numericValue71);

            C.NumericPoint numericPoint34 = new C.NumericPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue72 = new C.NumericValue();
            numericValue72.Text = "71592";

            numericPoint34.Append(numericValue72);

            C.NumericPoint numericPoint35 = new C.NumericPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue73 = new C.NumericValue();
            numericValue73.Text = "71592";

            numericPoint35.Append(numericValue73);

            C.NumericPoint numericPoint36 = new C.NumericPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue74 = new C.NumericValue();
            numericValue74.Text = "74632";

            numericPoint36.Append(numericValue74);

            numberingCache2.Append(formatCode2);
            numberingCache2.Append(pointCount4);
            numberingCache2.Append(numericPoint19);
            numberingCache2.Append(numericPoint20);
            numberingCache2.Append(numericPoint21);
            numberingCache2.Append(numericPoint22);
            numberingCache2.Append(numericPoint23);
            numberingCache2.Append(numericPoint24);
            numberingCache2.Append(numericPoint25);
            numberingCache2.Append(numericPoint26);
            numberingCache2.Append(numericPoint27);
            numberingCache2.Append(numericPoint28);
            numberingCache2.Append(numericPoint29);
            numberingCache2.Append(numericPoint30);
            numberingCache2.Append(numericPoint31);
            numberingCache2.Append(numericPoint32);
            numberingCache2.Append(numericPoint33);
            numberingCache2.Append(numericPoint34);
            numberingCache2.Append(numericPoint35);
            numberingCache2.Append(numericPoint36);

            numberReference2.Append(formula4);
            numberReference2.Append(numberingCache2);

            values2.Append(numberReference2);
            C.Smooth smooth2 = new C.Smooth() { Val = false };

            C.LineSerExtensionList lineSerExtensionList2 = new C.LineSerExtensionList();

            C.LineSerExtension lineSerExtension2 = new C.LineSerExtension() { Uri = "{C3380CC4-5D6E-409C-BE32-E72D297353CC}" };
            lineSerExtension2.AddNamespaceDeclaration("c16", "http://schemas.microsoft.com/office/drawing/2014/chart");

            OpenXmlUnknownElement openXmlUnknownElement3 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<c16:uniqueId val=\"{00000001-41EF-4BE6-930B-1BD1D946748B}\" xmlns:c16=\"http://schemas.microsoft.com/office/drawing/2014/chart\" />");

            lineSerExtension2.Append(openXmlUnknownElement3);

            lineSerExtensionList2.Append(lineSerExtension2);

            lineChartSeries2.Append(index2);
            lineChartSeries2.Append(order2);
            lineChartSeries2.Append(seriesText2);
            lineChartSeries2.Append(categoryAxisData2);
            lineChartSeries2.Append(values2);
            lineChartSeries2.Append(smooth2);
            lineChartSeries2.Append(lineSerExtensionList2);

            C.LineChartSeries lineChartSeries3 = new C.LineChartSeries();
            C.Index index3 = new C.Index() { Val = (UInt32Value)2U };
            C.Order order3 = new C.Order() { Val = (UInt32Value)3U };

            C.SeriesText seriesText3 = new C.SeriesText();
            C.NumericValue numericValue75 = new C.NumericValue();
            numericValue75.Text = "Available hours after MOW with Overtime(G) =C+(F*C)";

            seriesText3.Append(numericValue75);

            C.CategoryAxisData categoryAxisData3 = new C.CategoryAxisData();

            C.StringReference stringReference3 = new C.StringReference();
            C.Formula formula5 = new C.Formula();
            formula5.Text = "CHA1E!$E$9:$V$9";

            C.StringCache stringCache3 = new C.StringCache();
            C.PointCount pointCount5 = new C.PointCount() { Val = (UInt32Value)18U };

            C.StringPoint stringPoint37 = new C.StringPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue76 = new C.NumericValue();
            numericValue76.Text = "2022/10";

            stringPoint37.Append(numericValue76);

            C.StringPoint stringPoint38 = new C.StringPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue77 = new C.NumericValue();
            numericValue77.Text = "2022/11";

            stringPoint38.Append(numericValue77);

            C.StringPoint stringPoint39 = new C.StringPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue78 = new C.NumericValue();
            numericValue78.Text = "2022/12";

            stringPoint39.Append(numericValue78);

            C.StringPoint stringPoint40 = new C.StringPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue79 = new C.NumericValue();
            numericValue79.Text = "2023/01";

            stringPoint40.Append(numericValue79);

            C.StringPoint stringPoint41 = new C.StringPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue80 = new C.NumericValue();
            numericValue80.Text = "2023/02";

            stringPoint41.Append(numericValue80);

            C.StringPoint stringPoint42 = new C.StringPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue81 = new C.NumericValue();
            numericValue81.Text = "2023/03";

            stringPoint42.Append(numericValue81);

            C.StringPoint stringPoint43 = new C.StringPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue82 = new C.NumericValue();
            numericValue82.Text = "2023/04";

            stringPoint43.Append(numericValue82);

            C.StringPoint stringPoint44 = new C.StringPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue83 = new C.NumericValue();
            numericValue83.Text = "2023/05";

            stringPoint44.Append(numericValue83);

            C.StringPoint stringPoint45 = new C.StringPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue84 = new C.NumericValue();
            numericValue84.Text = "2023/06";

            stringPoint45.Append(numericValue84);

            C.StringPoint stringPoint46 = new C.StringPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue85 = new C.NumericValue();
            numericValue85.Text = "2023/07";

            stringPoint46.Append(numericValue85);

            C.StringPoint stringPoint47 = new C.StringPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue86 = new C.NumericValue();
            numericValue86.Text = "2023/08";

            stringPoint47.Append(numericValue86);

            C.StringPoint stringPoint48 = new C.StringPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue87 = new C.NumericValue();
            numericValue87.Text = "2023/09";

            stringPoint48.Append(numericValue87);

            C.StringPoint stringPoint49 = new C.StringPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue88 = new C.NumericValue();
            numericValue88.Text = "2023/10";

            stringPoint49.Append(numericValue88);

            C.StringPoint stringPoint50 = new C.StringPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue89 = new C.NumericValue();
            numericValue89.Text = "2023/11";

            stringPoint50.Append(numericValue89);

            C.StringPoint stringPoint51 = new C.StringPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue90 = new C.NumericValue();
            numericValue90.Text = "2023/12";

            stringPoint51.Append(numericValue90);

            C.StringPoint stringPoint52 = new C.StringPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue91 = new C.NumericValue();
            numericValue91.Text = "2024/01";

            stringPoint52.Append(numericValue91);

            C.StringPoint stringPoint53 = new C.StringPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue92 = new C.NumericValue();
            numericValue92.Text = "2024/02";

            stringPoint53.Append(numericValue92);

            C.StringPoint stringPoint54 = new C.StringPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue93 = new C.NumericValue();
            numericValue93.Text = "2024/03";

            stringPoint54.Append(numericValue93);

            stringCache3.Append(pointCount5);
            stringCache3.Append(stringPoint37);
            stringCache3.Append(stringPoint38);
            stringCache3.Append(stringPoint39);
            stringCache3.Append(stringPoint40);
            stringCache3.Append(stringPoint41);
            stringCache3.Append(stringPoint42);
            stringCache3.Append(stringPoint43);
            stringCache3.Append(stringPoint44);
            stringCache3.Append(stringPoint45);
            stringCache3.Append(stringPoint46);
            stringCache3.Append(stringPoint47);
            stringCache3.Append(stringPoint48);
            stringCache3.Append(stringPoint49);
            stringCache3.Append(stringPoint50);
            stringCache3.Append(stringPoint51);
            stringCache3.Append(stringPoint52);
            stringCache3.Append(stringPoint53);
            stringCache3.Append(stringPoint54);

            stringReference3.Append(formula5);
            stringReference3.Append(stringCache3);

            categoryAxisData3.Append(stringReference3);

            C.Values values3 = new C.Values();

            C.NumberReference numberReference3 = new C.NumberReference();
            C.Formula formula6 = new C.Formula();
            formula6.Text = "CHA1E!$E$106:$V$106";

            C.NumberingCache numberingCache3 = new C.NumberingCache();
            C.FormatCode formatCode3 = new C.FormatCode();
            formatCode3.Text = "#,##0.0";
            C.PointCount pointCount6 = new C.PointCount() { Val = (UInt32Value)18U };

            C.NumericPoint numericPoint37 = new C.NumericPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue94 = new C.NumericValue();
            numericValue94.Text = "68608";

            numericPoint37.Append(numericValue94);

            C.NumericPoint numericPoint38 = new C.NumericPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue95 = new C.NumericValue();
            numericValue95.Text = "87040";

            numericPoint38.Append(numericValue95);

            C.NumericPoint numericPoint39 = new C.NumericPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue96 = new C.NumericValue();
            numericValue96.Text = "87360";

            numericPoint39.Append(numericValue96);

            C.NumericPoint numericPoint40 = new C.NumericPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue97 = new C.NumericValue();
            numericValue97.Text = "82992";

            numericPoint40.Append(numericValue97);

            C.NumericPoint numericPoint41 = new C.NumericPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue98 = new C.NumericValue();
            numericValue98.Text = "82992";

            numericPoint41.Append(numericValue98);

            C.NumericPoint numericPoint42 = new C.NumericPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue99 = new C.NumericValue();
            numericValue99.Text = "82992";

            numericPoint42.Append(numericValue99);

            C.NumericPoint numericPoint43 = new C.NumericPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue100 = new C.NumericValue();
            numericValue100.Text = "82992";

            numericPoint43.Append(numericValue100);

            C.NumericPoint numericPoint44 = new C.NumericPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue101 = new C.NumericValue();
            numericValue101.Text = "82992";

            numericPoint44.Append(numericValue101);

            C.NumericPoint numericPoint45 = new C.NumericPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue102 = new C.NumericValue();
            numericValue102.Text = "82992";

            numericPoint45.Append(numericValue102);

            C.NumericPoint numericPoint46 = new C.NumericPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue103 = new C.NumericValue();
            numericValue103.Text = "82992";

            numericPoint46.Append(numericValue103);

            C.NumericPoint numericPoint47 = new C.NumericPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue104 = new C.NumericValue();
            numericValue104.Text = "82992";

            numericPoint47.Append(numericValue104);

            C.NumericPoint numericPoint48 = new C.NumericPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue105 = new C.NumericValue();
            numericValue105.Text = "82992";

            numericPoint48.Append(numericValue105);

            C.NumericPoint numericPoint49 = new C.NumericPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue106 = new C.NumericValue();
            numericValue106.Text = "82992";

            numericPoint49.Append(numericValue106);

            C.NumericPoint numericPoint50 = new C.NumericPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue107 = new C.NumericValue();
            numericValue107.Text = "79192";

            numericPoint50.Append(numericValue107);

            C.NumericPoint numericPoint51 = new C.NumericPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue108 = new C.NumericValue();
            numericValue108.Text = "71592";

            numericPoint51.Append(numericValue108);

            C.NumericPoint numericPoint52 = new C.NumericPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue109 = new C.NumericValue();
            numericValue109.Text = "71592";

            numericPoint52.Append(numericValue109);

            C.NumericPoint numericPoint53 = new C.NumericPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue110 = new C.NumericValue();
            numericValue110.Text = "71592";

            numericPoint53.Append(numericValue110);

            C.NumericPoint numericPoint54 = new C.NumericPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue111 = new C.NumericValue();
            numericValue111.Text = "74632";

            numericPoint54.Append(numericValue111);

            numberingCache3.Append(formatCode3);
            numberingCache3.Append(pointCount6);
            numberingCache3.Append(numericPoint37);
            numberingCache3.Append(numericPoint38);
            numberingCache3.Append(numericPoint39);
            numberingCache3.Append(numericPoint40);
            numberingCache3.Append(numericPoint41);
            numberingCache3.Append(numericPoint42);
            numberingCache3.Append(numericPoint43);
            numberingCache3.Append(numericPoint44);
            numberingCache3.Append(numericPoint45);
            numberingCache3.Append(numericPoint46);
            numberingCache3.Append(numericPoint47);
            numberingCache3.Append(numericPoint48);
            numberingCache3.Append(numericPoint49);
            numberingCache3.Append(numericPoint50);
            numberingCache3.Append(numericPoint51);
            numberingCache3.Append(numericPoint52);
            numberingCache3.Append(numericPoint53);
            numberingCache3.Append(numericPoint54);

            numberReference3.Append(formula6);
            numberReference3.Append(numberingCache3);

            values3.Append(numberReference3);
            C.Smooth smooth3 = new C.Smooth() { Val = false };

            C.LineSerExtensionList lineSerExtensionList3 = new C.LineSerExtensionList();

            C.LineSerExtension lineSerExtension3 = new C.LineSerExtension() { Uri = "{C3380CC4-5D6E-409C-BE32-E72D297353CC}" };
            lineSerExtension3.AddNamespaceDeclaration("c16", "http://schemas.microsoft.com/office/drawing/2014/chart");

            OpenXmlUnknownElement openXmlUnknownElement4 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<c16:uniqueId val=\"{00000002-41EF-4BE6-930B-1BD1D946748B}\" xmlns:c16=\"http://schemas.microsoft.com/office/drawing/2014/chart\" />");

            lineSerExtension3.Append(openXmlUnknownElement4);

            lineSerExtensionList3.Append(lineSerExtension3);

            lineChartSeries3.Append(index3);
            lineChartSeries3.Append(order3);
            lineChartSeries3.Append(seriesText3);
            lineChartSeries3.Append(categoryAxisData3);
            lineChartSeries3.Append(values3);
            lineChartSeries3.Append(smooth3);
            lineChartSeries3.Append(lineSerExtensionList3);

            C.LineChartSeries lineChartSeries4 = new C.LineChartSeries();
            C.Index index4 = new C.Index() { Val = (UInt32Value)3U };
            C.Order order4 = new C.Order() { Val = (UInt32Value)4U };

            C.SeriesText seriesText4 = new C.SeriesText();
            C.NumericValue numericValue112 = new C.NumericValue();
            numericValue112.Text = "Committed hours (D)";

            seriesText4.Append(numericValue112);

            C.CategoryAxisData categoryAxisData4 = new C.CategoryAxisData();

            C.StringReference stringReference4 = new C.StringReference();
            C.Formula formula7 = new C.Formula();
            formula7.Text = "CHA1E!$E$9:$V$9";

            C.StringCache stringCache4 = new C.StringCache();
            C.PointCount pointCount7 = new C.PointCount() { Val = (UInt32Value)18U };

            C.StringPoint stringPoint55 = new C.StringPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue113 = new C.NumericValue();
            numericValue113.Text = "2022/10";

            stringPoint55.Append(numericValue113);

            C.StringPoint stringPoint56 = new C.StringPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue114 = new C.NumericValue();
            numericValue114.Text = "2022/11";

            stringPoint56.Append(numericValue114);

            C.StringPoint stringPoint57 = new C.StringPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue115 = new C.NumericValue();
            numericValue115.Text = "2022/12";

            stringPoint57.Append(numericValue115);

            C.StringPoint stringPoint58 = new C.StringPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue116 = new C.NumericValue();
            numericValue116.Text = "2023/01";

            stringPoint58.Append(numericValue116);

            C.StringPoint stringPoint59 = new C.StringPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue117 = new C.NumericValue();
            numericValue117.Text = "2023/02";

            stringPoint59.Append(numericValue117);

            C.StringPoint stringPoint60 = new C.StringPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue118 = new C.NumericValue();
            numericValue118.Text = "2023/03";

            stringPoint60.Append(numericValue118);

            C.StringPoint stringPoint61 = new C.StringPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue119 = new C.NumericValue();
            numericValue119.Text = "2023/04";

            stringPoint61.Append(numericValue119);

            C.StringPoint stringPoint62 = new C.StringPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue120 = new C.NumericValue();
            numericValue120.Text = "2023/05";

            stringPoint62.Append(numericValue120);

            C.StringPoint stringPoint63 = new C.StringPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue121 = new C.NumericValue();
            numericValue121.Text = "2023/06";

            stringPoint63.Append(numericValue121);

            C.StringPoint stringPoint64 = new C.StringPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue122 = new C.NumericValue();
            numericValue122.Text = "2023/07";

            stringPoint64.Append(numericValue122);

            C.StringPoint stringPoint65 = new C.StringPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue123 = new C.NumericValue();
            numericValue123.Text = "2023/08";

            stringPoint65.Append(numericValue123);

            C.StringPoint stringPoint66 = new C.StringPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue124 = new C.NumericValue();
            numericValue124.Text = "2023/09";

            stringPoint66.Append(numericValue124);

            C.StringPoint stringPoint67 = new C.StringPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue125 = new C.NumericValue();
            numericValue125.Text = "2023/10";

            stringPoint67.Append(numericValue125);

            C.StringPoint stringPoint68 = new C.StringPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue126 = new C.NumericValue();
            numericValue126.Text = "2023/11";

            stringPoint68.Append(numericValue126);

            C.StringPoint stringPoint69 = new C.StringPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue127 = new C.NumericValue();
            numericValue127.Text = "2023/12";

            stringPoint69.Append(numericValue127);

            C.StringPoint stringPoint70 = new C.StringPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue128 = new C.NumericValue();
            numericValue128.Text = "2024/01";

            stringPoint70.Append(numericValue128);

            C.StringPoint stringPoint71 = new C.StringPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue129 = new C.NumericValue();
            numericValue129.Text = "2024/02";

            stringPoint71.Append(numericValue129);

            C.StringPoint stringPoint72 = new C.StringPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue130 = new C.NumericValue();
            numericValue130.Text = "2024/03";

            stringPoint72.Append(numericValue130);

            stringCache4.Append(pointCount7);
            stringCache4.Append(stringPoint55);
            stringCache4.Append(stringPoint56);
            stringCache4.Append(stringPoint57);
            stringCache4.Append(stringPoint58);
            stringCache4.Append(stringPoint59);
            stringCache4.Append(stringPoint60);
            stringCache4.Append(stringPoint61);
            stringCache4.Append(stringPoint62);
            stringCache4.Append(stringPoint63);
            stringCache4.Append(stringPoint64);
            stringCache4.Append(stringPoint65);
            stringCache4.Append(stringPoint66);
            stringCache4.Append(stringPoint67);
            stringCache4.Append(stringPoint68);
            stringCache4.Append(stringPoint69);
            stringCache4.Append(stringPoint70);
            stringCache4.Append(stringPoint71);
            stringCache4.Append(stringPoint72);

            stringReference4.Append(formula7);
            stringReference4.Append(stringCache4);

            categoryAxisData4.Append(stringReference4);

            C.Values values4 = new C.Values();

            C.NumberReference numberReference4 = new C.NumberReference();
            C.Formula formula8 = new C.Formula();
            formula8.Text = "CHA1E!$E$107:$V$107";

            C.NumberingCache numberingCache4 = new C.NumberingCache();
            C.FormatCode formatCode4 = new C.FormatCode();
            formatCode4.Text = "#,##0.0";
            C.PointCount pointCount8 = new C.PointCount() { Val = (UInt32Value)18U };

            C.NumericPoint numericPoint55 = new C.NumericPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue131 = new C.NumericValue();
            numericValue131.Text = "89755";

            numericPoint55.Append(numericValue131);

            C.NumericPoint numericPoint56 = new C.NumericPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue132 = new C.NumericValue();
            numericValue132.Text = "100082";

            numericPoint56.Append(numericValue132);

            C.NumericPoint numericPoint57 = new C.NumericPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue133 = new C.NumericValue();
            numericValue133.Text = "93296";

            numericPoint57.Append(numericValue133);

            C.NumericPoint numericPoint58 = new C.NumericPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue134 = new C.NumericValue();
            numericValue134.Text = "81188";

            numericPoint58.Append(numericValue134);

            C.NumericPoint numericPoint59 = new C.NumericPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue135 = new C.NumericValue();
            numericValue135.Text = "64789";

            numericPoint59.Append(numericValue135);

            C.NumericPoint numericPoint60 = new C.NumericPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue136 = new C.NumericValue();
            numericValue136.Text = "60153";

            numericPoint60.Append(numericValue136);

            C.NumericPoint numericPoint61 = new C.NumericPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue137 = new C.NumericValue();
            numericValue137.Text = "55570";

            numericPoint61.Append(numericValue137);

            C.NumericPoint numericPoint62 = new C.NumericPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue138 = new C.NumericValue();
            numericValue138.Text = "54474";

            numericPoint62.Append(numericValue138);

            C.NumericPoint numericPoint63 = new C.NumericPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue139 = new C.NumericValue();
            numericValue139.Text = "50850";

            numericPoint63.Append(numericValue139);

            C.NumericPoint numericPoint64 = new C.NumericPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue140 = new C.NumericValue();
            numericValue140.Text = "43004";

            numericPoint64.Append(numericValue140);

            C.NumericPoint numericPoint65 = new C.NumericPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue141 = new C.NumericValue();
            numericValue141.Text = "36640";

            numericPoint65.Append(numericValue141);

            C.NumericPoint numericPoint66 = new C.NumericPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue142 = new C.NumericValue();
            numericValue142.Text = "28988";

            numericPoint66.Append(numericValue142);

            C.NumericPoint numericPoint67 = new C.NumericPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue143 = new C.NumericValue();
            numericValue143.Text = "19621";

            numericPoint67.Append(numericValue143);

            C.NumericPoint numericPoint68 = new C.NumericPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue144 = new C.NumericValue();
            numericValue144.Text = "12400";

            numericPoint68.Append(numericValue144);

            C.NumericPoint numericPoint69 = new C.NumericPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue145 = new C.NumericValue();
            numericValue145.Text = "5790";

            numericPoint69.Append(numericValue145);

            C.NumericPoint numericPoint70 = new C.NumericPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue146 = new C.NumericValue();
            numericValue146.Text = "820";

            numericPoint70.Append(numericValue146);

            C.NumericPoint numericPoint71 = new C.NumericPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue147 = new C.NumericValue();
            numericValue147.Text = "820";

            numericPoint71.Append(numericValue147);

            C.NumericPoint numericPoint72 = new C.NumericPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue148 = new C.NumericValue();
            numericValue148.Text = "563";

            numericPoint72.Append(numericValue148);

            numberingCache4.Append(formatCode4);
            numberingCache4.Append(pointCount8);
            numberingCache4.Append(numericPoint55);
            numberingCache4.Append(numericPoint56);
            numberingCache4.Append(numericPoint57);
            numberingCache4.Append(numericPoint58);
            numberingCache4.Append(numericPoint59);
            numberingCache4.Append(numericPoint60);
            numberingCache4.Append(numericPoint61);
            numberingCache4.Append(numericPoint62);
            numberingCache4.Append(numericPoint63);
            numberingCache4.Append(numericPoint64);
            numberingCache4.Append(numericPoint65);
            numberingCache4.Append(numericPoint66);
            numberingCache4.Append(numericPoint67);
            numberingCache4.Append(numericPoint68);
            numberingCache4.Append(numericPoint69);
            numberingCache4.Append(numericPoint70);
            numberingCache4.Append(numericPoint71);
            numberingCache4.Append(numericPoint72);

            numberReference4.Append(formula8);
            numberReference4.Append(numberingCache4);

            values4.Append(numberReference4);
            C.Smooth smooth4 = new C.Smooth() { Val = false };

            C.LineSerExtensionList lineSerExtensionList4 = new C.LineSerExtensionList();

            C.LineSerExtension lineSerExtension4 = new C.LineSerExtension() { Uri = "{C3380CC4-5D6E-409C-BE32-E72D297353CC}" };
            lineSerExtension4.AddNamespaceDeclaration("c16", "http://schemas.microsoft.com/office/drawing/2014/chart");

            OpenXmlUnknownElement openXmlUnknownElement5 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<c16:uniqueId val=\"{00000003-41EF-4BE6-930B-1BD1D946748B}\" xmlns:c16=\"http://schemas.microsoft.com/office/drawing/2014/chart\" />");

            lineSerExtension4.Append(openXmlUnknownElement5);

            lineSerExtensionList4.Append(lineSerExtension4);

            lineChartSeries4.Append(index4);
            lineChartSeries4.Append(order4);
            lineChartSeries4.Append(seriesText4);
            lineChartSeries4.Append(categoryAxisData4);
            lineChartSeries4.Append(values4);
            lineChartSeries4.Append(smooth4);
            lineChartSeries4.Append(lineSerExtensionList4);

            C.LineChartSeries lineChartSeries5 = new C.LineChartSeries();
            C.Index index5 = new C.Index() { Val = (UInt32Value)4U };
            C.Order order5 = new C.Order() { Val = (UInt32Value)5U };

            C.SeriesText seriesText5 = new C.SeriesText();
            C.NumericValue numericValue149 = new C.NumericValue();
            numericValue149.Text = "Committed hours with Expected Projects (H) = D+E ";

            seriesText5.Append(numericValue149);

            C.CategoryAxisData categoryAxisData5 = new C.CategoryAxisData();

            C.StringReference stringReference5 = new C.StringReference();
            C.Formula formula9 = new C.Formula();
            formula9.Text = "CHA1E!$E$9:$V$9";

            C.StringCache stringCache5 = new C.StringCache();
            C.PointCount pointCount9 = new C.PointCount() { Val = (UInt32Value)18U };

            C.StringPoint stringPoint73 = new C.StringPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue150 = new C.NumericValue();
            numericValue150.Text = "2022/10";

            stringPoint73.Append(numericValue150);

            C.StringPoint stringPoint74 = new C.StringPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue151 = new C.NumericValue();
            numericValue151.Text = "2022/11";

            stringPoint74.Append(numericValue151);

            C.StringPoint stringPoint75 = new C.StringPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue152 = new C.NumericValue();
            numericValue152.Text = "2022/12";

            stringPoint75.Append(numericValue152);

            C.StringPoint stringPoint76 = new C.StringPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue153 = new C.NumericValue();
            numericValue153.Text = "2023/01";

            stringPoint76.Append(numericValue153);

            C.StringPoint stringPoint77 = new C.StringPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue154 = new C.NumericValue();
            numericValue154.Text = "2023/02";

            stringPoint77.Append(numericValue154);

            C.StringPoint stringPoint78 = new C.StringPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue155 = new C.NumericValue();
            numericValue155.Text = "2023/03";

            stringPoint78.Append(numericValue155);

            C.StringPoint stringPoint79 = new C.StringPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue156 = new C.NumericValue();
            numericValue156.Text = "2023/04";

            stringPoint79.Append(numericValue156);

            C.StringPoint stringPoint80 = new C.StringPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue157 = new C.NumericValue();
            numericValue157.Text = "2023/05";

            stringPoint80.Append(numericValue157);

            C.StringPoint stringPoint81 = new C.StringPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue158 = new C.NumericValue();
            numericValue158.Text = "2023/06";

            stringPoint81.Append(numericValue158);

            C.StringPoint stringPoint82 = new C.StringPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue159 = new C.NumericValue();
            numericValue159.Text = "2023/07";

            stringPoint82.Append(numericValue159);

            C.StringPoint stringPoint83 = new C.StringPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue160 = new C.NumericValue();
            numericValue160.Text = "2023/08";

            stringPoint83.Append(numericValue160);

            C.StringPoint stringPoint84 = new C.StringPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue161 = new C.NumericValue();
            numericValue161.Text = "2023/09";

            stringPoint84.Append(numericValue161);

            C.StringPoint stringPoint85 = new C.StringPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue162 = new C.NumericValue();
            numericValue162.Text = "2023/10";

            stringPoint85.Append(numericValue162);

            C.StringPoint stringPoint86 = new C.StringPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue163 = new C.NumericValue();
            numericValue163.Text = "2023/11";

            stringPoint86.Append(numericValue163);

            C.StringPoint stringPoint87 = new C.StringPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue164 = new C.NumericValue();
            numericValue164.Text = "2023/12";

            stringPoint87.Append(numericValue164);

            C.StringPoint stringPoint88 = new C.StringPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue165 = new C.NumericValue();
            numericValue165.Text = "2024/01";

            stringPoint88.Append(numericValue165);

            C.StringPoint stringPoint89 = new C.StringPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue166 = new C.NumericValue();
            numericValue166.Text = "2024/02";

            stringPoint89.Append(numericValue166);

            C.StringPoint stringPoint90 = new C.StringPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue167 = new C.NumericValue();
            numericValue167.Text = "2024/03";

            stringPoint90.Append(numericValue167);

            stringCache5.Append(pointCount9);
            stringCache5.Append(stringPoint73);
            stringCache5.Append(stringPoint74);
            stringCache5.Append(stringPoint75);
            stringCache5.Append(stringPoint76);
            stringCache5.Append(stringPoint77);
            stringCache5.Append(stringPoint78);
            stringCache5.Append(stringPoint79);
            stringCache5.Append(stringPoint80);
            stringCache5.Append(stringPoint81);
            stringCache5.Append(stringPoint82);
            stringCache5.Append(stringPoint83);
            stringCache5.Append(stringPoint84);
            stringCache5.Append(stringPoint85);
            stringCache5.Append(stringPoint86);
            stringCache5.Append(stringPoint87);
            stringCache5.Append(stringPoint88);
            stringCache5.Append(stringPoint89);
            stringCache5.Append(stringPoint90);

            stringReference5.Append(formula9);
            stringReference5.Append(stringCache5);

            categoryAxisData5.Append(stringReference5);

            C.Values values5 = new C.Values();

            C.NumberReference numberReference5 = new C.NumberReference();
            C.Formula formula10 = new C.Formula();
            formula10.Text = "CHA1E!$E$108:$V$108";

            C.NumberingCache numberingCache5 = new C.NumberingCache();
            C.FormatCode formatCode5 = new C.FormatCode();
            formatCode5.Text = "#,##0.0";
            C.PointCount pointCount10 = new C.PointCount() { Val = (UInt32Value)18U };

            C.NumericPoint numericPoint73 = new C.NumericPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue168 = new C.NumericValue();
            numericValue168.Text = "92744";

            numericPoint73.Append(numericValue168);

            C.NumericPoint numericPoint74 = new C.NumericPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue169 = new C.NumericValue();
            numericValue169.Text = "110334";

            numericPoint74.Append(numericValue169);

            C.NumericPoint numericPoint75 = new C.NumericPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue170 = new C.NumericValue();
            numericValue170.Text = "123531";

            numericPoint75.Append(numericValue170);

            C.NumericPoint numericPoint76 = new C.NumericPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue171 = new C.NumericValue();
            numericValue171.Text = "120458";

            numericPoint76.Append(numericValue171);

            C.NumericPoint numericPoint77 = new C.NumericPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue172 = new C.NumericValue();
            numericValue172.Text = "114330";

            numericPoint77.Append(numericValue172);

            C.NumericPoint numericPoint78 = new C.NumericPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue173 = new C.NumericValue();
            numericValue173.Text = "123650";

            numericPoint78.Append(numericValue173);

            C.NumericPoint numericPoint79 = new C.NumericPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue174 = new C.NumericValue();
            numericValue174.Text = "127943";

            numericPoint79.Append(numericValue174);

            C.NumericPoint numericPoint80 = new C.NumericPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue175 = new C.NumericValue();
            numericValue175.Text = "129550";

            numericPoint80.Append(numericValue175);

            C.NumericPoint numericPoint81 = new C.NumericPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue176 = new C.NumericValue();
            numericValue176.Text = "117516";

            numericPoint81.Append(numericValue176);

            C.NumericPoint numericPoint82 = new C.NumericPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue177 = new C.NumericValue();
            numericValue177.Text = "112226";

            numericPoint82.Append(numericValue177);

            C.NumericPoint numericPoint83 = new C.NumericPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue178 = new C.NumericValue();
            numericValue178.Text = "106422";

            numericPoint83.Append(numericValue178);

            C.NumericPoint numericPoint84 = new C.NumericPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue179 = new C.NumericValue();
            numericValue179.Text = "95680";

            numericPoint84.Append(numericValue179);

            C.NumericPoint numericPoint85 = new C.NumericPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue180 = new C.NumericValue();
            numericValue180.Text = "87603";

            numericPoint85.Append(numericValue180);

            C.NumericPoint numericPoint86 = new C.NumericPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue181 = new C.NumericValue();
            numericValue181.Text = "83803";

            numericPoint86.Append(numericValue181);

            C.NumericPoint numericPoint87 = new C.NumericPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue182 = new C.NumericValue();
            numericValue182.Text = "82533";

            numericPoint87.Append(numericValue182);

            C.NumericPoint numericPoint88 = new C.NumericPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue183 = new C.NumericValue();
            numericValue183.Text = "70311";

            numericPoint88.Append(numericValue183);

            C.NumericPoint numericPoint89 = new C.NumericPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue184 = new C.NumericValue();
            numericValue184.Text = "66751";

            numericPoint89.Append(numericValue184);

            C.NumericPoint numericPoint90 = new C.NumericPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue185 = new C.NumericValue();
            numericValue185.Text = "59028";

            numericPoint90.Append(numericValue185);

            numberingCache5.Append(formatCode5);
            numberingCache5.Append(pointCount10);
            numberingCache5.Append(numericPoint73);
            numberingCache5.Append(numericPoint74);
            numberingCache5.Append(numericPoint75);
            numberingCache5.Append(numericPoint76);
            numberingCache5.Append(numericPoint77);
            numberingCache5.Append(numericPoint78);
            numberingCache5.Append(numericPoint79);
            numberingCache5.Append(numericPoint80);
            numberingCache5.Append(numericPoint81);
            numberingCache5.Append(numericPoint82);
            numberingCache5.Append(numericPoint83);
            numberingCache5.Append(numericPoint84);
            numberingCache5.Append(numericPoint85);
            numberingCache5.Append(numericPoint86);
            numberingCache5.Append(numericPoint87);
            numberingCache5.Append(numericPoint88);
            numberingCache5.Append(numericPoint89);
            numberingCache5.Append(numericPoint90);

            numberReference5.Append(formula10);
            numberReference5.Append(numberingCache5);

            values5.Append(numberReference5);
            C.Smooth smooth5 = new C.Smooth() { Val = false };

            C.LineSerExtensionList lineSerExtensionList5 = new C.LineSerExtensionList();

            C.LineSerExtension lineSerExtension5 = new C.LineSerExtension() { Uri = "{C3380CC4-5D6E-409C-BE32-E72D297353CC}" };
            lineSerExtension5.AddNamespaceDeclaration("c16", "http://schemas.microsoft.com/office/drawing/2014/chart");

            OpenXmlUnknownElement openXmlUnknownElement6 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<c16:uniqueId val=\"{00000004-41EF-4BE6-930B-1BD1D946748B}\" xmlns:c16=\"http://schemas.microsoft.com/office/drawing/2014/chart\" />");

            lineSerExtension5.Append(openXmlUnknownElement6);

            lineSerExtensionList5.Append(lineSerExtension5);

            lineChartSeries5.Append(index5);
            lineChartSeries5.Append(order5);
            lineChartSeries5.Append(seriesText5);
            lineChartSeries5.Append(categoryAxisData5);
            lineChartSeries5.Append(values5);
            lineChartSeries5.Append(smooth5);
            lineChartSeries5.Append(lineSerExtensionList5);

            C.LineChartSeries lineChartSeries6 = new C.LineChartSeries();
            C.Index index6 = new C.Index() { Val = (UInt32Value)5U };
            C.Order order6 = new C.Order() { Val = (UInt32Value)6U };

            C.SeriesText seriesText6 = new C.SeriesText();
            C.NumericValue numericValue186 = new C.NumericValue();
            numericValue186.Text = "Committed hours with Expected proj, Active (K) = D+J";

            seriesText6.Append(numericValue186);

            C.CategoryAxisData categoryAxisData6 = new C.CategoryAxisData();

            C.StringReference stringReference6 = new C.StringReference();
            C.Formula formula11 = new C.Formula();
            formula11.Text = "CHA1E!$E$9:$V$9";

            C.StringCache stringCache6 = new C.StringCache();
            C.PointCount pointCount11 = new C.PointCount() { Val = (UInt32Value)18U };

            C.StringPoint stringPoint91 = new C.StringPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue187 = new C.NumericValue();
            numericValue187.Text = "2022/10";

            stringPoint91.Append(numericValue187);

            C.StringPoint stringPoint92 = new C.StringPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue188 = new C.NumericValue();
            numericValue188.Text = "2022/11";

            stringPoint92.Append(numericValue188);

            C.StringPoint stringPoint93 = new C.StringPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue189 = new C.NumericValue();
            numericValue189.Text = "2022/12";

            stringPoint93.Append(numericValue189);

            C.StringPoint stringPoint94 = new C.StringPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue190 = new C.NumericValue();
            numericValue190.Text = "2023/01";

            stringPoint94.Append(numericValue190);

            C.StringPoint stringPoint95 = new C.StringPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue191 = new C.NumericValue();
            numericValue191.Text = "2023/02";

            stringPoint95.Append(numericValue191);

            C.StringPoint stringPoint96 = new C.StringPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue192 = new C.NumericValue();
            numericValue192.Text = "2023/03";

            stringPoint96.Append(numericValue192);

            C.StringPoint stringPoint97 = new C.StringPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue193 = new C.NumericValue();
            numericValue193.Text = "2023/04";

            stringPoint97.Append(numericValue193);

            C.StringPoint stringPoint98 = new C.StringPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue194 = new C.NumericValue();
            numericValue194.Text = "2023/05";

            stringPoint98.Append(numericValue194);

            C.StringPoint stringPoint99 = new C.StringPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue195 = new C.NumericValue();
            numericValue195.Text = "2023/06";

            stringPoint99.Append(numericValue195);

            C.StringPoint stringPoint100 = new C.StringPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue196 = new C.NumericValue();
            numericValue196.Text = "2023/07";

            stringPoint100.Append(numericValue196);

            C.StringPoint stringPoint101 = new C.StringPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue197 = new C.NumericValue();
            numericValue197.Text = "2023/08";

            stringPoint101.Append(numericValue197);

            C.StringPoint stringPoint102 = new C.StringPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue198 = new C.NumericValue();
            numericValue198.Text = "2023/09";

            stringPoint102.Append(numericValue198);

            C.StringPoint stringPoint103 = new C.StringPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue199 = new C.NumericValue();
            numericValue199.Text = "2023/10";

            stringPoint103.Append(numericValue199);

            C.StringPoint stringPoint104 = new C.StringPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue200 = new C.NumericValue();
            numericValue200.Text = "2023/11";

            stringPoint104.Append(numericValue200);

            C.StringPoint stringPoint105 = new C.StringPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue201 = new C.NumericValue();
            numericValue201.Text = "2023/12";

            stringPoint105.Append(numericValue201);

            C.StringPoint stringPoint106 = new C.StringPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue202 = new C.NumericValue();
            numericValue202.Text = "2024/01";

            stringPoint106.Append(numericValue202);

            C.StringPoint stringPoint107 = new C.StringPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue203 = new C.NumericValue();
            numericValue203.Text = "2024/02";

            stringPoint107.Append(numericValue203);

            C.StringPoint stringPoint108 = new C.StringPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue204 = new C.NumericValue();
            numericValue204.Text = "2024/03";

            stringPoint108.Append(numericValue204);

            stringCache6.Append(pointCount11);
            stringCache6.Append(stringPoint91);
            stringCache6.Append(stringPoint92);
            stringCache6.Append(stringPoint93);
            stringCache6.Append(stringPoint94);
            stringCache6.Append(stringPoint95);
            stringCache6.Append(stringPoint96);
            stringCache6.Append(stringPoint97);
            stringCache6.Append(stringPoint98);
            stringCache6.Append(stringPoint99);
            stringCache6.Append(stringPoint100);
            stringCache6.Append(stringPoint101);
            stringCache6.Append(stringPoint102);
            stringCache6.Append(stringPoint103);
            stringCache6.Append(stringPoint104);
            stringCache6.Append(stringPoint105);
            stringCache6.Append(stringPoint106);
            stringCache6.Append(stringPoint107);
            stringCache6.Append(stringPoint108);

            stringReference6.Append(formula11);
            stringReference6.Append(stringCache6);

            categoryAxisData6.Append(stringReference6);

            C.Values values6 = new C.Values();

            C.NumberReference numberReference6 = new C.NumberReference();
            C.Formula formula12 = new C.Formula();
            formula12.Text = "CHA1E!$E$109:$V$109";

            C.NumberingCache numberingCache6 = new C.NumberingCache();
            C.FormatCode formatCode6 = new C.FormatCode();
            formatCode6.Text = "#,##0.0";
            C.PointCount pointCount12 = new C.PointCount() { Val = (UInt32Value)18U };

            C.NumericPoint numericPoint91 = new C.NumericPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue205 = new C.NumericValue();
            numericValue205.Text = "91260";

            numericPoint91.Append(numericValue205);

            C.NumericPoint numericPoint92 = new C.NumericPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue206 = new C.NumericValue();
            numericValue206.Text = "103518";

            numericPoint92.Append(numericValue206);

            C.NumericPoint numericPoint93 = new C.NumericPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue207 = new C.NumericValue();
            numericValue207.Text = "100059";

            numericPoint93.Append(numericValue207);

            C.NumericPoint numericPoint94 = new C.NumericPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue208 = new C.NumericValue();
            numericValue208.Text = "89829";

            numericPoint94.Append(numericValue208);

            C.NumericPoint numericPoint95 = new C.NumericPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue209 = new C.NumericValue();
            numericValue209.Text = "76087";

            numericPoint95.Append(numericValue209);

            C.NumericPoint numericPoint96 = new C.NumericPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue210 = new C.NumericValue();
            numericValue210.Text = "71635";

            numericPoint96.Append(numericValue210);

            C.NumericPoint numericPoint97 = new C.NumericPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue211 = new C.NumericValue();
            numericValue211.Text = "71562";

            numericPoint97.Append(numericValue211);

            C.NumericPoint numericPoint98 = new C.NumericPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue212 = new C.NumericValue();
            numericValue212.Text = "69666";

            numericPoint98.Append(numericValue212);

            C.NumericPoint numericPoint99 = new C.NumericPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue213 = new C.NumericValue();
            numericValue213.Text = "66162";

            numericPoint99.Append(numericValue213);

            C.NumericPoint numericPoint100 = new C.NumericPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue214 = new C.NumericValue();
            numericValue214.Text = "54472";

            numericPoint100.Append(numericValue214);

            C.NumericPoint numericPoint101 = new C.NumericPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue215 = new C.NumericValue();
            numericValue215.Text = "46488";

            numericPoint101.Append(numericValue215);

            C.NumericPoint numericPoint102 = new C.NumericPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue216 = new C.NumericValue();
            numericValue216.Text = "35736";

            numericPoint102.Append(numericValue216);

            C.NumericPoint numericPoint103 = new C.NumericPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue217 = new C.NumericValue();
            numericValue217.Text = "25769";

            numericPoint103.Append(numericValue217);

            C.NumericPoint numericPoint104 = new C.NumericPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue218 = new C.NumericValue();
            numericValue218.Text = "17938";

            numericPoint104.Append(numericValue218);

            C.NumericPoint numericPoint105 = new C.NumericPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue219 = new C.NumericValue();
            numericValue219.Text = "10858";

            numericPoint105.Append(numericValue219);

            C.NumericPoint numericPoint106 = new C.NumericPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue220 = new C.NumericValue();
            numericValue220.Text = "4448";

            numericPoint106.Append(numericValue220);

            C.NumericPoint numericPoint107 = new C.NumericPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue221 = new C.NumericValue();
            numericValue221.Text = "3378";

            numericPoint107.Append(numericValue221);

            C.NumericPoint numericPoint108 = new C.NumericPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue222 = new C.NumericValue();
            numericValue222.Text = "1221";

            numericPoint108.Append(numericValue222);

            numberingCache6.Append(formatCode6);
            numberingCache6.Append(pointCount12);
            numberingCache6.Append(numericPoint91);
            numberingCache6.Append(numericPoint92);
            numberingCache6.Append(numericPoint93);
            numberingCache6.Append(numericPoint94);
            numberingCache6.Append(numericPoint95);
            numberingCache6.Append(numericPoint96);
            numberingCache6.Append(numericPoint97);
            numberingCache6.Append(numericPoint98);
            numberingCache6.Append(numericPoint99);
            numberingCache6.Append(numericPoint100);
            numberingCache6.Append(numericPoint101);
            numberingCache6.Append(numericPoint102);
            numberingCache6.Append(numericPoint103);
            numberingCache6.Append(numericPoint104);
            numberingCache6.Append(numericPoint105);
            numberingCache6.Append(numericPoint106);
            numberingCache6.Append(numericPoint107);
            numberingCache6.Append(numericPoint108);

            numberReference6.Append(formula12);
            numberReference6.Append(numberingCache6);

            values6.Append(numberReference6);
            C.Smooth smooth6 = new C.Smooth() { Val = false };

            C.LineSerExtensionList lineSerExtensionList6 = new C.LineSerExtensionList();

            C.LineSerExtension lineSerExtension6 = new C.LineSerExtension() { Uri = "{C3380CC4-5D6E-409C-BE32-E72D297353CC}" };
            lineSerExtension6.AddNamespaceDeclaration("c16", "http://schemas.microsoft.com/office/drawing/2014/chart");

            OpenXmlUnknownElement openXmlUnknownElement7 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<c16:uniqueId val=\"{00000005-41EF-4BE6-930B-1BD1D946748B}\" xmlns:c16=\"http://schemas.microsoft.com/office/drawing/2014/chart\" />");

            lineSerExtension6.Append(openXmlUnknownElement7);

            lineSerExtensionList6.Append(lineSerExtension6);

            lineChartSeries6.Append(index6);
            lineChartSeries6.Append(order6);
            lineChartSeries6.Append(seriesText6);
            lineChartSeries6.Append(categoryAxisData6);
            lineChartSeries6.Append(values6);
            lineChartSeries6.Append(smooth6);
            lineChartSeries6.Append(lineSerExtensionList6);

            C.LineChartSeries lineChartSeries7 = new C.LineChartSeries();
            C.Index index7 = new C.Index() { Val = (UInt32Value)6U };
            C.Order order7 = new C.Order() { Val = (UInt32Value)7U };

            C.SeriesText seriesText7 = new C.SeriesText();
            C.NumericValue numericValue223 = new C.NumericValue();
            numericValue223.Text = "Available hours after MOW with OT + Subcont (N)=G+L";

            seriesText7.Append(numericValue223);

            C.CategoryAxisData categoryAxisData7 = new C.CategoryAxisData();

            C.StringReference stringReference7 = new C.StringReference();
            C.Formula formula13 = new C.Formula();
            formula13.Text = "CHA1E!$E$9:$V$9";

            C.StringCache stringCache7 = new C.StringCache();
            C.PointCount pointCount13 = new C.PointCount() { Val = (UInt32Value)18U };

            C.StringPoint stringPoint109 = new C.StringPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue224 = new C.NumericValue();
            numericValue224.Text = "2022/10";

            stringPoint109.Append(numericValue224);

            C.StringPoint stringPoint110 = new C.StringPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue225 = new C.NumericValue();
            numericValue225.Text = "2022/11";

            stringPoint110.Append(numericValue225);

            C.StringPoint stringPoint111 = new C.StringPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue226 = new C.NumericValue();
            numericValue226.Text = "2022/12";

            stringPoint111.Append(numericValue226);

            C.StringPoint stringPoint112 = new C.StringPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue227 = new C.NumericValue();
            numericValue227.Text = "2023/01";

            stringPoint112.Append(numericValue227);

            C.StringPoint stringPoint113 = new C.StringPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue228 = new C.NumericValue();
            numericValue228.Text = "2023/02";

            stringPoint113.Append(numericValue228);

            C.StringPoint stringPoint114 = new C.StringPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue229 = new C.NumericValue();
            numericValue229.Text = "2023/03";

            stringPoint114.Append(numericValue229);

            C.StringPoint stringPoint115 = new C.StringPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue230 = new C.NumericValue();
            numericValue230.Text = "2023/04";

            stringPoint115.Append(numericValue230);

            C.StringPoint stringPoint116 = new C.StringPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue231 = new C.NumericValue();
            numericValue231.Text = "2023/05";

            stringPoint116.Append(numericValue231);

            C.StringPoint stringPoint117 = new C.StringPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue232 = new C.NumericValue();
            numericValue232.Text = "2023/06";

            stringPoint117.Append(numericValue232);

            C.StringPoint stringPoint118 = new C.StringPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue233 = new C.NumericValue();
            numericValue233.Text = "2023/07";

            stringPoint118.Append(numericValue233);

            C.StringPoint stringPoint119 = new C.StringPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue234 = new C.NumericValue();
            numericValue234.Text = "2023/08";

            stringPoint119.Append(numericValue234);

            C.StringPoint stringPoint120 = new C.StringPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue235 = new C.NumericValue();
            numericValue235.Text = "2023/09";

            stringPoint120.Append(numericValue235);

            C.StringPoint stringPoint121 = new C.StringPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue236 = new C.NumericValue();
            numericValue236.Text = "2023/10";

            stringPoint121.Append(numericValue236);

            C.StringPoint stringPoint122 = new C.StringPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue237 = new C.NumericValue();
            numericValue237.Text = "2023/11";

            stringPoint122.Append(numericValue237);

            C.StringPoint stringPoint123 = new C.StringPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue238 = new C.NumericValue();
            numericValue238.Text = "2023/12";

            stringPoint123.Append(numericValue238);

            C.StringPoint stringPoint124 = new C.StringPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue239 = new C.NumericValue();
            numericValue239.Text = "2024/01";

            stringPoint124.Append(numericValue239);

            C.StringPoint stringPoint125 = new C.StringPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue240 = new C.NumericValue();
            numericValue240.Text = "2024/02";

            stringPoint125.Append(numericValue240);

            C.StringPoint stringPoint126 = new C.StringPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue241 = new C.NumericValue();
            numericValue241.Text = "2024/03";

            stringPoint126.Append(numericValue241);

            stringCache7.Append(pointCount13);
            stringCache7.Append(stringPoint109);
            stringCache7.Append(stringPoint110);
            stringCache7.Append(stringPoint111);
            stringCache7.Append(stringPoint112);
            stringCache7.Append(stringPoint113);
            stringCache7.Append(stringPoint114);
            stringCache7.Append(stringPoint115);
            stringCache7.Append(stringPoint116);
            stringCache7.Append(stringPoint117);
            stringCache7.Append(stringPoint118);
            stringCache7.Append(stringPoint119);
            stringCache7.Append(stringPoint120);
            stringCache7.Append(stringPoint121);
            stringCache7.Append(stringPoint122);
            stringCache7.Append(stringPoint123);
            stringCache7.Append(stringPoint124);
            stringCache7.Append(stringPoint125);
            stringCache7.Append(stringPoint126);

            stringReference7.Append(formula13);
            stringReference7.Append(stringCache7);

            categoryAxisData7.Append(stringReference7);

            C.Values values7 = new C.Values();

            C.NumberReference numberReference7 = new C.NumberReference();
            C.Formula formula14 = new C.Formula();
            formula14.Text = "CHA1E!$E$123:$V$123";

            C.NumberingCache numberingCache7 = new C.NumberingCache();
            C.FormatCode formatCode7 = new C.FormatCode();
            formatCode7.Text = "#,##0.0";
            C.PointCount pointCount14 = new C.PointCount() { Val = (UInt32Value)18U };

            C.NumericPoint numericPoint109 = new C.NumericPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue242 = new C.NumericValue();
            numericValue242.Text = "81736";

            numericPoint109.Append(numericValue242);

            C.NumericPoint numericPoint110 = new C.NumericPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue243 = new C.NumericValue();
            numericValue243.Text = "98990";

            numericPoint110.Append(numericValue243);

            C.NumericPoint numericPoint111 = new C.NumericPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue244 = new C.NumericValue();
            numericValue244.Text = "92304";

            numericPoint111.Append(numericValue244);

            C.NumericPoint numericPoint112 = new C.NumericPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue245 = new C.NumericValue();
            numericValue245.Text = "94342";

            numericPoint112.Append(numericValue245);

            C.NumericPoint numericPoint113 = new C.NumericPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue246 = new C.NumericValue();
            numericValue246.Text = "91092";

            numericPoint113.Append(numericValue246);

            C.NumericPoint numericPoint114 = new C.NumericPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue247 = new C.NumericValue();
            numericValue247.Text = "90392";

            numericPoint114.Append(numericValue247);

            C.NumericPoint numericPoint115 = new C.NumericPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue248 = new C.NumericValue();
            numericValue248.Text = "94246";

            numericPoint115.Append(numericValue248);

            C.NumericPoint numericPoint116 = new C.NumericPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue249 = new C.NumericValue();
            numericValue249.Text = "98492";

            numericPoint116.Append(numericValue249);

            C.NumericPoint numericPoint117 = new C.NumericPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue250 = new C.NumericValue();
            numericValue250.Text = "97992";

            numericPoint117.Append(numericValue250);

            C.NumericPoint numericPoint118 = new C.NumericPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue251 = new C.NumericValue();
            numericValue251.Text = "97492";

            numericPoint118.Append(numericValue251);

            C.NumericPoint numericPoint119 = new C.NumericPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue252 = new C.NumericValue();
            numericValue252.Text = "96992";

            numericPoint119.Append(numericValue252);

            C.NumericPoint numericPoint120 = new C.NumericPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue253 = new C.NumericValue();
            numericValue253.Text = "92992";

            numericPoint120.Append(numericValue253);

            C.NumericPoint numericPoint121 = new C.NumericPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue254 = new C.NumericValue();
            numericValue254.Text = "82992";

            numericPoint121.Append(numericValue254);

            C.NumericPoint numericPoint122 = new C.NumericPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue255 = new C.NumericValue();
            numericValue255.Text = "79192";

            numericPoint122.Append(numericValue255);

            C.NumericPoint numericPoint123 = new C.NumericPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue256 = new C.NumericValue();
            numericValue256.Text = "71592";

            numericPoint123.Append(numericValue256);

            C.NumericPoint numericPoint124 = new C.NumericPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue257 = new C.NumericValue();
            numericValue257.Text = "71592";

            numericPoint124.Append(numericValue257);

            C.NumericPoint numericPoint125 = new C.NumericPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue258 = new C.NumericValue();
            numericValue258.Text = "71592";

            numericPoint125.Append(numericValue258);

            C.NumericPoint numericPoint126 = new C.NumericPoint() { Index = (UInt32Value)17U };
            C.NumericValue numericValue259 = new C.NumericValue();
            numericValue259.Text = "74632";

            numericPoint126.Append(numericValue259);

            numberingCache7.Append(formatCode7);
            numberingCache7.Append(pointCount14);
            numberingCache7.Append(numericPoint109);
            numberingCache7.Append(numericPoint110);
            numberingCache7.Append(numericPoint111);
            numberingCache7.Append(numericPoint112);
            numberingCache7.Append(numericPoint113);
            numberingCache7.Append(numericPoint114);
            numberingCache7.Append(numericPoint115);
            numberingCache7.Append(numericPoint116);
            numberingCache7.Append(numericPoint117);
            numberingCache7.Append(numericPoint118);
            numberingCache7.Append(numericPoint119);
            numberingCache7.Append(numericPoint120);
            numberingCache7.Append(numericPoint121);
            numberingCache7.Append(numericPoint122);
            numberingCache7.Append(numericPoint123);
            numberingCache7.Append(numericPoint124);
            numberingCache7.Append(numericPoint125);
            numberingCache7.Append(numericPoint126);

            numberReference7.Append(formula14);
            numberReference7.Append(numberingCache7);

            values7.Append(numberReference7);
            C.Smooth smooth7 = new C.Smooth() { Val = false };

            C.LineSerExtensionList lineSerExtensionList7 = new C.LineSerExtensionList();

            C.LineSerExtension lineSerExtension7 = new C.LineSerExtension() { Uri = "{C3380CC4-5D6E-409C-BE32-E72D297353CC}" };
            lineSerExtension7.AddNamespaceDeclaration("c16", "http://schemas.microsoft.com/office/drawing/2014/chart");

            OpenXmlUnknownElement openXmlUnknownElement8 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<c16:uniqueId val=\"{00000006-41EF-4BE6-930B-1BD1D946748B}\" xmlns:c16=\"http://schemas.microsoft.com/office/drawing/2014/chart\" />");

            lineSerExtension7.Append(openXmlUnknownElement8);

            lineSerExtensionList7.Append(lineSerExtension7);

            lineChartSeries7.Append(index7);
            lineChartSeries7.Append(order7);
            lineChartSeries7.Append(seriesText7);
            lineChartSeries7.Append(categoryAxisData7);
            lineChartSeries7.Append(values7);
            lineChartSeries7.Append(smooth7);
            lineChartSeries7.Append(lineSerExtensionList7);

            C.DataLabels dataLabels1 = new C.DataLabels();
            C.ShowLegendKey showLegendKey1 = new C.ShowLegendKey() { Val = false };
            C.ShowValue showValue1 = new C.ShowValue() { Val = false };
            C.ShowCategoryName showCategoryName1 = new C.ShowCategoryName() { Val = false };
            C.ShowSeriesName showSeriesName1 = new C.ShowSeriesName() { Val = false };
            C.ShowPercent showPercent1 = new C.ShowPercent() { Val = false };
            C.ShowBubbleSize showBubbleSize1 = new C.ShowBubbleSize() { Val = false };

            dataLabels1.Append(showLegendKey1);
            dataLabels1.Append(showValue1);
            dataLabels1.Append(showCategoryName1);
            dataLabels1.Append(showSeriesName1);
            dataLabels1.Append(showPercent1);
            dataLabels1.Append(showBubbleSize1);
            C.ShowMarker showMarker1 = new C.ShowMarker() { Val = true };
            C.Smooth smooth8 = new C.Smooth() { Val = false };
            C.AxisId axisId1 = new C.AxisId() { Val = (UInt32Value)1688776879U };
            C.AxisId axisId2 = new C.AxisId() { Val = (UInt32Value)1U };

            C.LineChartExtensionList lineChartExtensionList1 = new C.LineChartExtensionList();

            C.LineChartExtension lineChartExtension1 = new C.LineChartExtension() { Uri = "{02D57815-91ED-43cb-92C2-25804820EDAC}" };
            lineChartExtension1.AddNamespaceDeclaration("c15", "http://schemas.microsoft.com/office/drawing/2012/chart");

            C15.FilteredLineSeriesExtension filteredLineSeriesExtension1 = new C15.FilteredLineSeriesExtension();

            C15.LineChartSeries lineChartSeries8 = new C15.LineChartSeries();
            C.Index index8 = new C.Index() { Val = (UInt32Value)7U };
            C.Order order8 = new C.Order() { Val = (UInt32Value)0U };

            C.SeriesText seriesText8 = new C.SeriesText();

            C.StringReference stringReference8 = new C.StringReference();

            C.StrRefExtensionList strRefExtensionList1 = new C.StrRefExtensionList();

            C.StrRefExtension strRefExtension1 = new C.StrRefExtension() { Uri = "{02D57815-91ED-43cb-92C2-25804820EDAC}" };

            C15.FormulaReference formulaReference1 = new C15.FormulaReference();
            C15.SequenceOfReferences sequenceOfReferences1 = new C15.SequenceOfReferences();
            sequenceOfReferences1.Text = "CHA1E!$E$9:$U$9";

            formulaReference1.Append(sequenceOfReferences1);

            strRefExtension1.Append(formulaReference1);

            strRefExtensionList1.Append(strRefExtension1);

            C.StringCache stringCache8 = new C.StringCache();
            C.PointCount pointCount15 = new C.PointCount() { Val = (UInt32Value)17U };

            C.StringPoint stringPoint127 = new C.StringPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue260 = new C.NumericValue();
            numericValue260.Text = "2022/10";

            stringPoint127.Append(numericValue260);

            C.StringPoint stringPoint128 = new C.StringPoint() { Index = (UInt32Value)1U };
            C.NumericValue numericValue261 = new C.NumericValue();
            numericValue261.Text = "2022/11";

            stringPoint128.Append(numericValue261);

            C.StringPoint stringPoint129 = new C.StringPoint() { Index = (UInt32Value)2U };
            C.NumericValue numericValue262 = new C.NumericValue();
            numericValue262.Text = "2022/12";

            stringPoint129.Append(numericValue262);

            C.StringPoint stringPoint130 = new C.StringPoint() { Index = (UInt32Value)3U };
            C.NumericValue numericValue263 = new C.NumericValue();
            numericValue263.Text = "2023/01";

            stringPoint130.Append(numericValue263);

            C.StringPoint stringPoint131 = new C.StringPoint() { Index = (UInt32Value)4U };
            C.NumericValue numericValue264 = new C.NumericValue();
            numericValue264.Text = "2023/02";

            stringPoint131.Append(numericValue264);

            C.StringPoint stringPoint132 = new C.StringPoint() { Index = (UInt32Value)5U };
            C.NumericValue numericValue265 = new C.NumericValue();
            numericValue265.Text = "2023/03";

            stringPoint132.Append(numericValue265);

            C.StringPoint stringPoint133 = new C.StringPoint() { Index = (UInt32Value)6U };
            C.NumericValue numericValue266 = new C.NumericValue();
            numericValue266.Text = "2023/04";

            stringPoint133.Append(numericValue266);

            C.StringPoint stringPoint134 = new C.StringPoint() { Index = (UInt32Value)7U };
            C.NumericValue numericValue267 = new C.NumericValue();
            numericValue267.Text = "2023/05";

            stringPoint134.Append(numericValue267);

            C.StringPoint stringPoint135 = new C.StringPoint() { Index = (UInt32Value)8U };
            C.NumericValue numericValue268 = new C.NumericValue();
            numericValue268.Text = "2023/06";

            stringPoint135.Append(numericValue268);

            C.StringPoint stringPoint136 = new C.StringPoint() { Index = (UInt32Value)9U };
            C.NumericValue numericValue269 = new C.NumericValue();
            numericValue269.Text = "2023/07";

            stringPoint136.Append(numericValue269);

            C.StringPoint stringPoint137 = new C.StringPoint() { Index = (UInt32Value)10U };
            C.NumericValue numericValue270 = new C.NumericValue();
            numericValue270.Text = "2023/08";

            stringPoint137.Append(numericValue270);

            C.StringPoint stringPoint138 = new C.StringPoint() { Index = (UInt32Value)11U };
            C.NumericValue numericValue271 = new C.NumericValue();
            numericValue271.Text = "2023/09";

            stringPoint138.Append(numericValue271);

            C.StringPoint stringPoint139 = new C.StringPoint() { Index = (UInt32Value)12U };
            C.NumericValue numericValue272 = new C.NumericValue();
            numericValue272.Text = "2023/10";

            stringPoint139.Append(numericValue272);

            C.StringPoint stringPoint140 = new C.StringPoint() { Index = (UInt32Value)13U };
            C.NumericValue numericValue273 = new C.NumericValue();
            numericValue273.Text = "2023/11";

            stringPoint140.Append(numericValue273);

            C.StringPoint stringPoint141 = new C.StringPoint() { Index = (UInt32Value)14U };
            C.NumericValue numericValue274 = new C.NumericValue();
            numericValue274.Text = "2023/12";

            stringPoint141.Append(numericValue274);

            C.StringPoint stringPoint142 = new C.StringPoint() { Index = (UInt32Value)15U };
            C.NumericValue numericValue275 = new C.NumericValue();
            numericValue275.Text = "2024/01";

            stringPoint142.Append(numericValue275);

            C.StringPoint stringPoint143 = new C.StringPoint() { Index = (UInt32Value)16U };
            C.NumericValue numericValue276 = new C.NumericValue();
            numericValue276.Text = "2024/02";

            stringPoint143.Append(numericValue276);

            stringCache8.Append(pointCount15);
            stringCache8.Append(stringPoint127);
            stringCache8.Append(stringPoint128);
            stringCache8.Append(stringPoint129);
            stringCache8.Append(stringPoint130);
            stringCache8.Append(stringPoint131);
            stringCache8.Append(stringPoint132);
            stringCache8.Append(stringPoint133);
            stringCache8.Append(stringPoint134);
            stringCache8.Append(stringPoint135);
            stringCache8.Append(stringPoint136);
            stringCache8.Append(stringPoint137);
            stringCache8.Append(stringPoint138);
            stringCache8.Append(stringPoint139);
            stringCache8.Append(stringPoint140);
            stringCache8.Append(stringPoint141);
            stringCache8.Append(stringPoint142);
            stringCache8.Append(stringPoint143);

            stringReference8.Append(strRefExtensionList1);
            stringReference8.Append(stringCache8);

            seriesText8.Append(stringReference8);

            C.Values values8 = new C.Values();

            C.NumberReference numberReference8 = new C.NumberReference();

            C.NumRefExtensionList numRefExtensionList1 = new C.NumRefExtensionList();

            C.NumRefExtension numRefExtension1 = new C.NumRefExtension() { Uri = "{02D57815-91ED-43cb-92C2-25804820EDAC}" };

            C15.FormulaReference formulaReference2 = new C15.FormulaReference();
            C15.SequenceOfReferences sequenceOfReferences2 = new C15.SequenceOfReferences();
            sequenceOfReferences2.Text = "CHA1E!$V$9";

            formulaReference2.Append(sequenceOfReferences2);

            numRefExtension1.Append(formulaReference2);

            numRefExtensionList1.Append(numRefExtension1);

            C.NumberingCache numberingCache8 = new C.NumberingCache();
            C.FormatCode formatCode8 = new C.FormatCode();
            formatCode8.Text = "0";
            C.PointCount pointCount16 = new C.PointCount() { Val = (UInt32Value)1U };

            C.NumericPoint numericPoint127 = new C.NumericPoint() { Index = (UInt32Value)0U };
            C.NumericValue numericValue277 = new C.NumericValue();
            numericValue277.Text = "0";

            numericPoint127.Append(numericValue277);

            numberingCache8.Append(formatCode8);
            numberingCache8.Append(pointCount16);
            numberingCache8.Append(numericPoint127);

            numberReference8.Append(numRefExtensionList1);
            numberReference8.Append(numberingCache8);

            values8.Append(numberReference8);
            C.Smooth smooth9 = new C.Smooth() { Val = false };

            C.LineSerExtensionList lineSerExtensionList8 = new C.LineSerExtensionList();

            C.LineSerExtension lineSerExtension8 = new C.LineSerExtension() { Uri = "{C3380CC4-5D6E-409C-BE32-E72D297353CC}" };
            lineSerExtension8.AddNamespaceDeclaration("c16", "http://schemas.microsoft.com/office/drawing/2014/chart");

            OpenXmlUnknownElement openXmlUnknownElement9 = OpenXmlUnknownElement.CreateOpenXmlUnknownElement("<c16:uniqueId val=\"{00000001-6710-4C67-AADE-AB359A33B83B}\" xmlns:c16=\"http://schemas.microsoft.com/office/drawing/2014/chart\" />");

            lineSerExtension8.Append(openXmlUnknownElement9);

            lineSerExtensionList8.Append(lineSerExtension8);

            lineChartSeries8.Append(index8);
            lineChartSeries8.Append(order8);
            lineChartSeries8.Append(seriesText8);
            lineChartSeries8.Append(values8);
            lineChartSeries8.Append(smooth9);
            lineChartSeries8.Append(lineSerExtensionList8);

            filteredLineSeriesExtension1.Append(lineChartSeries8);

            lineChartExtension1.Append(filteredLineSeriesExtension1);

            lineChartExtensionList1.Append(lineChartExtension1);

            lineChart1.Append(grouping1);
            lineChart1.Append(varyColors1);
            lineChart1.Append(lineChartSeries1);
            lineChart1.Append(lineChartSeries2);
            lineChart1.Append(lineChartSeries3);
            lineChart1.Append(lineChartSeries4);
            lineChart1.Append(lineChartSeries5);
            lineChart1.Append(lineChartSeries6);
            lineChart1.Append(lineChartSeries7);
            lineChart1.Append(dataLabels1);
            lineChart1.Append(showMarker1);
            lineChart1.Append(smooth8);
            lineChart1.Append(axisId1);
            lineChart1.Append(axisId2);
            lineChart1.Append(lineChartExtensionList1);

            C.CategoryAxis categoryAxis1 = new C.CategoryAxis();
            C.AxisId axisId3 = new C.AxisId() { Val = (UInt32Value)1688776879U };

            C.Scaling scaling1 = new C.Scaling();
            C.Orientation orientation1 = new C.Orientation() { Val = C.OrientationValues.MinMax };

            scaling1.Append(orientation1);
            C.Delete delete1 = new C.Delete() { Val = false };
            C.AxisPosition axisPosition1 = new C.AxisPosition() { Val = C.AxisPositionValues.Bottom };

            C.MajorGridlines majorGridlines1 = new C.MajorGridlines();

            C.ChartShapeProperties chartShapeProperties2 = new C.ChartShapeProperties();

            A.Outline outline2 = new A.Outline() { Width = 3175 };

            A.SolidFill solidFill2 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex2 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill2.Append(rgbColorModelHex2);
            A.PresetDash presetDash1 = new A.PresetDash() { Val = A.PresetLineDashValues.SystemDash };

            outline2.Append(solidFill2);
            outline2.Append(presetDash1);

            chartShapeProperties2.Append(outline2);

            majorGridlines1.Append(chartShapeProperties2);

            C.Title title2 = new C.Title();

            C.ChartText chartText2 = new C.ChartText();

            C.RichText richText2 = new C.RichText();
            A.BodyProperties bodyProperties2 = new A.BodyProperties();
            A.ListStyle listStyle2 = new A.ListStyle();

            A.Paragraph paragraph2 = new A.Paragraph();

            A.ParagraphProperties paragraphProperties2 = new A.ParagraphProperties();

            A.DefaultRunProperties defaultRunProperties2 = new A.DefaultRunProperties() { FontSize = 1000, Bold = true, Italic = false, Underline = A.TextUnderlineValues.None, Strike = A.TextStrikeValues.NoStrike, Baseline = 0 };

            A.SolidFill solidFill3 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex3 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill3.Append(rgbColorModelHex3);
            A.LatinFont latinFont2 = new A.LatinFont() { Typeface = "Times New Roman" };
            A.EastAsianFont eastAsianFont2 = new A.EastAsianFont() { Typeface = "Times New Roman" };
            A.ComplexScriptFont complexScriptFont2 = new A.ComplexScriptFont() { Typeface = "Times New Roman" };

            defaultRunProperties2.Append(solidFill3);
            defaultRunProperties2.Append(latinFont2);
            defaultRunProperties2.Append(eastAsianFont2);
            defaultRunProperties2.Append(complexScriptFont2);

            paragraphProperties2.Append(defaultRunProperties2);

            A.Run run2 = new A.Run();
            A.RunProperties runProperties2 = new A.RunProperties() { Language = "en-IN" };
            A.Text text2 = new A.Text();
            text2.Text = "Months";

            run2.Append(runProperties2);
            run2.Append(text2);

            paragraph2.Append(paragraphProperties2);
            paragraph2.Append(run2);

            richText2.Append(bodyProperties2);
            richText2.Append(listStyle2);
            richText2.Append(paragraph2);

            chartText2.Append(richText2);

            C.Layout layout3 = new C.Layout();

            C.ManualLayout manualLayout3 = new C.ManualLayout();
            C.LeftMode leftMode3 = new C.LeftMode() { Val = C.LayoutModeValues.Edge };
            C.TopMode topMode3 = new C.TopMode() { Val = C.LayoutModeValues.Edge };
            C.Left left3 = new C.Left() { Val = 0.4348373558568337D };
            C.Top top3 = new C.Top() { Val = 0.94246632869521441D };

            manualLayout3.Append(leftMode3);
            manualLayout3.Append(topMode3);
            manualLayout3.Append(left3);
            manualLayout3.Append(top3);

            layout3.Append(manualLayout3);
            C.Overlay overlay2 = new C.Overlay() { Val = false };

            C.ChartShapeProperties chartShapeProperties3 = new C.ChartShapeProperties();
            A.NoFill noFill3 = new A.NoFill();

            A.Outline outline3 = new A.Outline() { Width = 25400 };
            A.NoFill noFill4 = new A.NoFill();

            outline3.Append(noFill4);

            chartShapeProperties3.Append(noFill3);
            chartShapeProperties3.Append(outline3);

            title2.Append(chartText2);
            title2.Append(layout3);
            title2.Append(overlay2);
            title2.Append(chartShapeProperties3);
            C.NumberingFormat numberingFormat1 = new C.NumberingFormat() { FormatCode = "General", SourceLinked = true };
            C.MajorTickMark majorTickMark1 = new C.MajorTickMark() { Val = C.TickMarkValues.Cross };
            C.MinorTickMark minorTickMark1 = new C.MinorTickMark() { Val = C.TickMarkValues.None };
            C.TickLabelPosition tickLabelPosition1 = new C.TickLabelPosition() { Val = C.TickLabelPositionValues.NextTo };

            C.ChartShapeProperties chartShapeProperties4 = new C.ChartShapeProperties();

            A.Outline outline4 = new A.Outline() { Width = 3175 };

            A.SolidFill solidFill4 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex4 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill4.Append(rgbColorModelHex4);
            A.PresetDash presetDash2 = new A.PresetDash() { Val = A.PresetLineDashValues.Solid };

            outline4.Append(solidFill4);
            outline4.Append(presetDash2);

            chartShapeProperties4.Append(outline4);

            C.TextProperties textProperties1 = new C.TextProperties();
            A.BodyProperties bodyProperties3 = new A.BodyProperties() { Rotation = 0, Vertical = A.TextVerticalValues.Horizontal };
            A.ListStyle listStyle3 = new A.ListStyle();

            A.Paragraph paragraph3 = new A.Paragraph();

            A.ParagraphProperties paragraphProperties3 = new A.ParagraphProperties();

            A.DefaultRunProperties defaultRunProperties3 = new A.DefaultRunProperties() { FontSize = 800, Bold = false, Italic = false, Underline = A.TextUnderlineValues.None, Strike = A.TextStrikeValues.NoStrike, Baseline = 0 };

            A.SolidFill solidFill5 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex5 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill5.Append(rgbColorModelHex5);
            A.LatinFont latinFont3 = new A.LatinFont() { Typeface = "Arial" };
            A.EastAsianFont eastAsianFont3 = new A.EastAsianFont() { Typeface = "Arial" };
            A.ComplexScriptFont complexScriptFont3 = new A.ComplexScriptFont() { Typeface = "Arial" };

            defaultRunProperties3.Append(solidFill5);
            defaultRunProperties3.Append(latinFont3);
            defaultRunProperties3.Append(eastAsianFont3);
            defaultRunProperties3.Append(complexScriptFont3);

            paragraphProperties3.Append(defaultRunProperties3);
            A.EndParagraphRunProperties endParagraphRunProperties1 = new A.EndParagraphRunProperties() { Language = "en-US" };

            paragraph3.Append(paragraphProperties3);
            paragraph3.Append(endParagraphRunProperties1);

            textProperties1.Append(bodyProperties3);
            textProperties1.Append(listStyle3);
            textProperties1.Append(paragraph3);
            C.CrossingAxis crossingAxis1 = new C.CrossingAxis() { Val = (UInt32Value)1U };
            C.Crosses crosses1 = new C.Crosses() { Val = C.CrossesValues.AutoZero };
            C.AutoLabeled autoLabeled1 = new C.AutoLabeled() { Val = false };
            C.LabelAlignment labelAlignment1 = new C.LabelAlignment() { Val = C.LabelAlignmentValues.Center };
            C.LabelOffset labelOffset1 = new C.LabelOffset() { Val = (UInt16Value)100U };
            C.TickLabelSkip tickLabelSkip1 = new C.TickLabelSkip() { Val = 1 };
            C.TickMarkSkip tickMarkSkip1 = new C.TickMarkSkip() { Val = 1 };
            C.NoMultiLevelLabels noMultiLevelLabels1 = new C.NoMultiLevelLabels() { Val = false };

            categoryAxis1.Append(axisId3);
            categoryAxis1.Append(scaling1);
            categoryAxis1.Append(delete1);
            categoryAxis1.Append(axisPosition1);
            categoryAxis1.Append(majorGridlines1);
            categoryAxis1.Append(title2);
            categoryAxis1.Append(numberingFormat1);
            categoryAxis1.Append(majorTickMark1);
            categoryAxis1.Append(minorTickMark1);
            categoryAxis1.Append(tickLabelPosition1);
            categoryAxis1.Append(chartShapeProperties4);
            categoryAxis1.Append(textProperties1);
            categoryAxis1.Append(crossingAxis1);
            categoryAxis1.Append(crosses1);
            categoryAxis1.Append(autoLabeled1);
            categoryAxis1.Append(labelAlignment1);
            categoryAxis1.Append(labelOffset1);
            categoryAxis1.Append(tickLabelSkip1);
            categoryAxis1.Append(tickMarkSkip1);
            categoryAxis1.Append(noMultiLevelLabels1);

            C.ValueAxis valueAxis1 = new C.ValueAxis();
            C.AxisId axisId4 = new C.AxisId() { Val = (UInt32Value)1U };

            C.Scaling scaling2 = new C.Scaling();
            C.Orientation orientation2 = new C.Orientation() { Val = C.OrientationValues.MinMax };

            scaling2.Append(orientation2);
            C.Delete delete2 = new C.Delete() { Val = false };
            C.AxisPosition axisPosition2 = new C.AxisPosition() { Val = C.AxisPositionValues.Left };

            C.MajorGridlines majorGridlines2 = new C.MajorGridlines();

            C.ChartShapeProperties chartShapeProperties5 = new C.ChartShapeProperties();

            A.Outline outline5 = new A.Outline() { Width = 3175 };

            A.SolidFill solidFill6 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex6 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill6.Append(rgbColorModelHex6);
            A.PresetDash presetDash3 = new A.PresetDash() { Val = A.PresetLineDashValues.SystemDash };

            outline5.Append(solidFill6);
            outline5.Append(presetDash3);

            chartShapeProperties5.Append(outline5);

            majorGridlines2.Append(chartShapeProperties5);

            C.Title title3 = new C.Title();

            C.ChartText chartText3 = new C.ChartText();

            C.RichText richText3 = new C.RichText();
            A.BodyProperties bodyProperties4 = new A.BodyProperties();
            A.ListStyle listStyle4 = new A.ListStyle();

            A.Paragraph paragraph4 = new A.Paragraph();

            A.ParagraphProperties paragraphProperties4 = new A.ParagraphProperties();

            A.DefaultRunProperties defaultRunProperties4 = new A.DefaultRunProperties() { FontSize = 1000, Bold = true, Italic = false, Underline = A.TextUnderlineValues.None, Strike = A.TextStrikeValues.NoStrike, Baseline = 0 };

            A.SolidFill solidFill7 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex7 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill7.Append(rgbColorModelHex7);
            A.LatinFont latinFont4 = new A.LatinFont() { Typeface = "Times New Roman" };
            A.EastAsianFont eastAsianFont4 = new A.EastAsianFont() { Typeface = "Times New Roman" };
            A.ComplexScriptFont complexScriptFont4 = new A.ComplexScriptFont() { Typeface = "Times New Roman" };

            defaultRunProperties4.Append(solidFill7);
            defaultRunProperties4.Append(latinFont4);
            defaultRunProperties4.Append(eastAsianFont4);
            defaultRunProperties4.Append(complexScriptFont4);

            paragraphProperties4.Append(defaultRunProperties4);

            A.Run run3 = new A.Run();
            A.RunProperties runProperties3 = new A.RunProperties() { Language = "en-IN" };
            A.Text text3 = new A.Text();
            text3.Text = "Manhours";

            run3.Append(runProperties3);
            run3.Append(text3);

            paragraph4.Append(paragraphProperties4);
            paragraph4.Append(run3);

            richText3.Append(bodyProperties4);
            richText3.Append(listStyle4);
            richText3.Append(paragraph4);

            chartText3.Append(richText3);

            C.Layout layout4 = new C.Layout();

            C.ManualLayout manualLayout4 = new C.ManualLayout();
            C.LeftMode leftMode4 = new C.LeftMode() { Val = C.LayoutModeValues.Edge };
            C.TopMode topMode4 = new C.TopMode() { Val = C.LayoutModeValues.Edge };
            C.Left left4 = new C.Left() { Val = 1.2531328320802004E-2D };
            C.Top top4 = new C.Top() { Val = 0.46712357530651133D };

            manualLayout4.Append(leftMode4);
            manualLayout4.Append(topMode4);
            manualLayout4.Append(left4);
            manualLayout4.Append(top4);

            layout4.Append(manualLayout4);
            C.Overlay overlay3 = new C.Overlay() { Val = false };

            C.ChartShapeProperties chartShapeProperties6 = new C.ChartShapeProperties();
            A.NoFill noFill5 = new A.NoFill();

            A.Outline outline6 = new A.Outline() { Width = 25400 };
            A.NoFill noFill6 = new A.NoFill();

            outline6.Append(noFill6);

            chartShapeProperties6.Append(noFill5);
            chartShapeProperties6.Append(outline6);

            title3.Append(chartText3);
            title3.Append(layout4);
            title3.Append(overlay3);
            title3.Append(chartShapeProperties6);
            C.NumberingFormat numberingFormat2 = new C.NumberingFormat() { FormatCode = "#,##0.0", SourceLinked = true };
            C.MajorTickMark majorTickMark2 = new C.MajorTickMark() { Val = C.TickMarkValues.Outside };
            C.MinorTickMark minorTickMark2 = new C.MinorTickMark() { Val = C.TickMarkValues.None };
            C.TickLabelPosition tickLabelPosition2 = new C.TickLabelPosition() { Val = C.TickLabelPositionValues.NextTo };

            C.ChartShapeProperties chartShapeProperties7 = new C.ChartShapeProperties();

            A.Outline outline7 = new A.Outline() { Width = 3175 };

            A.SolidFill solidFill8 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex8 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill8.Append(rgbColorModelHex8);
            A.PresetDash presetDash4 = new A.PresetDash() { Val = A.PresetLineDashValues.Solid };

            outline7.Append(solidFill8);
            outline7.Append(presetDash4);

            chartShapeProperties7.Append(outline7);

            C.TextProperties textProperties2 = new C.TextProperties();
            A.BodyProperties bodyProperties5 = new A.BodyProperties() { Rotation = 0, Vertical = A.TextVerticalValues.Horizontal };
            A.ListStyle listStyle5 = new A.ListStyle();

            A.Paragraph paragraph5 = new A.Paragraph();

            A.ParagraphProperties paragraphProperties5 = new A.ParagraphProperties();

            A.DefaultRunProperties defaultRunProperties5 = new A.DefaultRunProperties() { FontSize = 800, Bold = false, Italic = false, Underline = A.TextUnderlineValues.None, Strike = A.TextStrikeValues.NoStrike, Baseline = 0 };

            A.SolidFill solidFill9 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex9 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill9.Append(rgbColorModelHex9);
            A.LatinFont latinFont5 = new A.LatinFont() { Typeface = "Arial" };
            A.EastAsianFont eastAsianFont5 = new A.EastAsianFont() { Typeface = "Arial" };
            A.ComplexScriptFont complexScriptFont5 = new A.ComplexScriptFont() { Typeface = "Arial" };

            defaultRunProperties5.Append(solidFill9);
            defaultRunProperties5.Append(latinFont5);
            defaultRunProperties5.Append(eastAsianFont5);
            defaultRunProperties5.Append(complexScriptFont5);

            paragraphProperties5.Append(defaultRunProperties5);
            A.EndParagraphRunProperties endParagraphRunProperties2 = new A.EndParagraphRunProperties() { Language = "en-US" };

            paragraph5.Append(paragraphProperties5);
            paragraph5.Append(endParagraphRunProperties2);

            textProperties2.Append(bodyProperties5);
            textProperties2.Append(listStyle5);
            textProperties2.Append(paragraph5);
            C.CrossingAxis crossingAxis2 = new C.CrossingAxis() { Val = (UInt32Value)1688776879U };
            C.Crosses crosses2 = new C.Crosses() { Val = C.CrossesValues.AutoZero };
            C.CrossBetween crossBetween1 = new C.CrossBetween() { Val = C.CrossBetweenValues.MidpointCategory };

            valueAxis1.Append(axisId4);
            valueAxis1.Append(scaling2);
            valueAxis1.Append(delete2);
            valueAxis1.Append(axisPosition2);
            valueAxis1.Append(majorGridlines2);
            valueAxis1.Append(title3);
            valueAxis1.Append(numberingFormat2);
            valueAxis1.Append(majorTickMark2);
            valueAxis1.Append(minorTickMark2);
            valueAxis1.Append(tickLabelPosition2);
            valueAxis1.Append(chartShapeProperties7);
            valueAxis1.Append(textProperties2);
            valueAxis1.Append(crossingAxis2);
            valueAxis1.Append(crosses2);
            valueAxis1.Append(crossBetween1);

            C.ShapeProperties shapeProperties1 = new C.ShapeProperties();
            A.NoFill noFill7 = new A.NoFill();

            A.Outline outline8 = new A.Outline() { Width = 12700 };

            A.SolidFill solidFill10 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex10 = new A.RgbColorModelHex() { Val = "808080" };

            solidFill10.Append(rgbColorModelHex10);
            A.PresetDash presetDash5 = new A.PresetDash() { Val = A.PresetLineDashValues.Solid };

            outline8.Append(solidFill10);
            outline8.Append(presetDash5);

            shapeProperties1.Append(noFill7);
            shapeProperties1.Append(outline8);

            plotArea1.Append(layout2);
            plotArea1.Append(lineChart1);
            plotArea1.Append(categoryAxis1);
            plotArea1.Append(valueAxis1);
            plotArea1.Append(shapeProperties1);

            C.Legend legend1 = new C.Legend();
            C.LegendPosition legendPosition1 = new C.LegendPosition() { Val = C.LegendPositionValues.Right };

            C.Layout layout5 = new C.Layout();

            C.ManualLayout manualLayout5 = new C.ManualLayout();
            C.LeftMode leftMode5 = new C.LeftMode() { Val = C.LayoutModeValues.Edge };
            C.TopMode topMode5 = new C.TopMode() { Val = C.LayoutModeValues.Edge };
            C.Left left5 = new C.Left() { Val = 0.8586799651535777D };
            C.Top top5 = new C.Top() { Val = 0.19124544467665275D };
            C.Width width2 = new C.Width() { Val = 0.14132003484642228D };
            C.Height height2 = new C.Height() { Val = 0.26449553027887923D };

            manualLayout5.Append(leftMode5);
            manualLayout5.Append(topMode5);
            manualLayout5.Append(left5);
            manualLayout5.Append(top5);
            manualLayout5.Append(width2);
            manualLayout5.Append(height2);

            layout5.Append(manualLayout5);
            C.Overlay overlay4 = new C.Overlay() { Val = false };

            C.ChartShapeProperties chartShapeProperties8 = new C.ChartShapeProperties();

            A.SolidFill solidFill11 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex11 = new A.RgbColorModelHex() { Val = "FFFFFF" };

            solidFill11.Append(rgbColorModelHex11);

            A.Outline outline9 = new A.Outline() { Width = 3175 };

            A.SolidFill solidFill12 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex12 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill12.Append(rgbColorModelHex12);
            A.PresetDash presetDash6 = new A.PresetDash() { Val = A.PresetLineDashValues.Solid };

            outline9.Append(solidFill12);
            outline9.Append(presetDash6);

            chartShapeProperties8.Append(solidFill11);
            chartShapeProperties8.Append(outline9);

            C.TextProperties textProperties3 = new C.TextProperties();
            A.BodyProperties bodyProperties6 = new A.BodyProperties();
            A.ListStyle listStyle6 = new A.ListStyle();

            A.Paragraph paragraph6 = new A.Paragraph();

            A.ParagraphProperties paragraphProperties6 = new A.ParagraphProperties();

            A.DefaultRunProperties defaultRunProperties6 = new A.DefaultRunProperties() { FontSize = 735, Bold = false, Italic = false, Underline = A.TextUnderlineValues.None, Strike = A.TextStrikeValues.NoStrike, Baseline = 0 };

            A.SolidFill solidFill13 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex13 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill13.Append(rgbColorModelHex13);
            A.LatinFont latinFont6 = new A.LatinFont() { Typeface = "Arial" };
            A.EastAsianFont eastAsianFont6 = new A.EastAsianFont() { Typeface = "Arial" };
            A.ComplexScriptFont complexScriptFont6 = new A.ComplexScriptFont() { Typeface = "Arial" };

            defaultRunProperties6.Append(solidFill13);
            defaultRunProperties6.Append(latinFont6);
            defaultRunProperties6.Append(eastAsianFont6);
            defaultRunProperties6.Append(complexScriptFont6);

            paragraphProperties6.Append(defaultRunProperties6);
            A.EndParagraphRunProperties endParagraphRunProperties3 = new A.EndParagraphRunProperties() { Language = "en-US" };

            paragraph6.Append(paragraphProperties6);
            paragraph6.Append(endParagraphRunProperties3);

            textProperties3.Append(bodyProperties6);
            textProperties3.Append(listStyle6);
            textProperties3.Append(paragraph6);

            legend1.Append(legendPosition1);
            legend1.Append(layout5);
            legend1.Append(overlay4);
            legend1.Append(chartShapeProperties8);
            legend1.Append(textProperties3);
            C.PlotVisibleOnly plotVisibleOnly1 = new C.PlotVisibleOnly() { Val = true };
            C.DisplayBlanksAs displayBlanksAs1 = new C.DisplayBlanksAs() { Val = C.DisplayBlanksAsValues.Gap };
            C.ShowDataLabelsOverMaximum showDataLabelsOverMaximum1 = new C.ShowDataLabelsOverMaximum() { Val = false };

            chart1.Append(title1);
            chart1.Append(autoTitleDeleted1);
            chart1.Append(plotArea1);
            chart1.Append(legend1);
            chart1.Append(plotVisibleOnly1);
            chart1.Append(displayBlanksAs1);
            chart1.Append(showDataLabelsOverMaximum1);

            C.ShapeProperties shapeProperties2 = new C.ShapeProperties();

            A.SolidFill solidFill14 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex14 = new A.RgbColorModelHex() { Val = "FFFFFF" };

            solidFill14.Append(rgbColorModelHex14);

            A.Outline outline10 = new A.Outline() { Width = 3175 };

            A.SolidFill solidFill15 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex15 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill15.Append(rgbColorModelHex15);
            A.PresetDash presetDash7 = new A.PresetDash() { Val = A.PresetLineDashValues.Solid };

            outline10.Append(solidFill15);
            outline10.Append(presetDash7);

            shapeProperties2.Append(solidFill14);
            shapeProperties2.Append(outline10);

            C.TextProperties textProperties4 = new C.TextProperties();
            A.BodyProperties bodyProperties7 = new A.BodyProperties();
            A.ListStyle listStyle7 = new A.ListStyle();

            A.Paragraph paragraph7 = new A.Paragraph();

            A.ParagraphProperties paragraphProperties7 = new A.ParagraphProperties();

            A.DefaultRunProperties defaultRunProperties7 = new A.DefaultRunProperties() { FontSize = 800, Bold = false, Italic = false, Underline = A.TextUnderlineValues.None, Strike = A.TextStrikeValues.NoStrike, Baseline = 0 };

            A.SolidFill solidFill16 = new A.SolidFill();
            A.RgbColorModelHex rgbColorModelHex16 = new A.RgbColorModelHex() { Val = "000000" };

            solidFill16.Append(rgbColorModelHex16);
            A.LatinFont latinFont7 = new A.LatinFont() { Typeface = "Arial" };
            A.EastAsianFont eastAsianFont7 = new A.EastAsianFont() { Typeface = "Arial" };
            A.ComplexScriptFont complexScriptFont7 = new A.ComplexScriptFont() { Typeface = "Arial" };

            defaultRunProperties7.Append(solidFill16);
            defaultRunProperties7.Append(latinFont7);
            defaultRunProperties7.Append(eastAsianFont7);
            defaultRunProperties7.Append(complexScriptFont7);

            paragraphProperties7.Append(defaultRunProperties7);
            A.EndParagraphRunProperties endParagraphRunProperties4 = new A.EndParagraphRunProperties() { Language = "en-US" };

            paragraph7.Append(paragraphProperties7);
            paragraph7.Append(endParagraphRunProperties4);

            textProperties4.Append(bodyProperties7);
            textProperties4.Append(listStyle7);
            textProperties4.Append(paragraph7);

            C.PrintSettings printSettings1 = new C.PrintSettings();

            C.HeaderFooter headerFooter1 = new C.HeaderFooter() { AlignWithMargins = false };
            C.OddHeader oddHeader1 = new C.OddHeader();
            oddHeader1.Text = "&A";
            C.OddFooter oddFooter1 = new C.OddFooter();
            oddFooter1.Text = "Page &P";

            headerFooter1.Append(oddHeader1);
            headerFooter1.Append(oddFooter1);
            C.PageMargins pageMargins1 = new C.PageMargins() { Left = 0.75D, Right = 0.75D, Top = 1D, Bottom = 1D, Header = 0.5D, Footer = 0.5D };
            C.PageSetup pageSetup1 = new C.PageSetup() { PaperSize = (UInt32Value)9U, Orientation = C.PageSetupOrientationValues.Landscape };

            printSettings1.Append(headerFooter1);
            printSettings1.Append(pageMargins1);
            printSettings1.Append(pageSetup1);

            chartSpace1.Append(date19041);
            chartSpace1.Append(editingLanguage1);
            chartSpace1.Append(roundedCorners1);
            chartSpace1.Append(alternateContent1);
            chartSpace1.Append(chart1);
            chartSpace1.Append(shapeProperties2);
            chartSpace1.Append(textProperties4);
            chartSpace1.Append(printSettings1);

            chartPart1.ChartSpace = chartSpace1;
        }

        // Generates content of spreadsheetPrinterSettingsPart1.

        // Generates content of part.
        #region Binary Data
        //private string spreadsheetPrinterSettingsPart1Data = "UABEAEYAQwByAGUAYQB0AG8AcgAgACgAcgBlAGQAaQByAGUAYwB0AGUAZAAgADIAKQAAAAAAAAAAAAAAAAAAAAEEAwbcAHwDQ++AAQIACQDqCm8IZAABAA8AWAICAAEAWAIDAAEATABlAHQAdABlAHIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAABAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFBSSVbiMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYAAAAAAAQJxAnECcAABAnAAAAAAAAAACIAHwDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAAAAAAAABAAXEsDAGhDBAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAA57FLTAMAAAAFAAoA/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIgAAABTTVRKAAAAABAAeAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

        private System.IO.Stream GetBinaryDataStream(string base64String)
        {
            return new System.IO.MemoryStream(System.Convert.FromBase64String(base64String));
        }

        #endregion

    }
}
