using ClosedXML.Excel;
using MoreLinq;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Mast;
using RapReportingApi.ViewModels;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

namespace RapReportingApi.Repositories.Mast
{
    public class MastdownloadRepository : IMastdownloadRepository
    {
        private XLColor customColor = XLColor.FromArgb(r: 79, g: 129, b: 189);

        public MastdownloadRepository()
        {            
        }

        public byte[] downloadTemplate(DataTable dt, string title, string sheetname)
        {
            byte[] xls_Bytes = null;
            using (XLWorkbook wb = new XLWorkbook())
            {
                Int32 cols = dt.Columns.Count;
                Int32 rows = dt.Rows.Count;

                IXLWorksheet ws = wb.Worksheets.Add(sheetname);
                ws.Range(1, 1, 1, cols).Merge();
                ws.Range(1, 1, 1, cols).Value = title;
                ws.Range(1, 1, 1, cols).Style.Font.FontSize = 14;
                ws.Range(1, 1, 1, cols).Style.Font.Bold = true;
                ws.Range(1, 1, 1, cols).Style.Font.FontColor = XLColor.White;
                //ws.Range(1, 1, 1, cols).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                ws.Range(1, 1, 1, cols).Style.Fill.BackgroundColor = customColor;
                ws.Range(1, 1, 1, cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                ws.Cell(3, 1).InsertTable(dt);

                var rngTable = ws.Range("A3:" + Convert.ToChar(65 + (cols - 1)) + (rows + 3));
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

        //public byte[] getDownLoadClient()
        //{
        //    byte[] m_Bytes = null;
        //    IEnumerable<Clntmast> clntmast = (IEnumerable<Clntmast>)clientRepository.getClient();
        //    var query = from p in clntmast.AsEnumerable()
        //                select p;
        //    DataTable dt = query.ToDataTable();
        //    m_Bytes = this.downloadTemplate(dt, "ClientMaster", "Client Master");
        //    return m_Bytes;
        //}

    }
}