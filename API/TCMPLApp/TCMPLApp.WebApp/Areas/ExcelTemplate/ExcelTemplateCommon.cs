using TCMPLApp.WebApp.Areas.ExcelTemplate.Models;
using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;

namespace TCMPLApp.WebApp.Areas.ExcelTemplate
{
    public class ExcelTemplateCommon
    {
        public enum CellBorder
        {
            LRMediumBThin,
            LRBThin,
            RMediumLBThin,
            BMedium,
        }

        #region Private

        private void SetCellValidation(ExcelRangeBase cell, ValidationItem validationItem)
        {
            if (validationItem != null)
            {
                cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
                if (validationItem.ErrorType == ValidationItemErrorTypeEnum.Critical)
                {
                    cell.Style.Fill.BackgroundColor.SetColor(Color.Red);
                }
                if (validationItem.ErrorType == ValidationItemErrorTypeEnum.Warning)
                {
                    cell.Style.Fill.BackgroundColor.SetColor(Color.Yellow);
                }
                if (cell.Comment == null)
                    cell.AddComment(validationItem.Message, "System");
                //else
                //cell.Comment.Text == validationItem.Message;

            }
        }

        private void SetCellValue(ExcelRangeBase cell, Object value)
        {
            if (value != null)
            {
                if (value.GetType() == typeof(string))
                {
                    cell.Value = value;
                }
                else if (value.GetType() == typeof(int))
                {
                    cell.Value = value;
                }
                else if (value.GetType() == typeof(decimal))
                {
                    cell.Value = value;
                }
                else if (value.GetType() == typeof(DateTime))
                {
                    cell.Value = value;
                }
                else
                {
                    throw new Exception("Not impelemented");
                }
            }
        }

        private void SetCellProperty(ExcelRangeBase cell, PropertyItem propertyItem)
        {
            if (propertyItem != null)
            {
                if (propertyItem.IsRequired == true)
                {
                    cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    cell.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(242, 242, 242));
                }
                if (!string.IsNullOrEmpty(propertyItem.Comment))
                {
                    if (cell.Comment == null)
                        cell.AddComment(propertyItem.Comment, "System");
                }
            }
        }

        #region Validation
        private void AddIntegerValidation(ExcelWorksheet worksheet, string rangeAddress)
        {

            var validation = worksheet.DataValidations.AddIntegerValidation(rangeAddress);
            validation.ShowErrorMessage = true;
            validation.ErrorStyle = ExcelDataValidationWarningStyle.stop;
            validation.ErrorTitle = "Value entered is not valid";
            validation.Error = "Cell must be a valid positive number.";
            validation.Operator = ExcelDataValidationOperator.greaterThanOrEqual;
            validation.Formula.Value = 0;
        }

        private void AddDecimalValidation(ExcelWorksheet worksheet, string rangeAddress)
        {

            var validation = worksheet.DataValidations.AddDecimalValidation(rangeAddress);
            validation.ShowErrorMessage = true;
            validation.ErrorStyle = ExcelDataValidationWarningStyle.stop;
            validation.ErrorTitle = "Value entered is not valid";
            validation.Error = "Cell must be a valid positive number.";
            validation.Operator = ExcelDataValidationOperator.greaterThanOrEqual;
            validation.Formula.Value = 0D;

        }

        private void AddDecimalWithNegativeValidation(ExcelWorksheet worksheet, string rangeAddress)
        {
            var validation = worksheet.DataValidations.AddDecimalValidation(rangeAddress);
            validation.ShowErrorMessage = true;
            validation.ErrorStyle = ExcelDataValidationWarningStyle.stop;
            validation.ErrorTitle = "Value entered is not valid";
            validation.Error = "Cell must be a valid number.";
            validation.Operator = ExcelDataValidationOperator.greaterThanOrEqual;
            validation.Formula.Value = -100D;
        }

        private void AddListValidation(ExcelWorksheet worksheet, string listAddress, string rangeAddress, bool allowBlank)
        {
            var validation = worksheet.DataValidations.AddListValidation(rangeAddress);
            validation.ShowErrorMessage = true;
            validation.ErrorStyle = ExcelDataValidationWarningStyle.stop;
            validation.ErrorTitle = "Value entered is not valid";
            validation.Error = "Select a value from the list.";
            validation.Formula.ExcelFormula = listAddress;
            validation.AllowBlank = allowBlank;

        }

        private void AddBooleanValidation(ExcelWorksheet worksheet, string rangeAddress, bool allowBlank)
        {

            var validation = worksheet.DataValidations.AddListValidation(rangeAddress);
            validation.ShowErrorMessage = true;
            validation.ErrorStyle = ExcelDataValidationWarningStyle.stop;
            validation.ErrorTitle = "Value entered is not valid";
            validation.Error = "Select a value between Yes or No.";
            validation.Formula.Values.Add("Yes");
            validation.Formula.Values.Add("No");
            validation.AllowBlank = allowBlank;

        }

        private void AddBooleanWillFollowValidation(ExcelWorksheet worksheet, string rangeAddress, bool allowBlank)
        {

            var validation = worksheet.DataValidations.AddListValidation(rangeAddress);
            validation.ShowErrorMessage = true;
            validation.ErrorStyle = ExcelDataValidationWarningStyle.stop;
            validation.ErrorTitle = "Value entered is not valid";
            validation.Error = "Select a value between Yes or No.";
            validation.Formula.Values.Add("Yes");
            validation.Formula.Values.Add("No");
            validation.Formula.Values.Add("Will follow");
            validation.AllowBlank = allowBlank;

        }

        private void AddCustomValidation(ExcelWorksheet worksheet, string rangeAddress, string formula, string error)
        {
            var validation = worksheet.DataValidations.AddCustomValidation(rangeAddress);
            validation.ShowErrorMessage = true;
            validation.ErrorStyle = ExcelDataValidationWarningStyle.stop;
            validation.ErrorTitle = "Value entered is not valid";
            validation.Error = error;
            validation.AllowBlank = true;
            validation.Operator = ExcelDataValidationOperator.equal;
            validation.Formula.ExcelFormula = formula;
        }

        #endregion                

        /// <summary>
        /// Merge row if height exceeds
        /// </summary>
        /// <param name="worksheet">Reference to ExcelWorksheet</param>
        /// <param name="objectsWithMergedCells">Items to check</param>
        /// <param name="rowHeight">Height of row</param>
        /// <param name="itemBodyColumnCount">Column count</param>
        /// <param name="currentSingleRow">Current row number</param>
        /// <returns></returns>
        private int MergeRows(ExcelWorksheet worksheet, List<dynamic> objectsWithMergedCells, double rowHeight, int itemBodyColumnCount, int currentSingleRow)
        {
            int rowToMerge = 0;

            foreach (var objectWithMergedCells in objectsWithMergedCells)
            {
                var cellFont = worksheet.Cells[currentSingleRow, objectWithMergedCells.ColumnStart].Style.Font;
                double cellWidth = 0;
                for (int c = objectWithMergedCells.ColumnStart; c < (objectWithMergedCells.ColumnStart + objectWithMergedCells.ColumnsCount); c++) { cellWidth += worksheet.Column(c).Width; }
                var cellHeight = MeasureTextHeight(Convert.ToString(objectWithMergedCells.Value), cellFont, cellWidth);

                if ((int)Math.Ceiling((cellHeight / rowHeight)) > rowToMerge)
                {
                    rowToMerge = (int)Math.Ceiling((cellHeight / rowHeight));
                }

            }

            //Merge rows and columns
            for (var i = 1; i <= itemBodyColumnCount; i++)
            {

                var objectWithMergedCells = objectsWithMergedCells.Where(x => x.ColumnStart == i).FirstOrDefault();
                var lastColumnToMerge = objectWithMergedCells != null ? objectWithMergedCells.ColumnEnd : i;

                if (rowToMerge > 1 | lastColumnToMerge > i)
                {
                    //System.Diagnostics.Debug.WriteLine($"Merge FROM row {currentSingleRow} col {i} TO row {currentSingleRow + rowToMerge - 1} col {lastColumnToMerge}");
                    worksheet.Cells[currentSingleRow, i, currentSingleRow + rowToMerge - 1, lastColumnToMerge].Merge = true;
                }
                i = lastColumnToMerge;
            }

            return rowToMerge;

        }

        private double MeasureTextHeight(string text, ExcelFont font, double width)
        {
            var tollerance = 1.20;
            SizeF size;

            if (string.IsNullOrEmpty(text)) return 0.0;
            using (var bitmap = new Bitmap(1, 1))
            {

                using (var graphics = Graphics.FromImage(bitmap))
                {
                    var pixelWidth = Convert.ToInt32(width * 7);  //7 pixels per excel column width
                    var fontSize = font.Size * 1.01f;
                    var drawingFont = new Font(font.Name, fontSize);
                    size = graphics.MeasureString(text, drawingFont, pixelWidth, new StringFormat { FormatFlags = StringFormatFlags.MeasureTrailingSpaces });
                }

            }

            //72 DPI and 96 points per inch.  Excel height in points with max of 409 per Excel requirements.
            var returnValue = Math.Min(Convert.ToDouble(size.Height) * 72 / 96, 409);
            return returnValue * tollerance;
        }

        private double MeasureTextHeight(string text, ExcelFont font, double width, bool bUnicode)
        {

            if (string.IsNullOrEmpty(text)) return 0.0;
            var bitmap = new Bitmap(1, 1);
            var graphics = Graphics.FromImage(bitmap);

            var pixelWidth = Convert.ToInt32(width * 7);  //7 pixels per excel column width
            var fontSize = font.Size * 1.01f;
            var drawingFont = new Font(font.Name, fontSize);
            var size = graphics.MeasureString(text, drawingFont, pixelWidth, new StringFormat { FormatFlags = StringFormatFlags.MeasureTrailingSpaces });

            //72 DPI and 96 points per inch.  Excel height in points with max of 409 per Excel requirements.
            return Math.Min(Convert.ToDouble(size.Height) * 72 / 96, 409);
        }

        private string RangeAddressGet(string worksheetName, string rangeAddress)
        {
            return rangeAddress.Replace(worksheetName, "").Replace("'", "").Replace("!", "").Replace("$", "");
        }

        private void SetCellBorder(ExcelRangeBase cell, CellBorder cellBorder)
        {
            switch (cellBorder)
            {
                case CellBorder.LRMediumBThin:
                    cell.Style.Border.Left.Style = ExcelBorderStyle.Medium;
                    cell.Style.Border.Right.Style = ExcelBorderStyle.Medium;
                    cell.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    break;

                case CellBorder.LRBThin:
                    cell.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    cell.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    cell.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    break;

                case CellBorder.RMediumLBThin:
                    cell.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    cell.Style.Border.Right.Style = ExcelBorderStyle.Medium;
                    cell.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    break;

                case CellBorder.BMedium:
                    cell.Style.Border.Bottom.Style = ExcelBorderStyle.Medium;
                    break;
            }



        }

        #endregion
    }
}
