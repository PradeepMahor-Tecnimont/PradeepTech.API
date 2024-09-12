using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using System.Reflection;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.Library.Excel.Template
{
    public partial class ExcelTemplate : IExcelTemplate
    {

        #region Import
        //public MemoryStream ValidateMfgId(Stream stream, IEnumerable<ValidationItem> validationItems)
        //{

        //    var excelPackage = new ExcelPackage(stream);
        //    var workbook = excelPackage.Workbook;
        //    var worksheetImport = workbook.Worksheets[0];

        //    foreach (var validationItem in validationItems)
        //    {

        //        var column = worksheetImport.Names[validationItem.FieldName];
        //        var cell = worksheetImport.Cells[validationItem.ExcelRowNumber + 1, column.Start.Column];

        //        cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
        //        if (validationItem.ErrorType == ValidationItemErrorTypeEnum.Critical)
        //        {
        //            cell.Style.Fill.BackgroundColor.SetColor(Color.Red);
        //        }
        //        if (validationItem.ErrorType == ValidationItemErrorTypeEnum.Warning)
        //        {
        //            cell.Style.Fill.BackgroundColor.SetColor(Color.Yellow);
        //        }
        //        cell.AddComment(validationItem.Message, "System");

        //    }

        //    var ms = new MemoryStream();
        //    excelPackage.SaveAs(ms);
        //    return ms;
        //}
        #endregion


        #region ImportEmpAssetMovement
        public MemoryStream ExportDMSEmpAssetMovement(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var filename = string.Format("{0} {1}.xlsx", "ImportDMSMovementPlan", version);
            var resourceName = string.Format("TCMPLApp.Library.Excel.Template.Template.{0}", filename);

            using (var resourceStream = assembly.GetManifestResourceStream(resourceName))
            {

                if (resourceStream == null)
                {
                    throw new Exception("Template not found");
                }

                using (var ms = new MemoryStream())
                {
                    var excelPackage = new ExcelPackage(ms, resourceStream);
                    var workbook = excelPackage.Workbook;
                    var worksheetDictionary = workbook.Worksheets[1];
                    var worksheetImport = workbook.Worksheets[0];

                    var rowNumber = 1;

                    foreach (var g in dictionaryCollection.DictionaryItems.GroupBy(c => c.FieldName))
                    {

                        var rangeName = g.Key;
                        var startRow = rowNumber;
                        foreach (var dictionaryItem in dictionaryCollection.DictionaryItems.Where(c => c.FieldName == rangeName).OrderBy(c => c.FieldName))
                        {
                            worksheetDictionary.Cells[rowNumber, 1].Value = dictionaryItem.FieldName;
                            worksheetDictionary.Cells[rowNumber, 2].Value = dictionaryItem.Value;
                            rowNumber += 1;
                        }
                        var endRow = rowNumber;

                        var columnRange = worksheetImport.Names[rangeName.Replace("Enum", "")];
                        var val = worksheetImport.DataValidations.AddListValidation(worksheetImport.Cells[2, columnRange.Start.Column, rowLimit, columnRange.End.Column].Address);
                        val.ShowErrorMessage = true;
                        val.ShowInputMessage = true;
                        val.Formula.ExcelFormula = worksheetDictionary.Cells[startRow, 2, endRow - 1, 2].FullAddressAbsolute;
                    }

                    var columnEmpno = worksheetImport.Names["Empno"];
                    var validationEmpno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnEmpno.Start.Column, rowLimit, columnEmpno.End.Column].Address);
                    validationEmpno.Error = "Empno length should 5 characters.";
                    validationEmpno.ShowErrorMessage = true;
                    validationEmpno.Formula.Value = 5;
                    validationEmpno.AllowBlank = false;
                    validationEmpno.Operator = ExcelDataValidationOperator.lessThanOrEqual;                    

                    var currentDesk = worksheetImport.Names["CurrentDesk"];
                    var validationCurretnDesk = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, currentDesk.Start.Column, rowLimit, currentDesk.End.Column].Address);
                    validationCurretnDesk.Error = "Reason length should be less than 10 characters";
                    validationCurretnDesk.ShowErrorMessage = true;
                    validationCurretnDesk.Formula.Value = 10;
                    validationCurretnDesk.AllowBlank = false;
                    validationCurretnDesk.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    var targetDesk = worksheetImport.Names["TargetDesk"];
                    var validationTargetDesk = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, targetDesk.Start.Column, rowLimit, targetDesk.End.Column].Address);
                    validationTargetDesk.Error = "Reason length should be less than 10 characters";
                    validationTargetDesk.ShowErrorMessage = true;
                    validationTargetDesk.Formula.Value = 10;
                    validationTargetDesk.AllowBlank = false;
                    validationTargetDesk.Operator = ExcelDataValidationOperator.lessThanOrEqual;                    

                    workbook.Worksheets[1].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }
        }

        public List<EmpAssetMovement> ImportDMSEmpAssetMovement(Stream stream)
        {
            List<EmpAssetMovement> movements = new List<EmpAssetMovement>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                var props = typeof(EmpAssetMovement).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var movementRow = new EmpAssetMovement();
                    foreach (var prop in props)
                    {
                        var column = worksheet.Names[prop.Name];
                        var type = movementRow.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo?.SetValue(movementRow, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo?.SetValue(movementRow, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, pinfo.PropertyType));
                            }
                        }

                    }
                    movements.Add(movementRow);
                    rowIndex += 1;
                }

            }

            return movements;
        }


        #endregion

    }

}
