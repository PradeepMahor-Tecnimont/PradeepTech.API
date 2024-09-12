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
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using FastMember;
using DocumentFormat.OpenXml;
using System.Text.RegularExpressions;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class OpenXMLUtilityRepository : ExecRepository, IOpenXMLUtilityRepository
    {        
        public OpenXMLUtilityRepository(IConfiguration configuration, ExecDBContext execDBContext) : base(execDBContext)
        {            

        }

        public byte[] ExcelDownloadFromDataTable<T>(IEnumerable<T> lt,
                                                    string reportTitle,
                                                    string templateName,
                                                    string fileName,
                                                    string sheetName,
                                                    int[] columnGetTotals,
                                                    int[] columnSetTotals,
                                                    int[] rowColumnSetTotals,
                                                    string[] multipleColumnGetTotals,
                                                    int[] multipleColumnSetTotals,
                                                    int[] rowMultipleColumnSetTotals)
        {
            byte[] xls_Bytes = null;                       

            //copy template to new file
            File.Copy(templateName, fileName, true);

            using (SpreadsheetDocument doc = SpreadsheetDocument.Open(fileName, true))
            {
                WorkbookPart workbookPart = doc.WorkbookPart;
                Sheet sheet = workbookPart.Workbook.Descendants<Sheet>().Where(sht => sht.Name == sheetName).FirstOrDefault();
                WorksheetPart worksheetPart = (WorksheetPart)workbookPart.GetPartById(sheet.Id);
                SheetData sheetData = worksheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();

                //create datatable
                DataTable dt = convert2DataTable(lt);

                //generate file
                ExportDataTable(dt, sheetData, columnGetTotals, columnSetTotals, rowColumnSetTotals, multipleColumnGetTotals, multipleColumnSetTotals, rowMultipleColumnSetTotals);

                var tableDefinitionPart = worksheetPart.TableDefinitionParts.Where(table => table.Table.DisplayName == "Table1").FirstOrDefault();
                if (tableDefinitionPart != null)
                {
                    UpdateTableDefinitionPart(tableDefinitionPart, lt.Count()+1);
                }

                doc.Save();
                workbookPart.Workbook.WorkbookProperties.RefreshAllConnections = true;
                sheet = workbookPart.Workbook.Descendants<Sheet>().Where(sht => sht.Name == "QuerySheet").FirstOrDefault();
                worksheetPart = (WorksheetPart)workbookPart.GetPartById(sheet.Id);
                tableDefinitionPart = worksheetPart.TableDefinitionParts.Where(table => table.Table.DisplayName == "Table1_2").FirstOrDefault();
                tableDefinitionPart.Table.Reload();
                doc.Close();    
                
                xls_Bytes = File.ReadAllBytes(fileName);
            }

            return xls_Bytes;
        }        

        private void ExportDataTable(DataTable exportData, SheetData sheetData, int[] columnGetTotals, int[] columnSetTotals, int[] rowSetTotals, string[] multipleColumnGetTotals, int[] multipleColumnSetTotals, int[] rowMultipleColumnSetTotals)
        {
            //array variable for array columnGetTotals
            decimal[] aColumnGetTotals = new decimal[columnGetTotals.Length];
            decimal[] aMultipleColumnGetTotals = new decimal[multipleColumnGetTotals.Length];            
            int aColumnGetTotalsCounter;
            //int aMultipleColumnGetTotalsCounter;

            //add column names to the first row  
            Row header = new Row();
            header.RowIndex = (UInt32)1;                       

            foreach (DataColumn column in exportData.Columns)
            {
                Cell headerCell = createTextCell(exportData.Columns.IndexOf(column) + 1, Convert.ToInt32(header.RowIndex.Value), column.ColumnName);
                header.AppendChild(headerCell);
            }

            sheetData.AppendChild(header);

            //loop through each data row  
            DataRow contentRow;
            int startRow = 2;
            for (int i = 0; i < exportData.Rows.Count; i++)
            {
                contentRow = exportData.Rows[i];
                sheetData.AppendChild(createContentRow(contentRow, i + startRow));

                //calculate totals for column numbers in columnTotals
                aColumnGetTotalsCounter = -1;
                foreach (var columnGetTotal in columnGetTotals)
                {
                    aColumnGetTotalsCounter++;
                    aColumnGetTotals[aColumnGetTotalsCounter] = aColumnGetTotals[aColumnGetTotalsCounter] + (decimal)exportData.Rows[i][columnGetTotal-1];
                    if (i == exportData.Rows.Count - 1)
                    {
                        sheetData.AppendChild(createContentRow4Formula(columnSetTotals[aColumnGetTotalsCounter], i + startRow + rowSetTotals[aColumnGetTotalsCounter], aColumnGetTotals[aColumnGetTotalsCounter]));
                    }
                }

                //calculate totals for column numbers in multipleColumnTotals
                //aMultipleColumnGetTotalsCounter = -1;
                //foreach (var multipleColumnGetTotal in multipleColumnGetTotals)
                //{
                //    aMultipleColumnGetTotalsCounter++;
                //    multipleColumnGetTotal.Split(",");
                //    aColumnGetTotals[aMultipleColumnGetTotalsCounter] = aColumnGetTotals[aMultipleColumnGetTotalsCounter] + (decimal)exportData.Rows[i][multipleColumnGetTotal - 1];
                //    if (i == exportData.Rows.Count - 1)
                //    {
                //        sheetData.AppendChild(createContentRow4Formula(multipleColumnSetTotals[aMultipleColumnGetTotalsCounter], i + startRow + rowMultipleColumnSetTotals[aMultipleColumnGetTotalsCounter], aColumnGetTotals[aColumnGetTotalsCounter]));
                //    }
                //}                
            }
        }

        #region IEnumerable to Datatable
        private DataTable convert2DataTable<T>(IEnumerable<T> lt)
        {
            //create datatable
            DataTable dt = new DataTable();
            using (var reader = ObjectReader.Create(lt))
            {
                dt.Load(reader);
            }
            return dt;
        }
        #endregion

        #region Write into excel

        private Cell createTextCell(int columnIndex, int rowIndex, object cellValue)
        {
            Cell cell = new Cell();

            cell.DataType = CellValues.InlineString;
            cell.CellReference = getColumnName(columnIndex) + rowIndex;

            InlineString inlineString = new InlineString();
            Text t = new Text();

            t.Text = cellValue.ToString();
            inlineString.AppendChild(t);
            cell.AppendChild(inlineString);

            return cell;
        }

        private Row createContentRow(DataRow dataRow, int rowIndex)
        {
            Row row = new Row
            {
                RowIndex = (UInt32)rowIndex
            };

            for (int i = 0; i < dataRow.Table.Columns.Count; i++)
            {
                Cell dataCell = createTextCell(i + 1, rowIndex, dataRow[i]);
                row.AppendChild(dataCell);
            }

            return row;
        }

        private string getColumnName(int columnIndex)
        {
            int dividend = columnIndex;
            string columnName = String.Empty;
            int modifier;

            while (dividend > 0)
            {
                modifier = (dividend - 1) % 26;
                columnName = Convert.ToChar(65 + modifier).ToString() + columnName;
                dividend = (int)((dividend - modifier) / 26);
            }

            return columnName;
        }

        #endregion

        #region Formulae

        private Row createContentRow4Formula(int columnIndex, int rowIndex, decimal cellValue)
        {
            Row row = new Row
            {
                RowIndex = (UInt32)rowIndex
            };

            Cell dataCell = createTextCell4Formula(columnIndex, rowIndex, cellValue);
            row.AppendChild(dataCell);
            return row;

        }

        private Cell createTextCell4Formula(int columnIndex, int rowIndex, decimal cellValue)
        {
            Cell cell = new Cell();

            cell.DataType = CellValues.InlineString;
            cell.CellReference = getColumnName(columnIndex) + rowIndex;

            InlineString inlineString = new InlineString();
            Text t = new Text();

            t.Text = cellValue.ToString();
            inlineString.AppendChild(t);
            cell.AppendChild(inlineString);

            return cell;
        }

        #endregion

        #region Resize table
        public void UpdateTableDefinitionPart(TableDefinitionPart tableDefinitionPart, int rowsCount)
        {
            var tableSize = tableDefinitionPart.Table.Reference;
            string newSize = UpdateRowsTo(tableSize, rowsCount);
            tableDefinitionPart.Table.Reference = newSize;
            tableDefinitionPart.Table.AutoFilter.Reference = newSize;
        }

        public string UpdateRowsTo(string tableReference, int rows)
        {
            string result = tableReference.Trim();
            var parts = result.Split(':');
            Regex regex = new Regex("[a-zA-Z]+");
            Match match = regex.Match(parts[1]);
            result = $"{parts[0]}:{match.Value}{rows}";
            return result;
        }

        #endregion
    }
}