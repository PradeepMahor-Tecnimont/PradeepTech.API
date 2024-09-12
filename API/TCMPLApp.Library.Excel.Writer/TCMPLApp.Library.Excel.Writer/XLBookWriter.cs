using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Reflection;
using TCMPLApp.Library.Excel.Writer.Model;

namespace TCMPLApp.Library.Excel.Writer
{
    public static class XLBookWriter
    {
        private const string ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        public static void ReplaceDataInXLTable<T>(SpreadsheetDocument XLSpreadSheet, string XLSheetName, string XLTableName, IEnumerable<T> data)
        {


            Sheet? sheet = XLSpreadSheet.WorkbookPart?.Workbook.Descendants<Sheet>().Where(sht => sht.Name == XLSheetName).FirstOrDefault();

            if (sheet == null)
            {
                throw new Exception("Worksheet not found");

            }
            var workSheetPart = (WorksheetPart)XLSpreadSheet.WorkbookPart?.GetPartById(sheet.Id?.ToString() ?? "");


            var tableDef = GetXLTableDefinition(workSheetPart, XLTableName);

            SheetData sheetData = workSheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();



            var xlTableDataRow = sheetData.Elements<Row>().Where(r => r.RowIndex == tableDef.StartRow + 1).FirstOrDefault();

            var cellStyles = GetCellStyles(xlTableDataRow, tableDef);

            for (int i = tableDef.StartRow + 1; i <= tableDef.EndRow; i++)
            {
                var rowToDel = sheetData.Elements<Row>().Where(r => r.RowIndex == i).FirstOrDefault();
                rowToDel.Remove();
            }

            PropertyInfo[] props = data.FirstOrDefault().GetType().GetProperties();
            int rowIndex = tableDef.StartRow;

            foreach (var dataRow in data)
            {
                rowIndex++;



                for (int j = 0; j < dataRow.GetType().GetProperties().Length; j++)
                {
                    // insert value in cell with dataType (String, Int, decimal, datatime)

                    Type dataRowType = dataRow.GetType();
                    PropertyInfo prop = dataRowType.GetProperty(props[j].Name);
                    object obj = prop.GetValue(dataRow, null);

                    string cellReference = (tableDef.StartCol + j).ToString() + "," + rowIndex.ToString();

                    cellReference = ToExcelCoordinates(cellReference);

                    UInt32Value cellStyleIndex;


                    if (j + 1 > cellStyles.Length)
                        cellStyleIndex = 0;
                    else
                        cellStyleIndex = cellStyles[j];

                    {
                        var cell = InsertCellInWorksheet(cellReference, (uint)rowIndex, workSheetPart);

                        var propType = props[j].PropertyType;
                        cell.StyleIndex = cellStyleIndex;

                        if (obj == null)
                        {
                            continue;
                        }

                        if (propType == typeof(string))
                        {
                            cell.CellValue = new CellValue(obj.ToString());
                            cell.DataType = new EnumValue<CellValues>(CellValues.String);
                        }
                        else if (propType == typeof(DateTime))
                        {
                            cell.DataType = new EnumValue<CellValues>(CellValues.Number);

                            if (obj != DBNull.Value)
                            {
                                System.Globalization.CultureInfo cultureinfo = new System.Globalization.CultureInfo("en-US");
                                DateTime valueDate = (DateTime)obj;
                                string valueString = valueDate.ToOADate().ToString(cultureinfo);
                                cell.CellValue = new CellValue(valueString);

                            }

                        }
                        else if (propType == typeof(long) || propType == typeof(int) || propType == typeof(decimal) || propType == typeof(short) || propType == typeof(Int32))
                        {

                            cell.DataType = new EnumValue<CellValues>(CellValues.Number);
                            cell.CellValue = new CellValue(obj.ToString());
                        }
                        else
                        {
                            cell.DataType = new EnumValue<CellValues>(CellValues.String);
                            cell.CellValue = new CellValue(obj.ToString());
                        }
                    }
                }
                if (rowIndex % 100 == 0)
                {
                    continue;
                }
            }

            RemoveExtraRowsInTable(sheetData, rowIndex + 1, tableDef);

            var endColReference = ToExcelCoordinates(tableDef.EndCol + "," + rowIndex);

            ResizeXLTable(workSheetPart, XLTableName, endColReference);

            workSheetPart.Worksheet.Save();
            XLSpreadSheet.WorkbookPart.Workbook.Save();
        }


        public static void AppendDataInExcel<T>(SpreadsheetDocument XLSpreadSheet, string XLSheetName, string XLTableName, IEnumerable<T> data)
        {

            Sheet? sheet = XLSpreadSheet.WorkbookPart?.Workbook.Descendants<Sheet>().Where(sht => sht.Name == XLSheetName).FirstOrDefault();

            if (sheet == null)
            {
                throw new Exception("Worksheet not found");

            }
            var workSheetPart = (WorksheetPart)XLSpreadSheet.WorkbookPart?.GetPartById(sheet.Id?.ToString() ?? "");

            var tableDef = GetXLTableDefinition(workSheetPart, XLTableName);
            SheetData sheetData = workSheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();



            var xlTableDataRow = sheetData.Elements<Row>().Where(r => r.RowIndex == tableDef.StartRow + 1).FirstOrDefault();

            var cellStyles = GetCellStyles(xlTableDataRow, tableDef);

            for (int i = tableDef.StartRow + 1; i <= tableDef.EndRow; i++)
            {
                var rowToDel = sheetData.Elements<Row>().Where(r => r.RowIndex == i).FirstOrDefault();
                rowToDel.Remove();
            }

            PropertyInfo[] props = data.FirstOrDefault().GetType().GetProperties();
            int rowIndex = tableDef.StartRow;

            foreach (var dataRow in data)
            {
                rowIndex++;

                DocumentFormat.OpenXml.Spreadsheet.Row newRow = new DocumentFormat.OpenXml.Spreadsheet.Row() { RowIndex = Convert.ToUInt32(rowIndex) };


                //Row sheetRow = new Row() { RowIndex = Convert.ToUInt32(rowIndex) };

                for (int j = 0; j < dataRow.GetType().GetProperties().Length; j++)
                {
                    // insert value in cell with dataType (String, Int, decimal, datatime)

                    Type dataRowType = dataRow.GetType();
                    PropertyInfo prop = dataRowType.GetProperty(props[j].Name);
                    object obj = prop.GetValue(dataRow, null);

                    string cellReference = (tableDef.StartCol + j).ToString() + "," + rowIndex.ToString();

                    cellReference = ToExcelCoordinates(cellReference);
                    UInt32Value? cellStyleIndex = null;

                    if (j + 1 <= cellStyles.Length)
                        cellStyleIndex = cellStyles[j] as UInt32Value;

                    Cell cell = new Cell();

                    cell.StyleIndex = cellStyleIndex;
                    cell.CellReference = cellReference;

                    if (obj == null)
                        continue;
                    var valueType = obj.GetType();

                    if (valueType == typeof(string))
                    {
                        
                        cell.CellValue = new CellValue(obj.ToString()); 
                        cell.DataType = new EnumValue<CellValues>(CellValues.String);
                    }
                    else if (valueType == typeof(DateTime))
                    {
                        cell.DataType = new EnumValue<CellValues>(CellValues.Number);

                            System.Globalization.CultureInfo cultureinfo = new System.Globalization.CultureInfo("en-US");
                            DateTime valueDate = (DateTime)obj;
                            string valueString = valueDate.ToOADate().ToString(cultureinfo);
                            cell.CellValue = new CellValue(valueString);

                    }
                    else if (valueType == typeof(long) || valueType == typeof(int) || valueType == typeof(decimal) || valueType == typeof(short) || valueType == typeof(Int32))
                    {

                        cell.DataType = new EnumValue<CellValues>(CellValues.Number);
                        cell.CellValue = new CellValue(obj.ToString());
                    }
                    else
                    {
                        cell.DataType = new EnumValue<CellValues>(CellValues.String);
                        cell.CellValue = new CellValue(obj.ToString());
                    }


                    newRow.AppendChild(cell);

                }
                sheetData.Append(newRow);
                //_worksheetPart.Worksheet.Save();
                if (rowIndex % 100 == 0)
                {
                    continue;
                }
            }
            //    _worksheetPart.Worksheet.Save();

            //RemoveExtraRowsInTable(rowIndex + 1, tableDef);

            var endColReference = ToExcelCoordinates(tableDef.EndCol + "," + rowIndex);
            ResizeXLTable(workSheetPart, XLTableName, endColReference);
            workSheetPart.Worksheet.Save();

        }

        public static void SetCellValue(SpreadsheetDocument XLSpreadSheet, string XLSheetName, string XLCellAddress, object XLCellValue)
        {

            Sheet? sheet = XLSpreadSheet.WorkbookPart?.Workbook.Descendants<Sheet>().Where(sht => sht.Name == XLSheetName).FirstOrDefault();

            if (sheet == null)
            {
                throw new Exception("Worksheet not found");

            }
            var workSheetPart = (WorksheetPart)XLSpreadSheet.WorkbookPart?.GetPartById(sheet.Id?.ToString() ?? "");


            var cell = InsertCellInWorksheet(XLCellAddress, (uint)int.Parse(ToNumericCoordinates(XLCellAddress).Split(",")[1]), workSheetPart);
            if (cell != null) { cell.RemoveAllChildren(); }
            AssignValueToCell(XLSpreadSheet, cell, XLCellValue);

        }






        private static XLTableCoOrdinates GetXLTableDefinition(WorksheetPart XLWorkSheetPart, string XLTableName)
        {

            TableDefinitionPart? tableDefinitionPart = XLWorkSheetPart.TableDefinitionParts.FirstOrDefault(r => r.Table.Name == XLTableName);
            string tableReference = string.Empty;

            if (tableDefinitionPart != null)
            {
                tableReference = tableDefinitionPart?.Table.Reference?.Value ?? "";

            }
            else throw new Exception("XLS002-Table definition not found.");


            string startColRow = ToNumericCoordinates(tableReference.Split(":")[0] ?? "");

            string endColRow = ToNumericCoordinates(tableReference.Split(":")[1] ?? "");

            XLTableCoOrdinates xlTableCoOrdinates = new XLTableCoOrdinates
            {
                ReferenceName = tableReference,
                StartCol = int.Parse(startColRow.Split(",")[0]),
                StartRow = int.Parse(startColRow.Split(",")[1]),
                EndCol = int.Parse(endColRow.Split(",")[0]),
                EndRow = int.Parse(endColRow.Split(",")[1])
            };

            return xlTableCoOrdinates;
        }

        private static string ToExcelCoordinates(string coordinates)
        {
            string first = coordinates.Substring(0, coordinates.IndexOf(','));
            int i = int.Parse(first);
            string second = coordinates.Substring(first.Length + 1);

            string str = string.Empty;
            while (i > 0)
            {
                str = ALPHABET[(i - 1) % 26] + str;
                i /= 26;
            }

            return str + second;
        }

        private static string ToExcelColumnName(int colNumber)
        {
            string str = string.Empty;
            int i = colNumber;
            while (i > 0)
            {
                str = ALPHABET[(i - 1) % 26] + str;
                i /= 26;
            }
            return str;
        }
        private static string ToNumericCoordinates(string coordinates)
        {
            string first = string.Empty;
            string second = string.Empty;

            CharEnumerator ce = coordinates.GetEnumerator();
            while (ce.MoveNext())
                if (char.IsLetter(ce.Current))
                    first += ce.Current;
                else
                    second += ce.Current;

            int i = 0;
            ce = first.GetEnumerator();
            while (ce.MoveNext())
                i = (26 * i) + ALPHABET.IndexOf(ce.Current) + 1;

            string str = i.ToString();
            return str + "," + second;
        }

        private static UInt32Value[] GetCellStyles(OpenXmlElement xlTableRow, XLTableCoOrdinates tableDef)
        {
            List<UInt32Value> cellStyles = new List<UInt32Value>();

            foreach (var cell in xlTableRow.Elements<Cell>())
            {
                var cellNumericRef = ToNumericCoordinates(cell.CellReference?.ToString() ?? "");
                var cellRow = int.Parse(cellNumericRef.Split(",")[1]);
                var cellCol = int.Parse(cellNumericRef.Split(",")[0]);
                if (tableDef.StartCol <= cellCol && cellCol <= tableDef.EndCol && tableDef.StartRow <= cellRow && cellRow <= tableDef.EndRow)
                {
                    cellStyles.Add(cell.StyleIndex ?? 0);
                }

            }
            return cellStyles.ToArray();
        }

        private static Cell InsertCellInWorksheet(string cellReference, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();

            // If the worksheet does not contain a row with the specified row index, insert one.
            Row newRow;
            Row? refRow = null;
            //if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
            //{
            //    newRow = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            //}
            //else
            //{
            //    newRow = new Row() { RowIndex = rowIndex };

            //    refRow = sheetData.Elements<Row>().Where(r => (r.RowIndex ?? 0) > rowIndex).FirstOrDefault();
            //    //sheetData.Append(row);
            //    //sheetData.InsertAt(newRow, (int)rowIndex-1);
            //    sheetData.InsertBefore(newRow, refRow);
            //}

            refRow = sheetData?.Elements<Row>().Where(r => (r.RowIndex ?? 0) >= rowIndex).FirstOrDefault();
            if ((refRow?.RowIndex ?? 0) == rowIndex)
            {
                newRow = refRow;
            }
            else
            {
                newRow = new Row() { RowIndex = rowIndex };
                sheetData.InsertBefore(newRow, refRow);
            }

            Cell newCell;
            Cell? refCell;
            int newCellColNum = int.Parse((ToNumericCoordinates(cellReference)).Split(",")[0]);

            refCell = newRow?.Elements<Cell>().Where(c => int.Parse(ToNumericCoordinates(c.CellReference?.Value ?? "").Split(",")[0]) >= newCellColNum).FirstOrDefault();

            if (refCell?.CellReference?.Value == cellReference)
                return refCell;
            else
                newCell = new Cell() { CellReference = cellReference };

            newRow?.InsertBefore(newCell, refCell);

            return newCell;

            //// If there is not a cell with the specified column name, insert one.  
            //if (newRow.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).Count() > 0)
            //{
            //    return newRow.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            //}
            //else
            //{
            //    //Cells must be in sequential order according to CellReference.Determine where to insert the new cell.
            //    Cell refCell = null;
            //    foreach (Cell cell in newRow.Elements<Cell>())
            //    {
            //        if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
            //        {
            //            refCell = cell;
            //            break;
            //        }
            //    }

            //    Cell newCell = new Cell() { CellReference = cellReference };
            //    newRow.InsertBefore(newCell, refCell);

            //    worksheet.Save();
            //    return newCell;
            //}
        }


        private static void RemoveExtraRowsInTable(SheetData sheetData, int StartRowIndex, XLTableCoOrdinates xlTableCoOrdinates)
        {

            for (int i = StartRowIndex; i <= xlTableCoOrdinates.EndRow; i++)
            {
                var xlTableDataRow = sheetData.Elements<Row>().Where(r => r.RowIndex == i).FirstOrDefault();
                for (int j = xlTableCoOrdinates.StartCol; j <= xlTableCoOrdinates.EndCol; j++)
                {
                    var cellReference = ToExcelCoordinates(j + "," + i);
                    var cell = xlTableDataRow.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
                    cell.Remove();
                }
            }


        }


        private static void ResizeXLTable(WorksheetPart worksheetPart, string XLTableName, string EndColReference)
        {
            TableDefinitionPart? tableDefinitionPart = worksheetPart.TableDefinitionParts.FirstOrDefault(r => r.Table.Name == XLTableName);
            string tableReference = string.Empty;

            if (tableDefinitionPart != null)
            {
                tableReference = tableDefinitionPart?.Table.Reference?.Value ?? "";
                tableDefinitionPart.Table.Reference.Value = tableReference.Split(":")[0] + ":" + EndColReference;
            }


        }





        private static void AssignValueToCell(SpreadsheetDocument XLSpreadsheetDocument, Cell cell, object value)
        {
            if (value == DBNull.Value || value == null) return;
            var objectType = value.GetType();

            if (objectType == typeof(string))
            {
                var index = InsertSharedStringItem(value.ToString(), XLSpreadsheetDocument);
                cell.CellValue = new CellValue(index.ToString());
                cell.DataType = new EnumValue<CellValues>(CellValues.SharedString);
            }
            else if (objectType == typeof(DateTime))
            {
                cell.DataType = new EnumValue<CellValues>(CellValues.Number);

                if (value != DBNull.Value)
                {
                    System.Globalization.CultureInfo cultureinfo = new System.Globalization.CultureInfo("en-US");
                    DateTime valueDate = (DateTime)value;
                    string valueString = valueDate.ToOADate().ToString(cultureinfo);
                    cell.CellValue = new CellValue(valueString);
                    //cell.StyleIndex = cell.StyleIndex ?? 14;
                }

            }
            else if (objectType == typeof(long) || objectType == typeof(int) || objectType == typeof(decimal) || objectType == typeof(short) || objectType == typeof(Int32))
            {

                cell.DataType = new EnumValue<CellValues>(CellValues.Number);
                cell.CellValue = new CellValue(value.ToString());
            }
            else
            {
                cell.DataType = new EnumValue<CellValues>(CellValues.String);
                cell.CellValue = new CellValue(value.ToString());
            }

        }

        private static int InsertSharedStringItem(string text, SpreadsheetDocument spreadSheet)
        {
            SharedStringTablePart shareStringPart;
            if (spreadSheet.WorkbookPart.GetPartsOfType<SharedStringTablePart>().Count() > 0)
            {
                shareStringPart = spreadSheet.WorkbookPart.GetPartsOfType<SharedStringTablePart>().First();
            }
            else
            {
                shareStringPart = spreadSheet.WorkbookPart.AddNewPart<SharedStringTablePart>();
            }
            return InsertSharedStringItem(text, shareStringPart);

        }

        private static int InsertSharedStringItem(string text, SharedStringTablePart shareStringPart)
        {
            // If the part does not contain a SharedStringTable, create one.
            if (shareStringPart.SharedStringTable == null)
            {
                shareStringPart.SharedStringTable = new SharedStringTable();
            }

            int i = 0;

            // Iterate through all the items in the SharedStringTable. If the text already exists, return its index.
            foreach (SharedStringItem item in shareStringPart.SharedStringTable.Elements<SharedStringItem>())
            {
                if (item.InnerText == text)
                {
                    return i;
                }

                i++;
            }

            // The text does not exist in the part. Create the SharedStringItem and return its index.
            shareStringPart.SharedStringTable.AppendChild(new SharedStringItem(new DocumentFormat.OpenXml.Spreadsheet.Text(text)));
            shareStringPart.SharedStringTable.Save();

            return i;
        }


        public static int GetColumnNumber(string name)
        {
            int number = 0;
            int pow = 1;
            for (int i = name.Length - 1; i >= 0; i--)
            {
                number += (name[i] - 'A' + 1) * pow;
                pow *= 26;
            }

            return number;
        }

    }
}
