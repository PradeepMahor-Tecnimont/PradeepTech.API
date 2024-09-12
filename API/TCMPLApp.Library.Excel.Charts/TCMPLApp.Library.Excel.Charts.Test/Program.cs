// See https://aka.ms/new-console-template for more information
using TCMPLApp.Library.Excel.Charts;
using TCMPLApp.Library.Excel.Charts.Models;

//Console.WriteLine("Hello, World!");


GenerateChart();

void GenerateChart()
{
    int FutureJobsBlockEndRowTemplate = 33;
    int FutureJobsBlockEndRow = 82;

    int[] SeriesRows = { 44, 45, 46, 47, 48, 49, 63 };

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
        WorksheetName = "0225"
    };

    OpenXMLExcelChart chart = new();

    IList<WSLineChartNew> worksheetLineCharts = new List<WSLineChartNew>();

    worksheetLineCharts.Add(lineChartMetaData);

    chart.InsertChartNew(@"D:\myTemp\0221E2209\CHA1EGrp_dev.xlsx", worksheetLineCharts);




    //XXXXXXXXXXXXXXXXXXXXXXXX
    //-------------------------
    //Working Copy
    //-------------------------
    //XXXXXXXXXXXXXXXXXXXXXXXX


    //OpenXMLExcelChart chart = new();

    //IList<WSLineChart> worksheetLineCharts = new List<WSLineChart>();
    //int futureJobEndRow = 65;
    //string sheetName = "CHA1E";
    //var retVal = InitLineChartDataForSheet(sheetName, 65);

    //WSLineChart worksheetChart = new WSLineChart
    //{
    //    SeriesData = retVal.AsEnumerable<LineChartValueSeries>(),
    //    WorksheetName = sheetName,
    //    ChartTitleText = "Cost Centre Work Load Projections",
    //    ValueAxisTitleText = "Months",
    //    CategoryAxisTitleText = "Manhours",
    //    FromPosition = new ExcelCoOrdinate { Row = 120, Col = 0 },
    //    ToPosition = new ExcelCoOrdinate { Row = 160, Col = 22 }
    //};

    //worksheetLineCharts.Add(worksheetChart);

    //chart.InsertChart(@"D:\myTemp\0221E2209\0247E2210_dev.xlsx", worksheetLineCharts);

    //-------------------------
    //XXXXXXXXXXXXXXXXXXXXXXXX
    //-------------------------





    //chart.InsertChart(@"D:\myTemp\0221E2209\0215E2207.xlsx", worksheetLineCharts);

    //chart.UpdateChart(@"D:\myTemp\0221E2209\0215E2207.xlsx", worksheetLineCharts);


    //OPEN XML SDK Tool Sample
    //OpenXMLExcelChart chart = new();
    //chart.InsertChartUsingOpenSDKToolSample(@"D:\myTemp\0221E2209\0215E2207.xlsx");


    //Access DrawingsPart
    //OpenXMLExcelChart chart = new();
    //chart.GetDrawingPart(@"D:\myTemp\0221E2209\0215E2207.xlsx");


    //ExcelChartCHA1E excelChartCHA1E = new ExcelChartCHA1E();
    //excelChartCHA1E.GenerateReport(@"D:\MyTemp\0221E2209\0247E2210_dev.xlsx");





    //MemoryStream stream = new MemoryStream(File.ReadAllBytes(@"C:\Users\Upen\\downloads\\ImportHRMastersCustom-1.xlsx"));



    //var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
    //List<DictionaryItem>? employees = excelTemplate?.ImportHRMastersCustom(stream);

    //MSSample mSSample = new MSSample();
    //mSSample.GenerateChart();

    //TCMPLApp.Library.Excel.Charts.ReportWithChart reportWithChart = new TCMPLApp.Library.Excel.Charts.ReportWithChart();
    //reportWithChart.CreateExcelDoc(@"c:\mytemp\SampleReportWithChart.xlsx");

    //SampleLineChart sampleLineChart = new SampleLineChart();
    //sampleLineChart.GenerateDoc(@"D:\MyTemp\0221E2209\0221E2209 - Automation.xlsx");

    //SampleBarChart sampleBarChart = new TCMPLApp.Library.Excel.Charts.SampleBarChart();
    //sampleBarChart.CreateExcelDoc(@"D:\myTemp\ChartTest\BarChart1.xlsx");

    //SampleLineChart sampleLineChart = new SampleLineChart();
    //sampleLineChart.GenerateDoc(@"D:\MyTemp\0221E2209\0221E2209 - Automation.xlsx");

}

//LineChartValueSeries[] InitLineChartData()
//{
//    LineChartValueSeries[] lineChartData = new LineChartValueSeries[] {
//                new LineChartValueSeries{ SeriesText="Available hours (A)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$104:$V$104"},
//                new LineChartValueSeries{ SeriesText="Available hours after MOW (C)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$105:$V$105"   },
//                new LineChartValueSeries{ SeriesText="Available hours after MOW with Overtime(G) =C+(F*C)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$107:$V$107"   },
//                new LineChartValueSeries{ SeriesText="Committed hours (D)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$108:$V$108"   },
//                new LineChartValueSeries{ SeriesText="Committed hours with Expected Projects (H) = D+E ", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$109:$V$109"   },
//                new LineChartValueSeries{ SeriesText="Committed hours with Expected proj, Active (K) = D+J", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$110:$V$110"   },
//                new LineChartValueSeries{ SeriesText="Available hours after MOW with OT + Subcont (N)=G+L", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$123:$V$123"   }
//            };
//    return lineChartData;
//}

//LineChartValueSeries[] InitLineChartDataFroDevDB()
//{
//    LineChartValueSeries[] lineChartData = new LineChartValueSeries[] {
//                //new LineChartValueSeries{ SeriesText="Available hours (A)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$58:$V$58"},
//                //new LineChartValueSeries{ SeriesText="Available hours after MOW (C)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$59:$V$59"   },
//                new LineChartValueSeries{ SeriesText="Available hours after MOW with Overtime(G) =C+(F*C)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$61:$V$61"   },
//                //new LineChartValueSeries{ SeriesText="Committed hours (D)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$60:$V$60"   },
//                new LineChartValueSeries{ SeriesText="Committed hours with Expected Projects (H) = D+E ", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$62:$V$62"   },
//                new LineChartValueSeries{ SeriesText="Committed hours with Expected proj, Active (K) = D+J", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$63:$V$63"   },
//                //new LineChartValueSeries{ SeriesText="Available hours after MOW with OT + Subcont (N)=G+L", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$123:$V$123"   }
//            };
//    return lineChartData;
//}


//LineChartValueSeries[] InitLineChartDataForSheet(string sheetName, int futureJobEndRow)
//{
//    LineChartValueSeries[] lineChartData = new LineChartValueSeries[] {
//                new LineChartValueSeries{ SeriesText="Available hours (A)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula="CHA1E!$E$76:$V$76" }
//                //,
//                //new LineChartValueSeries{ SeriesText="Available hours after MOW (C)", CategoryFormula="CHA1E!$E$9:$V$9", ValueFormula=string.Format("{0}!$E${1}:$V${1}",sheetName,(45+futureJobEndRow-33)) },
//                //new LineChartValueSeries { SeriesText = "Available hours after MOW with Overtime(G) =C+(F*C)", CategoryFormula = "CHA1E!$E$9:$V$9", ValueFormula=string.Format("{0}!$E${1}:$V${1}",sheetName,(46+futureJobEndRow-33)) },
//                //new LineChartValueSeries { SeriesText = "Committed hours (D)", CategoryFormula = "CHA1E!$E$9:$V$9", ValueFormula=string.Format("{0}!$E${1}:$V${1}",sheetName,(47+futureJobEndRow-33)) },
//                //new LineChartValueSeries { SeriesText = "Committed hours with Expected Projects (H) = D+E ", CategoryFormula = "CHA1E!$E$9:$V$9", ValueFormula=string.Format("{0}!$E${1}:$V${1}",sheetName,(48+futureJobEndRow-33)) },
//                //new LineChartValueSeries { SeriesText = "Committed hours with Expected proj, Active (K) = D+J", CategoryFormula = "CHA1E!$E$9:$V$9", ValueFormula=string.Format("{0}!$E${1}:$V${1}",sheetName,(49+futureJobEndRow-33)) },
//                //new LineChartValueSeries { SeriesText = "Available hours after MOW with OT + Subcont (N)=G+L", CategoryFormula = "CHA1E!$E$9:$V$9", ValueFormula=string.Format("{0}!$E${1}:$V${1}",sheetName,(63+futureJobEndRow-33)) },
//            };
//return lineChartData;
//}
