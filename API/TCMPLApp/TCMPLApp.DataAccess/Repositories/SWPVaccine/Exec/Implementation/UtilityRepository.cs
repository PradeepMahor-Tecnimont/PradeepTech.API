using System;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;
using Microsoft.Extensions.Configuration;
using TCMPLApp.Domain.Models;
using System.Data;
using ClosedXML.Excel;
using System.IO;
using System.Collections.Generic;
using TCMPLApp.DataAccess.Base;
using DocumentFormat.OpenXml.Drawing.Charts;
using DataTable = System.Data.DataTable;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class UtilityRepository : ExecRepository, IUtilityRepository
    {
        public UtilityRepository(IConfiguration configuration, ExecDBContext execDBContext) : base(execDBContext)
        {
        }

        public async Task<ProcedureResult> SendEmail(string empNo, string win_Uid, string apprStatus)
        {
            var obj = new { p_empno = empNo, p_appr = win_Uid, p_appr_status = apprStatus };
            var retVal = await ExecuteProc("selfservice.swp.send_mail", obj);
            return retVal;
        }

        //public byte[] ExcelDownload(DataTable dt, string ReportTitle, string Sheetname)
        //{
        //    byte[] xls_Bytes = null;
        //    using (XLWorkbook wb = new XLWorkbook())
        //    {
        //        Int32 cols = dt.Columns.Count;
        //        Int32 rows = dt.Rows.Count;

        // IXLWorksheet ws = wb.Worksheets.Add(Sheetname); ws.Range(1, 1, 1, cols).Merge();
        // ws.Range(1, 1, 1, cols).Value = ReportTitle; ws.Range(1, 1, 1, cols).Style.Font.FontSize
        // = 16; ws.Range(1, 1, 1, cols).Style.Font.Bold = true; //ws.Range(1, 1, 1,
        // cols).Style.Fill.BackgroundColor = XLColor.CornflowerBlue; ws.Range(1, 1, 1,
        // cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

        // ws.Cell(3, 1).InsertTable(dt);

        // var rngTable = ws.Range("A3:" + Convert.ToChar(65 + (cols - 1)) + (rows + 3));
        // rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
        // rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
        // rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
        // rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
        // rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
        // rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
        // rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
        // rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

        // ws.Tables.FirstOrDefault().SetShowAutoFilter(false); ws.Columns().AdjustToContents();
        // wb.CalculateMode = XLCalculateMode.Auto;

        // using (MemoryStream ms = new MemoryStream()) { wb.SaveAs(ms); byte[] buffer =
        // ms.GetBuffer(); long length = ms.Length; xls_Bytes = ms.ToArray(); }

        //        wb.Dispose();
        //    }
        //    return xls_Bytes;
        //}

        public byte[] ExcelDownloadFromIEnumerable<T>(IEnumerable<T> dt, string ReportTitle, string Sheetname)
        {
            byte[] xls_Bytes = null;
            using (XLWorkbook wb = new XLWorkbook())
            {
                var columns = (dt.GetType().GetGenericArguments()[0]).GetProperties();

                Int32 cols = columns.Count();
                Int32 rows = dt.ToList().Count;

                IXLWorksheet ws = wb.Worksheets.Add(Sheetname);
                if (cols < 20)
                {
                    ws.Range(1, 1, 1, cols).Value = ReportTitle;
                    ws.Range(1, 1, 1, cols).Style.Font.FontSize = 16;
                    ws.Range(1, 1, 1, cols).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, cols).Merge();
                    ws.Range(1, 1, 1, cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                }
                else
                {
                    ws.Range(1, 1, 1, 1).Value = ReportTitle;
                    ws.Range(1, 1, 1, 1).Style.Font.FontSize = 16;
                    ws.Range(1, 1, 1, 1).Style.Font.Bold = true;
                }
                ws.Cell(3, 1).InsertTable(dt);

                string endColAlphabets = string.Empty;

                if (cols <= 26)
                {
                    endColAlphabets = Convert.ToChar(65 + (cols - 1)).ToString();
                }
                else
                {
                    var modulusCols = cols % 26;
                    var absModulusCols = modulusCols == 0 ? 0 : (modulusCols - 1);

                    string modulusColsAlphabet = Convert.ToChar(65 + absModulusCols).ToString();
                    decimal columnGroups = cols / 26;

                    int absoluteCol = int.Parse(Math.Floor((columnGroups)).ToString());

                    string absoluteColAlphabet = Convert.ToChar(65 + absoluteCol - 1).ToString();
                    endColAlphabets = absoluteColAlphabet + modulusColsAlphabet;
                }

                var rngTable = ws.Range("A3:" + endColAlphabets + (rows + 3));
                rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
                rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
                rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
                rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

                ws.Tables.FirstOrDefault().SetShowAutoFilter(false);
                ws.Columns().AdjustToContents();
                wb.CalculateMode = XLCalculateMode.Auto;

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    xls_Bytes = ms.ToArray();
                }

                wb.Dispose();
            }
            return xls_Bytes;
        }

        public byte[] ExcelPivotDownloadFromIEnumerable<T>(IEnumerable<T> dt, string ReportTitle, string DataSheetname, string PivotSheetName, string[] ColumnLabels, string[] RowLabels, string[] ValuesLabelCount, string[] ValuesLabelSum = null)
        {
            byte[] xls_Bytes = null;
            using (XLWorkbook wb = new XLWorkbook())
            {
                var columns = (dt.GetType().GetGenericArguments()[0]).GetProperties();

                Int32 cols = columns.Count();
                Int32 rows = dt.ToList().Count;

                IXLWorksheet ws = wb.Worksheets.Add(DataSheetname);
                if (cols < 20)
                {
                    ws.Range(1, 1, 1, cols).Value = ReportTitle;
                    ws.Range(1, 1, 1, cols).Style.Font.FontSize = 16;
                    ws.Range(1, 1, 1, cols).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, cols).Merge();
                    ws.Range(1, 1, 1, cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                }
                else
                {
                    ws.Range(1, 1, 1, 1).Value = ReportTitle;
                    ws.Range(1, 1, 1, 1).Style.Font.FontSize = 16;
                    ws.Range(1, 1, 1, 1).Style.Font.Bold = true;
                }
                var table = ws.Cell(3, 1).InsertTable(dt);

                var rngTable = ws.Range("A3:" + Convert.ToChar(65 + (cols - 1)) + (rows + 3));
                rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
                rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
                rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
                rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

                var dataRange = table.RangeUsed();
                var ptSheet = wb.Worksheets.Add(PivotSheetName);
                var pt = ptSheet.PivotTables.Add(PivotSheetName, ptSheet.Cell(1, 1), dataRange);

                //System.Diagnostics.Debug.WriteLine(dataRange);

                foreach (var rowLabel in RowLabels.DefaultIfEmpty())
                {
                    pt.RowLabels.Add(rowLabel);
                }
                if (ColumnLabels?.Length > 0)
                {
                    foreach (var columnLabel in ColumnLabels.DefaultIfEmpty())
                    {
                        pt.ColumnLabels.Add(columnLabel);
                    }
                }
                if (ValuesLabelCount?.Length > 0)
                {
                    foreach (var countOfLabel in ValuesLabelCount.DefaultIfEmpty())
                    {
                        pt.Values.Add(countOfLabel).SetSummaryFormula(XLPivotSummary.Count);
                    }
                }

                if (ValuesLabelSum?.Length > 0)
                {
                    foreach (var countOfLabel in ValuesLabelSum.DefaultIfEmpty())
                    {
                        pt.Values.Add(countOfLabel).SetSummaryFormula(XLPivotSummary.Sum);
                    }
                }
                ws.Tables.FirstOrDefault().SetShowAutoFilter(false);
                ws.Columns().AdjustToContents();
                wb.CalculateMode = XLCalculateMode.Auto;

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    xls_Bytes = ms.ToArray();
                }

                wb.Dispose();
            }
            return xls_Bytes;
        }

        public byte[] ExcelDownloadFromDataTable(DataTable dt, string ReportTitle, string Sheetname)
        {
            byte[] xls_Bytes = null;
            using (XLWorkbook wb = new XLWorkbook())
            {
                // var columns = (dt.GetType().GetGenericArguments()[0]).GetProperties();

                Int32 cols = dt.Columns.Count;
                Int32 rows = dt.Rows.Count;

                IXLWorksheet ws = wb.Worksheets.Add(Sheetname);
                if (cols < 20)
                {
                    ws.Range(1, 1, 1, cols).Value = ReportTitle;
                    ws.Range(1, 1, 1, cols).Style.Font.FontSize = 16;
                    ws.Range(1, 1, 1, cols).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, cols).Merge();
                    ws.Range(1, 1, 1, cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                }
                else
                {
                    ws.Range(1, 1, 1, 1).Value = ReportTitle;
                    ws.Range(1, 1, 1, 1).Style.Font.FontSize = 16;
                    ws.Range(1, 1, 1, 1).Style.Font.Bold = true;
                }
                ws.Cell(3, 1).InsertTable(dt);

                string endColAlphabets = string.Empty;

                if (cols <= 26)
                {
                    endColAlphabets = Convert.ToChar(65 + (cols - 1)).ToString();
                }
                else
                {
                    var modulusCols = cols % 26;
                    var absModulusCols = modulusCols == 0 ? 0 : (modulusCols - 1);

                    string modulusColsAlphabet = Convert.ToChar(65 + absModulusCols).ToString();
                    decimal columnGroups = cols / 26;

                    int absoluteCol = int.Parse(Math.Floor((columnGroups)).ToString());

                    string absoluteColAlphabet = Convert.ToChar(65 + absoluteCol - 1).ToString();
                    endColAlphabets = absoluteColAlphabet + modulusColsAlphabet;
                }

                var rngTable = ws.Range("A3:" + endColAlphabets + (rows + 3));
                rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
                rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
                rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
                rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
                rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

                ws.Tables.FirstOrDefault().SetShowAutoFilter(false);
                ws.Columns().AdjustToContents();
                wb.CalculateMode = XLCalculateMode.Auto;

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    xls_Bytes = ms.ToArray();
                }

                wb.Dispose();
            }
            return xls_Bytes;
        }


        public byte[] ExcelDownloadWithMultipleSheets(List<ExcelSheetAttributes> sheetAttributes)
        {
            byte[] xls_Bytes = null;
            using (XLWorkbook wb = new XLWorkbook())
            {
                // var columns = (dt.GetType().GetGenericArguments()[0]).GetProperties();

                foreach (ExcelSheetAttributes sheetAttribute in sheetAttributes)
                {


                    Int32 cols = sheetAttribute.SheetData.Columns.Count;
                    Int32 rows = sheetAttribute.SheetData.Rows.Count;

                    IXLWorksheet ws = wb.Worksheets.Add(sheetAttribute.SheetName);
                    if (cols < 20)
                    {
                        ws.Range(1, 1, 1, cols).Value = sheetAttribute.SheetReportTitle;
                        ws.Range(1, 1, 1, cols).Style.Font.FontSize = 16;
                        ws.Range(1, 1, 1, cols).Style.Font.Bold = true;
                        ws.Range(1, 1, 1, cols).Merge();
                        ws.Range(1, 1, 1, cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    }
                    else
                    {
                        ws.Range(1, 1, 1, 1).Value = sheetAttribute.SheetReportTitle;
                        ws.Range(1, 1, 1, 1).Style.Font.FontSize = 16;
                        ws.Range(1, 1, 1, 1).Style.Font.Bold = true;
                    }
                    ws.Cell(3, 1).InsertTable(sheetAttribute.SheetData);

                    string endColAlphabets = string.Empty;

                    if (cols <= 26)
                    {
                        endColAlphabets = Convert.ToChar(65 + (cols - 1)).ToString();
                    }
                    else
                    {
                        var modulusCols = cols % 26;
                        var absModulusCols = modulusCols == 0 ? 0 : (modulusCols - 1);

                        string modulusColsAlphabet = Convert.ToChar(65 + absModulusCols).ToString();
                        decimal columnGroups = cols / 26;

                        int absoluteCol = int.Parse(Math.Floor((columnGroups)).ToString());

                        string absoluteColAlphabet = Convert.ToChar(65 + absoluteCol - 1).ToString();
                        endColAlphabets = absoluteColAlphabet + modulusColsAlphabet;
                    }

                    var rngTable = ws.Range("A3:" + endColAlphabets + (rows + 3));
                    rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
                    rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
                    rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
                    rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
                    rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
                    rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

                    ws.Tables.FirstOrDefault().SetShowAutoFilter(false);
                    ws.Columns().AdjustToContents();
                }

                wb.CalculateMode = XLCalculateMode.Auto;

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    xls_Bytes = ms.ToArray();
                }

                wb.Dispose();
            }
            return xls_Bytes;
        }


    }
}