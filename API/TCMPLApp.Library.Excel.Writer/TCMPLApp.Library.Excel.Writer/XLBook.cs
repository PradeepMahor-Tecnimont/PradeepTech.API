using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Data;
using System.Reflection;
using TCMPLApp.Library.Excel.Writer.Model;

namespace TCMPLApp.Library.Excel.Writer
{
    public class XLWorkBook : IDisposable
    {

        //
        //  D o   n o t   u s e   t h i s   c l a s s 
        //


        // To detect redundant calls
        private bool _disposedValue;

        private const string ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        MemoryStream? _stream;

        SpreadsheetDocument? _spreadsheetDocument;
        string _fileNamePath = string.Empty;

        WorksheetPart? _worksheetPart;

        private int _sheetCount = 0;


        public XLWorkBook(string FileNamePath)
        {
            _fileNamePath = FileNamePath;
            byte[] templateBytes = System.IO.File.ReadAllBytes(FileNamePath);
            _stream = new MemoryStream();
            _stream.Write(templateBytes, 0, (int)templateBytes.Length);

            _spreadsheetDocument = SpreadsheetDocument.Open(_stream, true);

            _sheetCount = _spreadsheetDocument.WorkbookPart?.Workbook.Sheets?.Count() ?? 0;
        }




        public void SaveToFile(string FilePathName)
        {
            _spreadsheetDocument?.Clone(FilePathName);

            _stream?.Close();
        }


        public MemoryStream? SaveTo()
        {

            return _stream;
        }

        private static Cell GetCellWithDataType(string cellRef, object value, Type type, UInt32Value? styleIndex)
        {
            if (type == typeof(DateTime))
            {
                Cell cell = new Cell()
                {
                    DataType = new EnumValue<CellValues>(CellValues.Number),
                    StyleIndex = styleIndex ?? 7
                };

                if (value != DBNull.Value)
                {
                    System.Globalization.CultureInfo cultureinfo = new System.Globalization.CultureInfo("en-US");
                    DateTime valueDate = (DateTime)value;
                    string valueString = valueDate.ToOADate().ToString(cultureinfo);
                    CellValue cellValue = new CellValue(valueString);
                    cell.Append(cellValue);
                }

                return cell;
            }
            else if (type == typeof(long) || type == typeof(int) || type == typeof(short))
            {
                Cell cell = new Cell() { CellReference = cellRef, CellValue = new CellValue(value.ToString() ?? ""), DataType = CellValues.Number };
                cell.StyleIndex = styleIndex ?? 6;
                return cell;
            }
            else if (type == typeof(decimal))
            {
                Cell cell = new Cell() { CellReference = cellRef, CellValue = new CellValue(value.ToString() ?? ""), DataType = CellValues.Number };
                cell.StyleIndex = styleIndex ?? 6;
                return cell;
            }
            else if (type == typeof(string))
            {
                Cell cell = new Cell() { CellReference = cellRef, CellValue = new CellValue(value.ToString() ?? ""), DataType = CellValues.String };
                cell.StyleIndex = styleIndex ?? 5;
                return cell;
            }
            else
            {
                Cell cell = new Cell() { CellReference = cellRef, CellValue = new CellValue(value.ToString() ?? ""), DataType = CellValues.String };
                cell.StyleIndex = styleIndex ?? 5;
                return cell;
            }
        }


        private string GetCellValue(Cell cell)
        {
            SharedStringTablePart? stringTablePart = _spreadsheetDocument?.WorkbookPart?.SharedStringTablePart;
            string? value = cell.CellValue?.InnerXml;
            if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
            {
                return stringTablePart?.SharedStringTable.ChildElements[Int32.Parse(value)].InnerText ?? "";
            }
            else
            {
                return value ?? "";
            }
        }





        private static WorksheetPart InsertWorksheet(WorkbookPart workbookPart, string XLSheetName)
        {
            // Add a new worksheet part to the workbook.
            WorksheetPart newWorksheetPart = workbookPart.AddNewPart<WorksheetPart>();
            newWorksheetPart.Worksheet = new Worksheet(new SheetData());
            newWorksheetPart.Worksheet.Save();

            Sheets sheets = workbookPart.Workbook.GetFirstChild<Sheets>();
            string relationshipId = workbookPart.GetIdOfPart(newWorksheetPart);

            // Get a unique ID for the new sheet.
            uint sheetId = 1;
            if (sheets.Elements<Sheet>().Count() > 0)
            {
                sheetId = sheets.Elements<Sheet>().Select(s => s.SheetId.Value).Max() + 1;
            }


            // Append the new worksheet and associate it with the workbook.
            Sheet sheet = new Sheet() { Id = relationshipId, SheetId = sheetId, Name = XLSheetName };
            sheets.Append(sheet);
            workbookPart.Workbook.Save();

            return newWorksheetPart;
        }



        public class XLSheet
        {
            XLWorkBook _xlBook;
            WorksheetPart _worksheetPart;
            int _sheetCount = 0;

            public XLSheet(XLWorkBook xlBook, string XLSheetName)
            {
                _xlBook = xlBook;
                if (_xlBook._spreadsheetDocument?.WorkbookPart != null)
                {
                    _worksheetPart = GetNewWorkSheetPart(_xlBook._spreadsheetDocument.WorkbookPart, XLSheetName);
                }
                else throw new Exception("XLS001-Worksheet initialization failed");
            }

            private WorksheetPart GetNewWorkSheetPart(WorkbookPart workbookPart, string XLSheetName)
            {
                //WorkbookPart? workbookPart = _xlWorkbook._spreadsheetDocument.WorkbookPart;

                Sheet? sheet = workbookPart?.Workbook.Descendants<Sheet>().Where(sht => sht.Name == XLSheetName).FirstOrDefault();

                if (sheet != null)
                {
                    return (WorksheetPart)workbookPart.GetPartById(sheet.Id?.ToString() ?? "");

                }


                // Add a WorksheetPart to the WorkbookPart.
                return InsertWorksheet(workbookPart, XLSheetName);

            }


            public void ReplaceDataInXLTable<T>(string XLTableName, IEnumerable<T> data)
            {


                var tableDef = GetXLTableDefinition(XLTableName);
                SheetData sheetData = _worksheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();



                var xlTableDataRow = sheetData?.Elements<Row>().Where(r => r.RowIndex == tableDef.StartRow + 1).FirstOrDefault() ?? new Row();


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


                    //Row sheetRow = new Row() { RowIndex = Convert.ToUInt32(rowIndex) };

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
                            var cell = InsertCellInWorksheet(cellReference, (uint)rowIndex, _worksheetPart);

                            var propType = props[j].PropertyType;
                            cell.StyleIndex = cellStyleIndex;

                            if (obj == null) { continue; }

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

                RemoveExtraRowsInTable(rowIndex + 1, tableDef);

                var endColReference = ToExcelCoordinates(tableDef.EndCol + "," + rowIndex);
                ResizeXLTable(XLTableName, endColReference);
                _worksheetPart.Worksheet.Save();
                _xlBook._spreadsheetDocument.WorkbookPart.Workbook.Save();
            }

            public static uint SetDateStyle(SpreadsheetDocument spreadsheetDoc)
            {
                // get the stylesheet from the current sheet    
                var stylesheet = spreadsheetDoc.WorkbookPart.WorkbookStylesPart.Stylesheet;

                var stylePart1 = spreadsheetDoc.WorkbookPart.GetPartsOfType<WorkbookStylesPart>();

                //if(stylePart1 == null)
                //{
                //    stylePart1 = spreadsheetDoc.WorkbookPart.AddNewPart<WorkbookStylesPart>();
                //    stylePart1.Stylesheet = new Stylesheet();
                //    stylePart1.Stylesheet.Save();
                //}

                //uint numberFormatId = AddCustomNumberFormat(stylePart1.Stylesheet, "dd/mm/yyyy");

                
                //uint styleIndex = AddCellFormat(stylePart1.Stylesheet, numberFormatId);

                return 3;

                //// cell formats are stored in the stylesheet's NumberingFormats
                //var numberingFormats = stylesheet.NumberingFormats;

                //// cell format string               
                //const string dateFormatCode = "dd-mm-yyyy";

                //// first check if we find an existing NumberingFormat with the desired formatcode

                //var dateFormat = numberingFormats.OfType<NumberingFormat>().FirstOrDefault(format => format.FormatCode == dateFormatCode);

                //// if not: create it
                //if (dateFormat == null)
                //{
                //    dateFormat = new NumberingFormat
                //    {
                //        NumberFormatId = UInt32Value.FromUInt32(164),  // Built-in number formats are numbered 0 - 163. Custom formats must start at 164.
                //        FormatCode = StringValue.FromString(dateFormatCode)
                //    };
                //    numberingFormats.AppendChild(dateFormat);

                //    // we have to increase the count attribute manually ?!?
                //    numberingFormats.Count = Convert.ToUInt32(numberingFormats.Count());

                //    // save the new NumberFormat in the stylesheet
                //    stylesheet.Save();
                //}
                //// get the (1-based) index of the dateformat
                //var dateStyleIndex = numberingFormats.ToList().IndexOf(dateFormat) + 1;

                //return dateStyleIndex;


            }

            private static uint AddCustomNumberFormat(Stylesheet stylesheet, string formatCode)
            {
                NumberingFormats numberingFormats = stylesheet.NumberingFormats ?? new NumberingFormats();
                NumberingFormat numberingFormat = new NumberingFormat() { FormatCode = formatCode };
                numberingFormats.Append(numberingFormat);
                stylesheet.NumberingFormats = numberingFormats;
                stylesheet.NumberingFormats.Count = (uint)numberingFormats.ChildElements.Count;
                return (uint)numberingFormats.ChildElements.Count - 1;
            }

            // Helper method to add a cell format to the stylesheet
            private static uint AddCellFormat(Stylesheet stylesheet, uint numberFormatId)
            {
                CellFormats cellFormats = stylesheet.CellFormats ?? new CellFormats();
                CellFormat cellFormat = new CellFormat() { NumberFormatId = numberFormatId };
                cellFormats.Append(cellFormat);
                stylesheet.CellFormats = cellFormats;
                stylesheet.CellFormats.Count = (uint)cellFormats.ChildElements.Count;
                return (uint)cellFormats.ChildElements.Count - 1;
            }

            public void AppendDataInExcel<T>(string XLTableName, IEnumerable<T> data)
            {


                var tableDef = GetXLTableDefinition(XLTableName);
                SheetData sheetData = _worksheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();



                var xlTableDataRow = sheetData.Elements<Row>().Where(r => r.RowIndex == tableDef.StartRow + 1).FirstOrDefault() ?? new Row();

                var cellStyles = GetCellStyles(xlTableDataRow, tableDef);

                for (int i = tableDef.StartRow + 1; i <= tableDef.EndRow; i++)
                {
                    var rowToDel = sheetData.Elements<Row>().Where(r => r.RowIndex == i).FirstOrDefault();
                    if (rowToDel != null)
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

                        UInt32Value cellStyleIndex;


                        DocumentFormat.OpenXml.Spreadsheet.Cell cell = new DocumentFormat.OpenXml.Spreadsheet.Cell();
                        cell.DataType = DocumentFormat.OpenXml.Spreadsheet.CellValues.String;
                        if (obj != null)
                            cell.CellValue = new DocumentFormat.OpenXml.Spreadsheet.CellValue(obj.ToString()); //

                        cell.CellReference = cellReference;

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
                ResizeXLTable(XLTableName, endColReference);
                _worksheetPart.Worksheet.Save();
                _xlBook._spreadsheetDocument.WorkbookPart.Workbook.Save();
            }

            public void AppendDataInExcelNew<T>(string XLTableName, IEnumerable<T> data)
            {

                var dateStyleIndex = SetDateStyle(_xlBook._spreadsheetDocument);

                var tableDef = GetXLTableDefinition(XLTableName);
                SheetData sheetData = _worksheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();

                var xlTableDataRow = sheetData.Elements<Row>().Where(r => r.RowIndex == tableDef.StartRow + 1).FirstOrDefault() ?? new Row();

                var cellStyles = GetCellStyles(xlTableDataRow, tableDef);

                for (int i = tableDef.StartRow + 1; i <= tableDef.EndRow; i++)
                {
                    var rowToDel = sheetData.Elements<Row>().Where(r => r.RowIndex == i).FirstOrDefault();
                    if (rowToDel != null)
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

                        UInt32Value cellStyleIndex;
                        if (j + 1 > cellStyles.Length)
                            cellStyleIndex = 0;
                        else
                            cellStyleIndex = cellStyles[j];

                        {
                            var cell = InsertCellInWorksheet(cellReference, (uint)rowIndex, _worksheetPart);

                            var propType = props[j].PropertyType;

                            if (obj == null) { continue; }

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
                                    cell.StyleIndex = 3;

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

                        //DocumentFormat.OpenXml.Spreadsheet.Cell cell = new DocumentFormat.OpenXml.Spreadsheet.Cell();
                        //cell.DataType = DocumentFormat.OpenXml.Spreadsheet.CellValues.String;
                        //if (obj != null)
                        //    cell.CellValue = new DocumentFormat.OpenXml.Spreadsheet.CellValue(obj.ToString()); //

                        //cell.CellReference = cellReference;

                        //newRow.AppendChild(cell);

                    }
                    //sheetData.Append(newRow);
                    //_worksheetPart.Worksheet.Save();
                    if (rowIndex % 100 == 0)
                    {
                        continue;
                    }
                }
                //    _worksheetPart.Worksheet.Save();

                RemoveExtraRowsInTable(rowIndex + 1, tableDef);

                var endColReference = ToExcelCoordinates(tableDef.EndCol + "," + rowIndex);
                ResizeXLTable(XLTableName, endColReference);
                _worksheetPart.Worksheet.Save();
                _xlBook._spreadsheetDocument.WorkbookPart.Workbook.Save();
            }
            private XLTableCoOrdinates GetXLTableDefinition(string XLTableName)
            {

                TableDefinitionPart? tableDefinitionPart = _worksheetPart.TableDefinitionParts.FirstOrDefault(r => r.Table.Name == XLTableName);
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

            private void RemoveExtraRowsInTable(int StartRowIndex, XLTableCoOrdinates xlTableCoOrdinates)
            {
                SheetData sheetData = _worksheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();

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


            private void ResizeXLTable(string XLTableName, string EndColReference)
            {
                TableDefinitionPart? tableDefinitionPart = _worksheetPart.TableDefinitionParts.FirstOrDefault(r => r.Table.Name == XLTableName);
                string tableReference = string.Empty;

                if (tableDefinitionPart != null)
                {
                    tableReference = tableDefinitionPart?.Table.Reference?.Value ?? "";
                    tableDefinitionPart.Table.Reference.Value = tableReference.Split(":")[0] + ":" + EndColReference;
                }


            }


            public void SetCellValue(string XLCellAddress, object XLCellValue)
            {

                var cell = InsertCellInWorksheet(XLCellAddress, (uint)int.Parse(ToNumericCoordinates(XLCellAddress).Split(",")[1]), _worksheetPart);
                if (cell != null) { cell.RemoveAllChildren(); }
                AssignValueToCell(cell, XLCellValue);

            }

            private void AssignValueToCell(Cell cell, object value)
            {
                if (value == DBNull.Value || value == null) return;
                var objectType = value.GetType();

                if (objectType == typeof(string))
                {
                    //var index = InsertSharedStringItem(value.ToString(), _xlBook._spreadsheetDocument);
                    cell.CellValue = new CellValue(value.ToString());
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
                        cell.StyleIndex = cell.StyleIndex ?? 14;
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

            public void ChangeQueryTableDefinition(string XLTableName)
            {
                TableDefinitionPart? tableDefinitionPart = _worksheetPart.TableDefinitionParts.FirstOrDefault(r => r.Table.Name == XLTableName);
                ChangeTableDefinitionPart(tableDefinitionPart);
            }

            public void ChangeTableDefinitionPart(TableDefinitionPart tableDefinitionPart1)
            {
                Table table1 = tableDefinitionPart1.Table;
                table1.RemoveNamespaceDeclaration("x");
                table1.AddNamespaceDeclaration("mc", "http://schemas.openxmlformats.org/markup-compatibility/2006");
                table1.AddNamespaceDeclaration("xr", "http://schemas.microsoft.com/office/spreadsheetml/2014/revision");
                table1.AddNamespaceDeclaration("xr3", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3");
                table1.TableType = TableValues.QueryTable;
                table1.MCAttributes = new MarkupCompatibilityAttributes() { Ignorable = "xr xr3" };
                table1.SetAttribute(new OpenXmlAttribute("xr", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2014/revision", "{33ED2B34-9D9B-4AA8-B00C-632EF2A02171}"));

                DocumentFormat.OpenXml.Spreadsheet.AutoFilter autoFilter1 = table1.GetFirstChild<DocumentFormat.OpenXml.Spreadsheet.AutoFilter>();
                TableColumns tableColumns1 = table1.GetFirstChild<TableColumns>();
                autoFilter1.SetAttribute(new OpenXmlAttribute("xr", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2014/revision", "{33ED2B34-9D9B-4AA8-B00C-632EF2A02171}"));

                TableColumn tableColumn1 = tableColumns1.GetFirstChild<TableColumn>();
                TableColumn tableColumn2 = tableColumns1.Elements<TableColumn>().ElementAt(1);
                TableColumn tableColumn3 = tableColumns1.Elements<TableColumn>().ElementAt(2);
                TableColumn tableColumn4 = tableColumns1.Elements<TableColumn>().ElementAt(3);
                TableColumn tableColumn5 = tableColumns1.Elements<TableColumn>().ElementAt(4);
                TableColumn tableColumn6 = tableColumns1.Elements<TableColumn>().ElementAt(5);
                TableColumn tableColumn7 = tableColumns1.Elements<TableColumn>().ElementAt(6);
                TableColumn tableColumn8 = tableColumns1.Elements<TableColumn>().ElementAt(7);
                TableColumn tableColumn9 = tableColumns1.Elements<TableColumn>().ElementAt(8);
                TableColumn tableColumn10 = tableColumns1.Elements<TableColumn>().ElementAt(9);
                TableColumn tableColumn11 = tableColumns1.Elements<TableColumn>().ElementAt(10);
                TableColumn tableColumn12 = tableColumns1.Elements<TableColumn>().ElementAt(11);
                TableColumn tableColumn13 = tableColumns1.Elements<TableColumn>().ElementAt(12);
                TableColumn tableColumn14 = tableColumns1.Elements<TableColumn>().ElementAt(13);
                TableColumn tableColumn15 = tableColumns1.Elements<TableColumn>().ElementAt(14);
                TableColumn tableColumn16 = tableColumns1.Elements<TableColumn>().ElementAt(15);
                TableColumn tableColumn17 = tableColumns1.Elements<TableColumn>().ElementAt(16);
                TableColumn tableColumn18 = tableColumns1.Elements<TableColumn>().ElementAt(17);
                tableColumn1.DataFormatId = null;
                tableColumn1.UniqueName = "1";
                tableColumn1.QueryTableFieldId = (UInt32Value)1U;
                tableColumn1.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{E7E3A517-C99C-4778-8A51-232D0102784A}"));
                tableColumn2.DataFormatId = null;
                tableColumn2.UniqueName = "2";
                tableColumn2.QueryTableFieldId = (UInt32Value)2U;
                tableColumn2.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{1FD4A2E4-B23E-4675-84B7-96962E1A0B0B}"));
                tableColumn3.DataFormatId = null;
                tableColumn3.UniqueName = "3";
                tableColumn3.QueryTableFieldId = (UInt32Value)3U;
                tableColumn3.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{E7F996DE-F6F0-4F21-9CD3-2E0E11D627E7}"));
                tableColumn4.DataFormatId = null;
                tableColumn4.UniqueName = "4";
                tableColumn4.QueryTableFieldId = (UInt32Value)4U;
                tableColumn4.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{1E6C7A2A-DE82-4B4E-8C1F-27F281CB57FC}"));
                tableColumn5.DataFormatId = null;
                tableColumn5.UniqueName = "5";
                tableColumn5.QueryTableFieldId = (UInt32Value)5U;
                tableColumn5.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{17179EB8-A009-4570-96C8-F19CE2CED72D}"));
                tableColumn6.DataFormatId = null;
                tableColumn6.UniqueName = "6";
                tableColumn6.QueryTableFieldId = (UInt32Value)6U;
                tableColumn6.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{3FFC1458-1F8A-4BD6-95DC-F2945E6B1D6E}"));
                tableColumn7.DataFormatId = null;
                tableColumn7.UniqueName = "7";
                tableColumn7.QueryTableFieldId = (UInt32Value)7U;
                tableColumn7.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{58EA33D1-75DA-459A-91F4-34D50F236723}"));
                tableColumn8.DataFormatId = null;
                tableColumn8.UniqueName = "8";
                tableColumn8.QueryTableFieldId = (UInt32Value)8U;
                tableColumn8.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{2E06842F-A27D-4597-BA1E-22ADC035C7E9}"));
                tableColumn9.DataFormatId = null;
                tableColumn9.UniqueName = "9";
                tableColumn9.QueryTableFieldId = (UInt32Value)9U;
                tableColumn9.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{98A21814-BEDD-46C2-9039-866815D3EB09}"));
                tableColumn10.DataFormatId = null;
                tableColumn10.UniqueName = "10";
                tableColumn10.QueryTableFieldId = (UInt32Value)10U;
                tableColumn10.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{C2F35794-5D43-4255-9BBD-A628A3DF0BB2}"));
                tableColumn11.DataFormatId = null;
                tableColumn11.UniqueName = "11";
                tableColumn11.QueryTableFieldId = (UInt32Value)11U;
                tableColumn11.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{10696E34-2104-4585-85FE-BD478281CBE6}"));
                tableColumn12.DataFormatId = null;
                tableColumn12.UniqueName = "12";
                tableColumn12.QueryTableFieldId = (UInt32Value)12U;
                tableColumn12.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{8A739C26-786A-4E54-BFD8-F6665D1AA73F}"));
                tableColumn13.DataFormatId = null;
                tableColumn13.UniqueName = "13";
                tableColumn13.QueryTableFieldId = (UInt32Value)13U;
                tableColumn13.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{FAF66DA0-0995-446B-B7B7-056F622CC60D}"));
                tableColumn14.DataFormatId = null;
                tableColumn14.UniqueName = "14";
                tableColumn14.QueryTableFieldId = (UInt32Value)14U;
                tableColumn14.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{0041E6B6-0458-40F2-978C-C2E4046407C6}"));
                tableColumn15.DataFormatId = null;
                tableColumn15.UniqueName = "15";
                tableColumn15.QueryTableFieldId = (UInt32Value)15U;
                tableColumn15.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{9187EFCA-CFB1-4A5E-943F-AE799C0ECED9}"));
                tableColumn16.DataFormatId = null;
                tableColumn16.UniqueName = "16";
                tableColumn16.QueryTableFieldId = (UInt32Value)16U;
                tableColumn16.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{B8FC8ECF-1E09-4013-BFD1-08429D4D5046}"));
                tableColumn17.DataFormatId = null;
                tableColumn17.UniqueName = "17";
                tableColumn17.QueryTableFieldId = (UInt32Value)17U;
                tableColumn17.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{4CCBC756-C47E-49D8-9CA6-95805BE8DC61}"));
                tableColumn18.DataFormatId = null;
                tableColumn18.UniqueName = "18";
                tableColumn18.QueryTableFieldId = (UInt32Value)18U;
                tableColumn18.SetAttribute(new OpenXmlAttribute("xr3", "uid", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3", "{A275F7D6-64CB-4C07-B6D3-9EC94E8EEE2D}"));
            }


        }





        #region Privet methods



        // Given a document name and text, 
        // inserts a new work sheet and writes the text to cell "A1" of the new worksheet.

        private static int InsertSharedStringItem(string text, SpreadsheetDocument spreadSheet)
        {
            SharedStringTablePart shareStringPart;
            if (spreadSheet.WorkbookPart?.GetPartsOfType<SharedStringTablePart>().Count() > 0)
            {
                shareStringPart = spreadSheet.WorkbookPart.GetPartsOfType<SharedStringTablePart>().First();
            }
            else
            {
                shareStringPart = spreadSheet.WorkbookPart?.AddNewPart<SharedStringTablePart>();
            }
            return InsertSharedStringItem(text, shareStringPart);

        }

        //public static void InsertText(string docName, string text)
        //{
        //    // Open the document for editing.
        //    using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
        //    {
        //        // Get the SharedStringTablePart. If it does not exist, create a new one.
        //        SharedStringTablePart shareStringPart;
        //        if (spreadSheet.WorkbookPart.GetPartsOfType<SharedStringTablePart>().Count() > 0)
        //        {
        //            shareStringPart = spreadSheet.WorkbookPart.GetPartsOfType<SharedStringTablePart>().First();
        //        }
        //        else
        //        {
        //            shareStringPart = spreadSheet.WorkbookPart.AddNewPart<SharedStringTablePart>();
        //        }

        //        // Insert the text into the SharedStringTablePart.
        //        int index = InsertSharedStringItem(text, shareStringPart);

        //        // Insert a new worksheet.
        //        WorksheetPart worksheetPart = InsertWorksheet(spreadSheet.WorkbookPart);

        //        // Insert cell A1 into the new worksheet.
        //        Cell cell = InsertCellInWorksheet("A", 1, worksheetPart);

        //        // Set the value of cell A1.
        //        cell.CellValue = new CellValue(index.ToString());
        //        cell.DataType = new EnumValue<CellValues>(CellValues.SharedString);

        //        // Save the new worksheet.
        //        worksheetPart.Worksheet.Save();
        //    }
        //}


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

        private static Cell InsertCellInWorksheet(string cellReference, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();

            // If the worksheet does not contain a row with the specified row index, insert one.
            Row row;
            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
            {
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            }
            else
            {
                row = new Row() { RowIndex = rowIndex };
                sheetData.Append(row);
            }
            //Cell refCell = null;

            //Cell newCell = new Cell() { CellReference = cellReference };
            //row.InsertBefore(newCell, refCell);

            //worksheet.Save();
            //return newCell;


            // If there is not a cell with the specified column name, insert one.  
            if (row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).Count() > 0)
            {
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            }
            else
            {
                //Cells must be in sequential order according to CellReference.Determine where to insert the new cell.
                Cell refCell = null;
                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }

                Cell newCell = new Cell() { CellReference = cellReference };
                row.InsertBefore(newCell, refCell);

                worksheet.Save();
                return newCell;
            }
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

        #endregion



        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        // Protected implementation of Dispose pattern.
        protected virtual void Dispose(bool disposing)
        {
            if (!_disposedValue)
            {
                if (disposing)
                {

                    _stream?.Dispose();

                    _spreadsheetDocument.Dispose();
                }

                _disposedValue = true;
            }
        }
    }

}

