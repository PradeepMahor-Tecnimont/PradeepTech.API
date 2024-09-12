using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Data;
using System.Globalization;

namespace TCMPLApp.Library.Excel.Writer
{
    public static class XLHelper
    {
        private const string noRecordsToDisplay = "No records to display";

        public static byte[] ExportToExcelDownload(DataSet dataSet)
        {
            byte[] byteResult = null;
            if (dataSet == null) { return byteResult; }

            if (dataSet.Tables.Count > 0)
            {
                using (MemoryStream stream = new MemoryStream())
                {
                    using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Create(stream, SpreadsheetDocumentType.Workbook))
                    {
                        // Add a WorkbookPart to the document.
                        WorkbookPart workbookpart = AddWorkbookPart(spreadsheetDocument);
                        AddSheet(spreadsheetDocument, out Sheets sheets, out uint currentSheetID);
                        AddNewPartStyle(workbookpart);

                        int rowIndexCount = 1;

                        foreach (DataTable dt in dataSet.Tables)
                        {
                            // Add a WorksheetPart to the WorkbookPart.
                            WorksheetPart worksheetPart = workbookpart.AddNewPart<WorksheetPart>();
                            worksheetPart.Worksheet = new Worksheet();
                            Columns columns = SetDefaultColumnWidth();
                            worksheetPart.Worksheet.Append(columns);

                            SheetData sheetData = new SheetData();
                            worksheetPart.Worksheet.AppendChild(sheetData);

                            // Append a new worksheet and associate it with the workbook.
                            Sheet sheet = new Sheet()
                            {
                                Id = spreadsheetDocument.WorkbookPart.GetIdOfPart(worksheetPart),
                                SheetId = currentSheetID,
                                Name = string.IsNullOrWhiteSpace(dt.TableName) ? "Sheet" + currentSheetID : dt.TableName
                            };

                            if (dt.Rows.Count == 0)
                            {
                                //if table rows count is 0, create Excel Sheet with default message
                                CreateDefaultWithMessage(rowIndexCount, sheetData);
                            }
                            else
                            {
                                int numberOfColumns = dt.Columns.Count;
                                string[] excelColumnNames = new string[numberOfColumns];

                                //Create Header
                                Row SheetrowHeader = CreateHeader(rowIndexCount, dt, numberOfColumns, excelColumnNames);
                                sheetData.Append(SheetrowHeader);
                                ++rowIndexCount;

                                //Create Body
                                rowIndexCount = CreateBody(rowIndexCount, dt, sheetData, excelColumnNames);
                            }

                            sheets.Append(sheet);

                            ++currentSheetID;

                            rowIndexCount = 1;
                        }

                        workbookpart.Workbook.Save();

                        // Close the document.
                        //spreadsheetDocument.Close();

                    }

                    stream.Flush();
                    stream.Position = 0;

                    byteResult = new byte[stream.Length];
                    stream.Read(byteResult, 0, byteResult.Length);
                }
            }
            return byteResult;
        }


        public static void ExcelTableGet()
        {
            using (SpreadsheetDocument document = SpreadsheetDocument.Open("yourfile.xlsx", true))
            {
                var workbookPart = document.WorkbookPart;
                var relationsShipId = workbookPart.Workbook.Descendants<Sheet>()
                                .FirstOrDefault(s => s.Name.Value.Trim().ToUpper() == "your sheetName")?.Id;

                var worksheetPart = (WorksheetPart)workbookPart.GetPartById(relationsShipId);

                TableDefinitionPart tableDefinitionPart = worksheetPart.TableDefinitionParts
                                                                                   .FirstOrDefault(r =>
                                                                                     r.Table.Name.Value.ToUpper() == "your Table Name");

                QueryTablePart queryTablePart = tableDefinitionPart.QueryTableParts.FirstOrDefault();

                Table excelTable = tableDefinitionPart.Table;

                var newCellRange = excelTable.Reference;
                var startCell = newCellRange.Value.Split(':')[0]; // you can have your own logic to find out row and column with this values
                var endCell = newCellRange.Value.Split(':')[1];// Then you can use them to extract values using regular open xml 
            }
        }
        //Customize column width
        private static Columns SetDefaultColumnWidth()
        {
            Columns columns = new Columns();
            //width of 1st Column
            columns.Append(new Column() { Min = 1, Max = 1, Width = 25, CustomWidth = true });
            //with of 2st Column
            columns.Append(new Column() { Min = 2, Max = 2, Width = 50, CustomWidth = true });
            //set column width from 3rd to 400 columns
            columns.Append(new Column() { Min = 3, Max = 400, Width = 10, CustomWidth = true });
            return columns;
        }

        private static void AddNewPartStyle(WorkbookPart workbookpart)
        {
            WorkbookStylesPart stylePart = workbookpart.AddNewPart<WorkbookStylesPart>();
            stylePart.Stylesheet = GenerateStylesheet();
            stylePart.Stylesheet.Save();
        }

        private static void AddSheet(SpreadsheetDocument spreadsheetDocument, out Sheets sheets, out uint currentSheetID)
        {
            sheets = spreadsheetDocument.WorkbookPart.Workbook.AppendChild(new Sheets());
            currentSheetID = 1;
        }

        private static WorkbookPart AddWorkbookPart(SpreadsheetDocument spreadsheetDocument)
        {
            WorkbookPart workbookpart = spreadsheetDocument.AddWorkbookPart();
            workbookpart.Workbook = new Workbook();
            return workbookpart;
        }

        private static void CreateDefaultWithMessage(int rowIndexCount, SheetData sheetData)
        {
            Row Sheetrow = new Row() { RowIndex = Convert.ToUInt32(rowIndexCount) };
            Cell cellHeader = new Cell() { CellReference = "A1", CellValue = new CellValue(noRecordsToDisplay), DataType = CellValues.String };
            cellHeader.StyleIndex = 1;

            Sheetrow.Append(cellHeader);
            sheetData.Append(Sheetrow);
        }

        private static int CreateBody(int rowIndexCount, DataTable dt, SheetData sheetData, string[] excelColumnNames)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                Row Sheetrow = new Row() { RowIndex = Convert.ToUInt32(rowIndexCount) };
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    // insert value in cell with dataType (String, Int, decimal, datatime)
                    Sheetrow.Append(GetCellWithDataType(excelColumnNames[j] + rowIndexCount, dt.Rows[i][j], dt.Columns[j].DataType));
                }
                sheetData.Append(Sheetrow);
                ++rowIndexCount;
            }

            return rowIndexCount;
        }

        private static Row CreateHeader(int rowIndexCount, DataTable dt, int numberOfColumns, string[] excelColumnNames)
        {
            Row SheetrowHeader = new Row() { RowIndex = Convert.ToUInt32(rowIndexCount) };
            for (int n = 0; n < numberOfColumns; n++)
            {
                excelColumnNames[n] = GetExcelColumnName(n);

                Cell cellHeader = new Cell() { CellReference = excelColumnNames[n] + rowIndexCount, CellValue = new CellValue(dt.Columns[n].ColumnName), DataType = CellValues.String };
                cellHeader.StyleIndex = 2;
                SheetrowHeader.Append(cellHeader);
            }

            return SheetrowHeader;
        }

        private static string GetExcelColumnName(int columnIndex)
        {
            if (columnIndex < 26)
            {
                return ((char)('A' + columnIndex)).ToString();
            }

            char firstChar = (char)('A' + (columnIndex / 26) - 1);
            char secondChar = (char)('A' + (columnIndex % 26));

            return string.Format(CultureInfo.CurrentCulture, "{0}{1}", firstChar, secondChar);
        }

        private static Stylesheet GenerateStylesheet()
        {
            Fonts fonts = GenerateFonts();
            Fills fills = GenerateFills();
            Borders borders = GenerateBorders();
            CellFormats cellFormats = GenerateCellFormats();
            Column column = GenerateColumnProperty();
            Stylesheet styleSheet = new Stylesheet(fonts, fills, borders, cellFormats, column);

            return styleSheet;
        }

        private static Column GenerateColumnProperty()
        {
            return new Column
            {
                Width = 100,
                CustomWidth = true
            };
        }

        private static CellFormats GenerateCellFormats()
        {
            CellFormats cellFormats = new CellFormats(
                // default - Cell StyleIndex = 0 
                new CellFormat(new Alignment() { WrapText = true, Vertical = VerticalAlignmentValues.Top }),

                // default2 - Cell StyleIndex = 1
                new CellFormat(new Alignment() { WrapText = true, Vertical = VerticalAlignmentValues.Top }) { FontId = 0, FillId = 0, BorderId = 1, ApplyBorder = true },

                // header - Cell StyleIndex = 2
                new CellFormat(new Alignment() { WrapText = true, Vertical = VerticalAlignmentValues.Top }) { FontId = 1, FillId = 0, BorderId = 1, ApplyFill = true },

                // DateTime DataType - Cell StyleIndex = 3
                new CellFormat(new Alignment() { Vertical = VerticalAlignmentValues.Top }) { FontId = 0, FillId = 0, BorderId = 1, ApplyBorder = true, NumberFormatId = 15, ApplyNumberFormat = true },

                // int,long,short DataType - Cell StyleIndex = 4
                new CellFormat(new Alignment() { WrapText = true, Vertical = VerticalAlignmentValues.Top }) { FontId = 0, FillId = 0, BorderId = 1, ApplyBorder = true, NumberFormatId = 1 },

                // decimal DataType  - Cell StyleIndex = 5
                new CellFormat(new Alignment() { WrapText = true, Vertical = VerticalAlignmentValues.Top }) { FontId = 0, FillId = 0, BorderId = 1, ApplyBorder = true, NumberFormatId = 2 }
                );
            return cellFormats;
        }

        private static Borders GenerateBorders()
        {
            Borders borders = new Borders(
                // index 0 default
                new Border(),

                // index 1 black border
                new Border(
                    new LeftBorder(new Color() { Auto = true }) { Style = BorderStyleValues.Thin },
                    new RightBorder(new Color() { Auto = true }) { Style = BorderStyleValues.Thin },
                    new TopBorder(new Color() { Auto = true }) { Style = BorderStyleValues.Thin },
                    new BottomBorder(new Color() { Auto = true }) { Style = BorderStyleValues.Thin },
                    new DiagonalBorder())
                );
            return borders;
        }

        private static Fills GenerateFills()
        {
            Fills fills = new Fills(
                // Index 0
                new Fill(new PatternFill() { PatternType = PatternValues.None }),

                // Index 1
                new Fill(new PatternFill() { PatternType = PatternValues.Gray125 }),

                // Index 2 - header
                new Fill(new PatternFill(new ForegroundColor { Rgb = new HexBinaryValue() { Value = "66666666" } }) { PatternType = PatternValues.Solid })
                );
            return fills;
        }

        private static Fonts GenerateFonts()
        {
            Fonts fonts = new Fonts(
                // Index 0 - default
                new Font(
                    new FontSize() { Val = 10 },
                    new FontName() { Val = "Arial Unicode" }
                ),

                // Index 1 - header
                new Font(
                    new FontSize() { Val = 10 },
                    new Bold()//,

                //new Color() { Rgb = "FFFFFF" }

                ));
            return fonts;
        }

        private static Cell GetCellWithDataType(string cellRef, object value, Type type)
        {
            if (type == typeof(DateTime))
            {
                Cell cell = new Cell()
                {
                    DataType = new EnumValue<CellValues>(CellValues.Number),
                    StyleIndex = 3
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
            if (type == typeof(long) || type == typeof(int) || type == typeof(short))
            {
                Cell cell = new Cell() { CellReference = cellRef, CellValue = new CellValue(value.ToString()), DataType = CellValues.Number };
                cell.StyleIndex = 4;
                return cell;
            }
            if (type == typeof(decimal))
            {
                Cell cell = new Cell() { CellReference = cellRef, CellValue = new CellValue(value.ToString()), DataType = CellValues.Number };
                cell.StyleIndex = 5;
                return cell;
            }
            else
            {
                Cell cell = new Cell() { CellReference = cellRef, CellValue = new CellValue(value.ToString()), DataType = CellValues.String };
                cell.StyleIndex = 1;
                return cell;
            }
        }

        private static string GetExcelA1Range(int startRow, int startColumn, int endRow, int endColumn)
        {
            return GetExcelColumnA1Reference(startColumn) + startRow.ToString() + ":" + GetExcelColumnA1Reference(endColumn) + endRow.ToString();
        }

        private static string GetExcelColumnA1Reference(int columnNumber)
        {
            int dividend = columnNumber;
            string columnName = String.Empty;
            int modulo;

            while (dividend > 0)
            {
                modulo = (dividend - 1) % 26;
                columnName = Convert.ToChar(65 + modulo).ToString() + columnName;
                dividend = (int)((dividend - modulo) / 26);
            }

            return columnName;
        }

        private const string ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        public static string ToExcelCoordinates(string coordinates)
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
    }

}
